#!/bin/bash
# ============================================================
# Assignment 2: Hadoop Multi-Node Cluster - WORKER Setup
# Run this on the worker node (ubuntu-worker1)
# ============================================================
# Student Name  : YOUR_NAME_HERE
# Enrollment No : YOUR_ENROLLMENT_HERE
# Subject       : Big Data
# ============================================================

echo "========================================================"
echo "  Big Data Assignment 2 - Worker Node Setup"
echo "  Student : YOUR_NAME_HERE"
echo "  Enroll  : YOUR_ENROLLMENT_HERE"
echo "========================================================"
echo ""

# ──────────────────────────────────────────────
# STEP 1: Set Hostname to 'worker1'
# ──────────────────────────────────────────────
echo "[Step 1] Setting hostname to 'worker1'..."
sudo hostnamectl set-hostname worker1

# ──────────────────────────────────────────────
# STEP 2: Configure SSH to Listen on Port 2223
# ──────────────────────────────────────────────
echo ""
echo "[Step 2] Configuring SSH to use port 2223..."

sudo sed -i 's/#Port 22/Port 2223/' /etc/ssh/sshd_config

# Disable socket activation and restart SSH service directly
sudo systemctl stop ssh.socket 2>/dev/null || true
sudo systemctl disable ssh.socket 2>/dev/null || true
sudo service ssh restart

echo "[Step 2] SSH configured on port 2223."

# ──────────────────────────────────────────────
# STEP 3: Create DataNode Data Directory
# ──────────────────────────────────────────────
echo ""
echo "[Step 3] Creating DataNode data directory..."
sudo mkdir -p /usr/local/hadoop/data/datanode
sudo chown -R $USER /usr/local/hadoop/data

echo "[Step 3] Worker setup complete. The master can now connect via SSH on port 2223."

echo ""
echo "========================================================"
echo "  Worker node is ready."
echo "  Run setup_master.sh on the master node."
echo "========================================================"
