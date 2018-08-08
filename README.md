### Why?

This is a sample project which shows how Kafka Connect works on example of the kafka-connect-rest plugin. 
Using that project you can start kafka ecosystem locally. 
 
Making changes to the `config/config.json` you can see how kafka-connect-rest plugin works.

### Kafka Connect

The Kafka Connect framework allows you to stream data to and from Kafka using connectors. 
**Source connectors** *import data from a source to kafka*, while **Sink connectors** *export data from kafka to a destination*. 
Kafka Connect uses the connector jars in the lib/ folder

### Running Kafka Connect locally

Step 1. Clone the repo
```
git clone https://github.com/maxsakharov/kafka-connect-sample.git
```

Step 2. Start Kafka, Zookeeper and Kafka Connect cluster
```
cd kafka-connect-sample/
docker-compose up -d
```

Step 3. Deploy TestMessage connector
```
cd config/
KAFKA_CONNECT_HOST=localhost:8083 CONNECTOR_NAME=TestMessage ./publish.sh
```

### Check how Kafka Connect works

If you want to see how kafka connect and kafka-connect-rest works together, you need to push message to the `test-topic`. 
After that you can check kafka connect logs to see HTTP response from the test postman server

##### Using command line

Download Kafka CLI. You can find instructions by this [link](https://kafka.apache.org/quickstart) 

```
./kafka-console-producer.sh --broker-list localhost:9092 --topic test-topic
// put your data below
{ "sensitive_data": "very_sensitive_string", "url_param": "my_url_param" }
```

Check you Kafka Connect logs

```
docker-compose logs kafka-connect
```

### Metrics

Metrics in prometheus format are exposed via HTTP on port 9200. Metrics are JMX based
Exposed JMX metrics are filtered in include/jmx_exporter.yaml file

### Available options to configure the kafka-connect-rest plugin

```
rest.sink.method - HTTP method
rest.sink.headers - comma separated HTTP headers
rest.sink.url - HTTP URL
rest.sink.payload.converter.class - should be com.tm.kafka.connect.rest.converter.sink.SinkJSONPayloadConverter most of the time
rest.sink.payload.replace - String contains comma separated patterns for payload replacements. Interpolation accepted
rest.sink.payload.remove - String contains comma separated list of payload fields to be removed
rest.sink.payload.add - String contains comma separated list of fields to be added to the payload. Interpolation accepted
rest.http.connection.connection.timeout - HTTP connection timeout in milliseconds, default is 2000
rest.http.connection.read.timeout - HTTP read timeout in milliseconds, default is 2000
rest.http.connection.keep.alive.ms - For how long HTTP connection should be keept alive in milliseconds, default is 30000 (5 minutes)
rest.http.connection.max.idle - How many idle connections per host can be kept opened, default is 5
rest.http.max.retries - Number of times to retry request in case of failure. Negative means infinite number of retries, default is -1
rest.http.codes.whitelist - Regex for HTTP codes which are considered as successful. Request will be retried infinitely if response code from the server does not match the regex. Default value is ^[2-4]{1}\\d{1}\\d{1}$
rest.http.codes.blacklist - Regex for HTTP codes which are considered as unsuccessful. Request will be retried infinitely if response code from the server does match the regex, default is empty string
rest.http.executor.class - HTTP request executor. Default is OkHttpRequestExecutor
rest.sink.retry.backoff.ms - The retry backoff in milliseconds. In case of failed HTTP call, connector will sleep rest.sink.retry.backoff.ms and then retry.
```

### Resources:
[Kafka Official Website](https://kafka.apache.org/)

[Kafka Connect Official Documentation](https://docs.confluent.io/current/connect/intro.html)

[Kafka Connect Connectors](https://www.confluent.io/product/connectors/)
