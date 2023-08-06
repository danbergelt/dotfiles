# dotfiles

1. Install nix:

```sh
$ sh <(curl -L https://nixos.org/nix/install) --no-daemon
$ . $HOME/.nix-profile/etc/profile.d/nix.sh
```

2. Install Home Manager:

```sh
$ nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
$ nix-channel --update
$ nix-shell '<home-manager>' -A install
```

3. Clone the dotfiles:

```sh
$ git clone https://github.com/danbergelt/dotfiles.git ~/dotfiles
```

(optional) 3a. Update `home.nix` file (E.G., updating `home.username` to match your username)

4. Install:

```sh
# This alias will be in the $PATH after the initial installation
$ alias hm="home-manager -f $HOME/dotfiles/home.nix"
# This command (re)initializes your environment. Run it after changes
$ hm switch
```
