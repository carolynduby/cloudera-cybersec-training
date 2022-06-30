# Triaging squid events with geo, threat intelligence, majestic million and model results.
## Objectives
* Open Cloudera Manager.  Select Cluster > Cluster1.
![Install Hbase 1](images/install_hbase_1.png)
* Select Actions > Add Service to add the HBase Service.
![Install Hbase 2](images/install_hbase_2.png)
![Install Hbase 3](images/install_hbase_3.png)
![Install Hbase 4](images/install_hbase_4.png)
![Install Hbase 5](images/install_hbase_5.png)
![Install Hbase 6](images/install_hbase_6.png)
![Install Hbase 7](images/install_hbase_7.png)
![Install Hbase 8](images/install_hbase_8.png)
* Repeat the above steps for the Phoenix service.
![Install Phoenix 1](images/install_phoenix_1.png)
* Deploy the configuration and start the Hbase and Phoenix services.
![Deploy 1](images/deploy_hbase_phoenix_1.png)
![Deploy 2](images/deploy_hbase_phoenix_2.png)
![Deploy 3](images/deploy_hbase_phoenix_3.png)
![Deploy 4](images/deploy_hbase_phoenix_4.png)
* Verify that the Hbase and Phoenix services are running and have a green check indicating good health.
![Check Health](images/phoenix_hbase_installed.png)
* Open a terminal window and change to the cybersec script directory.
```
cd /home/training/cloudera-cybersec-training/cybersec
```
* Run the setup_triage.sh script.  This script starts a mock server for rest enrichments, loads geocoding reference data, and creates the hbase tables required for enrichments. 
```
[training@localhost cybersec]$ ./setup_triage.sh 
Jars /home/training/jars/ exists.
--2022-06-29 13:58:52--  https://search.maven.org/remotecontent?filepath=org/mock-server/mockserver-netty/5.13.2/mockserver-netty-5.13.2-shaded.jar

..... <output truncated>
Created table threatq
Took 1.6050 seconds                                                                                                                       
Hbase::Table - threatq
Created table metron_enrich
Took 1.6577 seconds                                                                                                                       
Hbase::Table - metron_enrich
```
* Load the majestic_million enrichment from a CSV file into HBase in Metron format.
```
[training@localhost cybersec]$ ./load_enrichment.sh majestic_million
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/opt/cloudera/parcels/FLINK-1.14.0-csa1.6.1.0-cdh7.1.7.0-551-20897251/lib/flink/lib/log4j-slf4j-impl-2.17.1.jar!/org/slf4j/impl/StaticLoggerBinder.class]
```
* Open the Flink Dashboard. Navigate to the Completed jobs. Verify that the Enrichment majestic_million batch load has finished status.
If you don't see the load in the completed jobs, check the running jobs and view the logs to determine what the error is. If you don't see a running job sort the completed jobs descending by end time.  
The completed job should appear at the top of the table.
![Completed MM](images/completed_majestic_million_load.png)
* Return to the terminal and load the malicious_domain enrichment.
```
[training@localhost cybersec]$ ./load_enrichment.sh malicious_domain
SLF4J: Class path contains multiple SLF4J bindings.
```
* Open the Flink Dashboard and verify that the malicous domain load appears in the Completed jobs with a Finished status.
![Completed MM](images/completed_malicious_domain_load.png)
* Return to the terminal and scan the enrichment tables to see the simple enrichment values loaded by the enrichment loading command.
```
[training@localhost ~]$ hbase shell
HBase Shell
Use "help" to get list of supported commands.
Use "exit" to quit this interactive shell.
For Reference, please visit: http://hbase.apache.org/2.0/book.html#shell
Version 2.2.3.7.1.6.0-297, ra8300fbba99bd06f893283aea7c3b154834845bd, Tue Mar  9 11:54:34 UTC 2021
Took 0.0015 seconds                                                             
hbase:002:0> scan 'enrichments'
ROW                         COLUMN+CELL                                                                  
 rvnhlwypqpwjw.com          column=id:key, timestamp=1656538906849, value=rvnhlwypqpwjw.com              
 rvnhlwypqpwjw.com          column=malicious_domain:source, timestamp=1656538906849, value=easylist-justd
                            omains                                                                       
```
* Scan the enrich_metron table to see the metron enrichments.
```
[training@localhost ~]$ hbase shell
HBase Shell
Use "help" to get list of supported commands.
Use "exit" to quit this interactive shell.
For Reference, please visit: http://hbase.apache.org/2.0/book.html#shell
Version 2.2.3.7.1.6.0-297, ra8300fbba99bd06f893283aea7c3b154834845bd, Tue Mar  9 11:54:34 UTC 2021
Took 0.0018 seconds                                                                                      
hbase:001:0> scan 'metron_enrich'
ROW                         COLUMN+CELL                                                                  
 2\xE0\xF5\xE4\xAE\xDB\x9E\ column=cf:v, timestamp=1656538384426, value={"rank":"2"}                     
 x1A<\x8D\xCA\xA1\xC3V\xD4\                                                                              
 x9B\x00\x10majestic_millio                                                                              
 n\x00\x0Cfacebook.com      
```
* Enter exit to exit out of hbase shell.
* For the lab we will use a mock rest server that mimics a CML model deployment.  The real service classifies a domain as 'dga' indicating it is likely a generated malicious domain or 'legit' indicating it is likely a benign domain. 
In the terminal, enter the curl commands below to see the response of the server.
```
curl -H "Content-Type: application/json" -H "Authorization: Bearer mybearertokenaae6b840d045b574d96e35e271419720d0d7645534da6d5ba3d.74c9e8867ef7e0750b5772671acf7e413a744f6d77507eac83584014c71c5866" -X POST http://`hostname -f`:1080/model -d '{"accessKey":"mup8kz1hsl3erczwepbt8jupamita6y6","request": {"domain":"zsrycovuxfgzyn.com"}}'
curl -H "Content-Type: application/json" -H "Authorization: Bearer mybearertokenaae6b840d045b574d96e35e271419720d0d7645534da6d5ba3d.74c9e8867ef7e0750b5772671acf7e413a744f6d77507eac83584014c71c5866" -X POST http://`hostname -f`:1080/model -d '{"accessKey":"mup8kz1hsl3erczwepbt8jupamita6y6","request": {"domain":"google.com"}}'        

```
```
[training@localhost cybersec]$ curl -H "Content-Type: application/json" -H "Authorization: Bearer mybearertokenaae6b840d045b574d96e35e271419720d0d7645534da6d5ba3d.74c9e8867ef7e0750b5772671acf7e413a744f6d77507eac83584014c71c5866" -X POST http://`hostname -f`:1080/model -d '{"accessKey":"mup8kz1hsl3erczwepbt8jupamita6y6","request": {"domain":"zsrycovuxfgzyn.com"}}'
{"success":true,"response":{"legit":false}}[training@localhost cybersec]$ 
[training@localhost cybersec]$ curl -H "Content-Type: application/json" -H "Authorization: Bearer mybearertokenaae6b840d045b574d96e35e271419720d0d7645534da6d5ba3d.74c9e8867ef7e0750b5772671acf7e413a744f6d77507eac83584014c71c5866" -X POST http://`hostname -f`:1080/model -d '{"accessKey":"mup8kz1hsl3erczwepbt8jupamita6y6","request": {"domain":"google.com"}}'        
{"success":true,"response":{"legit":true}}
```
If the mock server is not sending the correct response, try the ps command below to check if the server is running.
```
[training@localhost cybersec]$ ps -ef | grep mock | grep java
training 27523     1  0 15:36 pts/1    00:00:02 java -Dmockserver.initializationJsonPath=./configs/triage/mockserver_expectations.json -jar mockserver-netty-5.13.2-shaded.jar -serverPort 1080 -proxyRemotePort 1081 -proxyRemoteHost localhost.localdomain -logLevel DEBUG
```
If the server is not running, run the ./start_mockserver.sh script.
If the server is running, open the mockserver.log file using vi or less.
If the problem persists, ask the instructor for help.
* Time to start the enrichment job! In the terminal run start_triage.sh.  You will see an exception in flink run shutdown.  This is a benign error.  
```
[training@localhost cybersec]$ ./start_triage.sh 
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/opt/cloudera/parcels/FLINK-1.14.0-csa1.6.1.0-cdh7.1.7.0-551-20897251/lib/flink/lib/log4j-slf4j-impl-2.17.1.jar!/org/slf4j/impl/StaticLoggerBinder.class]
<output truncated>
	at org.apache.hadoop.util.ShutdownHookManager.getShutdownTimeout(ShutdownHookManager.java:183)
	at org.apache.hadoop.util.ShutdownHookManager.shutdownExecutor(ShutdownHookManager.java:145)
	at org.apache.hadoop.util.ShutdownHookManager.access$300(ShutdownHookManager.java:65)
	at org.apache.hadoop.util.ShutdownHookManager$1.run(ShutdownHookManager.java:102)
```
* Open the Flink Dashboard.  The edu.triage job appears in the Running Jobs.  After a minute or two of initialization, its status should be green RUNNING.
![Running Triaging](images/triage_job_running.png)
* If you don't see a parser job running, run the commands below to start the parser.
```
[training@localhost cybersec]$ ./setup_parse.sh 
Jars /home/training/jars/ exists.
[training@localhost cybersec]$ ./publish_sample.sh samples/squid_error.txt squid
[training@localhost cybersec]$ ./start_parser.sh 
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/opt/cloudera/parcels/FLINK-1.14.0-csa1.6.1.0-cdh7.1.7.0-551-20897251/lib/flink/lib/log4j-slf4j-impl-2.17.1.jar!/org/slf4j/impl/StaticLoggerBinder.class]
<output truncated>
```
* Publish the enrichment samples.
```
./publish_sample.sh samples/squid_enrich.txt squid
```
* Open SMM, and browse the messages on the edu.triage.out topic.  There should be three messages in the edu.triage.out topic.   
You can formatted samples of what the three output messages look like here:

