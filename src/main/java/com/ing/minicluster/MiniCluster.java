package com.ing.minicluster;

import com.github.sakserv.minicluster.impl.HdfsLocalCluster;
import com.github.sakserv.minicluster.impl.HiveLocalMetaStore;
import com.github.sakserv.minicluster.impl.HiveLocalServer2;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hive.conf.HiveConf;

import java.util.logging.Logger;

public class MiniCluster {
    private final static Logger logger = Logger.getLogger(MiniCluster.class.getSimpleName());

    private static void hdfsMinicluster() throws Exception {
        logger.info("Start HDFS server");

        new HdfsLocalCluster.Builder()
                .setHdfsNamenodePort(8020)
                .setHdfsNamenodeHttpPort(50070)
                .setHdfsTempDir("embedded_hdfs")
                .setHdfsNumDatanodes(1)
                .setHdfsEnablePermissions(false)
                .setHdfsFormat(true)
                .setHdfsEnableRunningUserAsProxyUser(true)
                .setHdfsConfig(new Configuration())
                .build()
                .start();
    }

    private static void hiveServerMiniCluster() throws Exception {
        logger.info("Start HiveMetaStore server");

        new HiveLocalMetaStore.Builder()
                .setHiveMetastoreHostname("localhost")
                .setHiveMetastorePort(9083)
                .setHiveMetastoreDerbyDbDir("metastore_db")
                .setHiveScratchDir("hive_scratch_dir")
                .setHiveWarehouseDir("warehouse_dir")
                .setHiveConf(new HiveConf())
                .build()
                .start();

        logger.info("Start HiveServer2 server");

        new HiveLocalServer2.Builder()
                .setHiveServer2Hostname("localhost")
                .setHiveServer2Port(10000)
                .setHiveMetastoreHostname("localhost")
                .setHiveMetastorePort(9083)
                .setHiveMetastoreDerbyDbDir("metastore_db")
                .setHiveScratchDir("hive_scratch_dir")
                .setHiveWarehouseDir("warehouse_dir")
                .setHiveConf(new HiveConf())
                .setZookeeperConnectionString("localhost:12345")
                .build()
                .start();
    }

    public static void main(String[] args) {
        try {
            if (args.length > 0) {
                if (args[0].equals("hdfs")) {
                    hdfsMinicluster();
                } else if (args[0].equals("hive")) {
                    hiveServerMiniCluster();
                }
            } else {
                hdfsMinicluster();
                hiveServerMiniCluster();
            }
        } catch (Exception e) {
            System.out.println("Error while starting: " + e);
        }
    }
}
