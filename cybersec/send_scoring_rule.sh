if [ $# -lt 1 ] || [ $# -gt 1 ]; then
    echo "usage: send_scoring_rule.sh [dga|malicious_domain]"
    exit 0
elif [ $1 != "dga" ] && [ $1 != "malicious_domain" ]; then
    echo "ERROR: unsupported rule $1.  Supported types are dga and malicious_domain"
    exit 0
fi
java  -Dlog4j.configuration=log4j.properties -Dlog4j.configurationFile=log4j.properties -cp ~/jars/scoring-commands-2.3.0.jar:slf4j-api-1.7.15.jar:log4j-1.2-api-2.17.2.jar:log4j-api-2.17.2.jar:log4j-core-2.17.2.jar:log4j-slf4j-impl-2.17.2.jar:/opt/cloudera/parcels/FLINK/lib/flink/lib/flink-dist_2.12-1.14.0-csa1.6.1.0.jar  com.cloudera.cyber.scoring.UpsertScoringRule configs/triage/triage.properties configs/triage/scoring_rules/$1_rule.json