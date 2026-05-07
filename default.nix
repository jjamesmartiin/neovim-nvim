{ config, pkgs, ...}:
let
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  programs.ripgrep.enable = true;
  programs.fd.enable = true; # find replacement; depends on ripgrep and for telescope
  programs.fzf.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      gruvbox # theme
      vim-lsp # lsp
      telescope-nvim # fuzzy finder
      telescope-fzf-native-nvim
      oil-nvim # OIL file manager, view link for help https://github.com/stevearc/oil.nvim?tab=readme-ov-file
      lazygit-nvim # git support 

      # tmux navigator, depends on tmux plugin in config
      vim-tmux-navigator
      vim-commentary # comment out lines
      git-blame-nvim # git blame

      flash-nvim # fast nav using s

      # in vim terminal, configured for pop up
      toggleterm-nvim

      vim-table-mode

      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
    ];
  };

  home.file.".config/nvim/init.lua" = { 
    enable = true;
    source = link ./nvim-vimrc.lua;
  };
}
