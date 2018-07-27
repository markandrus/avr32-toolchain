let

  fetcher = { owner, repo, rev, sha256 }: builtins.fetchTarball {
    inherit sha256;
    url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
  };

  nixpkgs = fetcher {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "62dca7c9ab08ee5cc2043d6d374013b8041a3f21";
    sha256 = "0f0yajik1zmq8l862vs9ackl1pln5m4j9db61n223mhc4g4687lb";
  };

  pkgs = import nixpkgs {};

in

  pkgs.stdenv.mkDerivation {
    name = "avr32-toolchain";
    nativeBuildInputs = [
      pkgs.curl
      pkgs.git
      pkgs.gmp
      pkgs.gperf_3_0
      pkgs.libmpc
      pkgs.m4
      pkgs.mpfr
      pkgs.perl
      pkgs.texinfo4
      pkgs.unzip
    ];
    preBuild = ''
      unset SSL_CERT_FILE
      export HOME=$(pwd)
      export CFLAGS=-Wno-error=format-security
      export CXXFLAGS=-Wno-error=format-security
    '';
    buildFlags = [
      "install-cross"
    ];
    src = ./.;
  }
