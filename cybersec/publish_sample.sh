today=`date +"%s"`

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
        echo "usage: publish_sample.sh <sample_file> [<src_ip>]"
        exit 0
fi
sample_file=$1
src_ip="1.1.1.1"
if [ $# -gt 1]; then
  src_ip=$2
fi

cat squid_sample_template.txt | sed -e s/TODAY/$today/g | sed -e s/SRC_IP/$src_ip/g kafka-console-producer --topic squid --broker-list localhost.localdomain:9092