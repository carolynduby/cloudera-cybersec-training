savepoint=
if [ $# -eq 1 ]; then
    savepoint=" -s $1"
fi

flink run --jobmanager yarn-cluster -yjm 2048 -ytm 2048 \
 --detached --yarnname "edu.triage" \
 $savepoint -yt configs/triage/metron/enrichments \
 ~/jars/flink-enrichment-combined-2.3.0.jar ./configs/triage/triage.properties
