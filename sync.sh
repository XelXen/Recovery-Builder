#!/bin/bash

# Change to the Home Directory
cd ~

# Clone the Sync Repo
git clone $FOX_SYNC
cd sync

# Setup the Sync Branch
if [ -z "$SYNC_BRANCH" ]; then
    export SYNC_BRANCH=$(echo ${FOX_BRANCH} | cut -d_ -f2)
fi

# Sync the Sources
./orangefox_sync.sh --branch $SYNC_BRANCH --path "$SYNC_PATH" || { echo "ERROR: Failed to Sync OrangeFox Sources!" && exit 1; }

# Change to the Source Directory
cd $SYNC_PATH

# Clone the theme if not already present
if [ ! -d bootable/recovery/gui/theme ]; then
git clone https://gitlab.com/OrangeFox/misc/theme.git bootable/recovery/gui/theme || { echo "ERROR: Failed to Clone the OrangeFox Theme!" && exit 1; }
fi

# Clone the Commonsys repo, only for fox_9.0
if [ "$FOX_BRANCH" = "fox_9.0" ]; then
git clone --depth=1 https://github.com/TeamWin/android_vendor_qcom_opensource_commonsys.git -b android-9.0 vendor/qcom/opensource/commonsys || { echo "WARNING: Failed to Clone the Commonsys Repo!"; }
fi

# Clone Trees
git clone $DT_LINK $DT_PATH || { echo "ERROR: Failed to Clone the Device Trees!" && exit 1; }

# Exit
exit 0
