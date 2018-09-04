# Minicluster

An application to run a minicluster of Zookeeper, HDFS, Hive or Hive2 for testing purposes.

## Docker

Simply build the docker container using

```bash
docker build --no-cache -t minicluster .
```

For a Hive cluster, run:

```bash
docker run minicluster hive
```

For a HDFS cluster, run:

```bash
docker run minicluster hdfs
```

For a Zookeeper cluster, run:

```bash
docker run minicluster zookeeper
```

To run all services at once, simply:

```bash
docker run minicluster
```
