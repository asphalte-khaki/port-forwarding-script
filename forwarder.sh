#!/bin/bash

# Check if the user has root access
if [ "$(id -u)" -ne 0 ]; then
  echo $'\e[32mPlease run with root privileges.\e[0m'
  exit
fi

echo $'\e[35m'"  ___|              |        _ _|  _ \   /    
 |      _ \    __|  __|        |  |   |  _ \  
 |   | (   | \__ \  |          |  ___/  (   | 
\____|\___/  ____/ \__|      ___|_|    \___/  
                                              "$'\e[0m'

echo -e "\e[36mCreated By Masoud Gb Special Thanks Hamid Router\e[0m"
echo $'\e[35m'"Gost Ip6 Script v2.2.0"$'\e[0m'

options=($'\e[36m1. \e[0mGost Tunnel By IP4'
         $'\e[36m2. \e[0mGost Tunnel By IP6'
         $'\e[36m3. \e[0mGost Status'
         $'\e[36m4. \e[0mUpdate Script'
         $'\e[36m5. \e[0mAdd New IP'
         $'\e[36m6. \e[0mChange Gost Version'
         $'\e[36m7. \e[0mAuto Restart Gost'
         $'\e[36m8. \e[0mAuto Clear Cache'
         $'\e[36m9. \e[0mInstall BBR'
         $'\e[36m10. \e[0mRestart Services'
         $'\e[36m11. \e[0mRemove IPv4 or ipv6'
         $'\e[36m12. \e[0mUninstall'
         $'\e[36m13. \e[0mExit')

# Print prompt and options with cyan color
printf "\e[32mPlease Choice Your Options:\e[0m\n"
printf "%s\n" "${options[@]}"

# Read user input with white color
read -p $'\e[97mYour choice: \e[0m' choice

# If option 1 or 2 is selected
if [ "$choice" -eq 1 ] || [ "$choice" -eq 2 ]; then
    if [ "$choice" -eq 1 ]; then
        read -p $'\e[97mPlease enter the destination (Kharej) IPv4: \e[0m' destination_ip
    elif [ "$choice" -eq 2 ]; then
        read -p $'\e[97mPlease enter the destination (Kharej) IPv6: \e[0m' destination_ip
    fi

    read -p $'\e[32mPlease choose one of the options below:\n\e[0m\e[36m1. \e[0mEnter "Manually" Ports\n\e[36m2. \e[0mEnter "Range" Ports\e[32m\nYour choice: \e[0m' port_option

if [ "$port_option" -eq 1 ]; then
    read -p $'\e[36mPlease enter the desired ports (separated by commas): \e[0m' ports
elif [ "$port_option" -eq 2 ]; then
    read -p $'\e[36mPlease enter the port range (e.g., 54,65000): \e[0m' port_range

    IFS=',' read -ra port_array <<< "$port_range"

    # Check if the start and end port values are within the valid range
    if [ "${port_array[0]}" -lt 54 -o "${port_array[1]}" -gt 65000 ]; then
        echo $'\e[33mInvalid port range. Please enter a valid range starting from 54 and up to 65000.\e[0m'
        exit
    fi

    ports=$(seq -s, "${port_array[0]}" "${port_array[1]}")
else
    echo $'\e[31mInvalid option. Exiting...\e[0m'
    exit
fi

    read -p $'\e[32mSelect the protocol:\n\e[0m\e[36m1. \e[0mBy "Tcp" Protocol \n\e[36m2. \e[0mBy "Udp" Protocol \n\e[36m3. \e[0mBy "Grpc" Protocol \e[32m\nYour choice: \e[0m' protocol_option

if [ "$protocol_option" -eq 1 ]; then
    protocol="tcp"
elif [ "$protocol_option" -eq 2 ]; then
    protocol="udp"
elif [ "$protocol_option" -eq 3 ]; then
    protocol="grpc"
else
    echo $'\e[31mInvalid protocol option. Exiting...\e[0m'
    exit
fi

    echo $'\e[32mYou chose option\e[0m' $choice
    echo $'\e[97mDestination IP:\e[0m' $destination_ip
    echo $'\e[97mPorts:\e[0m' $ports
    echo $'\e[97mProtocol:\e[0m' $protocol

    # Commands to install and configure Gost
    echo $'\e[32mUpdating system packages, please wait...\e[0m'
    sysctl net.ipv4.ip_local_port_range="1024 65535"
# Add the sysctl command to the end of the script
echo "sysctl net.ipv4.ip_local_port_range=\"1024 65535\"" >> /etc/rc.local

# Enable the systemd service to run the sysctl command after reboot
cat <<EOL > /etc/systemd/system/sysctl-custom.service
[Unit]
Description=Custom sysctl settings

[Service]
ExecStart=/sbin/sysctl net.ipv4.ip_local_port_range="1024 65535"

[Install]
WantedBy=multi-user.target
EOL
# Enable the service
systemctl enable sysctl-custom

    apt update && sudo apt install wget nano -y && \
    # Add alias for 'gost' to execute the script
        echo 'alias gost="bash /etc/gost/install.sh"' >> ~/.bashrc
        source ~/.bashrc
        echo $'\e[32mSymbolic link created: /usr/local/bin/gost\e[0m'
    echo $'\e[32mSystem update completed.\e[0m'
    # Prompt user to choose Gost version
    echo $'\e[32mChoose Gost version:\e[0m'
    echo $'\e[36m1. \e[0mGost version 2.11.5 (official)'
    echo $'\e[36m2. \e[0mGost version 3.0.0 (latest)'

    # Read user input for Gost version
    read -p $'\e[97mYour choice: \e[0m' gost_version_choice

# Download and install Gost based on user's choice
if [ "$gost_version_choice" -eq 1 ]; then
    echo $'\e[32mInstalling Gost version 2.11.5, please wait...\e[0m' && \
    wget https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz && \
    echo $'\e[32mGost downloaded successfully.\e[0m' && \
    gunzip gost-linux-amd64-2.11.5.gz && \
    sudo mv gost-linux-amd64-2.11.5 /usr/local/bin/gost && \
    sudo chmod +x /usr/local/bin/gost && \
    echo $'\e[32mGost installed successfully.\e[0m'
else
    if [ "$gost_version_choice" -eq 2 ]; then
        echo $'\e[32mInstalling the latest Gost version 3.x, please wait...\e[0m'
        
        # Use the direct download link for Gost 3.0.0
        download_url="https://github.com/go-gost/gost/releases/download/v3.0.0/gost_3.0.0_linux_amd64.tar.gz"

        # Download the file to /tmp and check if it was downloaded correctly
        echo $'\e[32mDownloading Gost 3.0.0...\e[0m'
        wget -O /tmp/gost.tar.gz "$download_url"
        
        # Check if the file was downloaded successfully
        if [ ! -f /tmp/gost.tar.gz ]; then
            echo $'\e[31mError: Download failed. The file was not saved correctly.\e[0m'
            exit 1
        fi

        # Check if the file is not empty
        if [ ! -s /tmp/gost.tar.gz ]; then
            echo $'\e[31mError: The downloaded file is empty.\e[0m'
            exit 1
        fi

        # Extract the downloaded file
        tar -xvzf /tmp/gost.tar.gz -C /usr/local/bin/
        chmod +x /usr/local/bin/gost
        echo $'\e[32mGost 3.0.0 installed successfully.\e[0m'
    else
        echo $'\e[31mInvalid choice. Exiting...\e[0m'
        exit
    fi
fi

    # Continue creating the systemd service file
    exec_start_command="ExecStart=/usr/local/bin/gost"

    # Add lines for each port
    IFS=',' read -ra port_array <<< "$ports"
    port_count=${#port_array[@]}

    # Set the maximum number of ports per file
    max_ports_per_file=12000

    # Calculate the number of files needed
    file_count=$(( (port_count + max_ports_per_file - 1) / max_ports_per_file ))

    # Continue creating the systemd service files
    for ((file_index = 0; file_index < file_count; file_index++)); do
        # Create a new systemd service file
        cat <<EOL | sudo tee "/usr/lib/systemd/system/gost_$file_index.service" > /dev/null
[Unit]
Description=GO Simple Tunnel
After=network.target
Wants=network.target

[Service]
Type=simple
Environment="GOST_LOGGER_LEVEL=fatal"
EOL

        # Add lines for each port in the current file
        exec_start_command="ExecStart=/usr/local/bin/gost"
        for ((i = file_index * max_ports_per_file; i < (file_index + 1) * max_ports_per_file && i < port_count; i++)); do
            port="${port_array[i]}"
            exec_start_command+=" -L=$protocol://:$port/[$destination_ip]:$port"
        done

        # Append the ExecStart command to the current file
        echo "$exec_start_command" | sudo tee -a "/usr/lib/systemd/system/gost_$file_index.service" > /dev/null

        # Complete the current systemd service file
        cat <<EOL | sudo tee -a "/usr/lib/systemd/system/gost_$file_index.service" > /dev/null

[Install]
WantedBy=multi-user.target
EOL

        # Reload and restart the systemd service
        sudo systemctl enable "gost_$file_index.service"
        sudo systemctl start "gost_$file_index.service"
        sudo systemctl daemon-reload
        sudo systemctl restart "gost_$file_index.service"
    done

echo $'\e[32mGost configuration applied successfully.\e[0m'
    
# If option 3 is selected
elif [ "$choice" -eq 3 ]; then
    clear
    echo -e "\e[44m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo -e "\e[1;97m       🌐 GOST Status & Port Forward List       \e[0m"
    echo -e "\e[44m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"

    if command -v gost &>/dev/null; then
        echo -e "\e[32m✔ Gost is installed.\e[0m"
        echo

        active_services=$(systemctl list-units --type=service --state=active | grep gost_ | awk '{print $1}')
        
        if [ -z "$active_services" ]; then
            echo -e "\e[33m⚠ No active gost services found.\e[0m"
        else
            printf "\e[96m%-25s %-30s %-10s\e[0m\n" "Service Name" "IP:PORT" "Protocol"
            echo -e "\e[90m────────────────────────────────────────────────────────────────────\e[0m"

            for service in $active_services; do
                # Extract full ExecStart line with parameters
                exec_line=$(systemctl show "$service" -p ExecStart | cut -d'=' -f2-)

                # Extract each -L or -F argument even if in quotes
                forwards=$(echo "$exec_line" | grep -oP '"?-L=\K[^" ]+' || echo "")

                if [ -z "$forwards" ]; then
                    printf "\e[93m%-25s\e[0m %-30s %-10s\n" "$service" "N/A" "N/A"
                else
                    while read -r forward; do
                        # Examples: tcp://:50141/[10.10.10.2]:50141
                        proto=$(echo "$forward" | cut -d':' -f1)
                        
                        # Extract destination IP (inside brackets) and port
                        ip=$(echo "$forward" | grep -oP '\[\K[0-9a-fA-F:.]+' || echo "0.0.0.0")
                        port=$(echo "$forward" | grep -oP ']:\K[0-9]{2,5}' || echo "N/A")

                        printf "\e[92m%-25s\e[0m %-30s %-10s\n" "$service" "$ip:$port" "$proto"
                    done <<< "$forwards"
                fi
            done
        fi
    else
        echo -e "\e[31m✖ Gost is not installed on this system.\e[0m"
    fi

    echo
    echo -e "\e[36mPress any key to return to the menu...\e[0m"
    read -n 1 -s
    bash "$0"

# If option 4 is selected
elif [ "$choice" -eq 4 ]; then
    read -p $'\e[32mDo you want to update Gost script? (y/n): \e[0m' update_choice

    if [ "$update_choice" == "y" ]; then
        echo $'\e[32mUpdating Gost, please wait...\e[0m'
        # Save install.sh in /etc/gost directory
        sudo mkdir -p /etc/gost
wget -O /etc/gost/install.sh https://github.com/masoudgb/Gost-ip6/raw/main/install.sh
chmod +x /etc/gost/install.sh
        echo $'\e[32mUpdate completed.\e[0m'
    else
        echo $'\e[32mUpdate canceled.\e[0m'
    fi

    bash "$0"
fi

# If option 5 is selected
if [ "$choice" -eq 5 ]; then
    read -p $'\e[97mPlease enter the new destination (Kharej) IP 4 or 6: \e[0m' destination_ip
    read -p $'\e[36mPlease enter the new port (separated by commas): \e[0m' port
    read -p $'\e[32mSelect the protocol:\n\e[0m\e[36m1. \e[0mBy Tcp Protocol \n\e[36m2. \e[0mBy Grpc Protocol \e[32m\nYour choice: \e[0m' protocol_option

    if [ "$protocol_option" -eq 1 ]; then
        protocol="tcp"
    elif [ "$protocol_option" -eq 2 ]; then
        protocol="grpc"
    else
        echo $'\e[31mInvalid protocol option. Exiting...\e[0m'
        exit
    fi

    # Use the default protocol previously entered
    echo $'\e[32mYou chose option\e[0m' $choice
    echo $'\e[97mDestination IP:\e[0m' $destination_ip
    echo $'\e[97mPort(s):\e[0m' $port
    echo $'\e[97mProtocol:\e[0m' $protocol

    # Create the systemd service file
    cat <<EOL | sudo tee "/usr/lib/systemd/system/gost_$destination_ip.service" > /dev/null
[Unit]
Description=GO Simple Tunnel
After=network.target
Wants=network.target

[Service]
Type=simple
Environment="GOST_LOGGER_LEVEL=fatal"
EOL

    # Add lines for each port
    IFS=',' read -ra port_array <<< "$port"
    port_count=${#port_array[@]}

    # Set the maximum number of ports per file
    max_ports_per_file=12000

    # Calculate the number of files needed
    file_count=$(( (port_count + max_ports_per_file - 1) / max_ports_per_file ))

    for ((file_index = 0; file_index < file_count; file_index++)); do
        # Add lines for each port in the current file
        exec_start_command="ExecStart=/usr/local/bin/gost"
        for ((i = file_index * max_ports_per_file; i < (file_index + 1) * max_ports_per_file && i < port_count; i++)); do
            port="${port_array[i]}"
            exec_start_command+=" -L=$protocol://:$port/[$destination_ip]:$port"
        done

        # Append the ExecStart command to the current file
        echo "$exec_start_command" | sudo tee -a "/usr/lib/systemd/system/gost_$destination_ip.service" > /dev/null
    done

    # Complete the systemd service file
    cat <<EOL | sudo tee -a "/usr/lib/systemd/system/gost_$destination_ip.service" > /dev/null

[Install]
WantedBy=multi-user.target
EOL

    # Reload and restart the systemd service
    sudo systemctl enable "gost_$destination_ip.service"
    sudo systemctl start "gost_$destination_ip.service"
    sudo systemctl daemon-reload
    sudo systemctl restart "gost_$destination_ip.service"
    
    echo $'\e[32mGost configuration applied successfully.\e[0m'
    bash "$0"
    
 # If option 6 is selected
elif [ "$choice" -eq 6 ]; then
    echo $'\e[32mChoose Gost version:\e[0m'
    echo $'\e[36m1. \e[0mGost version 2.11.5 (official)'
    echo $'\e[36m2. \e[0mGost version 3.x (latest)'

    # Read user input for Gost version choice
    read -p $'\e[97mYour choice: \e[0m' gost_version_choice

    # Download and install Gost based on user's choice
    case "$gost_version_choice" in
        1)
            echo $'\e[32mInstalling Gost version 2.11.5, please wait...\e[0m' && \
            wget https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz && \
            echo $'\e[32mGost downloaded successfully.\e[0m' && \
            gunzip gost-linux-amd64-2.11.5.gz && \
            sudo mv gost-linux-amd64-2.11.5 /usr/local/bin/gost && \
            sudo chmod +x /usr/local/bin/gost && \
            echo $'\e[32mGost installed successfully.\e[0m'
            ;;
        2)
            echo $'\e[32mInstalling the latest Gost version 3.x, please wait...\e[0m' && \
            
            # Fetch the download URL for the latest 3.x version of Gost
            download_url=$(curl -s https://api.github.com/repos/go-gost/gost/releases | \
                           grep -oP '"browser_download_url": "\K(.*?linux.*?\.tar\.gz)(?=")' | \
                           grep -E 'v3\.' | \
                           head -n 1)
            
            # Check if a valid URL was fetched
            if [ -z "$download_url" ]; then
                echo $'\e[31mError: Could not find the download URL for the latest 3.x Gost version.\e[0m'
                exit 1
            fi

            # Download the file to /tmp and check if it was downloaded correctly
            echo $'\e[32mDownloading the latest version of Gost 3.x...\e[0m'
            wget -O /tmp/gost.tar.gz "$download_url"
            
            # Check if the file was downloaded successfully
            if [ ! -f /tmp/gost.tar.gz ]; then
                echo $'\e[31mError: Download failed. The file was not saved correctly.\e[0m'
                exit 1
            fi

            # Check if the file is not empty
            if [ ! -s /tmp/gost.tar.gz ]; then
                echo $'\e[31mError: The downloaded file is empty.\e[0m'
                exit 1
            fi

            # Extract the downloaded file
            tar -xvzf /tmp/gost.tar.gz -C /usr/local/bin/ && \
            chmod +x /usr/local/bin/gost && \
            echo $'\e[32mGost 3.x installed successfully.\e[0m'
            ;;
        *)
            echo $'\e[31mInvalid choice. Exiting...\e[0m'
            exit
            ;;
    esac
    bash "$0"
    
# If option 7 is selected
elif [ "$choice" -eq 7 ]; then
    clear
    echo -e "\e[44m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo -e "\e[1;97m        🔁 GOST Auto-Restart Scheduler         \e[0m"
    echo -e "\e[44m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo
    echo -e "\e[36m1. \e[0mEnable Auto Restart"
    echo -e "\e[36m2. \e[0mDisable Auto Restart"
    echo
    read -p $'\e[97mYour choice: \e[0m' auto_restart_option

    case "$auto_restart_option" in
        1)
            echo
            read -p $'\e[97m🔄 Enter interval in hours (e.g. 6): \e[0m' restart_time_hours

            if ! [[ "$restart_time_hours" =~ ^[0-9]+$ ]]; then
                echo -e "\e[31m❌ Invalid input. Please enter a number.\e[0m"
                bash "$0"
                exit
            fi

            # check the creat service
            gost_services=$(systemctl list-units --type=service | grep gost_ | awk '{print $1}')
            if [ -z "$gost_services" ]; then
                echo -e "\e[33m⚠ No gost_* services found. Cannot schedule auto-restart.\e[0m"
                bash "$0"
                exit
            fi

            # creat restart cron
            cat << 'EOF' | sudo tee /usr/local/bin/gost_auto_restart.sh >/dev/null
#!/bin/bash
for svc in $(systemctl list-units --type=service | grep gost_ | awk '{print $1}'); do
    systemctl restart "$svc"
done
EOF

            sudo chmod +x /usr/local/bin/gost_auto_restart.sh

            # remoce before cron
            crontab -l | grep -v 'gost_auto_restart.sh' 2>/dev/null | crontab -

            # add new cron
            (crontab -l 2>/dev/null ; echo "0 */$restart_time_hours * * * /usr/local/bin/gost_auto_restart.sh") | crontab -

            echo -e "\e[32m✅ Auto-Restart every $restart_time_hours hour(s) scheduled.\e[0m"
            ;;
        2)
            echo -e "\e[33mDisabling auto restart...\e[0m"

            # remove cron 
            sudo rm -f /usr/local/bin/gost_auto_restart.sh
            crontab -l | grep -v 'gost_auto_restart.sh' 2>/dev/null | crontab -

            echo -e "\e[32m✅ Auto-Restart disabled successfully.\e[0m"
            ;;
        *)
            echo -e "\e[31m❌ Invalid choice. Returning to menu...\e[0m"
            ;;
    esac

    echo
    echo -e "\e[36mPress any key to return to the menu...\e[0m"
    read -n 1 -s
    bash "$0"
fi

# If option 8 is selected
if [ "$choice" -eq 8 ]; then
    echo $'\e[32mChoose Auto Clear Cache option:\e[0m'
    echo $'\e[36m1. \e[0mEnable Auto Clear Cache'
    echo $'\e[36m2. \e[0mDisable Auto Clear Cache'

    read -p $'\e[97mYour choice: \e[0m' auto_clear_cache_option

    case "$auto_clear_cache_option" in
        1)
            echo $'\e[32mAuto Clear Cache Enabled.\e[0m'
            read -p $'\e[97mEnter the interval in days (e.g., 1 for daily, 7 for weekly): \e[0m' interval_days

            # Validate input: positive integer
            if ! [[ "$interval_days" =~ ^[1-9][0-9]*$ ]]; then
                echo -e "\e[31m❌ Invalid input. Please enter a positive integer.\e[0m"
                sleep 2
                bash "$0"
                exit
            fi

            # Remove existing auto clear cache cron jobs before adding new
            (crontab -l 2>/dev/null | grep -v 'drop_caches') | crontab -

            # Prepare the command for cache clearing
            cache_clear_cmd="sync; echo 3 > /proc/sys/vm/drop_caches"

            # Set up the cron job with the interval
            cron_schedule="0 0 */$interval_days * *"

            # Add new cron job
            (crontab -l 2>/dev/null; echo "$cron_schedule root bash -c '$cache_clear_cmd'") | crontab -

            echo $'\e[32m✅ Auto Clear Cache scheduled successfully.\e[0m'
            ;;
        2)
            echo $'\e[32mAuto Clear Cache Disabled.\e[0m'
            # Remove cron jobs related to cache clearing
            (crontab -l 2>/dev/null | grep -v 'drop_caches') | crontab -

            echo $'\e[32m✅ Auto Clear Cache disabled successfully.\e[0m'
            ;;
        *)
            echo $'\e[31mInvalid choice. Exiting...\e[0m'
            exit
            ;;
    esac

    # Relaunch the script menu
    echo
    echo -e "\e[36mPress any key to return to the menu...\e[0m"
    read -n 1 -s
    bash "$0"
