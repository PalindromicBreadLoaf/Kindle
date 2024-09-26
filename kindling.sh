#!/usr/bin/env bash

ASCII_DONE=$(cat << 'EOF'
            (                 ,&&&.
             )                .,.&&
            (  (              \=__/
                )             ,'-'.
          (    (  ,,      _.__|/ /|
           ) /\ -((------((_|___/ |
         (  // | (`'      ((  `'--|
       _ -.;_/ \\--._      \\ \-._/.
      (_;-// | \ \-'.\    <_,\_\`--'|
      ( `.__ _  ___,')      <_,-'__,'
       `'(_ )_)(_)_)'
EOF
)
ASCII=$(cat << 'EOF'
                            .:                    
                         .-==.                    
                      .-=====                     
                    :========                     
                  -==========.                    
                -=============                    
              .=++++++++++++++=                   
             -+++++++++++++++++=                  
            =+++++++++++++++++++=        :.       
           =++++++++++++++++++++++.    :==        
          -++++++++++++++++++++++++-  :++=.       
         .++++++++++++++++++++++++++= =++=-       
         -************+++************++++==:      
       . =*************=-=*************++===-     
      -* =*************+--=+*************+===-    
     =**::*************+----+**************===-   
    =****:=************=-----+**************+==:  
   .******+***********========***************+==. 
   -*****************=========****************=== 
   =****************==========*=+**************==:
   -**************+==========++==**************==-
   .############*============+===+#############===
.   +##########*=================*#############==-
:+. .#########*=================*#############*==.
 =%*+*########+===============+###**##########+=- 
  =##########*++++++++++++++++*###*+*########+=-  
   :*########*+++++++++++++++++***+++#######+=-   
     =########+++++++++++++++++++++++######+=.    
       =######*+++++++++++++++++++++*####*=:      
         :+####*+++++++++++++++++++*###*=:        
           .-+###*****************###+-.          
               :=*#*************#*+:.             
                   .-==+***++=-:                          
EOF
)

ASCII_TEXT=$(cat << 'EOF'
     )                       
    ( /(           (   (       
    )\())(         )\ ))\  (   
  |((_)\ )\  (    (()/((_)))\  
  |_ ((_|  _ )\ )  ((_)) /((_) 
  | |/ / (_)_   (  _| | (_))   
  | ' <  | | ' \)) _` | / -_)  
  |_|\_\ |_|_||_|\__,_|_\___| 
EOF
)

URLS=("https://vscode.download.prss.microsoft.com/dbazure/download/stable/f1e16e1e6214d7c44d078b1f0607b2388f29d729/code_1.91.1-1720564633_amd64.deb" 
"https://raw.githubusercontent.com/sleuthkit/autopsy/develop/linux_macos_install_scripts/install_prereqs_ubuntu.sh" 
"https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.1.2_build/ghidra_11.1.2_PUBLIC_20240709.zip"
"https://download.docker.com/linux/ubuntu/gpg"
"https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb"
"https://gef.blah.cat/sh")

OUTPUT_FILES=("vscode_amd64.deb" "autopsy_prereqs.sh" "ghidra_11.1.2.zip" "docker.asc" "msfinstall" "gef_install.sh")

Welcome(){
    echo ""
    #echo "$ASCII"
    echo "         Welcome to"
    echo "        ============"
    echo "$ASCII_TEXT"
    echo ""
    echo "A script kiddies dream come true!"
    echo "This script will install all"
    echo "of the dependencies needed to get you"
    echo "started in the world of CTF Competitions."
    echo ""
    echo ""
    echo "[+] Started Kindling the fire"
}

detect_package_manager() {
    if command -v apt &> /dev/null; then
        PACKAGE_MANAGER="apt"
    elif command -v pacman &> /dev/null; then
        PACKAGE_MANAGER="pacman"

        if command -v paru &> /dev/null; then
            AUR_HELPER="paru"
        elif command -v yay &> /dev/null; then
            AUR_HELPER="yay"
        else
            sudo pacman -S --noconfirm git base-devel
            git clone https://aur.archlinux.org/paru.git
            cd paru || exit
            makepkg -si --noconfirm
            cd ..
            rm -rf paru
            AUR_HELPER="paru"
        fi
    else
        echo "Neither apt nor pacman is available. Exiting."
        exit 1
    fi
}

install_packages() {
    # snapd install (apt only)
    if [ "$PACKAGE_MANAGER" == "apt" ]; then
      sudo apt install snapd -y
    fi
    
    # List of packages to install (space-separated)
    # apt packages
    local packages_apt=("gdb" "python3" "python3-pip" "python3-dev" "git" "libssl-dev"
    "libffi-dev" "build-essential" "gobuster" "emacs" "vim" "john" 
    "hashcat" "audacity" "exiftool" "nmap" "wireshark" "gcc-multilib" "g++-multilib"
    "curl" "sqlmap" "checksec" "exif" "ipython3" "hydra" "openjdk-17-jdk" 
    "autopsy")

    # pacman (and AUR) packages
    local packages_pacman=("gdb" "python" "python-pip" "python-devtools" "openssl"
    "libffi" "base-devel" "emacs" "vim" "john"
    "hashcat" "audacity" "perl-image-exiftool" "nmap" "wireshark-qt" "wireshark-cli" "gcc" "g++"
    "curl" "sqlmap" "checksec" "ipython" "hydra")

    local packages_AUR=("gobuster-bin" "exif" "jdk17-graalvm-ee-bin" "autopsy")

    # Update package lists
    echo "Updating package lists..."
    if [ "$PACKAGE_MANAGER" == "apt" ]; then
      sudo apt update
    else
      sudo pacman -Syyu --noconfirm
    fi

    # Install packages
    echo "Installing packages..."
    if [ "$PACKAGE_MANAGER" == "apt" ]; then
        if sudo apt install -y "${packages_apt[@]}"; then
            echo "Package installation complete."
        else
            echo "Package installation failed. Please check the error messages above."
        fi
    else
        if sudo pacman -S --noconfirm "${packages_pacman[@]}"; then
            echo "Package installation complete."
                if [ "$AUR_HELPER" == "paru" ]; then
                    paru -S --noconfirm "${packages_AUR[@]}"
                elif [ "$AUR_HELPER" == "yay" ]; then
                    yay -S --noconfirm "${packages_AUR[@]}"
                fi
        else
            echo "Package installation failed. Please check the error messages above."
        fi
    fi
}

# Fetch function to download all files
fetch() {
    local url=$1
    local output_file=$2

    # Run the curl command to fetch the data
    curl -L -sS -o "$output_file" "$url"

    # Check if the curl command was successful
    if [ $? -eq 0 ]; then
        echo "Download successful for $output_file."
        # Open the result file with the default text editor
        #xdg-open "$output_file" & # Using '&' to open files in parallel
    else
        echo "Download failed for $output_file. Please check the URL and try again."
    fi
}

Welcome
sleep 3

# install function call
detect_package_manager
install_packages

#=====================
#Special Packages
#=====================

for i in "${!URLS[@]}"; do
    fetch "${URLS[$i]}" "${OUTPUT_FILES[$i]}" &
done
wait
echo "[+] All downloads are completed."

# Ghidra stuff
#if [ -d /opt/ghidra ]; then
#    echo "[!] Found a ghidra folder already in /opt."
#    echo "[!] Ghidra is already installed."
#else
#    echo "[+] Ghidra is not installed. Installing..."
#    sudo mv ./ghidra_11.1.2.zip /opt/
#    sudo unzip /opt/ghidra_11.1.2.zip -d /opt/
#    sudo rm /opt/ghidra_11.1.2.zip
#    DESKTOP_ENTRY="[Desktop Entry]
#    Name=Ghidra Run
#    Comment=Run Ghidra
#    Exec=/opt/ghidra_11.1.2_PUBLIC/ghidraRun
#    Icon=/opt/ghidra_11.1.2_PUBLIC/docs/images/GHIDRA_1.png
#    Terminal=false
#    Type=Application
#    "
#    USER_HOME=$(eval echo ~"$SUDO_USER")
#    sudo echo "$DESKTOP_ENTRY" > "$USER_HOME/Desktop/ghidraRun.desktop"
#    sudo chmod +x "$USER_HOME/Desktop/ghidraRun.desktop"
#    echo "[+] Shortcut created on Desktop"
#fi
if [ "$PACKAGE_MANAGER" == "apt" ]; then
    sudo snap install ghidra
else
    sudo pacman -S --noconfirm ghidra
fi

# Pwn Tools
if [ "$PACKAGE_MANAGER" == "apt" ]; then
    python3 -m pip install pwntools
else
    if [ "$AUR_HELPER" == "paru" ]; then
        paru -S --noconfirm python-pwntools-git
    elif [ "$AUR_HELPER" == "yay" ]; then
        yay -S --noconfirm python-pwntools-git
    fi
fi

# Docker stuff
if [ "$PACKAGE_MANAGER" == "apt" ]; then
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
fi
if ! command -v docker &> /dev/null; then
    echo "[+] Docker is not installed. Installing..."
    if [ "$PACKAGE_MANAGER" == "apt" ]; then
      sudo apt-get install -y ca-certificates curl
      sudo install -m 0755 -d /etc/apt/keyrings
      sudo mv docker.asc /etc/apt/keyrings/
      sudo chmod a+r /etc/apt/keyrings/docker.asc
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update
      sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    else
      sudo pacman -S --noconfirm docker docker-compose ca-certificates curl docker-buildx containerd

      if [ "$AUR_HELPER" == "paru" ]; then
          paru -S --noconfirm lazydocker
      elif [ "$AUR_HELPER" == "yay" ]; then
          yay -S --noconfirm lazydocker
      fi

      sudo systemctl enable --now docker.service
    fi
else
    echo "[!] Docker is already installed."
fi

# Vscode stuff
if [ "$PACKAGE_MANAGER" == "apt" ]; then
    sudo snap install code --classic
else
    sudo pacman -S --noconfirm code
fi

#fuff
if [ "$PACKAGE_MANAGER" == "apt" ]; then
    sudo snap install ffuf
else
    if [ "$AUR_HELPER" == "paru" ]; then
        paru -S --noconfirm ffuf
    elif [ "$AUR_HELPER" == "yay" ]; then
        yay -S --noconfirm ffuf
    fi
fi

# Autopsy stuff
if [ "$PACKAGE_MANAGER" == "apt" ]; then
    sudo snap install autopsy
else
    if [ "$AUR_HELPER" == "paru" ]; then
        paru -S --noconfirm autopsy
    elif [ "$AUR_HELPER" == "yay" ]; then
        yay -S --noconfirm autopsy
    fi
fi

# CyberChef
if [ "$PACKAGE_MANAGER" == "apt" ]; then
    sudo snap install cyberchef
else
    if [ "$AUR_HELPER" == "paru" ]; then
        paru -S --noconfirm cyberchef-electron
    elif [ "$AUR_HELPER" == "yay" ]; then
        yay -S --noconfirm cyberchef-electron
    fi
fi

# Gef install
if [ "$PACKAGE_MANAGER" == "apt" ]; then
    sudo chmod +x ./gef_install.sh
    sudo ./gef_install.sh
else
    if [ "$AUR_HELPER" == "paru" ]; then
        paru -S --noconfirm gef-git
    elif [ "$AUR_HELPER" == "yay" ]; then
        yay -S --noconfirm gef-git
    fi
fi

# Metasploit
if [ "$PACKAGE_MANAGER" == "apt" ]; then
    sudo chmod 755 ./msfinstall
    sudo ./msfinstall
else
    if [ "$AUR_HELPER" == "paru" ]; then
        paru -S --noconfirm metasploit-git
    elif [ "$AUR_HELPER" == "yay" ]; then
        yay -S --noconfirm metasploit-git
    fi
fi

if [ "$PACKAGE_MANAGER" == "apt" ]; then
    sudo apt upgrade -y
else
    sudo pacman -Syu
fi

echo ""
echo "$ASCII_DONE"
echo "[+] The fire is nice and warm, enjoy! :)"
echo "If you want to make some smores, there is a folder"
echo "containing useful wordlists called 'Wordlists'"

