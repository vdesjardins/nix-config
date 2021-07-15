{
  system.defaults = {
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = true;
      _FXShowPosixPathInTitle = true;
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
}
