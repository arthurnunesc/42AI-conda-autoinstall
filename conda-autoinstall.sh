#!/bin/sh

# This script is written to be POSIX-compliant.

# Checks OS to define the correct conda install script name
define_conda_link() {
  if uname -s | grep -iqF Darwin; then
    echo "Miniconda3-latest-MacOSX-x86_64.sh"
  else
    echo "Miniconda3-latest-Linux-x86_64.sh"
  fi
}

which_shell() {
  if echo "$SHELL" | grep -iqF zsh; then
    echo "zsh"
  else
    echo "bash"
  fi
}

# $1=conda executable, $2=pip packages to install 
check_and_install_42AIenv() {
  printf 'Checking 42AI-%s environment: ' "$USER"
  if "$1" info --envs | grep -iqF 42AI-"$USER"; then
    printf "\e[33mDONE\e[0m\n"
  else
    printf "\e[31mKO\e[0m\n"
    printf "\e[33mCreating 42AI environnment:\e[0m\n"
    "$1" update -n base -c defaults conda -y
    # Double quoting $2 for some reason makes arguments be read as "jupyter==numpy=pandas pycodestyle" instead of "jupyter numpy pandas pycodestyle"
    "$1" create --name 42AI-"$USER" python=3.7 $2 -y
  fi
}

set_conda() {
  MINICONDA_PATH="$HOME/.local/miniconda3"
  CONDA="$MINICONDA_PATH/bin/conda"
  PIP_PACKAGES="jupyter numpy pandas pycodestyle"
  INSTALL_SCRIPT_NAME=$(define_conda_link)
  MY_SHELL=$(which_shell)
  DL_LINK="https://repo.anaconda.com/miniconda/"$INSTALL_SCRIPT_NAME
  DL_LOCATION="/tmp/"

  printf "Checking conda: "
  if $CONDA -h 2>/dev/null; then
    printf "\e[32mOK\e[0m\n"
    check_and_install_42AIenv "$CONDA" "$PIP_PACKAGES"
    return
  else
    printf "\e[31mKO\e[0m\n"
  fi
  printf "Checking if conda install script is downloaded: "
  if [ ! -f "$DL_LOCATION""$INSTALL_SCRIPT_NAME" ]; then
    printf "\e[31mKO\e[0m\n"
    printf "\e[33mDonwloading installer:\e[0m\n"
    wget -P "$DL_LOCATION" "$DL_LINK"
  else
    printf "\e[32mOK\e[0m\n"
  fi
  printf "\e[33mInstalling conda:\e[0m\n"
  sh "$DL_LOCATION""$INSTALL_SCRIPT_NAME" -b -p "$MINICONDA_PATH"
  printf "\e[33mConda initial setup:\e[0m\n"
  $CONDA init "$MY_SHELL"
  $CONDA config --set auto_activate_base false
  check_and_install_42AIenv "$CONDA" "$PIP_PACKAGES"
  printf "\e[33mLaunch the following command or restart your shell:\e[0m\n"
  if [ "$MY_SHELL" = "zsh" ]; then
    printf "\tsource ~/.zshrc\n"
  else
    printf "\tsource ~/.bash_profile\n"
  fi
}

set_conda
