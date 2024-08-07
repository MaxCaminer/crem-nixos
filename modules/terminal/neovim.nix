{
lib,
config,
...
}:{
	options = {
		neovim.enable =
			lib.mkEnableOption "enables neovim";
	};

	config = lib.mkIf config.neovim.enable {
    programs.neovim = {
			enable = true;
			viAlias = true;
			vimAlias = true;
			vimdiffAlias = true;
			withPython3 = true;
			extraConfig = ''
				set number relativenumber
				set tabstop=4
				set shiftwidth=4 smarttab
			'';		
	  };
	};
}
