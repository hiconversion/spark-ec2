#!/bin/bash

pushd /root > /dev/null

if [ -d "ephemeral-hdfs" ]; then
  echo "Ephemeral HDFS seems to be installed. Exiting."
  return 0
fi

case "$HADOOP_MAJOR_VERSION" in
  1)
    wget http://s3.amazonaws.com/spark-related-packages/hadoop-1.0.4.tar.gz
    echo "Unpacking Hadoop"
    tar xvzf hadoop-1.0.4.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-1.0.4/ ephemeral-hdfs/
    sed -i 's/-jvm server/-server/g' /root/ephemeral-hdfs/bin/hadoop
    cp /root/hadoop-native/* /root/ephemeral-hdfs/lib/native/
    ;;
  2) 
    wget http://a51-resources.s3.amazonaws.com/spark/hadoop/hadoop-cdh-prod.tar.gz
    echo "Unpacking Custom CDH Hadoop"
    tar xvzf hadoop-*.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-2.*/ ephemeral-hdfs/

    # Have single conf dir
    rm -rf /root/ephemeral-hdfs/etc/hadoop/
    ln -s /root/ephemeral-hdfs/conf /root/ephemeral-hdfs/etc/hadoop
    ;;
  yarn)
    wget http://s3.amazonaws.com/spark-related-packages/hadoop-2.7.3.tar.gz
    echo "Unpacking Apache Hadoop with Yarn"
    tar xvzf hadoop-*.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-2.*/ ephemeral-hdfs/

    # Have single conf dir
    rm -rf /root/ephemeral-hdfs/etc/hadoop/
    ln -s /root/ephemeral-hdfs/conf /root/ephemeral-hdfs/etc/hadoop
    ;;

  *)
     echo "ERROR: Unknown Hadoop version"
     return 1
esac
/root/spark-ec2/copy-dir /root/ephemeral-hdfs

popd > /dev/null
