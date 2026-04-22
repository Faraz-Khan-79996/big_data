#!/bin/bash
# ============================================================
# Assignment 2: WSL Multi-Node Setup (PowerShell Commands)
# Run these commands in Windows PowerShell to clone WSL
# ============================================================
# Student Name  : YOUR_NAME_HERE
# Enrollment No : YOUR_ENROLLMENT_HERE
# Subject       : Big Data
# ============================================================

# NOTE: This is a reference script. Run these in PowerShell.

echo "# ── Step 1: Export existing Ubuntu WSL instance ──"
echo "wsl --export Ubuntu ubuntu-master.tar"
echo ""
echo "# ── Step 2: Import as a new worker instance ──"
echo 'wsl --import ubuntu-worker1 C:\wsl\worker1 ubuntu-master.tar'
echo ""
echo "# ── Step 3: Launch the master instance ──"
echo "wsl -d Ubuntu"
echo ""
echo "# ── Step 4: In another terminal, launch worker ──"
echo "wsl -d ubuntu-worker1"
echo ""
echo "# After both instances are running:"
echo "# 1. Run setup_worker.sh inside ubuntu-worker1"
echo "# 2. Run setup_master.sh inside Ubuntu (master)"
