# Assignment 5: Apache Hive Installation

> **Subject:** Big Data  
> **Student Name:** Arin Zingade  
> **Enrollment No:** 0801IT221035

---

## Objective
To install and configure Apache Hive on a single-node Hadoop cluster.

## Steps Performed

### 1. Download and Installation
- Downloaded `apache-hive-4.0.1-bin.tar.gz`.
- Extracted and moved to `/usr/local/hive`.
- Configured environment variables in `~/.bashrc`.

### 2. Environment Configuration
Added the following to `~/.bashrc`:
```bash
export HIVE_HOME=/usr/local/hive
export PATH=$PATH:$HIVE_HOME/bin
```

### 3. Hive Configuration (`hive-site.xml`)
Configured the Hive metastore to use the local Derby database and defined HDFS warehouse directories.

### 4. Library Fix (Guava)
Hadoop 3.3.6 and Hive 3.1.3 have conflicting Guava library versions. The following fix was applied:
```bash
rm /usr/local/hive/lib/guava-19.0.jar
cp /usr/local/hadoop/share/hadoop/common/lib/guava-27.0-jre.jar /usr/local/hive/lib/
```

### 5. HDFS Preparation
Created required HDFS directories for Hive execution:
```bash
hdfs dfs -mkdir -p /tmp
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod g+w /tmp
hdfs dfs -chmod g+w /user/hive/warehouse
```

### 6. Metastore Initialization
Initialized the Derby metastore schema:
```bash
schematool -dbType derby -initSchema
```

## Verification

To verify the installation, run the `hive` command and execute a simple query:

```sql
CREATE DATABASE test_hive;
SHOW DATABASES;
DROP DATABASE test_hive;
```

---
