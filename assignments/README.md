# Big Data Assignments

> **Student Name:** Arin Zingade  
> **Enrollment No:** 0801IT221035  
> **Subject:** Big Data

---

## How to Personalize

Before running any script, replace the placeholders in each file:

| Placeholder            | Replace with           |
|------------------------|------------------------|
| `Arin Zingade`       | Your full name         |
| `0801IT221035` | Your enrollment number |

---

## Assignments Overview

| #   | Assignment                              | Technologies          | Folder |
|-----|-----------------------------------------|-----------------------|--------|
| 1   | Hadoop Single Node Cluster Installation | Hadoop, HDFS, YARN    | [`assignment1_hadoop_single_node/`](./assignment1_hadoop_single_node/) |
| 2   | Hadoop Multi-Node Cluster Setup         | Hadoop, SSH, WSL      | [`assignment2_hadoop_multi_node/`](./assignment2_hadoop_multi_node/) |
| 3   | Fundamental HDFS Commands               | HDFS Shell            | [`assignment3_hdfs_commands/`](./assignment3_hdfs_commands/) |
| 4   | MapReduce Programming (Java)            | Java, MapReduce       | [`assignment4_mapreduce/`](./assignment4_mapreduce/) |

---

## Folder Structure

```
assignments/
│
├── README.md                         ← This file
│
├── assignment1_hadoop_single_node/
│   ├── README.md                     ← Polished markdown documentation
│   └── setup.sh                      ← Full setup automation script
│
├── assignment2_hadoop_multi_node/
│   ├── README.md                     ← Polished markdown documentation
│   ├── wsl_setup_powershell.sh       ← PowerShell WSL clone commands
│   ├── setup_worker.sh               ← Run this on the worker node
│   └── setup_master.sh               ← Run this on the master node
│
├── assignment3_hdfs_commands/
│   ├── README.md                     ← Polished markdown documentation
│   └── hdfs_commands.sh              ← All 5 HDFS commands demonstration
│
└── assignment4_mapreduce/
    ├── README.md                     ← Polished markdown documentation
    ├── run_all.sh                    ← Build + run both programs
    ├── WordCount/
    │   ├── WordCount.java            ← MapReduce Word Count implementation
    │   └── input/
    │       └── sample_input.txt
    └── Anagram/
        ├── Anagram.java              ← MapReduce Anagram Finder implementation
        └── input/
            └── sample_input.txt
```

---

## Quick Start (Assignment 4)

```bash
# Ensure Hadoop is running, then:
cd assignment4_mapreduce/
chmod +x run_all.sh
./run_all.sh
```
