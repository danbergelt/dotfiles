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

4. Clone the dotfiles to your home directory:

```sh
git clone https://github.com/danbergelt/dotfiles.git ~/dotfiles
```

5. Configure your cloned dotfiles repo:

```sh
# Set an access token
git remote remove origin
git remote add origin "https://<TOKEN>@github.com/danbergelt/dotfiles.git"

# Set the user
git config user.name "danbergelt"
git config user.email "dan@danbergelt.com"
```

6. Open up the config generated in step 3:

```sh
home-manager edit
```

7. Import the cloned `base.nix`:

```nix
{ config, pkgs, ... }:

{
  # ...other generated fields

  imports = [~/dotfiles/base.nix];
}
```

8. Install:

```sh
home-manager switch
```
