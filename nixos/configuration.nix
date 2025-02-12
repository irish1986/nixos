{ config, lib, pkgs, meta, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = meta.hostname;
    firewall.enable = true;
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  };

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  users.users = {

    root = {
    };

    nixos = {
      isNormalUser = true; 
      description = "nixos user"; 
      # Created using mkpasswd -m sha-512
      hashedPassword = "$6$6klB2tIMoGV/gxz4$IEcodJRdlxb3ZtdlEc/o/XTey06UlFfGfkstrv04AAsoOi5a7FeYqhgBmXS.1i912W8WAGq3IxSIcWwfiaNCB.";
      extraGroups = [ 
        "networkmanager" 
        "wheel" 
        "docker"
      ];
      packages = with pkgs; [
        tree
      ];
      openssh.authorizedKeys.keys = [
        "CHANGE"
      ];
    };

  };

  environment.systemPackages = with pkgs; [
     cifs-utils
     curl
     git
     k3s
     neofetch
     neovim
     nfs-utils
  ];

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
    };
  #   k3s = {
  #     enable = true;
  #     role = "server";
  #     tokenFile = /var/lib/rancher/k3s/server/token;
  #     extraFlags = toString ([
  #       "--write-kubeconfig-mode \"0644\""
  #       "--cluster-init"
  #       "--disable servicelb"
  #       "--disable traefik"
  #       "--disable local-storage"
  #     ] ++ (if meta.hostname == "homelab-0" then [] else [
  #         "--server https://homelab-0:6443"
  #     ]));
  #     clusterInit = (meta.hostname == "homelab-0");
  #   };
  # openiscsi = {
  #   enable = true;
  #   name = "iqn.2016-04.com.open-iscsi:${meta.hostname}";
  #   };
  };

  system.stateVersion = "23.11";
}