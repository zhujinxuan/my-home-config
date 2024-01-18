{ config, pkgs, ... }: {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "zhujinxuan";
    userEmail = "zhujinxuan@gmail.com";
    delta = {
      enable = true;
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "decorations";
        whitespace-error-style = "22 reverse";
      };
    };
  };

  programs.password-store = {
    enable = true;
    settings = { PASSWORD_STORE_KEY = "0x98311E6463708C2B"; };
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  programs.bat = {
    enable = true;
    config = { theme = "TwoDark"; };
    extraPackages = with pkgs.bat-extras; [ batgrep batman batdiff batwatch ];
  };

  programs.eza = { enable = true; };

  home.file.tridactyl = {
    source = ./home-files/tridactylrc;
    target = ".tridactylrc";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    stdlib = ''
      use_nvm() {
        local node_version=$1

        nvm_sh=~/.nvm/nvm.sh
        if [[ -e $nvm_sh ]]; then
          source $nvm_sh
          nvm use $node_version
        fi
      }
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    prezto = {
      enable = true;
      editor = {
        keymap = "vi";
        dotExpansion = true;
        promptContext = true;
      };
      utility.safeOps = false;

      pmodules = [
        "archive"
        "autosuggestions"
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "fasd"
        "spectrum"
        "ssh"
        "completion"
        "syntax-highlighting"
        "history-substring-search"
        "node"
        "homebrew"
        "haskell"
        "prompt"
      ];
      prompt = {
        theme = "powerlevel10k";
        pwdLength = "long";
      };
      tmux.itermIntegration = true;
      autosuggestions.color = "fg=blue";
    };
  };

  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
    controlPersist = "4h";
    matchBlocks = {
      "egenerationmarketing.com" = {
        hostname = "egenerationmarketing.com";
        user = "root";
        identityFile = [ "~/.ssh/egm-aws.pem" "~/.ssh/id_rsa" ];
        identitiesOnly = true;
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = [ "~/.ssh/id_rsa" ];
      };
      "github-kakaa" = {
        hostname = "github.com";
        user = "git";
        identityFile = [ "~/.ssh/kakaa_rsa" ];
        identitiesOnly = true;
      };
    };
  };

}
