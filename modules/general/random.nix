{
pkgs,
...
}:{
	home.packages = with pkgs; [
        neofetch
        git
        dig
        krb5
        docker
        updog
        feh
        google-chrome
        sqlite-web
        sqlite-utils
				unstable.ueberzugpp
    ];
}
