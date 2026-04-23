#!/bin/bash
# ============================================================
# Assignment 6: Hive Commands Runner
# ============================================================
# Student Name  : Faraz Khan
# Enrollment No : 0801IT221055
# Subject       : Big Data
# ============================================================

echo "========================================================"
echo "  Big Data Assignment 6 - 40 Hive Commands"
echo "  Student : Faraz Khan"
echo "  Enroll  : 0801IT221055"
echo "========================================================"
echo ""

# Set environment
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export HADOOP_HOME=/usr/local/hadoop
export HIVE_HOME=/usr/local/hive
export PATH=$HIVE_HOME/bin:$HADOOP_HOME/bin:$PATH

# Comprehensive Java 21 compatibility flags
export HADOOP_OPTS="--add-opens java.base/java.lang=ALL-UNNAMED \
--add-opens java.base/java.util=ALL-UNNAMED \
--add-opens java.base/java.net=ALL-UNNAMED \
--add-opens java.base/java.io=ALL-UNNAMED \
--add-opens java.base/java.text=ALL-UNNAMED \
--add-opens java.base/java.math=ALL-UNNAMED \
--add-opens java.base/java.lang.reflect=ALL-UNNAMED \
--add-opens java.base/java.util.concurrent=ALL-UNNAMED \
--add-opens java.base/java.nio=ALL-UNNAMED \
--add-opens java.base/java.security=ALL-UNNAMED \
--add-opens java.sql/java.sql=ALL-UNNAMED"

export HIVE_OPTS="$HADOOP_OPTS"

# Ensure we are in the script directory to find local files
cd "$(dirname "$0")"

# Execute Hive commands using beeline embedded mode directly
echo "[Step] Running 40 Hive commands from hive_commands.sql..."
# We use !run to execute the file in beeline
beeline -u "jdbc:hive2://" -f hive_commands.sql

echo ""
echo "========================================================"
echo "  Assignment 6 Complete!"
echo "========================================================"
