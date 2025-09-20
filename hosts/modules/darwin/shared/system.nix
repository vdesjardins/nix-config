{config, ...}: {
  networking.applicationFirewall = {
    enable = true;
    enableStealthMode = true;
    allowSignedApp = true;
  };

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

        NSWindowShouldDragOnGesture = true;
        NSAutomaticWindowAnimationsEnabled = true;
      };

      trackpad = {
        Clicking = true;
      };

      # universalaccess = {
      #   reduceMotion = true;
      # };
    };

    keyboard = {
      enableKeyMapping = true;
    };

    # settings not yet supported by nix-darwin
    activationScripts.postActivation.text = ''
      # Disable the sound effects on boot
      /usr/sbin/nvram StartupMute="%01"
      # disable sound when connecting charger
      sudo -u ${config.system.primaryUser} defaults write com.apple.PowerChime ChimeOnNoHardware -bool true

      # Disable the “Are you sure you want to open this application?” dialog
      sudo -u ${config.system.primaryUser} defaults write com.apple.LaunchServices LSQuarantine -bool false
      # Automatically quit printer app once the print jobs complete
      sudo -u ${config.system.primaryUser} defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

      # Reveal IP address, hostname, OS version, etc. when clicking the clock
      # in the login window
      defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

      # screenshot
      sudo -u ${config.system.primaryUser} defaults write com.apple.screencapture location -string "''${HOME}/Documents/Screenshots"
      sudo -u ${config.system.primaryUser} defaults write com.apple.screencapture type -string "png"
      sudo -u ${config.system.primaryUser} defaults write com.apple.screencapture disable-shadow -bool true

      # Avoid creating .DS_Store files on network or USB volumes
      sudo -u ${config.system.primaryUser} defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
      sudo -u ${config.system.primaryUser} defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

      # Lang
      sudo -u ${config.system.primaryUser} defaults write NSGlobalDomain AppleLanguages -array "en-CA" "fr-CA"
      sudo -u ${config.system.primaryUser} defaults write NSGlobalDomain AppleLocale -string "en_CA"

      sudo -u ${config.system.primaryUser} defaults write com.apple.HIToolbox AppleEnabledInputSources -array ''\\
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

      sudo -u ${config.system.primaryUser} defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID  "org.unknown.keylayout.us-altgr-intl"
      sudo -u ${config.system.primaryUser} defaults write com.apple.HIToolbox AppleGlobalTextInputProperties '{"TextInputGlobalPropertyPerContextInput" = 1; }'
      sudo -u ${config.system.primaryUser} defaults write com.apple.TextInputMenu visible 1

      cp ${./keyboards/us-altgr-intl.keylayout} /Library/keyboard\ Layouts/us-altgr-intl.keylayout

      sudo -u ${config.system.primaryUser} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };
}
