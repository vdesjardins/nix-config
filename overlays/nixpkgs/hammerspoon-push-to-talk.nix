inputs: _self: super: {
  hammerspoon-push-to-talk = super.stdenv.mkDerivation {
    name = "hammerspoon-push-to-talk";

    src = inputs.hammerspoon-spoons;

    phases = ["unpackPhase" "installPhase"];

    installPhase = ''
      mkdir -p $out/share/hammerspoon/
      cp -r Source/PushToTalk.spoon $out/share/hammerspoon/
    '';
  };
}