fi

# If option 9 is selected
if [ "$choice" -eq 9 ]; then
    echo -e "\e[36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo -e "\e[1;97m 🚀 Full Network Optimization (Advanced Mode) \e[0m"
    echo -e "\e[36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo -e "\e[32m⏳ Applying kernel and system-level enhancements...\e[0m"
    sleep 1

    # ✅ install BBR 
    if ! lsmod | grep -q bbr; then
        echo -e "\e[34m→ Installing BBR (Google's TCP Congestion Control)...\e[0m"
        wget -N --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && \
        chmod +x bbr.sh && bash bbr.sh
    else
        echo -e "\e[32m✔ BBR already installed and active.\e[0m"
    fi

    # ✅ systemd and network
    cat <<EOF >/etc/sysctl.d/99-forwarding-optimize.conf
# Enable BBR and optimize for forwarding/VPN
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

# TCP Optimization
net.core.netdev_max_backlog = 65536
net.core.somaxconn = 65535
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_sack = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_fin_timeout = 8
net.ipv4.tcp_keepalive_time = 120
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.ip_forward = 1

# UDP Optimization
net.ipv4.udp_mem = 65536 131072 262144

# Protection against SYN flood
net.ipv4.tcp_abort_on_overflow = 1
net.ipv4.tcp_syncookies = 1

# Allow high port range
net.ipv4.ip_local_port_range = 1024 65535

# Queue & backlog tuning
net.unix.max_dgram_qlen = 2048

# Increase connection tracking limit (for iptables/nftables)
net.netfilter.nf_conntrack_max = 262144
EOF

    sysctl --system

    # ✅ secret
    ulimit -n 1048576
    sed -i '/\* soft nofile/d;/\* hard nofile/d' /etc/security/limits.conf
    echo -e "* soft nofile 1048576\n* hard nofile 1048576" >> /etc/security/limits.conf

    # ✅ NIC Offload ( disable TSO, GSO, GRO for low delay)
    if command -v ethtool &>/dev/null; then
        for iface in $(ls /sys/class/net | grep -v lo); do
            echo -e "\e[34m→ NIC tuning for interface: $iface\e[0m"
            ethtool -K "$iface" gro off gso off tso off &>/dev/null
        done
    fi

    # ✅ enable RPS/RFS for CPU multi-core
    echo 32768 > /proc/sys/net/core/rps_sock_flow_entries
    for iface in /sys/class/net/*/queues/rx-*/rps_cpus; do
        echo f > "$iface" 2>/dev/null
    done

    # show succesfuly
    echo -e "\e[32m✅ Full network optimization completed successfully.\e[0m"
    echo
    echo -e "\e[36mPress any key to return to the menu...\e[0m"
    read -n 1 -s
    bash "$0"

# If option 10 is selected
elif [ "$choice" -eq 12 ]; then
    # Prompt the user for confirmation
    read -p $'\e[91mWarning\e[33m: This will uninstall Gost and remove all related data. Are you sure you want to continue? (y/n): ' uninstall_confirm

    # Check user confirmation
    if [ "$uninstall_confirm" == "y" ]; then
        # Countdown for uninstallation in a single line
        echo $'\e[32mUninstalling Gost in 3 seconds... \e[0m' && sleep 1 && echo $'\e[32m2... \e[0m' && sleep 1 && echo $'\e[32m1... \e[0m' && sleep 1 && {
            # Remove the auto_restart_cronjob.sh script
            sudo rm -f /usr/bin/auto_restart_cronjob.sh

            # Remove the cron job for Auto Restart
            crontab -l | grep -v '/usr/bin/auto_restart_cronjob.sh' | crontab -

            # Continue with the rest of the uninstallation process
            sudo systemctl daemon-reload
            sudo systemctl stop gost_*.service
            sudo rm -f /usr/local/bin/gost
            sudo rm -rf /etc/gost
            sudo rm -f /usr/lib/systemd/system/gost_*.service
            sudo rm -f /etc/systemd/system/multi-user.target.wants/gost_*.service
            systemctl stop sysctl-custom
            systemctl disable sysctl-custom
            sudo rm -f /etc/systemd/system/sysctl-custom.service
            sudo rm -f /etc/systemd/system/multi-user.target.wants/sysctl-custom.service
            systemctl daemon-reload
            
            echo $'\e[32mGost successfully uninstalled.\e[0m'
        }
    else
        echo $'\e[32mUninstallation canceled.\e[0m'
    fi
    
# If option 11 is selected
elif [ "$choice" -eq 13 ]; then
    echo $'\e[32mYou have exited the script.\e[0m'
    exit
fi
# Restart Services
if [ "$choice" -eq 10 ]; then
    echo -e "\e[36mRestarting all related services (Gost, etc)...\e[0m"
    systemctl restart gost 2>/dev/null && echo -e "\e[32m✅ Gost restarted.\e[0m"
    systemctl restart gost-ipv6 2>/dev/null && echo -e "\e[32m✅ Gost IPv6 restarted.\e[0m"
    #haha
    echo -e "\e[36mAll services restarted.\e[0m"
    read -n 1 -s -r -p $'\e[97mPress any key to return to menu...\e[0m'
    bash "$0"
fi

if [ "$choice" -eq 11 ]; then
    ip_dir="/etc/gost/ips"

    echo -e "\n\e[36m🗑 Removing GOST forwarded IP...\e[0m"

    if [ ! -d "$ip_dir" ]; then
        echo -e "\e[31m⚠ IP list directory not found at $ip_dir.\e[0m"
        read -n 1 -s -r -p $'\n\e[97mPress any key to return to menu...\e[0m'
        bash "$0"
        exit
    fi

    ip_list=$(ls "$ip_dir" 2>/dev/null)
    if [ -z "$ip_list" ]; then
        echo -e "\e[31m⚠ No GOST IPs found to remove.\e[0m"
        read -n 1 -s -r -p $'\n\e[97mPress any key to return to menu...\e[0m'
        bash "$0"
        exit
    fi

    echo -e "\n\e[32m📋 IPs forwarded via GOST:\e[0m"
    echo "$ip_list" | nl

    read -p $'\e[97mEnter the number of the IP to remove: \e[0m' num
    selected_ip=$(echo "$ip_list" | sed -n "${num}p")

    if [ -z "$selected_ip" ]; then
        echo -e "\e[31m⚠ Invalid selection.\e[0m"
    else
        echo -e "\n\e[33m⏳ Removing GOST forward for IP: $selected_ip...\e[0m"

        # Stop and disable systemd service
        systemctl stop "gost@$selected_ip.service" 2>/dev/null
        systemctl disable "gost@$selected_ip.service" 2>/dev/null
        rm -f "/etc/systemd/system/gost@$selected_ip.service"

        # Remove IP config
        rm -f "$ip_dir/$selected_ip"

        # Reload systemd
        systemctl daemon-reexec
        systemctl daemon-reload

        echo -e "\n\e[32m✅ GOST forward for IP $selected_ip has been removed.\e[0m"
    fi

    read -n 1 -s -r -p $'\n\e[97mPress any key to return to menu...\e[0m'
    bash "$0"
fi
