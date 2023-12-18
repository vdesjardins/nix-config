{
  config,
  pkgs,
  ...
}: {
  services.mako = {
    enable = true;

    anchor = "bottom-right";
    backgroundColor = "24283b";
    textColor = "c0caf5";
    width = 350;
    margin = "0,20,20";
    padding = "10";
    borderSize = 2;
    borderColor = "414868";
    borderRadius = 5;

    groupBy = "summary";

    format = "<b>%s %p</b>\\n%b";

    defaultTimeout = 10000;
  };
}
