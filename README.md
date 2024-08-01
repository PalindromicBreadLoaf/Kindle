# CTF Tools Installation Script

[INSERT THE .gif]
## Overview

This repository contains a Bash script that installs a suite of tools required for participating in Capture The Flag (CTF) cybersecurity competitions. The script automates the installation of various essential tools and dependencies, saving time and effort for participants.

## Features

- Installs a comprehensive list of packages needed for CTFs
- Downloads and sets up specialized tools like Ghidra, Docker, VSCode, and more
- Creates desktop shortcuts for easy access to applications
- Ensures the system is up-to-date with the latest versions of tools

## Prerequisites

- Ubuntu or any Debian-based distribution
- `sudo` privileges

## Installation

1. **Clone the repository:**
    ```sh
    git clone https://github.com/yourusername/CTF-tools-install-script.git
    cd Kindle
    ```

2. **Make the script executable:**
    ```sh
    chmod +x install.sh
    ```

3. **Run the script:**
    ```sh
    sudo ./install.sh
    ```

## Tools Installed

The script installs the following tools:

- General packages: `gdb`, `python3`, `python3-pip`, `git`, `libssl-dev`, `curl`, etc.
- Specialized tools: `Ghidra`, `Docker`, `VSCode`, `Metasploit`, `Autopsy`, `CyberChef`, `GEF`, etc.
- Network tools: `nmap`, `wireshark`, `hydra`, `sqlmap`, etc.
- Forensic tools: `autopsy`, `exiftool`, etc.
- Miscellaneous: `hashcat`, `john`, `gobuster`, `ffuf`, etc.

## Usage

After running the script, all tools will be installed and ready to use. Some tools will have shortcuts created on the desktop for quick access.

## Contributing

Contributions are welcome! If you have suggestions for additional tools or improvements to the script, feel free to create an issue or submit a pull request.

1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Make your changes
4. Commit your changes (`git commit -am 'Add new feature'`)
5. Push to the branch (`git push origin feature-branch`)
6. Create a new Pull Request

## License

It would be nice if you could add our @BGCTF repo in your private forks :)

## Acknowledgements

- ASCII art generated using [ASCII Art Generator](https://www.ascii-art.de/)

## Contact

For any questions or feedback, please open an issue on the repository or contact [BGSUCTF@gmail.com](mailto:BGSUCTF@gmail.com).

---

Happy Hacking!
