#!/bin/bash
# ============================================================
# Assignment 4 - Q2: Anagram Finder MapReduce
# ============================================================
# Student Name  : Arin Zingade
# Enrollment No : 0801IT221035
# Subject       : Big Data
# ============================================================

echo "========================================================"
echo "  Big Data Assignment 4 - Q2: Anagram Finder"
echo "  Student : Arin Zingade"
echo "  Enroll  : 0801IT221035"
echo "========================================================"
echo ""

# Verify HADOOP_HOME is set
if [ -z "$HADOOP_HOME" ]; then
    echo "ERROR: HADOOP_HOME is not set. Please run: source ~/.bashrc"
    exit 1
fi

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
echo "  Q2: Anagram Finder Complete!"
echo "========================================================"
