# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  ################
  ## allow unfree
  ################
  nixpkgs.config.allowUnfree = true;


  ##############
  ## BOOTLOADER.
  ##############
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    systemd-boot.consoleMode = "auto";
  };


  #########
  ## KERNEL
  #########
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "ntfs" ];


  ########
  ## HOST
  ########




  #########
  ## LOCALE
  #########
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";


  #########
  ## WM/DE
  #########
	services.xserver = {
    enable = true;

    videoDrivers = [ "nvidia" ];
    #deviceSection = ''
    #  Option "DRI" "2"
    #  Option "TearFree" "true"
    #'';

		desktopManager = {
			xfce.enable = true;
      # plasma5.enable = true;
		};

		displayManager = {
			defaultSession = "none+dwm";
      
      lightdm = {
        enable = true;
      };

      ## true if tty or dwm
			startx.enable = true;
		};

      windowManager = {
        dwm.enable = true;
    };
  };


  ##########
  ## WAYLAND
  ##########
  programs.sway.enable = true;


  ##########
  ## OVERLAY
  ##########
  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        src = /home/khang/suckless/dwm ;  
      });
       
      slstatus = super.slstatus.overrideAttrs (oldAttrs: rec {
        patches = [
		      /home/khang/default_suckless/slstatus-config-header.diff # this is a generated diff file
		    ]; 
      }); 

      dmenu = super.dwm.overrideAttrs (oldAttrs: rec {
        src = /home/khang/suckless/dmenu ;
      });

      slock = super.slock.overrideAttrs (oldAttrs: rec {
        src = /home/khang/suckless/slock;
        buildInputs = oldAttrs.buildInputs ++ [
          self.imlib2 
          self.xorg.libXinerama 
          self.xorg.libXft
        ]; 
      });

      st = super.st.overrideAttrs (oldAttrs: rec {
        src = /home/khang/suckless/st;
      });
    })
  ];
		

  ########
  ## INPUT
  ########
  services.xserver = {
    layout = "us, us";
    xkbVariant = "colemak_dh, ";
    xkbOptions = "grp:shifts_toggle";
	};
	
  
  #######
  ## CUPS
  #######
    services.printing.enable = true;


  ###########
  ## PIPEWIRE
  ###########
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    #jack.enable = true;
  };


  ##########
  ## ACCOUNT
  ##########
  users.users.khang = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; 
    initialPassword = "123456"; # Enable ‘sudo’ for the user.
  };
  ## System wide
  users = {
    defaultUserShell = pkgs.bash;
  } ;


  ##########
  ## PACKAGE
  ##########
  environment.systemPackages = with pkgs; [
    # editors
    vim
    emacs
    sublime4

    # net
    wget
    curl

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
    git
    gnumake
    gcc
    python310
    man
    man-pages

    # utils
	  pfetch
    yt-dlp
    p7zip
    xclip

    # app
    easyeffects
    flatpak
    gimp
    mpv

    # suckless
    dwm
    slstatus
    slock
    dmenu
    st

    # library

    imlib2
  ];


  ########
  ## FONTS
  ########
  fonts.fonts = with pkgs; [
    font-awesome
    hack-font
    terminus_font
  ];


  ##############
  ## ENVIRONMENT
  ##############
  # annoying ask password https://github.com/NixOS/nixpkgs/issues/24311
  environment.extraInit = ''
    unset -v SSH_ASKPASS
  '';
  environment.etc."inputrc" = {
    text = pkgs.lib.mkDefault( pkgs.lib.mkAfter ''
      set completion-ignore-case On
    '');
  };

  # vim
  environment.variables.VIM = "/etc/vim";
  environment.variables.VIMRUNTIME = "/etc/vim";
  environment.etc."vim/vimrc".text = ''
    set nocompatible
    
    set number 
    set showmatch 
    set visualbell
     
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
  environment.etc."vim/defaults.vim".text = ''
  '';

  # mpv
  environment.etc."mpv.conf".text = ''
    force-window=immediate
    keep-open=yes
    keep-open-pause=yes
    volume=60
  '';


  ###########
  ## PROGRAMS
  ###########
  programs = {
    bash = {
      enableCompletion = true;

      shellAliases = {
        clip = "xclip -sel c";
        clipo = "xclip -sel c -o";
        wiki = "lynx gopher://gopherpedia.com";
        ddg = "lynx https://lite.duckduckgo.com/lite";
        rm = "rm -I";
      };

      shellInit = ''
      '';
    }; 

    slock.enable = true;
  };



  ##########
  ## SERVICES
  ##########
  systemd.services = {
  };
  security.pki.certificateFiles = [
    "/home/khang/Downloads/openvpn/ca.crt"
    "/home/khang/Downloads/openvpn/taarst.crt"

  ];
  services.flatpak.enable = true;
  xdg.portal.enable = true; # goes with if no gnome


  ##########
  ## NETWORK
  ##########
  networking.networkmanager = {
    enable = true;
    dhcp = "dhcpcd";
  };

  networking.hostName = "painmachine"; # Define your hostname.
  #networking.wireless = {
  #  enable = true;  # Enables wireless support via wpa_supplicant. 
  #  userControlled.enable = true;
  #};


  #########
  ## NVIDIA
  #########
  hardware.nvidia = {
    modesetting.enable = true;

    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
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
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlo1.useDHCP = true;
  # services.xserver.libinput.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

