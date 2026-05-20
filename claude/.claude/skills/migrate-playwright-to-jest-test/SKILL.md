---
name: migrate-e2e-playwright-to-jest
description: Helps users migrate an e2e test for API layer using playwright into Jest
---

# Skill: Migrate Playwright E2E Tests to Jest/Supertest

## When to Use

Use this skill when asked to migrate Playwright-based API tests from `e2e/specs/neutron/` to
Jest/Supertest tests following the patterns in `apps/neutron/test/`.

---

## Overview

Playwright E2E tests under `e2e/specs/neutron/` test the Neutron API over a live HTTP server.
The equivalent Jest tests live under `apps/neutron/test/<domain>/` and use `supertest` against a
NestJS testing module, backed by either **pg-mem** (fast, in-process) or **Testcontainers**
(real Postgres, for complex scenarios).

Reference implementation: `apps/neutron/test/observation/`

---

## File Layout

For each domain being migrated, create files mirroring the `observation` reference:

```
apps/neutron/test/<domain>/
  <domain>.controller.spec.ts   # HTTP routing, auth, validation, response shape
  <domain>.service.spec.ts      # Business logic, edge cases (only when needed — see below)
  <domain>.helpers.ts           # createXxxModule() helper that wires up NovaTest
```

---

## Key Building Blocks

### 1. `NovaTest` — module builder (`apps/neutron/test/helpers/nest.ts`)

```ts
import { NovaTest } from '../helpers/nest';

export function createMyModule(dataSource: DataSource): NovaTest {
  return new NovaTest()
    .withProviders(MyService, MyRepository /* ...deps */)
    .withAuthGuard(dataSource) // required for controllers with guards
    .withControllers(MyController)
    .withDataSource(dataSource);
}
```

Useful `NovaTest` methods:

| Method                                                    | Purpose                                                                                |
| --------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| `.withProviders(...providers)`                            | Add services, repositories, or `{ provide, useValue }` objects                         |
| `.withDataSource(dataSource)`                             | Inject a TypeORM DataSource (and its EntityManager)                                    |
| `.withAuthGuard(dataSource)`                              | Wire `GlobalAuthGuard`, `MinimumRoleGuard`, `GlobalRolesGuard` + JWT strategy          |
| `.withControllers(...controllers)`                        | Register NestJS controllers                                                            |
| `.withModules(...)` / `.withImports(...)`                 | Add NestJS modules or dynamic modules                                                  |
| `.withCommonProviders()`                                  | Shortcut for `ConfigService`, `OrgService`, `UserService`, `WarehouseRepository`, etc. |
| `.withCustomFormsProviders()`                             | Shortcut for all custom-forms repositories                                             |
| `.withMockedService(ServiceClass, { method: jest.fn() })` | Inject a shallow mock of a service                                                     |
| `.withFeatureFlagService(mock)`                           | Override `FeatureFlagService`                                                          |
| `.compile()`                                              | Build and return the `TestingModule`                                                   |

### 2. DataSource fixtures (`apps/neutron/test/helpers/fixtures/`)

#### pg-mem (default — fast, in-process)

```ts
import { useDataSourceFixture } from '../helpers/fixtures';

const getDataSource = useDataSourceFixture();

beforeAll(async () => {
  const { dataSource } = getDataSource()!;
  // ...
});
```

`useDataSourceFixture` sets up `beforeAll` / `afterAll` / `beforeEach` (with snapshot restore).

#### Testcontainers (real Postgres)

```ts
import { useTestContainerFixture } from '../helpers/fixtures';
// or directly:
import { setupTestContainers, CONTAINER_HOOK_TIMEOUT_MS } from '../helpers/datasource';

const getTestContainer = useTestContainerFixture();

beforeAll(async () => {
  const { dataSource } = getTestContainer();
  // ...
}, CONTAINER_HOOK_TIMEOUT_MS);
```

**Choose pg-mem** for controller/service tests that do not rely on transactions, triggers, custom
constraints, or other Postgres-specific behavior.

**Choose Testcontainers** when:

- The service uses database transactions (`QueryRunner`, nested transactions)
- The test needs real Postgres constraints or generated columns
- The service behaviour differs from pg-mem (e.g. complex SQL, CTEs, full-text search)

On macOS with Colima, prefix Testcontainers runs with:

```
TESTCONTAINERS_RYUK_DISABLED=true npx jest <spec> --runInBand
```

### 3. Factories (`apps/neutron/test/factories/`)

```ts
import { makeFactories } from '../factories';

const factories = makeFactories(dataSource);

// Build (in-memory, no DB write):
const user = factories.userFactory.build({ role: UserRole.ADMIN });

// Create (persisted):
const user = await factories.userFactory.create({ role: UserRole.INTERNAL });
```

### 4. Auth helpers (`apps/neutron/test/helpers/utils.ts`)

```ts
import { getAuthHeader } from '../helpers/utils';

const user = await factories.userFactory.create({ role: UserRole.ADMIN });
request(app.getHttpServer()).get('/my-endpoint').set('Authorization', getAuthHeader(user));
```

For internal "login-as" impersonation tests use `getLoginAsAuthHeader(impersonated, internal)`.

---

## Controller Spec Pattern

