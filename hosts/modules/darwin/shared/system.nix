{
  lib,
  pkgs,
  ...
}: {
  fonts.fontDir.enable = true;

  system = {
    defaults = {
      loginwindow = {
        GuestEnabled = false;
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        QuitMenuItem = true;
        _FXShowPosixPathInTitle = true;
      };

      alf = {
        globalstate = 1;
        loggingenabled = 0;
        stealthenabled = 1;
        allowdownloadsignedenabled = 1;
      };

      # dock settings
      dock = {
        # auto show and hide dock
        autohide = true;
        # remove delay for showing dock
        autohide-delay = 0.0;
        # how fast is the dock showing animation
        autohide-time-modifier = 1.0;
        tilesize = 50;
        static-only = true;
        showhidden = false;
        show-recents = false;
        show-process-indicators = true;
        orientation = "bottom";
        mru-spaces = false;
        launchanim = false;
        mineffect = "scale";
        minimize-to-application = true;
      };

      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.sound.beep.volume" = 0.000;
        # allow key repeat
        ApplePressAndHoldEnabled = false;
        # delay before repeating keystrokes
        InitialKeyRepeat = 10;
        # delay between repeated keystrokes upon holding a key
        KeyRepeat = 1;
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "Automatic";
        # tap to click
        "com.apple.mouse.tapBehavior" = 1;

        AppleMetricUnits = 1;
        AppleMeasurementUnits = "Centimeters";
        AppleTemperatureUnit = "Celsius";
      };

      trackpad = {
        Clicking = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
    };

    # settings not yet supported by nix-darwin
    activationScripts.postUserActivation.text = ''
      # Disable the sound effects on boot
      sudo /usr/sbin/nvram StartupMute="%01"
      # disable sound when connecting charger
      defaults write com.apple.PowerChime ChimeOnNoHardware -bool true

      # Disable the “Are you sure you want to open this application?” dialog
      defaults write com.apple.LaunchServices LSQuarantine -bool false
      # Automatically quit printer app once the print jobs complete
      defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

      # Reveal IP address, hostname, OS version, etc. when clicking the clock
      # in the login window
      sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

      # screenshot
      defaults write com.apple.screencapture location -string "''${HOME}/Documents/Screenshots"
      defaults write com.apple.screencapture type -string "png"
      defaults write com.apple.screencapture disable-shadow -bool true

      # Avoid creating .DS_Store files on network or USB volumes
      defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
      defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

      # Lang
      defaults write NSGlobalDomain AppleLanguages -array "en-CA" "fr-CA"
      defaults write NSGlobalDomain AppleLocale -string "en_CA"

      defaults write com.apple.HIToolbox AppleEnabledInputSources -array ''\\
      "<dict>
        <key>InputSourceKind</key>
        <string>Keyboard Layout</string>
        <key>KeyboardLayout ID</key>
        <integer>-25794</integer>
        <key>KeyboardLayout Name</key>
        <string>us-altgr-intl</string>
      </dict>" ''\\
      "<dict>
        <key>InputSourceKind</key>
        <string>Keyboard Layout</string>
        <key>KeyboardLayout ID</key>
        <integer>29</integer>
        <key>KeyboardLayout Name</key>
        <string>Canadian</string>
      </dict>" ''\\
      "<dict>
        <key>InputSourceKind</key>
        <string>Keyboard Layout</string>
        <key>KeyboardLayout ID</key>
        <integer>80</integer>
        <key>KeyboardLayout Name</key>
        <string>Canadian - CSA</string>
      </dict>"

      defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID  "org.unknown.keylayout.us-altgr-intl"
      defaults write com.apple.HIToolbox AppleGlobalTextInputProperties '{"TextInputGlobalPropertyPerContextInput" = 1; }'
      defaults write com.apple.TextInputMenu visible 1

      sudo cp ${./keyboards/us-altgr-intl.keylayout} /Library/keyboard\ Layouts/us-altgr-intl.keylayout
    '';
  };
}
