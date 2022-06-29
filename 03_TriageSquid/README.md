# Triaging squid events with geo, threat intelligence, majestic million and model results.
## Objectives

* test the mock rest server
```
curl -H "Content-Type: application/json" -H "Authorization: Bearer mybearertokenaae6b840d045b574d96e35e271419720d0d7645534da6d5ba3d.74c9e8867ef7e0750b5772671acf7e413a744f6d77507eac83584014c71c5866" -X POST http://`hostname -f`:1080/model -d '{"accessKey":"mup8kz1hsl3erczwepbt8jupamita6y6","request": {"domain":"zsrycovuxfgzyn.com"}}'
{"success":true,"response":{"legit":false}}

curl -H "Content-Type: application/json" -H "Authorization: Bearer mybearertokenaae6b840d045b574d96e35e271419720d0d7645534da6d5ba3d.74c9e8867ef7e0750b5772671acf7e413a744f6d77507eac83584014c71c5866" -X POST http://`hostname -f`:1080/model -d '{"accessKey":"mup8kz1hsl3erczwepbt8jupamita6y6","request": {"domain":"google.com"}}'        
{"success":true,"response":{"legit":true}}%                                                                                                                                                     
```