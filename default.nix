{ config, pkgs, ...}:
let
  link = config.lib.file.mkOutOfStoreSymlink;

  # vim packages not in nixpkgs, but from github
  ccryptor-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "ccryptor.nvim";
    version = "2025-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "kurotych";
      repo = "ccryptor.nvim";
      rev = "4b2cd7fbf54eb8385d023b7411be4a46ab0eded8";
      hash = "sha256-CUjM8cr+SbgSd+NFbHysxogbq0QPJ/pXdSGo4p5AuHo=";
    };
  };
  telescope-ag = pkgs.vimUtils.buildVimPlugin {
    pname = "telescope-ag";
    version = "2025-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "kelly-lin";
      repo = "telescope-ag";
      rev = "7d25064da3c7689461bcfa89ad1f08548415193d";
      hash = "sha256-xOgiiTElHLgx7Gwp6aR0Ipfanq6ZTTgiQv9Zs3LTb1g=";
    };
  };

  copilot-vim = pkgs.vimUtils.buildVimPlugin {
    pname = "copilot.vim";
    version = "2025-05-13";
    src = pkgs.fetchFromGitHub {
      owner = "github";
      repo = "copilot.vim";
      rev = "d1e8429bef7f7709586886b0a23a46fbecc685c4";
      sha256 = "0cmsmfhna1yx81kbr23br206kicph0fpwqycvnh1mv5cibg26k9g";
    };
  };

in
{
  programs.ripgrep.enable = true;
  programs.fd.enable = true; # find replacement; depends on ripgrep and for telescope
  programs.fzf.enable = true;
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      gruvbox # theme
      vim-nix # nix language
      vim-lsp # lsp
      telescope-nvim # fuzzy finder
      telescope-fzf-native-nvim
      oil-nvim # OIL file manager
      lazygit-nvim # git support 

      markdown-preview-nvim

      # tmux navigator, depends on tmux plugin in config
      vim-tmux-navigator
      vim-commentary # comment out lines
      vim-windowswap
      git-blame-nvim # git blame
      limelight-vim # used for highlighting the current line

      flash-nvim # fast nav using s

      # adding a gitlinker that lets me grab URLS
      gitlinker-nvim

      # DIY Plugins
      ccryptor-nvim

      # conflict marker vim 
      conflict-marker-vim

      # in vim terminal, configured for pop up
      toggleterm-nvim

      vim-table-mode

      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
    ];
    initLua = ''
      dofile("${link ./init.lua}")
    '';
  };

  home.packages = [
    pkgs.nodejs
    pkgs.wl-clipboard
    pkgs.xclip
  ];

  home.file.".config/nvim/lua" = {
    enable = true;
    source = link ./lua;
  };
}
