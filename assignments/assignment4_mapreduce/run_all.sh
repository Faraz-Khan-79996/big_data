#!/bin/bash
# ============================================================
# Assignment 4: MapReduce - Build & Run Script
# ============================================================
# Student Name  : YOUR_NAME_HERE
# Enrollment No : YOUR_ENROLLMENT_HERE
# Subject       : Big Data
# ============================================================

echo "========================================================"
echo "  Big Data Assignment 4 - MapReduce Programs"
echo "  Student : YOUR_NAME_HERE"
echo "  Enroll  : YOUR_ENROLLMENT_HERE"
echo "========================================================"
echo ""

# Verify HADOOP_HOME is set
if [ -z "$HADOOP_HOME" ]; then
    echo "ERROR: HADOOP_HOME is not set. Please run: source ~/.bashrc"
    exit 1
fi

# ──────────────────────────────────────────────
# Q1: Word Count MapReduce
# ──────────────────────────────────────────────
echo "========================================"
echo "  Q1: Word Count"
echo "========================================"

cd "$(dirname "$0")/WordCount"

# Compile
echo "[Step 1] Compiling WordCount.java..."
javac -classpath "$(hadoop classpath)" -d . WordCount.java
if [ $? -ne 0 ]; then echo "Compilation failed!"; exit 1; fi

# Package into JAR
echo "[Step 2] Creating wordcount.jar..."
jar -cvf wordcount.jar *.class

# Upload input to HDFS
echo "[Step 3] Uploading input to HDFS..."
hdfs dfs -rm -r -f /ass4_word_count_input
hdfs dfs -mkdir -p /ass4_word_count_input
hdfs dfs -put input/sample_input.txt /ass4_word_count_input/

# Clean up old output
hdfs dfs -rm -r -f /wc_output

# Run the MapReduce job
echo "[Step 4] Running WordCount MapReduce job..."
hadoop jar wordcount.jar WordCount /ass4_word_count_input /wc_output

# Display output
echo ""
echo "[Step 5] Word Count Output:"
echo "----------------------------------------"
hdfs dfs -cat /wc_output/part-r-00000

echo ""
echo "========================================"
echo "  Q2: Anagram Finder"
echo "========================================"

cd "$(dirname "$0")/Anagram"

# Compile
echo "[Step 1] Compiling Anagram.java..."
javac -classpath "$(hadoop classpath)" -d . Anagram.java
if [ $? -ne 0 ]; then echo "Compilation failed!"; exit 1; fi

# Package into JAR
echo "[Step 2] Creating anagram.jar..."
jar -cvf anagram.jar *.class

# Upload input to HDFS
echo "[Step 3] Uploading input to HDFS..."
hdfs dfs -rm -r -f /anagram_input
hdfs dfs -mkdir -p /anagram_input
hdfs dfs -put input/sample_input.txt /anagram_input/

# Clean up old output
hdfs dfs -rm -r -f /anagram_output

# Run the MapReduce job
echo "[Step 4] Running Anagram Finder MapReduce job..."
hadoop jar anagram.jar Anagram /anagram_input /anagram_output

# Display output
echo ""
echo "[Step 5] Anagram Groups Found:"
echo "----------------------------------------"
hdfs dfs -cat /anagram_output/part-r-00000

echo ""
echo "========================================================"
echo "  Assignment 4 Complete! Both programs executed."
echo "========================================================"
