{pkgs, ...}: {
  home.packages = with pkgs; [
    age-plugin-yubikey
    passage # passwords management with age
    rage
  ];

  home.sessionVariables = {
    PASSAGE_AGE = "rage";
  };
}
