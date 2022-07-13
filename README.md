Init a new Mac machine by simply running one line of script

Inspired by
- [carousell/laptop](https://github.com/carousell/laptop)
- [brandonb927/osx-for-hackers.sh](https://gist.github.com/brandonb927/3195465])
- [nnja/new-computer](https://github.com/nnja/new-computer)

# Usage

Open terminal and execute:
```sh
/bin/bash -c "$(curl -fsSL https://ins.tomaz.dev/mac/setup.sh)"
```

### Manual Configuration

**Alfred**
- Alfred -> Powerpack -> License Alfred
- Alfred -> Advanced -> Syncing -> "Set preferences folder"
  - **SET TO**: ~/Dropbox/sync/alfred

**Iterm2**
- Iterm2 -> Preferences -> General -> Preferences tab
  - **CHECK**: Load preferences from a custom folder or URL
  - **SET TO**: ~/Dropbox/sync/iterm2


**System Preferences**
- General -> Appearance -> Dark
- Desktop & Screen Saver -> Screen Saver -> "Hot Corners..."
  - Turn off all hot corners
- Dock & Menu Bar
- Siri
  - **UNCHECK** Enable Ask Siri
  - **UNCHECK** Show Siri in menu bar
- Keyboard
  - Keyboard -> Keyboard -> Key Repeat



