# WateringCppEx
Xcode Source Editor Extentsion (Xcode 8+)


## Example

(not ready)

# Install

0. On OS X 10.11 El Capitan, run the following command and restart your Mac:

```
sudo /usr/libexec/xpccachectl
```

### easy way
1. Download `WateringCpp.dmg` from https://github.com/sidepelican/WateringCppEx/releases
1. Open `.dmg` and drag `WateringCpp.app` to your Applications folder
1. Run ``WateringCpp.app`` and exit again.
1. Go to System Preferences (not Xcode) -> Extensions -> Xcode Source Editor and enable the extension
1. The menu-item should now be available from Xcode's Editor menu.

### build by yourself
1. Open .xcodeproj
1. Enable target signing for both the Application and the Source Code Extension using your own developer ID
1. Product > Archive
1. Right click archive > Show in Finder
1. Right click archive > Show Package Contents
1. Open Products, Applications
1. Drag ``WateringCpp.app`` to your Applications folder
1. Run ``WateringCpp.app`` and exit again.
1. Go to System Preferences (not Xcode) -> Extensions -> Xcode Source Editor and enable the extension
1. The menu-item should now be available from Xcode's Editor menu.

# Licence
The MIT License. See the LICENSE file for more infomation.
