# dotfiles

1. Install nix:

```sh
sh <(curl -L https://nixos.org/nix/install) --no-daemon
. $HOME/.nix-profile/etc/profile.d/nix.sh
```

2. Install Home Manager:

```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

3. Initialize a local config:

```sh
home-manager init
```

4. Clone the dotfiles:

```sh
git clone https://github.com/danbergelt/dotfiles.git ~/dotfiles
```

Inside the repo, you'll probably want to set the remote to include a Github access token:

```sh
git remote remove origin
git remote add origin "https://<TOKEN>@github.com/danbergelt/dotfiles.git"

# Recommended for consistency when pushing commits
git config user.name "danbergelt"
git config user.email "dan@danbergelt.com"
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
home-manager switch
```
