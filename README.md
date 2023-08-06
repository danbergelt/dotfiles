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

3. Initialize a local config:

```sh
$ home-manager init
```

4. Clone the dotfiles:

```sh
$ git clone https://github.com/danbergelt/dotfiles.git ~/dotfiles
```

5. Open up the config generated in step 3:

```sh
home-manager edit
```

6. Import the cloned `base.nix`:

```nix
imports = [
  <your_home_dir>/dotfiles/base.nix
];
```

7. Install:

```sh
# This command (re)initializes your env. You'll run
# this after every change to home.nix or base.nix
$ home-manager switch
```
