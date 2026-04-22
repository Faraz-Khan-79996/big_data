#!/bin/bash
# ============================================================
# Assignment 3: Fundamental HDFS Commands
# ============================================================
# Student Name  : YOUR_NAME_HERE
# Enrollment No : YOUR_ENROLLMENT_HERE
# Subject       : Big Data
# ============================================================

echo "========================================================"
echo "  Big Data Assignment 3 - Fundamental HDFS Commands"
echo "  Student : YOUR_NAME_HERE"
echo "  Enroll  : YOUR_ENROLLMENT_HERE"
echo "========================================================"
echo ""

# Directory in HDFS to use (named after enrollment for uniqueness)
HDFS_DIR="/assignment3_YOUR_ENROLLMENT_HERE"
LOCAL_FILE="file.txt"
DOWNLOAD_FILE="downloaded.txt"

# ──────────────────────────────────────────────
# COMMAND 1: Create a Directory in HDFS (mkdir)
# ──────────────────────────────────────────────
echo "========================================"
echo "Command 1: Create Directory in HDFS"
echo "========================================"
echo "\$ hdfs dfs -mkdir $HDFS_DIR"
hdfs dfs -mkdir $HDFS_DIR

echo ""
echo "\$ hdfs dfs -ls /"
hdfs dfs -ls /

# ──────────────────────────────────────────────
# COMMAND 2: Upload a Local File to HDFS (put)
# ──────────────────────────────────────────────
echo ""
echo "========================================"
echo "Command 2: Upload File to HDFS"
echo "========================================"

# Create a local file to upload
echo "Hello Hadoop Assignment" > $LOCAL_FILE
echo "[Created local file: $LOCAL_FILE]"

echo "\$ hdfs dfs -put $LOCAL_FILE $HDFS_DIR"
hdfs dfs -put $LOCAL_FILE $HDFS_DIR

echo ""
echo "\$ hdfs dfs -ls $HDFS_DIR"
hdfs dfs -ls $HDFS_DIR

# ──────────────────────────────────────────────
# COMMAND 3: Read a File in HDFS (cat)
# ──────────────────────────────────────────────
echo ""
echo "========================================"
echo "Command 3: Read File from HDFS (cat)"
echo "========================================"
echo "\$ hdfs dfs -cat $HDFS_DIR/$LOCAL_FILE"
hdfs dfs -cat $HDFS_DIR/$LOCAL_FILE

# ──────────────────────────────────────────────
# COMMAND 4: Download a File from HDFS (get)
# ──────────────────────────────────────────────
echo ""
echo "========================================"
echo "Command 4: Download File from HDFS"
echo "========================================"
# Remove existing downloaded file if present
rm -f $DOWNLOAD_FILE

echo "\$ hdfs dfs -get $HDFS_DIR/$LOCAL_FILE $DOWNLOAD_FILE"
hdfs dfs -get $HDFS_DIR/$LOCAL_FILE $DOWNLOAD_FILE

echo ""
echo "[Verifying downloaded file locally with ls:]"
ls -lh $DOWNLOAD_FILE

echo ""
echo "[Content of downloaded file:]"
cat $DOWNLOAD_FILE

# ──────────────────────────────────────────────
# COMMAND 5: Delete a File from HDFS (rm)
# ──────────────────────────────────────────────
echo ""
echo "========================================"
echo "Command 5: Delete File from HDFS"
echo "========================================"
echo "\$ hdfs dfs -rm $HDFS_DIR/$LOCAL_FILE"
hdfs dfs -rm $HDFS_DIR/$LOCAL_FILE

echo ""
echo "[Verifying HDFS directory is now empty:]"
echo "\$ hdfs dfs -ls $HDFS_DIR"
hdfs dfs -ls $HDFS_DIR

echo ""
echo "========================================================"
echo "  Assignment 3 Complete! All HDFS commands executed."
echo "========================================================"
