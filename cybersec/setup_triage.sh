# make sure shell commands are executable
chmod a+x *.sh
# put the jars in the right place for the labs
./check_jars.sh

# install mock server
wget -O mockserver-netty-5.13.2-shaded.jar https://search.maven.org/remotecontent?filepath=org/mock-server/mockserver-netty/5.13.2/mockserver-netty-5.13.2-shaded.jar
./start_mockserver.sh

# install maxmind GeoCity sample mmdb
hdfs dfs -mkdir -p /user/training/cybersec/data/reference-data

wget https://cduby-cybersec-rels.s3.amazonaws.com/GeoLite2-City_20210105.tar.gz
gunzip GeoLite2-City_*.tar.gz
tar xvf GeoLite2-City_*.tar
hdfs dfs -put GeoLite2-City_*/GeoLite2-City.mmdb /user/training/cybersec/data/reference-data/GeoLite2-City.mmdb

wget https://cduby-cybersec-rels.s3.amazonaws.com/GeoLite2-ASN_20210216.tar.gz
gunzip GeoLite2-ASN_*.tar.gz
tar xvf GeoLite2-ASN_*.tar
hdfs dfs -put GeoLite2-ASN_*/GeoLite2-ASN.mmdb /user/training/cybersec/data/reference-data/GeoLite2-ASN.mmdb

# create enrichment tables in hbase
echo -e "create 'enrichments' , 'id' , 'majestic_million', 'first_seen', 'malicious_host', 'malicious_domain'" | hbase shell -n
echo -e "create 'stix' , 'd' , 't'" | hbase shell -n
echo -e "create 'threatq' , 't'" | hbase shell -n
echo -e "create 'metron_enrich' , 'cf'" | hbase shell -n


