#!/bin/bash
# Custom installation
# Zen Desktop Environment @ Debian Stable
# Is recommended a fresh installation of Debian Stable without any Desktop Environment

# Global variables
ROOT=`whoami`
ZEN_USER=""
ZEN_REPO="https://raw.githubusercontent.com/TonyWhite/ZenDE/main"

function main()
{
  # Must be root
  if [[ "${ROOT}" == "root" ]]; then
    select_user
    if [[ "${ZEN_USER}" != "" ]]; then
      # Ok, let's install
      debian_stable_repository
      install_environment
      default_themes
      jwm_per_user
      echo "Installation terminated."
      printf "Reboot in "
      printf "3..."
      sleep 1
      printf "2..."
      sleep 1
      printf "1..."
      sleep 1
      printf "0"
      reboot
    else
      echo "No users in /home"
      echo ""
      echo "   KEEP CALM   "
      echo "      and      "
      echo "CREATE NEW USER"
    fi
  else
    echo "You aren't root."
  fi
}

function select_user()
{
  USER_LIST=`ls /home`
  if [[ ${#USER_LIST[@]} == 1 ]]; then
    ZEN_USER=${USER_LIST[0]}
  elif [[ ${#USER_LIST[@]} -gt 1 ]]; then
    while true; do
      clear
      echo "Select one user:"
      for ITEM in ${USER_LIST[@]}; do
        echo "- ${ITEM}"
      done
      read CHOICE
      
      CORRECT_CHOICE=false
      for ITEM in ${USER_LIST[@]}; do
        if [[ "${CHOICE}" == "${ITEM}" ]]; then
          CORRECT_CHOICE=true
          ZEN_USER=${CHOICE}
          break
        fi
      done
      
      if [[ $CORRECT_CHOICE == true ]]; then
        break
      fi
    done
  fi
}

function debian_stable_repository()
{
  printf "Setting Official Debian Stable repository..."
  (
    echo "#########################"
    echo "# OFFICIAL DEBIAN REPOS #"
    echo "#########################"
    echo "# Main"
    echo "deb [arch=all,amd64,i386] http://deb.debian.org/debian/ stable main contrib non-free"
    echo "deb [arch=all,amd64,i386] http://deb.debian.org/debian/ stable-updates main contrib non-free"
    echo "deb [arch=all,amd64,i386] http://deb.debian.org/debian-security/ stable-security main"
    echo ""
    echo "# Testing"
    echo "#deb [arch=all,amd64,i386] http://deb.debian.org/debian/ testing main contrib non-free"
    echo "#deb [arch=all,amd64,i386] http://deb.debian.org/debian/ testing-updates main contrib non-free"
    echo ""
    echo "# Backports"
    echo "#deb http://deb.debian.org/debian stable-backports main"
  ) > /etc/apt/sources.list
  echo "OK"
  echo "Requesting update..."
  apt-get update
}

function default_themes()
{
  echo "##########################"
  echo "# Set GTK Theme for root #"
  echo "##########################"
  cd "/root"
  wget "${ZEN_REPO}/usr/share/zen-de/superuser/.gtkrc-2.0"
  mkdir -p "/root/.config/gtk-3.0"
  cd "/root/.config/gtk-3.0"
  wget "${ZEN_REPO}/usr/share/zen-de/superuser/.config/gtk-3.0/settings.ini"
  
  echo "##################################"
  echo "# Monokai theme for text editors #"
  echo "##################################"
  NAME="monokai.xml"
  cd /usr/share/gtksourceview*
  cd "styles"
  wget "${ZEN_REPO}/usr/share/gtksourceview/${NAME}"
  
  #echo "#############"
  #echo "# Vimix GTK #"
  #echo "#############"
  #cd "/root"
  #wget "https://github.com/vinceliuice/vimix-gtk-themes/archive/master.zip" -O "vimix-gtk-themes.zip"
  #unzip "vimix-gtk-themes.zip"
  #rm "vimix-gtk-themes.zip"
  #cd "vimix-gtk-themes-master"
  #./install.sh -a -d "/usr/share/themes"
  #cd "/root"
  #rm -R "vimix-gtk-themes-master"
  
  #echo "###############"
  #echo "# Vimix icons #"
  #echo "###############"
  #wget "https://github.com/vinceliuice/vimix-icon-theme/archive/master.zip" -O "vimix-icon-theme.zip"
  #unzip "vimix-icon-theme.zip"
  #rm "vimix-icon-theme.zip"
  #cd "vimix-icon-theme-master"
  #./install.sh
  #cd "/root"
  #rm -R "vimix-icon-theme-master"
}

function jwm_per_user()
{
  echo "##################"
  echo "# Create folders #"
  echo "##################"
  mkdir -p "/home/${ZEN_USER}/.config/autostart"
  mkdir -p "/home/${ZEN_USER}/.config/gtk-3.0"
  mkdir -p "/home/${ZEN_USER}/.config/zen-de"
  mkdir -p "/home/${ZEN_USER}/.config/pcmanfm/default"
  chown ${ZEN_USER}:${ZEN_USER} "/home/${ZEN_USER}"
  chown ${ZEN_USER}:${ZEN_USER} "/home/${ZEN_USER}/.config"
  chown ${ZEN_USER}:${ZEN_USER} "/home/${ZEN_USER}/.config/autostart"
  chown ${ZEN_USER}:${ZEN_USER} "/home/${ZEN_USER}/.config/gtk-3.0"
  chown ${ZEN_USER}:${ZEN_USER} "/home/${ZEN_USER}/.config/zen-de"
  
  echo "#######################"
  echo "# Config jwm per user #"
  echo "#######################"
  cd "/home/${ZEN_USER}"
  wget "${ZEN_REPO}/usr/share/zen-de/user/.bash_aliases"
  wget "${ZEN_REPO}/usr/share/zen-de/user/.jwmrc"
  wget "${ZEN_REPO}/usr/share/zen-de/user/.gtkrc-2.0"
  chown ${ZEN_USER}:${ZEN_USER} "/home/${ZEN_USER}/.bash_aliases"
  chown ${ZEN_USER}:${ZEN_USER} "/home/${ZEN_USER}/.jwmrc"
  chown ${ZEN_USER}:${ZEN_USER} "/home/${ZEN_USER}/.gtkrc-2.0"
  
  cd "/home/${ZEN_USER}/.config"
  wget "${ZEN_REPO}/usr/share/zen-de/user/.config/mimeapps.list"
  chown ${ZEN_USER}:${ZEN_USER} "/home/${ZEN_USER}/.config/mimeapps.list"
  
  cd "/home/${ZEN_USER}/.config/gtk-3.0"
  wget "${ZEN_REPO}/usr/share/zen-de/user/.config/gtk-3.0/settings.ini"
  chown ${ZEN_USER}:${ZEN_USER} "/home/${ZEN_USER}/.config/gtk-3.0/settings.ini"
  
  cd "/home/${ZEN_USER}/.config/pcmanfm/default"
  wget "${ZEN_REPO}/usr/share/zen-de/user/.config/pcmanfm/default/desktop-items-0.conf"
  wget "${ZEN_REPO}/usr/share/zen-de/user/.config/pcmanfm/default/pcmanfm.conf"
}

function install_environment()
{
  # Install applications
  apt-get -y install xorg dbus-x11 jwm coreutils bc sudo zenity fbautostart mate-notification-daemon lightdm pcmanfm menulibre connman cmst grun firefox-esr gvfs-backends sshfs synaptic gparted cups lxtask galculator galternatives xarchiver sakura audacious vlc font-manager gucharmap conky-all arandr baobab neofetch pluma i3lock feh imagemagick gpicview x11-xserver-utils lxappearance lxpolkit xscreensaver locate
  
  # Pacchetto light-locker
  # si installa automaticamente?
  # situazione: in /etc/xdg/autostart si crea il lanciatore di light-locker e xorg (o xscreensaver) lo rilevano come programma predefinito (perché il mio zen-lock non è registrato nei loro database)
  # obiettivo: il blocco dello schermo e lo screensaver devono essere gestiti da programmi leggeri e indipendenti dal DE
  
  # Install themes
  # Adapta theme has a QT porting
  apt-get -y install adapta-gtk-theme greybird-gtk-theme gnome-brave-icon-theme gnome-dust-icon-theme gnome-human-icon-theme gnome-illustrious-icon-theme gnome-noble-icon-theme gnome-wine-icon-theme gnome-wise-icon-theme shiki-colors arc-theme oxygencursors breeze-cursor-theme gtk2-engines-oxygen gtk2-engines-qtcurve
  
  echo "#################################################"
  echo "# WORKAROUND FOR gnome-colors-common icon theme #"
  echo "#################################################"
  cd "/usr/share/icons/gnome-colors-common/scalable/places"
  wget "${ZEN_REPO}/workaround/gnome-colors-common/user-trash.svg"
  
  echo "#######################"
  echo "# Lightdm Zen Session #"
  echo "#######################"
  NAME="01_zen_session.conf"
  mkdir -p "/etc/lightdm/lightdm.conf.d"
  cd "/etc/lightdm/lightdm.conf.d"
  wget "${ZEN_REPO}/etc/lightdm/lightdm.conf.d/${NAME}"
  
  echo "############################"
  echo "# Prepare autostart folder #"
  echo "############################"
  mkdir -p "/etc/xdg/autostart"
  cd "/etc/xdg/autostart"
  
  #NAME="screensaver.desktop"
  #wget "${ZEN_REPO}/etc/xdg/autostart/${NAME}"
  #cp "origine" "/etc/xdg/autostart/${NAME}"
  
  #NAME="connman.desktop"
  #wget "${ZEN_REPO}/etc/xdg/autostart/${NAME}"
  #cp "origine" "/etc/xdg/autostart/${NAME}"
  
  echo "#######################"
  echo "# Install to /usr/bin #"
  echo "#######################"
  mkdir -p "/usr/bin"
  mkdir -p "/usr/share/applications"
  mkdir -p "/usr/share/pixmaps"
  
  NAME="xclock-switch"
  cd "/usr/bin"
  wget "${ZEN_REPO}/usr/bin/${NAME}"
  chmod +x "${NAME}"
  
  NAME="zen-bastard-messages"
  cd "/usr/bin"
  wget "${ZEN_REPO}/usr/bin/${NAME}"
  chmod +x "${NAME}"
  cd "/usr/share/applications"
  wget "${ZEN_REPO}/usr/share/applications/${NAME}.desktop"
  chmod +x "${NAME}.desktop"
  
  NAME="zen-brightness"
  cd "/usr/bin"
  wget "${ZEN_REPO}/usr/bin/${NAME}"
  chmod +x "${NAME}"
  cd "/usr/share/pixmaps"
  wget "${ZEN_REPO}/usr/share/pixmaps/${NAME}.svg"
  cd "/usr/share/applications"
  wget "${ZEN_REPO}/usr/share/applications/${NAME}.desktop"
  chmod +x "${NAME}.desktop"
  
  NAME="zen-calendar"
  cd "/usr/bin"
  wget "${ZEN_REPO}/usr/bin/${NAME}"
  chmod +x "${NAME}"
  
  NAME="zen-fortune"
  cd "/usr/bin"
  wget "${ZEN_REPO}/usr/bin/${NAME}"
  chmod +x "${NAME}"
  cd "/usr/share/applications"
  wget "${ZEN_REPO}/usr/share/applications/${NAME}.desktop"
  chmod +x "${NAME}.desktop"
  
  NAME="zen-lock"
  cd "/usr/bin"
  wget "${ZEN_REPO}/usr/bin/${NAME}"
  chmod +x "${NAME}"
  cd "/usr/share/applications"
  wget "${ZEN_REPO}/usr/share/applications/${NAME}.desktop"
  chmod +x "${NAME}.desktop"
  
  NAME="zen-logout"
  cd "/usr/bin"
  wget "${ZEN_REPO}/usr/bin/${NAME}"
  chmod +x "${NAME}"
  cd "/usr/share/applications"
  wget "${ZEN_REPO}/usr/share/applications/${NAME}.desktop"
  chmod +x "${NAME}.desktop"
  
  NAME="zen-network"
  cd "/usr/bin"
  wget "${ZEN_REPO}/usr/bin/${NAME}"
  chmod +x "${NAME}"
  cd "/usr/share/applications"
  wget "${ZEN_REPO}/usr/share/applications/${NAME}.desktop"
  chmod +x "${NAME}.desktop"
  cd "/etc/xdg/autostart"
  wget "${ZEN_REPO}/usr/share/applications/${NAME}.desktop"
  chmod +x "${NAME}.desktop"
  
  NAME="zen-printers"
  cd "/usr/bin"
  wget "${ZEN_REPO}/usr/bin/${NAME}"
  chmod +x "${NAME}"
  
  NAME="zen-reboot"
  cd "/usr/bin"
  wget "${ZEN_REPO}/usr/bin/${NAME}"
  chmod +x "${NAME}"
  
  NAME="zen-session"
  cd "/usr/bin"
  wget "${ZEN_REPO}/usr/bin/${NAME}"
  chmod +x "${NAME}"
  mkdir -p "/usr/share/xsessions"
  cd "/usr/share/xsessions"
  wget "${ZEN_REPO}/usr/share/xsessions/${NAME}.desktop"
  cd "/usr/share/pixmaps"
  wget "${ZEN_REPO}/usr/share/pixmaps/zen-logo.png"
  wget "${ZEN_REPO}/usr/share/pixmaps/zen-logo.svg"
  wget "${ZEN_REPO}/usr/share/pixmaps/zen-logo_16.png"
  wget "${ZEN_REPO}/usr/share/pixmaps/zen-logo_16_white.png"
  wget "${ZEN_REPO}/usr/share/pixmaps/zen-logo_white.png"
  wget "${ZEN_REPO}/usr/share/pixmaps/zen-logo_white.svg"
  
  NAME="zen-shutdown"
  cd "/usr/bin"
  wget "${ZEN_REPO}/usr/bin/${NAME}"
  chmod +x "${NAME}"
  
  NAME="zen-sshfs"
  cd "/usr/bin"
  wget "${ZEN_REPO}/usr/bin/${NAME}"
  chmod +x "${NAME}"
  cd "/usr/share/applications"
  wget "${ZEN_REPO}/usr/share/applications/${NAME}.desktop"
  chmod +x "${NAME}.desktop"
  
  NAME="zen-sudo"
  cd "/usr/bin"
  wget "${ZEN_REPO}/usr/bin/${NAME}"
  chmod +x "${NAME}"
  cd "/usr/share/applications"
  wget "${ZEN_REPO}/usr/share/applications/${NAME}.desktop"
  chmod +x "${NAME}.desktop"
  
  NAME="zen-sysinfo"
  cd "/usr/bin"
  wget "${ZEN_REPO}/usr/bin/${NAME}"
  chmod +x "${NAME}"
  cd "/usr/share/pixmaps"
  wget "${ZEN_REPO}/usr/share/pixmaps/${NAME}.svg"
  cd "/usr/share/applications"
  wget "${ZEN_REPO}/usr/share/applications/${NAME}.desktop"
  chmod +x "${NAME}.desktop"
  
  echo "################################"
  echo "# Install to /usr/share/zen-de #"
  echo "################################"
  mkdir -p "/usr/share/zen-de/jwm"
  cd "/usr/share/zen-de"
  NAME="zen-logo.svg"
  wget "${ZEN_REPO}/usr/share/zen-de/${NAME}"
  
  cd "/usr/share/zen-de/jwm"
  NAME="DETECT_ICONS"
  wget "${ZEN_REPO}/usr/share/zen-de/jwm/${NAME}"
  chmod +x "${NAME}"
  NAME="KEY_ALT+F2"
  wget "${ZEN_REPO}/usr/share/zen-de/jwm/${NAME}"
  chmod +x "${NAME}"
  NAME="MENU"
  wget "${ZEN_REPO}/usr/share/zen-de/jwm/${NAME}"
  chmod +x "${NAME}"
  NAME="MENU_ZEN"
  wget "${ZEN_REPO}/usr/share/zen-de/jwm/${NAME}"
  chmod +x "${NAME}"
  
  mkdir -p "/usr/share/zen-de/lock"
  cd "/usr/share/zen-de/lock"
  NAME="config"
  wget "${ZEN_REPO}/usr/share/zen-de/lock/${NAME}"
  NAME="enso.png"
  wget "${ZEN_REPO}/usr/share/zen-de/lock/${NAME}"
  NAME="none.png"
  wget "${ZEN_REPO}/usr/share/zen-de/lock/${NAME}"
  NAME="yin-yang.png"
  wget "${ZEN_REPO}/usr/share/zen-de/lock/${NAME}"
  
  mkdir -p "/usr/share/zen-de/wallpaper"
  cd "/usr/share/zen-de/wallpaper"
  NAME="zen-tech-wallpaper-green.png"
  wget "${ZEN_REPO}/usr/share/zen-de/wallpaper/${NAME}"
  NAME="zen-tech-wallpaper-red.png"
  wget "${ZEN_REPO}/usr/share/zen-de/wallpaper/${NAME}"
  NAME="zen-tech-wallpaper-red-1920x1080.png"
  wget "${ZEN_REPO}/usr/share/zen-de/wallpaper/${NAME}"
  NAME="zen-tech-wallpaper-white.png"
  wget "${ZEN_REPO}/usr/share/zen-de/wallpaper/${NAME}"
  NAME="zen-wallpaper.png"
  wget "${ZEN_REPO}/usr/share/zen-de/wallpaper/${NAME}"
}

main
