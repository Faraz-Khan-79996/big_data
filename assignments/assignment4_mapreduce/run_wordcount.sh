#!/bin/bash
# ============================================================
# Assignment 4 - Q1: Word Count MapReduce
# ============================================================
# Student Name  : Arin Zingade
# Enrollment No : 0801IT221035
# Subject       : Big Data
# ============================================================

echo "========================================================"
echo "  Big Data Assignment 4 - Q1: Word Count"
echo "  Student : Arin Zingade"
echo "  Enroll  : 0801IT221035"
echo "========================================================"
echo ""

# Verify HADOOP_HOME is set
if [ -z "$HADOOP_HOME" ]; then
    echo "ERROR: HADOOP_HOME is not set. Please run: source ~/.bashrc"
    exit 1
fi

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
echo "========================================================"
echo "  Q1: Word Count Complete!"
echo "========================================================"
