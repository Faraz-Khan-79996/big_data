#!/bin/bash
# ============================================================
# Assignment 2: Hadoop Multi-Node Cluster - MASTER Setup
# ============================================================
# Student Name  : YOUR_NAME_HERE
# Enrollment No : YOUR_ENROLLMENT_HERE
# Subject       : Big Data
# ============================================================

echo "========================================================"
echo "  Big Data Assignment 2 - Hadoop Multi-Node (Master)"
echo "  Student : YOUR_NAME_HERE"
echo "  Enroll  : YOUR_ENROLLMENT_HERE"
echo "========================================================"
echo ""

# ──────────────────────────────────────────────
# STEP 1: Set Hostname on Master
# ──────────────────────────────────────────────
echo "[Step 1] Setting hostname to 'master'..."
sudo hostnamectl set-hostname master

# ──────────────────────────────────────────────
# STEP 2: Configure /etc/hosts
# ──────────────────────────────────────────────
echo ""
echo "[Step 2] Configuring /etc/hosts for cluster networking..."

sudo tee -a /etc/hosts > /dev/null << 'EOF'
127.0.0.1 master
127.0.0.1 worker1
EOF

echo "[Step 2] /etc/hosts updated."

# ──────────────────────────────────────────────
# STEP 3: Setup Passwordless SSH to Worker
# ──────────────────────────────────────────────
echo ""
echo "[Step 3] Generating SSH key (if not already present)..."
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
fi

echo "[Step 3] Copying SSH key to worker1 on port 2223..."
echo "         (Worker must be running and accessible)"
ssh-copy-id -p 2223 $(whoami)@worker1

echo "[Step 3] Testing passwordless SSH to worker1..."
ssh -p 2223 $(whoami)@worker1 "echo 'SSH to worker1 successful'"

# ──────────────────────────────────────────────
# STEP 4: Configure Hadoop on Master
# ──────────────────────────────────────────────
echo ""
echo "[Step 4] Configuring Hadoop configuration files on master..."

HADOOP_CONF=/usr/local/hadoop/etc/hadoop

# 4a. core-site.xml
sudo tee $HADOOP_CONF/core-site.xml > /dev/null << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://master:9000</value>
  </property>
</configuration>
EOF

# 4b. hdfs-site.xml
sudo tee $HADOOP_CONF/hdfs-site.xml > /dev/null << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:///usr/local/hadoop/data/namenode</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:///usr/local/hadoop/data/datanode</value>
  </property>
</configuration>
EOF

# 4c. hadoop-env.sh – use port 2223 for SSH to worker
sudo tee -a $HADOOP_CONF/hadoop-env.sh > /dev/null << 'EOF'

# Multi-node SSH options (worker listens on port 2223)
export HADOOP_SSH_OPTS="-p 2223 -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10s"
EOF

# 4d. workers file – list worker hostnames
echo "worker1" | sudo tee $HADOOP_CONF/workers > /dev/null

echo "[Step 4] Hadoop configuration complete on master."

# ──────────────────────────────────────────────
# STEP 5: Create Data Directories & Format NameNode
# ──────────────────────────────────────────────
echo ""
echo "[Step 5] Creating NameNode and DataNode directories..."
sudo mkdir -p /usr/local/hadoop/data/namenode
sudo mkdir -p /usr/local/hadoop/data/datanode
sudo chown -R $USER /usr/local/hadoop/data

echo "[Step 5] Formatting NameNode..."
hdfs namenode -format -force

# ──────────────────────────────────────────────
# STEP 6: Start Cluster Services
# ──────────────────────────────────────────────
echo ""
echo "[Step 6] Starting HDFS..."
start-dfs.sh

echo "[Step 6] Starting YARN..."
start-yarn.sh

echo "[Step 6] Checking running Java processes (jps)..."
jps

echo ""
echo "[Step 6] HDFS Cluster Report:"
hdfs dfsadmin -report

# ──────────────────────────────────────────────
# STEP 7: HDFS Operations Demo
# ──────────────────────────────────────────────
echo ""
echo "[Step 7] Running basic HDFS operations..."
hdfs dfs -mkdir /demo
echo "Multi-node Hadoop cluster is working!" | hdfs dfs -put - /demo/test.txt
hdfs dfs -ls /demo

echo ""
echo "========================================================"
echo "  Multi-Node Cluster Ready!"
echo "  HDFS UI : http://master:9870"
echo "  YARN UI : http://master:8088"
echo "========================================================"
