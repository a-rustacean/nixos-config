{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.zsh =
        let
          omzCustom = pkgs.linkFarm "omz-custom" [
            {
              name = "themes/powerlevel10k";
              path = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
            }
            {
              name = "plugins/zsh-autosuggestions";
              path = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
            }
            {
              name = "plugins/zsh-autopair/zsh-autopair.plugin.zsh";
              path = "${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh";
            }
          ];
        in
        inputs.wrapper-modules.wrappers.zsh.wrap {
          inherit pkgs;
          package = pkgs.zsh;
          runtimePkgs = [
            pkgs.nix-zsh-completions
            pkgs.oh-my-zsh
          ];
          zshrc.content = ''
            source ${../../p10k-zsh}
            plugins=(git zsh-autopair zsh-autosuggestions node nvm npm rust)
            ZSH_THEME=powerlevel10k/powerlevel10k
            ZSH_CUSTOM=${omzCustom}
            source ${pkgs.oh-my-zsh}/share/oh-my-zsh/oh-my-zsh.sh

            typeset -U path cdpath fpath manpath
            for profile in ''${(z)NIX_PROFILES}; do
              fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
            done
            HELPDIR="${pkgs.zsh}/share/zsh/$ZSH_VERSION/help"

            set_opts=(
              HIST_FCNTL_LOCK HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
              NO_APPEND_HISTORY NO_EXTENDED_HISTORY NO_HIST_EXPIRE_DUPS_FIRST
              NO_HIST_FIND_NO_DUPS NO_HIST_IGNORE_ALL_DUPS NO_HIST_SAVE_NO_DUPS
            )
            for opt in "''${set_opts[@]}"; do
              setopt "$opt"
            done
            unset opt set_opts

            HISTSIZE="10000"
            SAVEHIST="10000"
            HISTFILE="/home/$USER/.zsh_history"
          '';
        };
    };
}
