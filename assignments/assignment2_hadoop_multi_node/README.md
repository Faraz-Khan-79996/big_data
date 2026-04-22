# Assignment 2: Hadoop Multi-Node Cluster Installation

> **Subject:** Big Data  
> **Student Name:** YOUR_NAME_HERE  
> **Enrollment No:** YOUR_ENROLLMENT_HERE

---

## Objective

Set up a Hadoop multi-node cluster (1 Master + 1 Worker) using two WSL instances on the same Windows machine, configure passwordless SSH communication, and verify distributed HDFS operations.

---

## Architecture

```
┌──────────────────────────┐       SSH (port 2223)       ┌──────────────────────────┐
│       MASTER NODE        │ ──────────────────────────► │      WORKER NODE         │
│   WSL Instance: Ubuntu   │                             │  WSL Instance: ubuntu-   │
│   hostname: master       │                             │  worker1                 │
│                          │                             │  hostname: worker1       │
│  NameNode                │                             │                          │
│  SecondaryNameNode       │                             │  DataNode                │
│  ResourceManager         │                             │  NodeManager             │
└──────────────────────────┘                             └──────────────────────────┘
```

---

## Environment

| Component  | Details                          |
|------------|----------------------------------|
| OS         | Ubuntu 20.04 (WSL2)              |
| Java       | OpenJDK 8                        |
| Hadoop     | 3.3.6                            |
| Mode       | Multi-Node Cluster               |
| SSH Port   | 2223 (worker), 22 (master)       |

---

## Steps

### Step 1 — Clone WSL Instance (PowerShell)

Run in **Windows PowerShell** to create a separate WSL instance for the worker:

```powershell
# Export the existing Ubuntu instance
wsl --export Ubuntu ubuntu-master.tar

# Import as a new worker instance
wsl --import ubuntu-worker1 C:\wsl\worker1 ubuntu-master.tar
```

Launch them in separate terminals:
```powershell
# Terminal 1 – Master
wsl -d Ubuntu

# Terminal 2 – Worker
wsl -d ubuntu-worker1
```

---

### Step 2 — Set Hostnames

**On Master:**
```bash
sudo hostnamectl set-hostname master
```

**On Worker:**
```bash
sudo hostnamectl set-hostname worker1
```

---

### Step 3 — Configure `/etc/hosts` (on both nodes)

```
127.0.0.1   master
127.0.0.1   worker1
```

Add these lines to `/etc/hosts` on **both** nodes.

---

### Step 4 — Configure SSH on Worker (Port 2223)

Since both WSL instances share the same NAT network, the worker must listen on a different port to avoid conflicts with the master.

```bash
# Edit SSH config
sudo nano /etc/ssh/sshd_config
# Change: Port 22  →  Port 2223

# Restart SSH
sudo systemctl stop ssh.socket
sudo systemctl disable ssh.socket
sudo service ssh restart
```

---

### Step 5 — Setup Passwordless SSH (on Master)

```bash
# Generate RSA key
ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa

# Copy public key to worker on port 2223
ssh-copy-id -p 2223 <username>@worker1

# Test
ssh -p 2223 <username>@worker1 "echo 'Connected to worker1'"
```

---

### Step 6 — Configure Hadoop on Master

Navigate to: `cd /usr/local/hadoop/etc/hadoop`

#### `core-site.xml`
```xml
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://master:9000</value>
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

#### `hadoop-env.sh`
Add at the bottom:
```bash
export HADOOP_SSH_OPTS="-p 2223 -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10s"
```

#### `workers` file
```
worker1
```

---

### Step 7 — Format NameNode and Start Services

```bash
# Format NameNode (only once!)
hdfs namenode -format -force

# Start HDFS and YARN
start-dfs.sh
start-yarn.sh

# Verify running processes
jps
```

**Expected Master `jps` Output:**
```
NameNode
SecondaryNameNode
ResourceManager
Jps
```

**Verify Cluster:**
```bash
hdfs dfsadmin -report
```

Output confirms **1 Live Datanode** running on worker1.

---

### Step 8 — Test HDFS Operations

```bash
hdfs dfs -mkdir /demo
hdfs dfs -put /etc/passwd /demo
hdfs dfs -ls /demo
```

**Output:**
```
Found 1 items
-rw-r--r--   1 <user> supergroup    2345  /demo/passwd
```

---

## Conclusion

A multi-node Hadoop cluster was successfully configured across two WSL instances. The master node runs NameNode, SecondaryNameNode, and ResourceManager, while the worker node runs DataNode and NodeManager. SSH on a non-standard port (2223) was used to distinguish the two nodes on the same machine. The `hdfs dfsadmin -report` confirmed the worker was recognized as a live datanode.
