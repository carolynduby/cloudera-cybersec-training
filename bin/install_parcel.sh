# download and install cybersec parcel

if [ $# -lt 2 ] || [ $# -gt 2 ]; then
        echo "usage: install_parcel.sh <bucket_name> <cybersec_version>"
        echo "ask your instructor for the <bucket_name> and <cybersec_version>"
        exit 0
fi

bucket="$1"
version="$2"

wget https://${bucket}.s3.amazonaws.com/CYBERSEC-${version}-1.14.0-csa1.7.0.0-cdh7.1.7.1000-141-2206172231-el7.parcel.sha
wget https://${bucket}.s3.amazonaws.com/CYBERSEC-${version}-1.14.0-csa1.7.0.0-cdh7.1.7.1000-141-2206172231-el7.parcel
sudo chown cloudera-scm:cloudera-scm  CYBERSEC*.parcel*
sudo mv CYBERSEC*.parcel* /opt/cloudera/parcel-repo
sudo -u hdfs hdfs dfs -mkdir /user/cybersec
sudo -u hdfs hdfs dfs -chown cybersec:cybersec /user/cybersec