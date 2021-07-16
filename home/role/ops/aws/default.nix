{ pkgs, ... }: {
  home.packages = with pkgs; [ aws-iam-authenticator awscli ];
}
