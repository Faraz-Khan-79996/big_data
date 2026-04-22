# Assignment 2: Hadoop Multi-Node Cluster Installation

> **Subject:** Big Data  
> **Student Name:** Arin Zingade  
> **Enrollment No:** 0801IT221035

---

## Objective

Set up a Hadoop multi-node cluster (NameNode + DataNode + ResourceManager + NodeManager) on a single Linux machine using **pre-built Docker images** from the Big Data Europe (`bde2020`) project. Each service runs as an isolated Docker container on a shared bridge network, simulating a real distributed cluster.

---

## Architecture

```
                    Docker Bridge Network: hadoop-net
    ┌─────────────────────────────────────────────────────────┐
    │                                                         │
    │  ┌──────────────┐         ┌──────────────────────────┐ │
    │  │  namenode    │←──────→ │       datanode           │ │
    │  │  (HDFS Master│  HDFS   │  (HDFS Worker)           │ │
    │  │  Port: 9870) │         │  Port: 9864              │ │
    │  └──────────────┘         └──────────────────────────┘ │
    │                                                         │
    │  ┌──────────────┐         ┌──────────────────────────┐ │
    │  │resource      │←──────→ │     nodemanager          │ │
    │  │manager       │  YARN   │  (YARN Worker)           │ │
    │  │(YARN Master) │         │  Port: 8042              │ │
    │  │Port: 8088    │         │                          │ │
    │  └──────────────┘         └──────────────────────────┘ │
    └─────────────────────────────────────────────────────────┘
```

---

## Why Pre-built Images?

Instead of building Hadoop from scratch inside a container, we use **`bde2020` images** from Docker Hub — maintained, production-tested images with Hadoop 3.2.1 + Java 8 pre-installed and pre-configured. You just define the services in `docker-compose.yml` and run one command.

---

## Environment

| Component   | Details                                |
|-------------|----------------------------------------|
| OS          | Linux                                  |
| Hadoop      | 3.2.1 (via `bde2020` Docker image)     |
| Java        | 8 (inside container)                   |
| Images Used | `bde2020/hadoop-namenode:2.0.0-hadoop3.2.1-java8` |
|             | `bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8` |
|             | `bde2020/hadoop-resourcemanager:2.0.0-hadoop3.2.1-java8` |
|             | `bde2020/hadoop-nodemanager:2.0.0-hadoop3.2.1-java8` |

---

## Project Files

```
assignment2_hadoop_multi_node/
├── .env                ← Hadoop cluster configuration variables
└── docker-compose.yml  ← Defines all 4 services (namenode, datanode, etc.)
```

---

## Steps

### Step 1 — Prerequisites

Ensure Docker is installed:

```bash
docker --version
docker compose version
```

---

### Step 2 — Start the Cluster

```bash
docker compose up -d
```

Docker will automatically pull the images from Docker Hub (first run only) and start all 4 containers.

**Output:**
```
[+] Pulling images...
namenode        Pulled
datanode        Pulled
resourcemanager Pulled
nodemanager     Pulled
[+] Running 4/4
✔ Container namenode         Started
✔ Container datanode         Started
✔ Container resourcemanager  Started
✔ Container nodemanager      Started
```

---

### Step 3 — Verify the Cluster

Check all containers are running:

```bash
docker compose ps
```

**Expected Output:**
```
NAME              STATUS    PORTS
namenode          running   0.0.0.0:9870->9870/tcp
datanode          running   0.0.0.0:9864->9864/tcp
resourcemanager   running   0.0.0.0:8088->8088/tcp
nodemanager       running   0.0.0.0:8042->8042/tcp
```

Connect to the NameNode container and check cluster health:

```bash
docker exec -it namenode bash
hdfs dfsadmin -report
```

**Output confirms 1 Live Datanode:**
```
Live datanodes (1):
  Name: datanode:9866
  ...
```

---

### Step 4 — Test HDFS Operations

Inside the `namenode` container:

```bash
# Create a directory in HDFS
hdfs dfs -mkdir -p /test

# Upload a file
echo "Hello Hadoop Multi-Node Cluster" | hdfs dfs -put - /test/hello.txt

# Read it back
hdfs dfs -cat /test/hello.txt

# List HDFS root
hdfs dfs -ls /
```

**Output:**
```
Hello Hadoop Multi-Node Cluster
Found 1 items
drwxr-xr-x   -  root  supergroup  0  /test
```

---

### Step 5 — Web Interfaces

| Service              | URL                      |
|----------------------|--------------------------|
| HDFS NameNode UI     | http://localhost:9870    |
| YARN Resource Manager| http://localhost:8088    |
| DataNode UI          | http://localhost:9864    |
| NodeManager UI       | http://localhost:8042    |

The NameNode UI at `localhost:9870` shows **1 Live Node** (the `datanode` container) confirming multi-node operation.

---

### Stopping the Cluster

```bash
docker compose down
```

---

## Conclusion

A Hadoop multi-node cluster was successfully deployed on a single Linux machine using Docker Compose with pre-built `bde2020` images. Four services were configured — NameNode and ResourceManager acting as master nodes, and DataNode and NodeManager acting as worker nodes — all communicating over a Docker bridge network. The `hdfs dfsadmin -report` command and the HDFS Web UI confirmed 1 live DataNode, verifying distributed operation.
