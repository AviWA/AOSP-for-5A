#!/bin/bash

# Install required packages
sudo apt-get install git-core gnupg flex bison build-essential zip curl zlib1g-dev libc6-dev-i386 libncurses5 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig -y

# Update package lists
sudo apt-get update -y

# Install repo
sudo apt-get install repo -y

# Clone scripts repository
git clone https://github.com/akhilnarang/scripts.git

# Navigate to the setup directory
cd scripts/setup

# Run android_build_env script
bash android_build_env.sh

# Move back to the previous directory
cd ../..

# Install openjdk-8
sudo apt-get install openjdk-8* -y

# Create necessary directories
mkdir ~/bin
PATH=~/bin:$PATH
mkdir aosp
cd aosp

# Download and set up repo
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo

# Configure git
git config --global user.name "ak"
git config --global user.email "lampphone092@gmail.com"

# Initialize LineageOS repository
repo init -u https://github.com/LineageOS/android.git -b lineage-15.1

# Sync the repository
repo sync

# Set up ccache
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
ccache -M 50G
ccache -o compression=true

# Disable Ninja build
export USE_NINJA=false

# Create symbolic link for python2
sudo ln -s /usr/bin/python2 /usr/bin/python

# Clone kernel, device, vendor, and packages repositories
git clone https://github.com/SunnyRaj84348/android_kernel_xiaomi_msm8917.git -b lineage-15.1 kernel/xiaomi/msm8917
git clone https://github.com/SunnyRaj84348/android_device_xiaomi_riva.git -b lineage-15.1 device/xiaomi/riva
git clone https://github.com/SunnyRaj84348/android_vendor_xiaomi.git -b lineage-15.1 vendor/xiaomi
git clone https://github.com/LineageOS/android_packages_resources_devicesettings.git -b lineage-15.1 packages/resources/devicesettings

# Initialize environment setup script
. build/envsetup.sh
brunch lineage_riva-userdebug