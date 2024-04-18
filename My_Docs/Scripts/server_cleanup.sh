#!/bin/bash

# Clean package cache
echo "Cleaning package cache..."
sudo apt-get clean
sudo apt-get autoclean

# Remove old packages
echo "Removing old packages..."
sudo apt-get autoremove --purge

# Clean up temporary files
echo "Cleaning temporary files..."
sudo rm -rf /tmp/*

# Clear thumbnail cache
echo "Clearing thumbnail cache..."
rm -rf $HOME/.cache/thumbnails/*

# Clear log files
echo "Clearing log files..."
sudo find /var/log -type f -delete

# Clear memory cache
echo "Clearing memory cache..."
sudo sync
sudo echo 3 > /proc/sys/vm/drop_caches

echo "Cleanup completed!"
