# Ultimate IP Forwarder Script v1.1

![License](https://img.shields.io/badge/license-MIT-green)
![Shell Script](https://img.shields.io/badge/language-Bash-yellow)

---

## Overview

**Ultimate IP Forwarder** is a powerful and interactive Bash script for forwarding **TCP**, **UDP**, and **TCP over UDP** traffic on **Ubuntu 20.04/22.04+** systems.  
It supports **IPv4**, **IPv6**, and **domains** and is designed to run permanently using `systemd` services — with no manual configuration required.

---

## Features

- Support for `TCP`, `UDP`, and `TCP over UDP`
- Multi-port forwarding with persistent `systemd` services
- IPv4, IPv6, and domain/subdomain support
- Fully interactive command-line menu UI
- One-click optimization of Linux sysctl forwarding settings
- Auto-start on reboot (persistent services)
- View, remove, or fully uninstall individual or all rules
- Fast installation with no code editing required

---

## Requirements

- Ubuntu 20.04 or newer  
- Root or sudo access  
- Internet connection (for installing dependencies)

---

## Quick Installation

To install and launch the script instantly, run the following command in your terminal:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/asphalte-khaki/port-forwarding-script/main/forwarder.sh)
