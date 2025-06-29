#!/bin/bash

# Define the content for the systemd service file
SERVICE_CONTENT="[Unit]
Description=Nezha Agent
After=network.target

[Service]
Type=simple
User=root
Group=root
WorkingDirectory=/opt/nezha/agent
ExecStart=/opt/nezha/agent/nezha-agent -c /opt/nezha/agent/config.yml
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
"

# Define the path for the service file
SERVICE_FILE="/etc/systemd/system/nezha-agent.service"

echo "Attempting to create and configure Nezha Agent service..."

# Create the service file using tee with sudo to write to /etc/systemd/system/
echo "$SERVICE_CONTENT" | sudo tee "$SERVICE_FILE" > /dev/null

# Check if the service file was created successfully
if [ $? -eq 0 ]; then
    echo "Service file '$SERVICE_FILE' created successfully."

    # Reload the systemd daemon to recognize the new service
    echo "Reloading systemd daemon..."
    sudo systemctl daemon-reload

    # Enable the service to start on boot
    echo "Enabling Nezha Agent service to start automatically on boot..."
    sudo systemctl enable nezha-agent

    # Start the Nezha Agent service
    echo "Starting Nezha Agent service now..."
    sudo systemctl start nezha-agent

    # Display the status of the service
    echo "Checking Nezha Agent service status:"
    sudo systemctl status nezha-agent --no-pager

    echo -e "\nNezha Agent service setup complete!"
    echo "It should now be running and set to start on system boot."
else
    echo "Error: Failed to create service file. Please check your permissions."
    exit 1
fi
