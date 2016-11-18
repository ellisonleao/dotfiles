if application "Spotify" is running then
    tell application "Spotify"
      set theName to name of the current track
      set theArtist to artist of the current track
      if (theArtist as string) is equal to "" then
            return "Shitty Ads"
      end if
      try
        return "♫  " & the theArtist & " - " & theName
      on error err
      end try
	end tell
else
    return "No song"
end if
