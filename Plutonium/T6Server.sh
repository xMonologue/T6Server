#!/bin/bash

# T6Server.sh - Plutonium Call of Duty: Black Ops II Server Script
# Version: 2.1.0
# Author: Sterbweise
# Last Updated: 21/08/2024

# Description:
# This script is designed to run and manage a dedicated server for Call of Duty: Black Ops II
# using the Plutonium client. It supports both Multiplayer and Zombie modes, and includes
# functionality for server updates and automatic restarts.

# Usage:
# 1. Configure the variables below according to your server setup
# 2. Run the script with: bash T6Server.sh

# Note: This script requires Wine to be installed on your system to run the Windows executable.

# Configuration variables
# These variables define the basic settings for your server. Modify them as needed.

# Full path to this script
readonly SCRIPT_PATH=$(readlink -f "${BASH_SOURCE[0]}")
# Directory containing this script
readonly SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
# Name of your server as it will appear in the server browser
readonly SERVER_NAME=""

# Game path configuration
# This is the path to your game files. Choose the appropriate path based on your game mode.
# For Multiplayer mode, use: "/opt/T6Server/Server/Multiplayer"
# For Zombie mode, use:     "/opt/T6Server/Server/Zombie"
readonly GAME_PATH="/opt/T6Server/Server/Zombie"

# Your unique server key provided by Plutonium (https://platform.plutonium.pw/serverkeys)
readonly SERVER_KEY=""

# Config file selection
# This is the configuration file for your server. Choose based on your game mode.
# For Multiplayer mode, use: "dedicated.cfg"
# For Zombie mode, use:     "dedicated_zm.cfg"
readonly CONFIG_FILE="dedicated_zm.cfg"

# The UDP port your server will listen on
readonly SERVER_PORT=4976

# Game mode selection
# This determines which game mode your server will run.
# For Multiplayer mode, use: "t6mp"
# For Zombie mode, use:     "t6zm"
readonly GAME_MODE="t6zm"

# Installation directory of Plutonium
readonly INSTALL_DIR="/opt/T6Server/Plutonium"

# Load a mod to your server (Make sure to setup a FastDL website so users can download the mod loaded into your server)
# How to setup FastDL: https://plutonium.pw/docs/server/iw5/fastdl/
# How to load mods into the server: https://plutonium.pw/docs/server/t4/loading-mods/ (Just use the T6 Folder, not the T4 folder since its WAW but the process is the same)
# Made by @XMonologue (Not the whole script but the MOD section)
MOD=""

# Note: To switch to Zombie mode, make the following changes:
# 1. Set GAME_PATH to "/opt/T6Server/Server/Zombie"
# 2. Set CONFIG_FILE to "dedicated_zm.cfg"
# 3. Set GAME_MODE to "t6zm"

# Function to update server files
# This function uses the Plutonium updater to ensure your server is running the latest version
update_server() {
    ./plutonium-updater -d "$INSTALL_DIR"
}

# Function to start and maintain the server
# This function starts the server and automatically restarts it if it crashes
start_server() {
    local timestamp
    printf -v timestamp '%(%F_%H:%M:%S)T' -1
    
    # Set the terminal title
    echo -e '\033]2;Plutonium - '"$SERVER_NAME"' - Server restart\007'
    
    # Display server information
    echo "Visit plutonium.pw | Join the Discord (plutonium) for NEWS and Updates!"
    echo "Server $SERVER_NAME will load $CONFIG_FILE and listen on port $SERVER_PORT UDP!"
    echo "To shut down the server close this window first!"
    echo "$timestamp $SERVER_NAME server started."

    # Main server loop
    while true; do
        # Start the server using Wine
        wine .\\bin\\plutonium-bootstrapper-win32.exe "$GAME_MODE" "$GAME_PATH" -dedicated +start_map_rotate +set key "$SERVER_KEY" +set fs_game $MOD +set net_port "$SERVER_PORT" +set sv_config "$CONFIG_FILE" 2>/dev/null
        
        # If the server stops, log the event and restart
        printf -v timestamp '%(%F_%H:%M:%S)T' -1
        echo "$timestamp WARNING: $SERVER_NAME server closed or dropped... server restarting."
        sleep 1
    done
}

# Main execution
# First update the server, then start it
update_server
start_server
