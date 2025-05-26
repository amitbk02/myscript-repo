#!/bin/bash

# Define the 3 target hosts
HOST1="192.168.1.101"
HOST2="192.168.1.102"
HOST3="192.168.1.103"

# Remote temp directory
REMOTE_DIR="/tmp/vim-install"
PKG_NAME="vim"

echo "🔐 Logging into HOST1: $HOST1 and downloading RPM..."
ssh "$HOST1" bash -c "'
  sudo mkdir -p $REMOTE_DIR
  cd $REMOTE_DIR
  sudo dnf download $PKG_NAME -y
'"

echo "📥 Finding downloaded RPM on HOST1..."
RPM_NAME=$(ssh "$HOST1" "ls $REMOTE_DIR/${PKG_NAME}*.rpm | xargs -n 1 basename" | head -n 1)

if [ -z "$RPM_NAME" ]; then
  echo "❌ RPM file not found on HOST1!"
  exit 1
fi

echo "📤 Copying $RPM_NAME from HOST1 to HOST2 and HOST3..."
ssh "$HOST1" "scp $REMOTE_DIR/$RPM_NAME $HOST2:$REMOTE_DIR/"
ssh "$HOST1" "scp $REMOTE_DIR/$RPM_NAME $HOST3:$REMOTE_DIR/"

echo "⚙️ Installing $RPM_NAME on HOST1..."
ssh "$HOST1" "sudo rpm -ivh $REMOTE_DIR/$RPM_NAME"

echo "⚙️ Logging into HOST2: $HOST2 and installing..."
ssh "$HOST2" "sudo rpm -ivh $REMOTE_DIR/$RPM_NAME"

echo "⚙️ Logging into HOST3: $HOST3 and installing..."
ssh "$HOST3" "sudo rpm -ivh $REMOTE_DIR/$RPM_NAME"

echo "✅ All done! vim installed on all 3 hosts."
