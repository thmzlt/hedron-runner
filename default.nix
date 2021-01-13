{ pkgs ? import (fetchTarball "https://github.com/nixos/nixpkgs/archive/release-20.09.tar.gz") { } }:

pkgs.dockerTools.buildImageWithNixDb {
  name = "ghcr.io/thmzlt/hedron-runner";
  tag = "latest";

  contents = [
    ./root
    pkgs.bashInteractive
    pkgs.cacert
    pkgs.coreutils
    pkgs.git
    pkgs.man
    pkgs.nix
  ];

  extraCommands = ''
    # Symlink /usr/bin for /usr/bin/env
    mkdir usr
    ln -s ../bin usr/bin

    # Make sure /tmp exists
    mkdir -m 1777 tmp

    # Create $HOME
    mkdir -vp root
  '';

  config = {
    Cmd = [ "${pkgs.bash}/bin/bash" ];
    Env = [
      "BASH_ENV=/etc/profile.d/nix.sh"
      "ENV=/etc/profile.d/nix.sh"
      "NIX_BUILD_SHELL=${pkgs.bash}/bin/bash"
      "NIX_PATH=nixpkgs=${./fake_nixpkgs}"
      "PAGER=${pkgs.coreutils}/bin/cat"
      "PATH=/usr/bin:/bin"
      "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      "USER=root"
    ];
  };
}