```ts
import 'dotenv/config';
import request from 'supertest';
import { HttpStatus, INestApplication } from '@nestjs/common';
import { makeFactories } from '../factories';
import { useDataSourceFixture } from '../helpers/fixtures';
import { createMyModule } from './my.helpers';
import { UserRole } from '@nova/core';
import { getAuthHeader } from '../helpers/utils';

describe('MyController', () => {
  let app: INestApplication;
  let factories: ReturnType<typeof makeFactories>;

  const getDataSource = useDataSourceFixture();

  beforeAll(async () => {
    const { dataSource } = getDataSource()!;
    factories = makeFactories(dataSource);
    const moduleRef = await createMyModule(dataSource).compile();
    app = moduleRef.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('GET /my-resource', () => {
    it('requires authentication', async () => {
      const res = await request(app.getHttpServer()).get('/my-resource');
      expect(res.status).toBe(HttpStatus.UNAUTHORIZED);
    });

    it('returns 200 for authenticated user', async () => {
      const user = await factories.userFactory.create({ role: UserRole.ADMIN });
      const res = await request(app.getHttpServer()).get('/my-resource').set('Authorization', getAuthHeader(user));
      expect(res.status).toBe(HttpStatus.OK);
    });
  });
});
```

### What controller tests should cover

- HTTP routing and status codes
- Authorization / RBAC (`UNAUTHORIZED`, `FORBIDDEN`)
- Input validation (DTO errors → `BAD_REQUEST`)
- Response shape (`toMatchObject`, `toEqual`)

Service methods are typically **mocked** with `jest.spyOn(service, 'method').mockResolvedValue(...)`.
This keeps controller tests focused on HTTP concerns.

---

## Service Spec Pattern (add only when warranted)

Add a service spec when **any** of:

- Service has > 3 public methods with branching logic
- Service manages complex entity relationships
- Service has external integrations that need mocking at a different level
- Multiple validation rules lead to different outcomes

```ts
import 'dotenv/config';
import { useDataSourceFixture } from '../helpers/fixtures';
import { makeFactories } from '../factories';
import { NovaTest } from '../helpers/nest';
import { MyService } from '@nova/neutron/app/my/my.service';
import { MyRepository } from '@nova/neutron/app/my/my.repository';

describe('MyService', () => {
  let service: MyService;
  let factories: ReturnType<typeof makeFactories>;

  const getDataSource = useDataSourceFixture();

  beforeAll(async () => {
    const { dataSource } = getDataSource()!;
    factories = makeFactories(dataSource);

    const moduleRef = await new NovaTest()
      .withDataSource(dataSource)
      .withCommonProviders()
      .withProviders(MyRepository, MyService)
      .compile();

    service = moduleRef.get(MyService);
  });

  it('does the right thing', async () => {
    // ...
  });
});
```

---

## Mocking External Dependencies

Services that call external HTTP APIs, S3, SQS, etc. should be mocked at the module level in the
helpers file, not individually per test. See `observation.helpers.ts` for examples:

```ts
// In <domain>.helpers.ts
const mockHttpService = {
  get: jest.fn(),
  post: jest.fn(),
  // ...
};

export function createMyModule(dataSource: DataSource): NovaTest {
  return new NovaTest().withProviders(
    { provide: HttpService, useValue: mockHttpService },
    { provide: S3Client, useValue: s3client },
    // ...
  );
  // ...
}
```

For `FeatureFlagService`:

```ts
import { useFeatureFlagFixture } from '../helpers/fixtures';
const getFeatureFlag = useFeatureFlagFixture(true); // true = all flags on
const { service: mockFeatureFlagService } = getFeatureFlag();
```

---

## Migration Checklist

1. **Locate** the Playwright spec under `e2e/specs/neutron/<domain>/`.
2. **Identify** all HTTP endpoints tested and the roles/payloads used.
3. **Create** `apps/neutron/test/<domain>/<domain>.helpers.ts` with `createXxxModule()`.
   - Start with `.withCommonProviders()` then add domain-specific providers.
   - Mock services that reach external systems (HTTP, S3, SQS, notifications, email).
4. **Create** `apps/neutron/test/<domain>/<domain>.controller.spec.ts`.
   - Cover: unauthenticated access, role-based access, DTO validation, success paths.
   - Mock service layer with `jest.spyOn` where possible.
5. **Create** `apps/neutron/test/<domain>/<domain>.service.spec.ts` only if warranted (see criteria above).
6. **Choose the right DataSource**:
   - Default to `useDataSourceFixture()` (pg-mem).
   - Switch to `useTestContainerFixture()` / `setupTestContainers` when the domain uses transactions or complex SQL.
7. **Run lint** — fix all errors before considering the task complete:
   ```bash
   npm run neutron:lint
   ```
8. **Run the new tests** to confirm they pass:
   ```bash
   npx jest apps/neutron/test/<domain> --runInBand
   ```
9. **Delete the old Playwright spec** once the Jest tests are green.
10. **Do NOT commit** the changes — leave them for the developer to review.

---

## Running Tests

```bash
# Run a specific Jest test file
npx jest apps/neutron/test/my-domain --runInBand

# Run with Testcontainers on macOS/Colima
TESTCONTAINERS_RYUK_DISABLED=true npx jest apps/neutron/test/my-domain --runInBand

# Lint check
npm run neutron:lint
```
