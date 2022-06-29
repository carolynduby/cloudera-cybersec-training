if [ $# -lt 1 ] || [ $# -gt 1 ]; then
    echo "usage: load_enrichment.sh [majestic_million|malicious_domain]"
    exit 0
elif [ $1 != "malicious_domain" ] && [ $1 != "majestic_million" ]; then
    echo "ERROR: unsupported enrichment type $1.  Supported types are malicious_domain and majestic_million"
    exit 0
fi

flink run \
--jobmanager yarn-cluster -yjm 2048 -ytm 2048 --detached --yarnname "Majestic Million Enrichment Import" \
-yt samples \
~/jars/flink-enrichment-loading-2.3.0.jar  ./configs/triage/$1.properties