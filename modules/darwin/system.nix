{
  system.defaults = {
    loginwindow = {
      GuestEnabled = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
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
      autohide-delay = "0.0";
      # how fast is the dock showing animation
      autohide-time-modifier = "1.0";
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
      "com.apple.sound.beep.volume" = "0.000";
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

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
    swapLeftCommandAndLeftAlt = true;
  };

  # settings not yet supported by nix-darwin
  system.activationScripts.postActivation.text = ''
    defaults write com.apple.Finder AppleShowAllFiles -bool YES;

    defaults write NSGlobalDomain AppleLanguages -array "en-CA" "fr-CA"
    defaults write NSGlobalDomain AppleLocale -string "en_CA";

    defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>29</integer><key>KeyboardLayout Name</key><string>Canadian</string></dict>'
    defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>80</integer><key>KeyboardLayout Name</key><string>Canadian - CSA</string></dict>'

    defaults write com.apple.HIToolbox AppleGlobalTextInputProperties '{"TextInputGlobalPropertyPerContextInput" = 1; }'
    defaults write com.apple.TextInputMenu visible 1
  '';
}
