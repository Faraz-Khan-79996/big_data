#!/bin/bash
# ============================================================
# Assignment 1: Hadoop Single Node Cluster Installation
# ============================================================
# Student Name  : YOUR_NAME_HERE
# Enrollment No : YOUR_ENROLLMENT_HERE
# Subject       : Big Data
# ============================================================

echo "========================================================"
echo "  Big Data Assignment 1 - Hadoop Single Node Setup"
echo "  Student : YOUR_NAME_HERE"
echo "  Enroll  : YOUR_ENROLLMENT_HERE"
echo "========================================================"
echo ""

# ──────────────────────────────────────────────
# STEP 1: Install Java 8
# ──────────────────────────────────────────────
echo "[Step 1] Installing Java 8..."
sudo apt-get update -y
sudo apt-get install -y openjdk-8-jdk

echo "[Step 1] Verifying Java installation..."
java -version

# ──────────────────────────────────────────────
# STEP 2: Download and Extract Hadoop 3.3.6
# ──────────────────────────────────────────────
echo ""
echo "[Step 2] Downloading Hadoop 3.3.6..."
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz

echo "[Step 2] Extracting Hadoop..."
tar -xzvf hadoop-3.3.6.tar.gz

echo "[Step 2] Moving Hadoop to /usr/local/hadoop..."
sudo mv hadoop-3.3.6 /usr/local/hadoop

# ──────────────────────────────────────────────
# STEP 3: Configure Environment Variables
# ──────────────────────────────────────────────
echo ""
echo "[Step 3] Configuring environment variables in ~/.bashrc..."

cat >> ~/.bashrc << 'EOF'

# ── Hadoop / Java Environment Variables ──
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
EOF

source ~/.bashrc
echo "[Step 3] Environment variables set."

# ──────────────────────────────────────────────
# STEP 4: Configure Hadoop XML Files
# ──────────────────────────────────────────────
echo ""
echo "[Step 4] Configuring Hadoop XML files..."

HADOOP_CONF=/usr/local/hadoop/etc/hadoop

# 4a. hadoop-env.sh
sudo tee $HADOOP_CONF/hadoop-env.sh > /dev/null << 'EOF'
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
EOF

# 4b. core-site.xml
sudo tee $HADOOP_CONF/core-site.xml > /dev/null << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://localhost:9000</value>
  </property>
</configuration>
EOF

# 4c. hdfs-site.xml
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

# 4d. mapred-site.xml
sudo tee $HADOOP_CONF/mapred-site.xml > /dev/null << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
  <property>
    <name>yarn.app.mapreduce.am.env</name>
    <value>HADOOP_MAPRED_HOME=$HADOOP_HOME</value>
  </property>
  <property>
    <name>mapreduce.map.env</name>
    <value>HADOOP_MAPRED_HOME=$HADOOP_HOME</value>
  </property>
  <property>
    <name>mapreduce.reduce.env</name>
    <value>HADOOP_MAPRED_HOME=$HADOOP_HOME</value>
  </property>
</configuration>
EOF

# 4e. yarn-site.xml
sudo tee $HADOOP_CONF/yarn-site.xml > /dev/null << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
    <value>org.apache.hadoop.mapred.ShuffleHandler</value>
  </property>
</configuration>
EOF

echo "[Step 4] Hadoop configuration files updated."

# ──────────────────────────────────────────────
# STEP 5: Configure SSH for Localhost
# ──────────────────────────────────────────────
echo ""
echo "[Step 5] Setting up SSH for localhost..."
sudo apt-get install -y openssh-server openssh-client

# Generate SSH key (no passphrase)
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
fi

cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

echo "[Step 5] Testing SSH to localhost..."
ssh -o StrictHostKeyChecking=no localhost "echo 'SSH to localhost successful'"

# ──────────────────────────────────────────────
# STEP 6: Create Data Directories and Format NameNode
# ──────────────────────────────────────────────
echo ""
echo "[Step 6] Creating data directories..."
sudo mkdir -p /usr/local/hadoop/data/namenode
sudo mkdir -p /usr/local/hadoop/data/datanode
sudo chown -R $USER /usr/local/hadoop/data

echo "[Step 6] Formatting NameNode..."
hdfs namenode -format -force

# ──────────────────────────────────────────────
# STEP 7: Start Hadoop Services
# ──────────────────────────────────────────────
echo ""
echo "[Step 7] Starting HDFS..."
start-dfs.sh

echo "[Step 7] Starting YARN..."
start-yarn.sh

echo "[Step 7] Verifying running processes (jps)..."
jps

# ──────────────────────────────────────────────
# STEP 8: Web Interface Info
# ──────────────────────────────────────────────
echo ""
echo "========================================================"
echo "  Setup Complete! Access Web UIs at:"
echo "  HDFS NameNode UI : http://localhost:9870"
echo "  YARN Resource Mgr: http://localhost:8088"
echo "========================================================"
