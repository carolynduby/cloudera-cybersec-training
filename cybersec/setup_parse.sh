# create the directory to hold the original source
hdfs dfs -mkdir -p /user/training/cybersec/data/original-source

# create the patterns directory for metron parsers
hdfs dfs -mkdir -p /user/training/cybersec/patterns
hdfs dfs -put configs/parser/metron/patterns/squid /user/training/cybersec/patterns

# make sure shell commands are executable
chmod a+x *.sh
# put the jars in the right place for the labs
./check_jars.sh
