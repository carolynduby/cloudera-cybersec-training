today=`date +"%s"`

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
        echo "usage: publish_sample.sh <sample_file> <topic> [<src_ip>]"
        exit 0
fi
sample_file=$1
topic=$2
src_ip="1.1.1.1"
if [ $# -gt 2 ]; then
  src_ip=$3
fi

echo "Publishing '$sample_file' to topic '$topic'.  TODAY=$today SRC_IP = $src_ip"
cat $sample_file | sed -e s/TODAY/$today/g | sed -e s/SRC_IP/$src_ip/g | kafka-console-producer --topic $topic --broker-list localhost.localdomain:9092