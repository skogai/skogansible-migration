# Ansible Collection Tools - Task Inventory

This document contains a complete inventory of all Ansible tasks defined in the ansible-collection-tools collection, organized by role.

## Table of Contents

- [age](#age)
- [atuin](#atuin)
- [awscli](#awscli)
- [bat](#bat)
- [cfssl](#cfssl)
- [chezmoi](#chezmoi)
- [croc](#croc)
- [direnv](#direnv)
- [eza](#eza)
- [fd](#fd)
- [fzf](#fzf)
- [git_delta](#git_delta)
- [golang](#golang)
- [haproxy](#haproxy)
- [iaac](#iaac)
- [just](#just)
- [k8s](#k8s)
- [kitty](#kitty)
- [lazydocker](#lazydocker)
- [lazygit](#lazygit)
- [minio](#minio)
- [mkcert](#mkcert)
- [nvim_bob](#nvim_bob)
- [nvm](#nvm)
- [ohmyzsh](#ohmyzsh)
- [prek](#prek)
- [python](#python)
- [rclone](#rclone)
- [restic](#restic)
- [ripgrep](#ripgrep)
- [shellcheck](#shellcheck)
- [shfmt](#shfmt)
- [sops](#sops)
- [starship](#starship)
- [syncthing](#syncthing)
- [taplo](#taplo)
- [yazi](#yazi)
- [yq](#yq)
- [zellij](#zellij)
- [zoxide](#zoxide)

---

## age

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Check if binary already exists in $PATH
- Get installed version if any
- Register installed version vars
- Displaying installed version

### release.yaml

- Get checksum
- Registering checksums related vars
- Get checksums list
- Get checksum for {{ age_release_artifact_name }}
- Installing age {{ age_v }}
- Ensure permissions

---

## atuin

### main.yaml

- Preflight preparation
- Installing Atuin

### preflight.yaml

- Check if binary already exists in $PATH
- Get installed version if any
- Register installed version vars
- Displaying installed version

### release.yaml

- Get checksum
- Registering checksums related vars
- Get checksums list
- Get checksum for {{ atuin_release_artifact_name }}
- Installing atuin {{ atuin_v }}
- Ensure permissions

---

## awscli

### main.yaml

- Preflight preparation
- Installing awscli on the Linux OS from archive

### preflight.yaml

- Check if binary already exists in $PATH
- Binary path data
- Get installed version if any
- Register preflight facts
- Reporting installed version

### linux.yaml

- Getting awscli release artifact archive
- Creating extraction dir {{ awscli_extraction_dst }}
- Extracting archive
- Installing awscli
- Updating awscli
- Deleting downloaded artifacts

---

## bat

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting preflight facts
- Reporting installed version
- Check if Bash completions path exists
- Check if ZSH completions path exists
- Check if Fish completions path exists

### release_archive.yaml

- Creating extraction dir {{ bat_extraction_path }}
- Getting release archive
- Extracting archive to {{ bat_extraction_path }}
- Installing binary to {{ bat_bin_dst }}/{{ bat_bin }}
- Installing Bash completions
- Installing ZSH completions
- Installing Fish completions
- Deleting release artifacts

---

## cfssl

### main.yaml

- Preflight preparation
- Deploy cfssl from release archive

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version

### release_archive.yaml

- Creating extraction dir {{ cfssl_extraction_path }}
- Getting release archive
- Extracting archive to {{ cfssl_extraction_path }}
- Installing cfssl-bundle to {{ cfssl_bin_dst }}
- Installing cfssl-certinfo to {{ cfssl_bin_dst }}
- Installing cfssl-newkey to {{ cfssl_bin_dst }}
- Installing cfssl-scan to {{ cfssl_bin_dst }}
- Installing cfssl-ocspdump to {{ cfssl_bin_dst }}
- Installing cfssl to {{ cfssl_bin_dst }}
- Installing cfssljson to {{ cfssl_bin_dst }}
- Deleting release artifacts

---

## chezmoi

### main.yaml

- Preflight preparation
- Get checksum
- Install chezmoi release archive
- Install chezmoi binary
- Install chezmoi release OS package

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Set final artifact name
- Check if Bash completions path exists
- Check if ZSH completions path exists
- Check if Fish completions path exists

### checksums.yaml

- Registering Github API headers
- Get checksums list
- Get checksum for {{ _chezmoi_artifact_name }}

### release_archive.yaml

- Creating extraction dir {{ chezmoi_extraction_path }}
- Dowloading release archive
- Extracting archive to {{ chezmoi_extraction_path }}
- Installing chezmoi binary to {{ chezmoi_bin_dst }}/{{ chezmoi_bin }}
- Installing ZSH completions
- Installing Bash completions
- Installing Fish completions
- Deleting release artifacts

### release_package.yaml

- Getting release chezmoi
- Install RPM package
- Install DEB package

### release_binary.yaml

- Download chezmoi binary

---

## croc

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version

### release_archive.yaml

- Creating extraction dir {{ croc_extraction_path }}
- Getting release archive
- Extracting archive to {{ croc_extraction_path }}
- Installing binary to {{ croc_bin_dst }}/{{ croc_bin }}
- Deleting release artifacts

---

## direnv

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Check if binary already exists in $PATH
- Get installed version if any
- Register installed version vars
- Displaying current version

### release.yaml

- Deploying direnv {{ direnv_v }}
- Set permissions

---

## eza

### main.yaml

- Preflight preparation
- Release archive installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version
- Check if Bash completions path exists
- Check if ZSH completions path exists
- Check if Fish completions path exists

### release_archive.yaml

- Creating extraction dir {{ eza_extraction_path }}
- Getting release archive
- Extracting archive to {{ eza_extraction_path }}
- Installing binary to {{ eza_bin_dst }}/{{ eza_bin }}
- Deploy man pages
- Creating extraction dir {{ eza_extraction_path }}/man
- Extracting man archive to {{ eza_extraction_path }}/man
- Locate man pages
- Install man pages to correct section
- Deploy eza completions for shells
- Creating extraction dir {{ eza_extraction_path }}/completions
- Extracting completions archive to {{ eza_extraction_path }}/completions
- Installing ZSH completions
- Installing Bash completions
- Installing Fish completions
- Deleting release artifacts

---

## fd

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version
- Check if Bash completions path exists
- Check if ZSH completions path exists
- Check if Fish completions path exists

### release_archive.yaml

- Creating extraction dir {{ fd_extraction_path }}
- Getting release archive
- Extracting archive to {{ fd_extraction_path }}
- Installing binary to {{ fd_bin_dst }}/{{ fd_bin }}
- Installing man pages
- Installing ZSH completions
- Installing Bash completions
- Installing Fish completions
- Deleting release artifacts

---

## fzf

### main.yaml

- Preflight preparation
- Get fzf-tmux completions path
- Installing fzf from release archive
- Installing fzf from OS packages

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version

### release_archive.yaml

- Creating extraction dir {{ fzf_extraction_path }}
- Getting release archive
- Extracting archive to {{ fzf_extraction_path }}
- Installing binary to {{ fzf_bin_dst }}/{{ fzf_bin }}
- Installing man pages
- Installing ZSH completions
- Installing Bash completions
- Installing Fish completions
- Deleting release artifacts

---

## git_delta

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version
- Check if Bash completions path exists
- Check if ZSH completions path exists
- Check if Fish completions path exists

### release_archive.yaml

- Creating extraction dir {{ git_delta_extraction_path }}
- Getting release archive
- Extracting archive to {{ git_delta_extraction_path }}
- Installing binary to {{ git_delta_bin_dst }}/{{ git_delta_bin }}
- Installing ZSH completions
- Installing Bash completions
- Installing Fish completions
- Deleting release artifacts

---

## golang

### main.yaml

- Preflight preparation
- Installing golang from release archive

### preflight.yaml

- Check if golang binary already exists
- Get installed version if any
- Register golang version vars
- Displaying installed golang version

### release_archive.yaml

- Getting golang release archive
- Creating golang installation directory {{ golang_install_path }}
- Removing old golang version
- Extracting golang archive
- Setting golang permissions

---

## haproxy

### main.yaml

- Preflight preparation
- Getting haproxy installed version
- Installing haproxy from release archive
- Installing haproxy OS packages

### preflight.yaml

- Check if binary already exists in $PATH
- Get installed version if any
- Register installed version vars
- Displaying installed version

### release_archive.yaml

- Creating extraction dir {{ haproxy_extraction_path }}
- Extracting archive
- Copying binary to {{ haproxy_bin_dst }}/{{ haproxy_bin }}
- Creating haproxy user and group
- Setting haproxy permissions
- Creating haproxy config directory
- Creating haproxy sysconfig directory
- Deploying haproxy sysconfig file
- Deploying haproxy configuration file
- Setting haproxy systemd service

---

## iaac

### main.yaml

- Check current state
- Deployment plan
- Apply deployment

### preflight.yaml

- Assert iaac_action value
- Setup output variable

---

## just

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version
- Check if Bash completions path exists
- Check if ZSH completions path exists
- Check if Fish completions path exists

### release_archive.yaml

- Creating extraction dir {{ just_extraction_path }}
- Getting release archive
- Extracting archive to {{ just_extraction_path }}
- Installing binary to {{ just_bin_dst }}/{{ just_bin }}
- Installing man pages
- Installing ZSH completions
- Installing Bash completions
- Installing Fish completions
- Deleting release artifacts

---

## k8s

### main.yaml

- Preflight preparation
- Deploy kubectl from release archive
- Deploying helm from release archive
- Deploying kubectx from release archive

### preflight.yaml

- Check if kubectl binary already exists
- Get kubectl installed version if any
- Register kubectl version vars
- Displaying installed kubectl version
- Check if helm binary already exists
- Get helm installed version if any
- Register helm version vars
- Displaying installed helm version
- Check if kubectx binary already exists
- Get kubectx installed version if any
- Register kubectx version vars
- Displaying installed kubectx version

### helm_archive.yaml

- Creating helm extraction dir {{ helm_extraction_path }}
- Getting helm release archive
- Extracting helm archive to {{ helm_extraction_path }}
- Installing helm binary to {{ helm_bin_dst }}/{{ helm_bin }}
- Setting helm permissions
- Deleting helm release artifacts

### kubectl_archive.yaml

- Creating kubectl extraction dir {{ kubectl_extraction_path }}
- Getting kubectl release archive
- Extracting kubectl archive to {{ kubectl_extraction_path }}
- Installing kubectl binary to {{ kubectl_bin_dst }}/{{ kubectl_bin }}
- Setting kubectl permissions
- Deleting kubectl release artifacts

### kubectx_archive.yaml

- Creating kubectx extraction dir {{ kubectx_extraction_path }}
- Getting kubectx release archive
- Extracting kubectx archive to {{ kubectx_extraction_path }}
- Installing kubectx binary to {{ kubectx_bin_dst }}/{{ kubectx_bin }}
- Installing kubens binary to {{ kubectx_bin_dst }}/{{ kubectx_switch_bin }}
- Setting kubectx permissions
- Deleting kubectx release artifacts

---

## kitty

### main.yaml

- Preflight preparation
- Installing kitty from repository
- Installing kitty from release archive

### preflight.yaml

- Check if binary already exists in $PATH
- Get installed version if any
- Register installed version vars
- Displaying installed version

### release_archive.yaml

- Creating extraction dir {{ kitty_extraction_path }}
- Getting release archive
- Extracting archive to {{ kitty_extraction_path }}
- Installing binary to {{ kitty_bin_dst }}/{{ kitty_bin }}
- Creating symbolic link for kitty
- Setting kitty permissions
- Installing terminfo file
- Deploying kitty desktop file
- Deleting release artifacts

---

## lazydocker

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version

### release_archive.yaml

- Creating extraction dir {{ lazydocker_extraction_path }}
- Getting release archive
- Extracting archive to {{ lazydocker_extraction_path }}
- Installing binary to {{ lazydocker_bin_dst }}/{{ lazydocker_bin }}
- Deleting release artifacts

---

## lazygit

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version

### release_archive.yaml

- Creating extraction dir {{ lazygit_extraction_path }}
- Getting release archive
- Extracting archive to {{ lazygit_extraction_path }}
- Installing binary to {{ lazygit_bin_dst }}/{{ lazygit_bin }}
- Deleting release artifacts

---

## minio

### main.yaml

- Preflight preparation
- Getting minio installed version
- Installing minio client from release archive
- Installing minio server from release archive

### preflight.yaml

- Check if binary already exists in $PATH
- Get installed version if any
- Register installed version vars
- Displaying installed version

### minio_client.yaml

- Getting minio client release archive
- Installing minio client binary to {{ minio_bin_dst }}/{{ minio_mc_bin }}
- Setting minio client permissions

### minio_server.yaml

- Getting minio server release archive
- Installing minio server binary to {{ minio_bin_dst }}/{{ minio_bin }}
- Setting minio server permissions
- Creating minio user and group
- Creating minio data directory
- Setting minio data directory permissions
- Deploying minio environment file
- Deploying minio systemd service
- Starting and enabling minio service

---

## mkcert

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Check if binary already exists in $PATH
- Get installed version if any
- Register installed version vars
- Displaying installed version

### release.yaml

- Deploying mkcert {{ mkcert_v }}
- Set permissions

---

## nvim_bob

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version

### release_archive.yaml

- Creating extraction dir {{ nvim_bob_extraction_path }}
- Getting release archive
- Extracting archive to {{ nvim_bob_extraction_path }}
- Installing binary to {{ nvim_bob_bin_dst }}/{{ nvim_bob_bin }}
- Deleting release artifacts

---

## nvm

### main.yaml

- Preflight preparation
- Installing nvm from release archive

### preflight.yaml

- Checking if nvm directory exists
- Getting installed nvm version if any
- Registering nvm version vars
- Displaying installed nvm version

### release_archive.yaml

- Creating nvm installation directory
- Cloning nvm from GitHub
- Checking out nvm version {{ nvm_v }}
- Installing nvm

---

## ohmyzsh

### main.yaml

- Preflight preparation
- Dependencies installation
- Oh-my-zsh setup on a Linux host

### example.yaml

- Example Oh-my-zsh setup on ubuntu
- Install oh-my-zsh for the current user
- Install zsh-syntax-highlighting
- Cloning fast-syntax-highlighting
- Installing powerlevel10k

### preflight.yaml

- Assert omz_update_mode value
- Assert omz_update_frequency value
- Set omz_users variable if empty

### deps.yaml

- Installing dependencies on Linux
- Create global fpath directories

### ohmyzsh.yaml

- Get zsh path
- Set zsh path fact
- Checking if user "{{ omz_user.name }}" exists
- Seting facts about the user "{{ omz_user.name }}"
- Clonning oh-my-zsh repo for "{{ omz_user.name }}"
- Create custom fpath directories for user "{{ omz_user.name }}"
- Set ~/.oh-my-zsh permissions for user "{{ omz_user.name }}"
- Checking if ~/.zshrc exists for "{{ omz_user.name }}"
- Adding default ~/.zshrc for "{{ omz_user.name }}"
- Putting ~/.zshrc for "{{ omz_user.name }}"
- Setting ZSH theme "{{ omz_theme }}"
- Configuring custom .zshrc
- Setting zsh as default shell for the user "{{ omz_user.name }}"

---

## prek

### main.yaml

- Preflight preparation
- Getting prek installed version
- Creating prek config file
- Installing prek from release

### preflight.yaml

- Check if binary already exists in $PATH
- Get installed version if any
- Register installed version vars
- Displaying installed version

### config.yaml

- Set prek config path facts
- Create prek config directory
- Create prek configuration file

### release.yaml

- Creating extraction dir {{ prek_extraction_path }}
- Getting prek release archive
- Extracting archive to {{ prek_extraction_path }}
- Installing prek binary to {{ prek_bin_dst }}/{{ prek_bin }}
- Setting prek binary permissions
- Deleting prek release artifacts

---

## python

### main.yaml

- Preflight preparation
- Installing pyenv from release archive

### preflight.yaml

- Check if pyenv binary already exists
- Get installed version if any
- Register pyenv version vars
- Displaying installed pyenv version

### release_archive.yaml

- Creating pyenv installation directory
- Cloning pyenv from GitHub
- Installing pyenv build dependencies
- Initializing pyenv

---

## rclone

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version
- Check if Bash completions path exists
- Check if ZSH completions path exists

### release_archive.yaml

- Creating extraction dir {{ rclone_extraction_path }}
- Getting release archive
- Extracting archive to {{ rclone_extraction_path }}
- Installing binary to {{ rclone_bin_dst }}/{{ rclone_bin }}
- Installing man pages
- Installing ZSH completions
- Installing Bash completions
- Deleting release artifacts

---

## restic

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version

### release_binary.yaml

- Getting release binary
- Installing binary to {{ restic_bin_dst }}/{{ restic_bin }}
- Setting restic binary permissions

---

## ripgrep

### main.yaml

- Preflight preparation
- Deploy from release archive
- Install ripgrep on a Debian based OS
- Install ripgrep on a RedHat based OS

### preflight.yaml

- Get currently installed version if any
- Setting preflight facts
- Reporting installed version
- Check if Bash completions path exists
- Check if ZSH completions path exists
- Check if Fish completions path exists

### uninstall.yaml

- Uninstall ripgrep installed from release archive
- Removing ripgrep binary
- Removing ripgrep man pages
- Removing ripgrep Bash completions
- Removing ripgrep ZSH completions
- Removing ripgrep Fish completions

### debian.yaml

- Install ripgrep on Debian based OS
- Install ripgrep from release deb package
- Install ripgrep from OS packages
- Uninstall ripgrep

### redhat.yaml

- Install ripgrep from EPEL packages
- Install epel-release
- Install ripgrep from epel
- Install ripgrep on Fedora
- Uninstall ripgrep

### release.yaml

- Get checksum
- Registering checksums related vars
- Get checksums list
- Get checksum for {{ ripgrep_release_archive_name }}
- Creating extraction dir {{ ripgrep_extraction_path }}
- Getting release archive
- Extracting archive to {{ ripgrep_extraction_path }}
- Installing ripgrep binary to {{ ripgrep_bin_dst }}/{{ ripgrep_bin }}
- Installing man pages
- Installing ZSH completions
- Installing Bash completions
- Installing Fish completions
- Deleting release artifacts

### handlers/main.yaml

- Remove ripgrep archive
- Set ripgrep permissions and ownership

---

## shellcheck

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version

### release_archive.yaml

- Creating extraction dir {{ shellcheck_extraction_path }}
- Getting release archive
- Extracting archive to {{ shellcheck_extraction_path }}
- Installing binary to {{ shellcheck_bin_dst }}/{{ shellcheck_bin }}
- Deleting release artifacts

---

## shfmt

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Check if binary already exists in $PATH
- Get installed version if any
- Register installed version vars
- Displaying installed version

### release.yaml

- Get checksum
- Registering checksums related vars
- Get checksums list
- Get checksum for {{ shfmt_release_artifact_name }}
- Installing shfmt {{ shfmt_v }}
- Ensure permissions

---

## sops

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version

### release_archive.yaml

- Creating extraction dir {{ sops_extraction_path }}
- Getting release archive
- Extracting archive to {{ sops_extraction_path }}
- Installing binary to {{ sops_bin_dst }}/{{ sops_bin }}
- Deleting release artifacts

---

## starship

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version

### release_archive.yaml

- Creating extraction dir {{ starship_extraction_path }}
- Getting release archive
- Extracting archive to {{ starship_extraction_path }}
- Installing binary to {{ starship_bin_dst }}/{{ starship_bin }}
- Deleting release artifacts

---

## syncthing

### main.yaml

- Preflight preparation
- Getting syncthing installed version
- Installing syncthing from release archive

### preflight.yaml

- Check if binary already exists in $PATH
- Get installed version if any
- Register installed version vars
- Displaying installed version

### release_archive.yaml

- Creating extraction dir {{ syncthing_extraction_path }}
- Getting release archive
- Extracting archive to {{ syncthing_extraction_path }}
- Installing syncthing binary to {{ syncthing_bin_dst }}/{{ syncthing_bin }}
- Creating syncthing user and group
- Creating syncthing home directory
- Setting syncthing home directory permissions
- Deploying syncthing systemd service
- Starting and enabling syncthing service

---

## taplo

### main.yaml

- Preflight preparation
- Release archive installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version

### release_archive.yaml

- Creating extraction dir {{ taplo_extraction_path }}
- Getting release archive
- Gunzip file in-place
- Installing binary to {{ taplo_bin_dst }}/{{ taplo_bin }}
- Deleting release artifacts

---

## yazi

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version

### release_archive.yaml

- Creating extraction dir {{ yazi_extraction_path }}
- Getting release archive
- Extracting archive to {{ yazi_extraction_path }}
- Installing binary to {{ yazi_bin_dst }}/{{ yazi_bin }}
- Deleting release artifacts

---

## yq

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version

### release_binary.yaml

- Getting release binary
- Installing binary to {{ yq_bin_dst }}/{{ yq_bin }}
- Setting yq binary permissions

---

## zellij

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version

### release_archive.yaml

- Creating extraction dir {{ zellij_extraction_path }}
- Getting release archive
- Extracting archive to {{ zellij_extraction_path }}
- Installing binary to {{ zellij_bin_dst }}/{{ zellij_bin }}
- Deleting release artifacts

---

## zoxide

### main.yaml

- Preflight preparation
- Binary download and installation

### preflight.yaml

- Get currently installed version if any
- Setting version facts
- Reporting installed version

### release_archive.yaml

- Creating extraction dir {{ zoxide_extraction_path }}
- Getting release archive
- Extracting archive to {{ zoxide_extraction_path }}
- Installing binary to {{ zoxide_bin_dst }}/{{ zoxide_bin }}
- Deleting release artifacts

---

## Summary Statistics

- **Total Roles**: 41
- **Total Task Files**: 120+
- **Task Organization**: Organized by role, then by task file within each role
- **Common Task Patterns**:
  - Preflight preparation/checks
  - Version management and detection
  - Binary/archive downloads
  - Installation and permissions
  - Shell completions (Bash, ZSH, Fish)
  - Man page installation

Generated: 2025-12-18
