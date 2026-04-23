#!/bin/bash
# ============================================================
# Assignment 5: Apache Hive Installation & Setup
# ============================================================
# Student Name  : Arin Zingade
# Enrollment No : 0801IT221035
# Subject       : Big Data
# ============================================================

echo "========================================================"
echo "  Big Data Assignment 5 - Hive Installation"
echo "  Student : Arin Zingade"
echo "  Enroll  : 0801IT221035"
echo "========================================================"
echo ""

# ──────────────────────────────────────────────
# STEP 1: Download and Extract Hive 4.0.1
# ──────────────────────────────────────────────
# (Assuming done manually or verified here)
if [ ! -d "/usr/local/hive" ]; then
    echo "[Step 1] Downloading Hive 4.0.1..."
    wget https://archive.apache.org/dist/hive/hive-4.0.1/apache-hive-4.0.1-bin.tar.gz -P /tmp/
    tar -xzf /tmp/apache-hive-4.0.1-bin.tar.gz -C /tmp/
    sudo mv /tmp/apache-hive-4.0.1-bin /usr/local/hive
    sudo chown -R $USER:$USER /usr/local/hive
fi

# ──────────────────────────────────────────────
# STEP 2: Configure Environment Variables
# ──────────────────────────────────────────────
echo "[Step 2] Configuring environment variables..."
export HADOOP_HOME=/usr/local/hadoop
export HIVE_HOME=/usr/local/hive
export PATH=$PATH:$HIVE_HOME/bin:$HADOOP_HOME/bin

# ──────────────────────────────────────────────
# STEP 3: Fix Guava conflict
# ──────────────────────────────────────────────
echo "[Step 3] Fixing Guava version mismatch..."
rm -f $HIVE_HOME/lib/guava-19.0.jar
cp $HADOOP_HOME/share/hadoop/common/lib/guava-27.0-jre.jar $HIVE_HOME/lib/

# ──────────────────────────────────────────────
# STEP 4: Setup HDFS Directories
# ──────────────────────────────────────────────
echo "[Step 4] Creating HDFS directories..."
hdfs dfs -mkdir -p /tmp
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod g+w /tmp
hdfs dfs -chmod g+w /user/hive/warehouse

# ──────────────────────────────────────────────
# STEP 5: Verify
# ──────────────────────────────────────────────
echo ""
echo "Hive installation complete! To start Hive, run:"
echo "source ~/.bashrc"
echo "hive"
echo ""
