# Assignment 1: Installation of Hadoop on a Single Node Cluster

> **Subject:** Big Data  
> **Student Name:** Arin Zingade  
> **Enrollment No:** 0801IT221035

---

## Objective

Set up a fully functional single-node Hadoop cluster (Pseudo-Distributed Mode) on Ubuntu/WSL, configure all required services, and verify the installation via both CLI and web interfaces.

---

## Environment

| Component     | Version/Details              |
|---------------|------------------------------|
| OS            | Ubuntu 20.04 (WSL2)          |
| Java          | OpenJDK 8 (1.8.0_402)        |
| Hadoop        | 3.3.6                        |
| Mode          | Pseudo-Distributed (Single Node) |

---

## Steps

### Step 1 — Install Java 8

Hadoop requires Java 8. Install and verify:

```bash
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk
java -version
```

**Output:**
```
openjdk version "1.8.0_402"
OpenJDK Runtime Environment ...
```

---

### Step 2 — Download and Extract Hadoop

```bash
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
tar -xzvf hadoop-3.3.6.tar.gz
sudo mv hadoop-3.3.6 /usr/local/hadoop
```

---

### Step 3 — Configure Environment Variables

Add the following to `~/.bashrc`:

```bash
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
```

Apply changes:
```bash
source ~/.bashrc
```

---

### Step 4 — Configure Hadoop XML Files

Navigate to: `cd /usr/local/hadoop/etc/hadoop`

#### `core-site.xml`
```xml
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://localhost:9000</value>
  </property>
</configuration>
```

#### `hdfs-site.xml`
```xml
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
```

#### `mapred-site.xml`
```xml
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>
```

#### `yarn-site.xml`
```xml
<configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
</configuration>
```

#### `hadoop-env.sh`
```bash
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
```

---

### Step 5 — Configure SSH for Localhost

Hadoop uses SSH to manage daemons even in single-node mode.

```bash
sudo apt-get install -y openssh-server openssh-client
ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

# Test
ssh localhost
```

---

### Step 6 — Format the NameNode

> **Important:** Only run this once. Re-running will erase all HDFS data.

```bash
hdfs namenode -format
```

---

### Step 7 — Start Hadoop Services

```bash
start-dfs.sh
start-yarn.sh
jps
```

**Expected `jps` Output:**
```
2942  NameNode
3063  DataNode
3285  SecondaryNameNode
3507  ResourceManager
3623  NodeManager
3993  Jps
```

---

### Step 8 — Verify via Web Interface

| Service      | URL                          |
|--------------|------------------------------|
| HDFS NameNode | http://localhost:9870        |
| YARN Resource Manager | http://localhost:8088 |

The NameNode Web UI shows:
- Overview: `localhost:9000 (active)`
- Configured Capacity, DFS Used, Live Datanodes: **1**

---

## Conclusion

A single-node Hadoop cluster was successfully installed and configured on Ubuntu/WSL. Java 8 was installed, Hadoop 3.3.6 was extracted and configured, SSH was set up for localhost communication, and all Hadoop daemons (NameNode, DataNode, SecondaryNameNode, ResourceManager, NodeManager) were verified to be running via the `jps` command and the web interfaces.
