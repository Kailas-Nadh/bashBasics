#! /bin/bash
#Update the packages and upgrade it to the current version
sudo apt update && sudo apt upgrade 
#Install necessary packages 
sudo apt install -y openssh-server openssh-client ufw
#Start ssh service and enable it upon startup
sudo systemctl start ssh.service
sudo systemctl enable ssh
sudo systemctl status ssh --no-pager
#Allow ssh on default port via firewall
sudo ufw allow ssh
sudo ufw enable && sudo ufw reload
sudo systemctl restart ssh.service

# Port change if needed
echo "Do you want to change the SSH port (Default port is 22)? (y/n)"
read option

# Convert the option to lowercase to handle both 'y' and 'Y'
option=$(echo "$option" | tr '[:upper:]' '[:lower:]')

if [ "$option" == "y" ]; then
    # Prompt for the new port number
    echo "What port should it be changed to?"
    read portNumber
    
    # Validate that portNumber is a valid port number (between 1 and 65535)
    if ! [[ "$portNumber" =~ ^[0-9]+$ ]] || [ "$portNumber" -lt 1 ] || [ "$portNumber" -gt 65535 ]; then
        echo "Invalid port number. Please enter a number between 1 and 65535."
        exit 1
    fi

    # Change the SSH port in the configuration file
    sudo sed -i "s/^#Port 22/Port $portNumber/" /etc/ssh/sshd_config
    
    # Ensure the new port is allowed through the firewall
    sudo ufw allow "$portNumber"/tcp
    
    # Remove the old port from the firewall rules
    sudo ufw delete allow 22/tcp
    
    # Reload the firewall rules
    sudo ufw reload
    
    # Restart the SSH service to apply the changes
    sudo systemctl restart ssh
    
    # Test SSH connection on the new port
    if ssh -p "$portNumber" localhost; then
        echo "SSH port successfully changed to $portNumber"
    else
        echo "Port change not successful. Please check your configuration."
        echo "Run 'sudo ss -tlpn | grep ssh' to see currently assigned port."
    fi
else
    # Notify the user that the default port will be maintained
    echo "Default port 22 maintained"
    
    # Test SSH connection on the default port
    if ssh localhost; then
        echo "SSH connection successful on port 22"
    else
        echo "SSH connection on port 22 failed. Please check your configuration."
        echo "Run 'sudo ss -tlpn | grep ssh' to see currently assigned port."
    fi
fi

# To connect to a remote system with SSH when you only have a dynamic public IP, you can use a Dynamic DNS (DDNS) service to associate a hostname with your dynamic IP #address. Here are the steps to connect to a remote system with SSH when you have a dynamic public IP:

#Set up a Dynamic DNS (DDNS) service: A DDNS service will associate a hostname with your dynamic IP address so that you can connect to your remote system even when your IP address changes.

# Configure your router to update your DDNS service with your current IP address: Most routers have the option to automatically update your DDNS service with your current IP address.

#Set up port forwarding on your router: Port forwarding is a way to forward incoming traffic from the internet to a specific device on your local network. To set up port forwarding for SSH, you need to forward incoming traffic on port 22 to the IP address of the device running the SSH server.

#Connect to the remote system using the hostname associated with your dynamic IP address: Once you have set up port forwarding and a DDNS service, you can connect to the remote system using the hostname associated with your dynamic IP address. The command to connect to a remote system with SSH is:
