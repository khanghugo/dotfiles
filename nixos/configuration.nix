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
  };


  #########
  ## KERNEL
  #########
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  ########
  ## HOST
  ########
  networking.hostName = "painmachine"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


  #########
  ## LOCALE
  #########
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";


  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlo1.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };


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
  #nixpkgs.overlays = [
   # (final: prev: {
    #  dwm = prev.dwm.overrideAttrs (old: { src = /home/khang/dwm ;});

	#st = prev.st.overrideAttrs (old: { 
		#src = pkgs.fetchFromGitHub {
		#	owner = "khanghugo";
		#	repo = "st";
		#	rev = "827b907f88552e08e77a75139c4f0275cbd9365b";
		#	sha256 = "0whyygr55y8qfqg9scd55lvb6ay5kphnxawiwah1fbl0clgzwfgf";
		#	}; 
		#
		#src = builtins.fetchTarball {
		#	url = "https://api.github.com/repos/khanghugo/st/tarball/master" ;
		#	};
		#
		#src = pkgs.fetchgit {
		#	url = "https://github.com/khanghugo/st.git" ;
		#	sha256 = "0whyygr55y8qfqg9scd55lvb6ay5kphnxawiwah1fbl0clgzwfgf";
		#	};

		#src = /home/khang/st ;
	
		#}
	#);
   # })
  #];

  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        src = /home/khang/suckless/dwm ;  
	});
       
      slstatus = super.slstatus.overrideAttrs (oldAttrs: rec {
	patches = [
		/home/khang/default_suckless/slstatus-config-header.diff # this is a generated diff file
		] ; 
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
	
  
  ##################################
  ## Enable CUPS to print documents.
  ##################################
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


  ####################################################################
  ## Enable touchpad support (enabled default in most desktopManager).
  ####################################################################
  # services.xserver.libinput.enable = true;


  ###########
  ## ACCOUNT.
  ###########
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
    vim
    emacs
    wget
    firefox
    chromium
    networkmanager
    networkmanagerapplet
	  pfetch
    git
    gnumake
    gcc
    (st.overrideAttrs (oldAttrs: rec {
      src = /home/khang/suckless/st ;
    }))

    (dmenu.overrideAttrs (oldAttrs: rec {
      src = /home/khang/suckless/dmenu ;
    }))

    slstatus
    pavucontrol
    easyeffects
    python310
    xorg.xbacklight
    gimp
    yt-dlp
    mpv
    p7zip
    xclip
    lynx
    sublime4
  ];


  ########
  ## FONTS
  ########
  fonts.fonts = with pkgs; [
    font-awesome
    hack-font
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
      };

      shellInit = ''
      '';

    }; 
  };
  #programs.ssh.askPassword = ""; # ssh will ask for password inside the terminal

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?


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
}

