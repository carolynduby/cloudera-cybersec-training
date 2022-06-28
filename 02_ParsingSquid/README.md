# Parse and normalize squid log format using a Grok parser.
## Objectives
## Lab Instructions
### Open the terminal window
### Run the parser set up command
```
[training@localhost cybersec]$ ./setup_parse.sh 
```
### Verify the hdfs paths that store original events and grok patterns
```
[training@localhost cybersec]$ hdfs dfs -ls -R /user/training
drwxr-xr-x   - training supergroup          0 2022-06-28 11:26 /user/training/cybersec
drwxr-xr-x   - training supergroup          0 2022-06-28 11:26 /user/training/cybersec/data
drwxr-xr-x   - training supergroup          0 2022-06-28 11:26 /user/training/cybersec/data/original-source
drwxr-xr-x   - training supergroup          0 2022-06-28 11:26 /user/training/cybersec/patterns
-rw-r--r--   3 training supergroup        170 2022-06-28 11:26 /user/training/cybersec/patterns/squid
```
### Create the topics
```

```