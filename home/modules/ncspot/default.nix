{config, ...}: {
  programs.ncspot = {
    settings = {
      credentials = {
        username_cmd = "echo vdesjardins";
        password_cmd = "passage services/spotify";
      };
    };
  };
}
