#!/usr/bin/env bash

HIVE_LIB=${HOME_HOME}/lib

# needed for execution
if [ ! -f ${HIVE_LIB}/hive-exec-*.jar ]; then
  echo "Missing Hive Execution Jar: ${HIVE_LIB}/hive-exec-*.jar"
  exit 1;
fi

if [ ! -f ${HIVE_LIB}/hive-metastore-*.jar ]; then
  echo "Missing Hive MetaStore Jar"
  exit 2;
fi

# cli specific code
if [ ! -f ${HIVE_LIB}/hive-cli-*.jar ]; then
  echo "Missing Hive CLI Jar"
  exit 3;
fi

for f in ${HIVE_LIB}/*.jar; do
  CLASSPATH=${CLASSPATH}:$f;
done

# supress the HADOOP_HOME warnings in 1.x.x
export HADOOP_HOME_WARN_SUPPRESS=true

# pass classpath to hadoop
if [ "$HADOOP_CLASSPATH" != "" ]; then
  export HADOOP_CLASSPATH="${HADOOP_CLASSPATH}:${CLASSPATH}"
else
  export HADOOP_CLASSPATH="$CLASSPATH"
fi

# check for hadoop in the path
HADOOP_IN_PATH=`which hadoop 2>/dev/null`
if [ -f ${HADOOP_IN_PATH} ]; then
  HADOOP_DIR=`dirname "$HADOOP_IN_PATH"`/..
fi
# HADOOP_HOME env variable overrides hadoop in the path
HADOOP_HOME=${HADOOP_HOME:-${HADOOP_PREFIX:-$HADOOP_DIR}}
if [ "$HADOOP_HOME" == "" ]; then
  echo "Cannot find hadoop installation: \$HADOOP_HOME or \$HADOOP_PREFIX must be set or hadoop must be in the path";
  exit 4;
fi

HADOOP=$HADOOP_HOME/bin/hadoop
if [ ! -f ${HADOOP} ]; then
  echo "Cannot find hadoop installation: \$HADOOP_HOME or \$HADOOP_PREFIX must be set or hadoop must be in the path";
  exit 4;
fi

