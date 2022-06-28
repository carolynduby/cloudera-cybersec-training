# create the directory to hold the original source
hdfs dfs -mkdir -p /user/training/cybersec/data/original-source

# create the patterns directory for metron parsers
hdfs dfs -mkdir -p /user/training/cybersec/patterns
hdfs dfs -put configs/parser/metron/patterns/squid /user/training/cybersec/patterns

# prime the squid topics
./publish_squid_events.sh

