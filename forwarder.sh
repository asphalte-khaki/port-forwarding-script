#!/bin/bash

# -----------------------------
# Ultimate IP Forwarder Script v1.1 (Fixed)
# Author: [YourGitHubUsername]
# Description: Multi-protocol, IPv4/IPv6/Domain Forwarder with full menu UI
# OS: Ubuntu 20.04/22.04+
# -----------------------------

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

FORWARD_CONF="/etc/forwarder_rules.conf"
SYSTEMD_DIR="/etc/systemd/system"

function check_install_dependencies() {
    echo -e "${BLUE}[*] Installing dependencies...${NC}"
    apt update && apt install -y socat jq net-tools lsof curl
}

function choose_protocol() {
    echo -e "${YELLOW}Enter the protocol:${NC}"
    echo -e "1) TCP\n2) UDP\n3) TCP over UDP"
    read -p "Enter 1/2/3: " proto
    case $proto in
        1) protocol="tcp";;
        2) protocol="udp";;
        3) protocol="tcp_over_udp";;
        *) echo -e "${RED}Invalid protocol!${NC}"; exit 1;;
    esac
}

function setup_forwarding() {
    read -p "Enter remote destination (IP/IPv6/domain): " dest
    read -p "Enter ports to forward (comma separated, e.g., 443,80,8080): " ports

    IFS=',' read -ra PORT_ARRAY <<< "$ports"
    for port in "${PORT_ARRAY[@]}"; do
        unit_name="forward_${protocol}_${port}_${dest//[^a-zA-Z0-9]/}"
        service_file="${SYSTEMD_DIR}/${unit_name}.service"

        if [[ $protocol == "tcp_over_udp" ]]; then
            socat_cmd="socat UDP4-RECV:${port},fork TCP:${dest}:${port}"
        else
            socat_cmd="socat ${protocol^^}4-LISTEN:${port},fork ${protocol^^}4:${dest}:${port}"
        fi

        echo "[Unit]
Description=Port Forward ${protocol} $port to $dest
After=network.target

[Service]
ExecStart=/bin/bash -c '$socat_cmd'
Restart=always

[Install]
WantedBy=multi-user.target" > "$service_file"

        systemctl daemon-reexec
        systemctl daemon-reload
        systemctl enable --now "$unit_name"
        echo "$protocol|$port|$dest|$unit_name" >> "$FORWARD_CONF"

        echo -e "${GREEN}[+] Forwarding ${protocol^^} on port $port to $dest started.${NC}"
    done
}

function optimize_forwarding() {
    echo -e "${CYAN}[*] Optimizing system for port forwarding...${NC}"
    sysctl -w net.ipv4.ip_forward=1
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

    sysctl -w net.ipv6.conf.all.forwarding=1
    echo "net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.conf

    echo -e "${GREEN}[?] Optimization complete.${NC}"
}

function show_state() {
    echo -e "${BLUE}[*] Active Forwarding Rules:${NC}"
    if [[ -f $FORWARD_CONF ]]; then
        while IFS='|' read -r proto port dest unit; do
            echo -e "${CYAN}$proto -> $dest:$port via $unit${NC}"
        done < "$FORWARD_CONF"
    else
        echo -e "${RED}[!] No rules found.${NC}"
    fi
}

function uninstall_entry() {
    read -p "Enter the IP/domain to remove: " remove_target
    tmp_file=$(mktemp)
    if [[ -f $FORWARD_CONF ]]; then
        while IFS='|' read -r proto port dest unit; do
            if [[ "$dest" == "$remove_target" ]]; then
                systemctl stop "$unit" || true
                systemctl disable "$unit" || true
                rm -f "${SYSTEMD_DIR}/${unit}.service"
                echo -e "${YELLOW}[-] Removed forwarding for $dest:$port ($proto)${NC}"
            else
                echo "$proto|$port|$dest|$unit" >> "$tmp_file"
            fi
        done < "$FORWARD_CONF"
        mv "$tmp_file" "$FORWARD_CONF"
        systemctl daemon-reload
    else
        echo -e "${RED}[!] No rules to remove.${NC}"
    fi
}

function uninstall_all() {
    echo -e "${RED}!!! This will remove all forwarding rules and the script itself.${NC}"
    read -p "Are you sure? (y/n): " confirm
    if [[ $confirm == "y" ]]; then
        if [[ -f $FORWARD_CONF ]]; then
            while IFS='|' read -r _ _ _ unit; do
                systemctl stop "$unit" || true
                systemctl disable "$unit" || true
                rm -f "${SYSTEMD_DIR}/${unit}.service"
            done < "$FORWARD_CONF"
            rm -f "$FORWARD_CONF"
            systemctl daemon-reload
        fi
        rm -- "$0"
        echo -e "${GREEN}[?] Uninstalled all forward rules and the script itself.${NC}"
        exit 0
    fi
}

function main_menu() {
    clear
    echo -e "${CYAN}========= Ultimate IP Forwarder =========${NC}"
    echo -e "${GREEN}1) Forward IPv4"
    echo -e "2) Forward IPv6"
    echo -e "3) Forward Domain/Subdomain"
    echo -e "4) Optimize Forwarding"
    echo -e "5) Show State"
    echo -e "6) Uninstall IP or Domain"
    echo -e "7) Uninstall Script${NC}"
    echo -ne "\n${YELLOW}Select an option [1-7]: ${NC}"
    read choice
    case $choice in
        1)
            choose_protocol
            setup_forwarding
            ;;
        2)
            choose_protocol
            setup_forwarding
            ;;
        3)
            choose_protocol
            setup_forwarding
            ;;
        4)
            optimize_forwarding
            ;;
        5)
            show_state
            ;;
        6)
            uninstall_entry
            ;;
        7)
            uninstall_all
            ;;
        *)
            echo -e "${RED}[!] Invalid choice${NC}"
            ;;
    esac
    echo -e "\n${BLUE}Press Enter to return to menu...${NC}"
    read
    main_menu
}

check_install_dependencies
main_menu
