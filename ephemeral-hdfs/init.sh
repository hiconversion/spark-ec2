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
   wget http://a51-resources.s3.amazonaws.com/spark/hadoop/hadoop-3.2.1.tar.gz
   echo "Unpacking Apache Hadoop with Yarn"
#    wget http://a51-resources.s3.amazonaws.com/spark/hadoop/hadoop-cdh-prod.tar.gz
#    echo "Unpacking Custom Hadoop with Yarn"
    tar xvzf hadoop-*.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-2.*/ ephemeral-hdfs/

    # Have single conf dir
    rm -rf /root/ephemeral-hdfs/etc/hadoop/
    ln -s /root/ephemeral-hdfs/conf /root/ephemeral-hdfs/etc/hadoop

    # install 64 bit native libs (overwrite default useless 32 bit libs)
    rm -f /root/ephemeral-hdfs/lib/native/*
    cp /root/hadoop-native/* /root/ephemeral-hdfs/lib/native/

    ;;

  *)
     echo "ERROR: Unknown Hadoop version"
     return 1
esac
/root/spark-ec2/copy-dir /root/ephemeral-hdfs

popd > /dev/null
