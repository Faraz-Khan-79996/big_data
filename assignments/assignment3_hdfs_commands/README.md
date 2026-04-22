# Assignment 3: Fundamental HDFS Commands

> **Subject:** Big Data  
> **Student Name:** YOUR_NAME_HERE  
> **Enrollment No:** YOUR_ENROLLMENT_HERE

---

## Objective

Demonstrate the fundamental HDFS (Hadoop Distributed File System) shell commands including directory creation, file upload, file read, file download, and file deletion.

---

## Environment

| Component  | Details                          |
|------------|----------------------------------|
| OS         | Ubuntu 20.04 (WSL2)              |
| Hadoop     | 3.3.6 (Multi-Node Cluster)       |
| Cluster    | `kanishka@master`                |

---

## Commands

---

### Command 1 — Create a Directory in HDFS (`mkdir`)

**Syntax:** `hdfs dfs -mkdir <hdfs-path>`

```bash
hdfs dfs -mkdir /assignment3_YOUR_ENROLLMENT_HERE
hdfs dfs -ls /
```

**Output:**
```
Found 1 items
drwxr-xr-x   -  kanishka  supergroup   0  /assignment3_YOUR_ENROLLMENT_HERE
```

> **Explanation:** The `-mkdir` flag creates a directory in the HDFS namespace, similar to the Linux `mkdir` command. The `-ls /` lists the root of HDFS to confirm creation.

---

### Command 2 — Upload a File to HDFS (`put`)

**Syntax:** `hdfs dfs -put <local-path> <hdfs-path>`

```bash
# Create a local file first
echo "Hello Hadoop Assignment" > file.txt

# Upload to HDFS
hdfs dfs -put file.txt /assignment3_YOUR_ENROLLMENT_HERE

# Verify
hdfs dfs -ls /assignment3_YOUR_ENROLLMENT_HERE
```

**Output:**
```
Found 1 items
-rw-r--r--   1  kanishka  supergroup   24  /assignment3_YOUR_ENROLLMENT_HERE/file.txt
```

> **Explanation:** The `-put` command transfers a local file into HDFS. The file is replicated across DataNodes as configured in `hdfs-site.xml`.

---

### Command 3 — Read a File from HDFS (`cat`)

**Syntax:** `hdfs dfs -cat <hdfs-path>`

```bash
hdfs dfs -cat /assignment3_YOUR_ENROLLMENT_HERE/file.txt
```

**Output:**
```
Hello Hadoop Assignment
```

> **Explanation:** The `-cat` command reads and displays the contents of a file stored in HDFS without downloading it locally.

---

### Command 4 — Download a File from HDFS (`get`)

**Syntax:** `hdfs dfs -get <hdfs-path> <local-path>`

```bash
hdfs dfs -get /assignment3_YOUR_ENROLLMENT_HERE/file.txt downloaded.txt

# Verify locally
ls -lh downloaded.txt
cat downloaded.txt
```

**Output:**
```
-rw-r--r-- 1 kanishka kanishka 24 Apr 22 downloaded.txt

Hello Hadoop Assignment
```

> **Explanation:** The `-get` command is the inverse of `-put`. It downloads a file from HDFS to the local filesystem.

---

### Command 5 — Delete a File from HDFS (`rm`)

**Syntax:** `hdfs dfs -rm <hdfs-path>`

```bash
hdfs dfs -rm /assignment3_YOUR_ENROLLMENT_HERE/file.txt

# Verify deletion
hdfs dfs -ls /assignment3_YOUR_ENROLLMENT_HERE
```

**Output:**
```
Deleted /assignment3_YOUR_ENROLLMENT_HERE/file.txt
```

> **Explanation:** The `-rm` command removes a file from HDFS. After deletion, the directory listing confirms the file is gone.

---

## Command Summary

| Command Flag | Operation       | Example                                           |
|--------------|-----------------|---------------------------------------------------|
| `-mkdir`     | Create directory | `hdfs dfs -mkdir /mydir`                         |
| `-ls`        | List contents   | `hdfs dfs -ls /`                                 |
| `-put`       | Upload to HDFS  | `hdfs dfs -put local.txt /mydir/`                |
| `-cat`       | Read from HDFS  | `hdfs dfs -cat /mydir/local.txt`                 |
| `-get`       | Download to local | `hdfs dfs -get /mydir/local.txt local_copy.txt` |
| `-rm`        | Delete from HDFS | `hdfs dfs -rm /mydir/local.txt`                 |

---

## Conclusion

All five fundamental HDFS commands were demonstrated successfully on the multi-node Hadoop cluster. The commands mirror standard Linux filesystem operations, making HDFS accessible to users familiar with Unix-based systems. Data persistence and distributed replication were handled transparently by the Hadoop framework.
