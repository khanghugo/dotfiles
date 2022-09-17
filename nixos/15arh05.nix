# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  ##########
  ## SYSTEM
  ##########
  # locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # fs
  # boot.supportedFilesystems = [ "ntfs" ];

  # kernel
  # boot.kernelPackages = pkgs.linuxPackages_latest; # will get bleeding edge

  # bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    systemd-boot.consoleMode = "max";
  };

  # cups 
  services.printing.enable = true;

  # input
  services.xserver = {
    layout = "us, us";
    xkbVariant = "colemak_dh, ";
    xkbOptions = "grp:shifts_toggle";
  };

  # pipewire
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # default shell
  users = {
    defaultUserShell = pkgs.bash;
  } ;

  # network
  networking.networkmanager = {
    enable = true;
    dhcp = "dhcpcd";
  };

  # dns
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  # hostname
  networking.hostName = "painmachine2"; # Define your hostname.
  # wireless is handled by networkmanager
  #networking.wireless = {
  #  enable = true;  # Enables wireless support via wpa_supplicant. 
  #  userControlled.enable = true;
  #};

  # steam controller
  hardware.steam-hardware.enable = true;

  # bluetooth
  hardware.bluetooth.enable = true;
  # services.blueman.enable = true; 

  # virtualization
  # virtualisation.libvirtd.enable = true;
  # boot.kernelModules = [ "kvm-amd" ];
  # programs.dconf.enable = true;
  # boot.kernelParams = [ "amd_iommu=on" "pcie_aspm=off" ];

  ##########
  ## PACKAGE
  ##########
  # allow unfree
  nixpkgs.config.allowUnfree = true;

  # package
  environment.systemPackages = with pkgs; [
    # editors
    vim_configurable
    emacs
    sublime4

    # browser
    firefox
    chromium
    lynx

    # dirty packages
    networkmanager
    networkmanagerapplet
    pavucontrol
    pcmanfm

    # dev
    python310
    man
    man-pages
    docker
    docker-compose
    git
    gnumake
    gcc
    gdb

    # utils
    yt-dlp
    p7zip
    wget
    curl
    pciutils
    feh # for dwm background image, ~/Pictures/.bg/anyname.png
    
    # loonix
    pfetch
    xclip
    alsa-utils
    flameshot
    tree
    htop

    # app
    easyeffects
    flatpak
    gimp
    mpv
    qbittorrent

    # suckless
    dwm
    slstatus
    slock
    dmenu
    st

    # virtual machine
    # virt-manager
    # qemu
    # win-qemu

    # gnome

    # more
    steam-run

    # nvidia
    nvidia-offload
  ];

  # flatpak
  services.flatpak.enable = true;
  # xdg.portal = {
  #   enable = true; # goes with if no gnome
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # };

  # enable slock
  programs.slock.enable = true;

  # kdeconnect
  programs.kdeconnect.enable = true;

  # font
  fonts.fonts = with pkgs; [
    font-awesome
    hack-font
    terminus_font
    dejavu_fonts
    liberation_ttf
    corefonts
  ];

  # docker
  virtualisation.docker.enable = true;
  # virtualisation.docker.enableOnBoot = true;
  

  # mysql
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    # port = 3360;

    # settings.mysqld = {
    #   bind-address = "0.0.0.0";
    #   skip-grant-tables = true;
    #   default-authentication-plugin = "mysql_native_password";
    # };

  };
  # services.longview.mysqlPasswordFile = "/run/keys/mysql.password";

  # portal is https://localhost:32400/web
  #services.plex = {
  #  enable = true;
  #  openFirewall = true;
  #};

  # backlight
  programs.light.enable = true;

  #########
  ## WM/DE
  #########
	services.xserver = {
    enable = true;

    videoDrivers = [ "nvidia" ];

		desktopManager = {
			# xfce.enable = true;
      plasma5.enable = true;
      # gnome.enable = true;
		};

    windowManager = {
        dwm.enable = true;
    };

		displayManager = {
			defaultSession = "none+dwm";
      # gdm.enable = true;
      
      lightdm = {
        enable = true;
        # extraConfig = ''
        #   display-setup-script=xrandr --output DP-0 --mode 1920x1080 --rate 143.85 --primary --output HDMI-0 --off
        # '';
        # greeters.gtk = {
        #   extraConfig= ''
        #     active-monitor=0
        #  '';
        # };
      };

      ## true if tty or dwm
			startx.enable = true;
		};

    # wallpaper
    desktopManager.wallpaper = {
      mode = "fill";
      # combineScreens = true;
    };

  };

  # wayland
  # programs.sway.enable = true;

  # more gnome
  # environment.gnome.excludePackages = (with pkgs; [
  #   gnome-photos
  #   gnome-tour
  #   ]) ++ (with pkgs.gnome; [
  #     cheese # webcam tool
  #     gnome-music
  #     gnome-terminal
  #     gedit # text editor
  #     epiphany # web browser
  #     geary # email reader
  #     evince # document viewer
  #     gnome-characters
  #     totem # video player
  #     tali # poker game
  #     iagno # go game
  #     hitori # sudoku game
  #     atomix # puzzle game
  # ]);


  ##########
  ## CONFIG
  ##########
  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        # src = super.fetchgit {
        #   url = "https://github.com/khanghugo/dwm.git";
        #   rev = "7af654c670b15f89e2cf5f5751bffdd7d07fb554";
        #   sha256 = "NNZiNU9NV8M6+JYeHljsQm+fOsWUG4cSz+9tv1qOe5A=";
        # }; 

        src = /home/khang/suckless/dwm;
      });
       
      slstatus = super.slstatus.overrideAttrs (oldAttrs: rec {
        #patches = [
		    #  /home/khang/default_suckless/slstatus-config-header.diff # this is a generated diff file if pulled from git
		    #];

        src = /home/khang/suckless/slstatus; 

        buildInputs = oldAttrs.buildInputs ++ [
          self.xorg.libX11
        ];
      }); 

      dmenu = super.dwm.overrideAttrs (oldAttrs: rec {
        src = super.fetchgit {
          url = "https://github.com/khanghugo/dmenu.git";
          rev = "85390236cc517055457a78a5bda79082a28efcee";
          sha256 = "WwbCA/Uu6YUgEENyYltp95h7VMx6d1dPw/naEWZOegE=";
        };
      });

      slock = super.slock.overrideAttrs (oldAttrs: rec {
        src = super.fetchgit {
          url = "https://github.com/khanghugo/slock.git";
          rev = "8279acab9bbae8e697e4782a4da638a3e3b31854";
          sha256 = "FnpoDBbD2tMiG3hbwnd3/d6seg7QjPFTblIokKrUMYA=";
        };
        buildInputs = oldAttrs.buildInputs ++ [
          self.imlib2 
          self.xorg.libXinerama 
          self.xorg.libXft
        ]; 
      });

      st = super.st.overrideAttrs (oldAttrs: rec {
        src = super.fetchgit {
          url = "https://github.com/khanghugo/st.git";
          rev = "8f5002c2499c8a61e0331e47907c2f08a98d8885";
          sha256 = "5yi8Mb27BpjagAsnHg6RU/ehHtuNLSrwrRgL4LMmCFo=";
        };
      });

      vim_configurable = super.vim_configurable.customize {
        name = "vim";

        vimrcConfig.customRC = ''
          set nocompatible

          set backspace=indent,eol,start
          
          set number 
          set showmatch 
          set visualbell
          syntax on
           
          set hlsearch
          set smartcase
          set ignorecase
          set incsearch
           
          set autoindent
          set shiftwidth=4
          set smartindent
          set smarttab
          set softtabstop=4
           
          set ruler
           
          set undolevels=1000
        '';
      };
    })
  ];
 
  # ctrl backspace function
  environment.etc."inputrc" = {
    text = pkgs.lib.mkDefault( pkgs.lib.mkAfter ''
      set completion-ignore-case On
    '');
  };

  # mpv
  environment.variables.MPV_HOME = "/etc/mpv"; # mpv is not using /etc/mpv for sys wide and also the standard on mpv is all over the place....
  environment.etc."mpv/mpv.conf".text = ''
    force-window=immediate
    keep-open=yes
    keep-open-pause=yes
    volume=65
  '';

  # bash
  programs.bash = {
      enableCompletion = true;

      shellAliases = {
        clip = "xclip -sel c";
        clipo = "xclip -sel c -o";
        wiki = "lynx gopher://gopherpedia.com";
        ddg = "lynx https://lite.duckduckgo.com/lite";
        rm = "rm -I";
        ".." = "cd ..";
        "..." = ".. && ..";
      };

      shellInit = ''
      '';
  };

  # default text editor, does not work that well on gnome or kde
  # programs.vim.defaultEditor = true;

  
  ########
  ## USER
  ########
  users.users.khang = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "video" ]; 
    initialPassword = "123456"; # Enable ‘sudo’ for the user.
  };

  #######
  ## STEAM
  #######
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        pango
        SDL_Pango
        SDL
        SDL_ttf
      ];
    };
  };

  ##########
  ## NVIDIA
  ##########
  hardware.nvidia = {
    modesetting.enable = true;

    prime = {
      offload.enable = true;
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  #hardware.opengl = {
  #    enable = true;
  #    driSupport = true;
  #    extraPackages = with pkgs; [
  #        intel-compute-runtime
  #        intel-media-driver
  #        vaapiIntel
  #        vaapiVdpau
  #        libvdpau-va-gl
  #    ];
  #};


  ### REMNANTS

  networking.useDHCP = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

