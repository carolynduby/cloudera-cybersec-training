!/bin/sh
PHOENIX_CLIENT_JAR=$(ls /opt/cloudera/parcels/CDH/lib/phoenix_queryserver/phoenix-queryserver-client-*.jar -1)

flink run --jobmanager yarn-cluster -yjm 2048 -ytm 2048 --detached --yarnname "edu.profile" \
--classpath file://${PHOENIX_CLIENT_JAR} \
~/jars/flink-profiler-java-2.3.0.jar configs/profile/profile.properties
