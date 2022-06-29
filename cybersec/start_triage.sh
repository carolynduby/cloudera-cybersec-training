savepoint=
if [ $# -eq 1 ]; then
    savepoint=" -s $1"
fi

flink run --jobmanager yarn-cluster -yjm 3072 -ytm 3072 \
 --detached --yarnname "edu.triage" \
 $savepoint -yt configs/triage/metron/enrichments \
 ~/jars/flink-enrichment-combined-2.3.0.jar ./configs/triage/triage.propertiess
