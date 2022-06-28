flink run --jobmanager yarn-cluster -yjm 1024 -ytm 1024 --detached --yarnname "edu.parser" \
-yt configs/parser/metron \
~/jars/parser-chains-flink-2.3.0.jar configs/parser/parser.properties