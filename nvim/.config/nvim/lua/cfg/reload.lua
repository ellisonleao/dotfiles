local reload = {}

--- Unload modules with a prefix
function reload.unload_modules(prefix)
    local to_unload = {}

    for k, _ in pairs(package.loaded) do
        if vim.startswith(k, prefix .. ".") then
            table.insert(to_unload, k)
        end
    end

    for _, v in pairs(to_unload) do
        package.loaded[v] = nil
    end
end

--- Unloads modules from this user config
function reload.unload_user_modules()
    reload.unload_modules("cfg") -- Unload config core
    reload.unload_modules("modules") -- Unload layers
end

--- Updates `package.path` from Vim's `runtimepath`
function reload.update_package_path()
    vim._update_package_paths()
end

return reload