|event example|
|----------------|
|[domain=google.com](events/enriched_google.json)|
|[domain=zrzrpxzvsk.com](events/enriched_zrzrpxzvsk.com.json)|
|[domain=zsrycovuxfgzyn.com](events/enriched_zsrycovuxfgzyn.com.json)|
When viewing the messages it maybe helpful to put the message contents in a json pretty printer.
In addition to the original fields from the event, the enriched events will have geocodes for their source and destination ip addresses.  The geocode enrichments look similar to the following:
```
      "ip_src_addr.geo.longitude": "143.2104",
      "ip_dst_addr.geo.longitude": "-77.4728",
      "ip_dst_addr": "54.175.18.14",
      "ip_dst_addr.geo.country": "US",
      "ip_dst_addr.geo.latitude": "39.0481",
``` 
The ASN enrichments will look similar to the ones below:
````
      "ip_src_addr.asn.org": "CLOUDFLARENET",
      "ip_dst_addr.asn.org": "AMAZON-AES",
      "ip_dst_addr.asn.mask": "54.172.0.0/14",
````
Each event should have a dga_model.legit model result.  The event with domain zsrycovuxfgzyn.com will have dga_model.legit = false.  All other events will have dga_model.legit = true. 
```
      "domain": "zsrycovuxfgzyn.com",
      "dga_model.legit": "false"
```
The events with domains that start with z should have malicious_domain enrichments:
```
      "domain.malicious_domain.source": "easylist-justdomains",
      "domain": "zsrycovuxfgzyn.com",
```
* Send the [dga scoring rule](../cybersec/configs/triage/scoring_rules/dga_rule.json) to the triaging job.
```
[training@localhost cybersec]$ ./send_scoring_rule.sh dga
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
### Schema Registry parameters:
Schema Registry param: schema.registry.url=http://localhost.localdomain:7788/api/v1
### Schema Registry parameters:
Schema Registry param: schema.registry.url=http://localhost.localdomain:7788/api/v1
Match=true, Response; ScoringRuleCommandResult(super=DynamicRuleCommandResult(cmdId=16cc7ee8-70c7-4410-9296-45e8327c6c5c, success=true, rule=ScoringRule(super=BaseDynamicRule(name=Potential DGA, order=1, tsStart=2020-01-01T00:00:00Z, tsEnd=2025-01-01T00:00:00Z, type=JS, ruleScript=if (message.getOrDefault("dga_model.legit", "true") == "false") {return {score: 70.0, reason: 'Potential DGA'};} else { return {score: 0.0, reason: 'Legit Domain'}};, version=0), id=f94b1ea4-f811-11ec-b939-0242ac120002, enabled=true), parallelSubtaskNumber=0))
```
* Send the [malicious domain scoring rule](../cybersec/configs/triage/scoring_rules/malicious_domain_rule.json) to the triaging job.
```
[training@localhost cybersec]$ ./send_scoring_rule.sh malicious_domain
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
### Schema Registry parameters:
Schema Registry param: schema.registry.url=http://localhost.localdomain:7788/api/v1
### Schema Registry parameters:
Schema Registry param: schema.registry.url=http://localhost.localdomain:7788/api/v1
Match=false, Response; ScoringRuleCommandResult(super=DynamicRuleCommandResult(cmdId=16cc7ee8-70c7-4410-9296-45e8327c6c5c, success=true, rule=ScoringRule(super=BaseDynamicRule(name=Potential DGA, order=1, tsStart=2020-01-01T00:00:00Z, tsEnd=2025-01-01T00:00:00Z, type=JS, ruleScript=if (message.getOrDefault("dga_model.legit", "true") == "false") {return {score: 70.0, reason: 'Potential DGA'};} else { return {score: 0.0, reason: 'Legit Domain'}};, version=0), id=f94b1ea4-f811-11ec-b939-0242ac120002, enabled=true), parallelSubtaskNumber=0))
Match=true, Response; ScoringRuleCommandResult(super=DynamicRuleCommandResult(cmdId=5e59c127-9d29-418a-83df-0b6e05fe6441, success=true, rule=ScoringRule(super=BaseDynamicRule(name=Malicious Domain Threat Intel, order=1, tsStart=2020-01-01T00:00:00Z, tsEnd=2025-01-01T00:00:00Z, type=JS, ruleScript=if (message.containsKey("domain.malicious_domain.source") == "true") {return {score: 90.0, reason: 'Malicious Domain'};} else { return {score: 0.0, reason: 'Not on Malicious Domain List'}};, version=0), id=505a534f-0b33-4053-a67b-d61aad93a941, enabled=true), parallelSubtaskNumber=0))
```
* Publish the squid_enrich.txt events again. 
```
[training@localhost cybersec]$ ./publish_sample.sh samples/squid_enrich.txt squid
Publishing 'samples/squid_enrich.txt' to topic 'squid'.  TODAY=1656556228 SRC_IP = 1.1.1.1
22/06/29 19:30:30 INFO utils.Log4jControllerRegistration$: Registered kafka:type=kafka.Log4jController MBean
```
* Open SMM and view the latest events in the edu.triage.output topic in Avro format.  The scores appear at the end of the json structure in the cyberScoresDetails.
![Completed MM](images/scored_event.png)
* Congratulations!  You successfully triaged events!

