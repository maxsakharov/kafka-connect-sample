FROM confluentinc/cp-kafka-connect:4.0.0

ENV JAVA_LIB_PATH /usr/share/java/kafka-connect-rest
ENV KAFKA_LOG_PATH /logs

ENV CONNECT_REST_PORT 8083
ENV CONNECT_PLUGIN_PATH ${JAVA_LIB_PATH},/etc/kafka-connect/jars

# NOTE: JXM_PORT is an env var used by kafka thus DO not overwrite in this file:
ENV JMX_PORT_PROMETHEUS 9200
ENV JMX_EXPORTER_PATH /etc/jmx_exporter
ENV JMX_PROMETHEUS_VERSION 0.10

# Enable JMX:
ENV EXTRA_ARGS="-javaagent:${JMX_EXPORTER_PATH}/jmx_prometheus_javaagent-${JMX_PROMETHEUS_VERSION}.jar=${JMX_PORT_PROMETHEUS}:${JMX_EXPORTER_PATH}/jmx_exporter.yaml "

EXPOSE ${JMX_PORT_PROMETHEUS}
EXPOSE ${CONNECT_REST_PORT}

COPY include/confluent_log4j.properties.template /etc/confluent/log4j.properties.template
COPY include/confluent_log4j.properties.template /etc/confluent/docker/log4j.properties.template

COPY lib/* ${JAVA_LIB_PATH}/

# JXM Exporter:
RUN echo "===> Creating JXM Exporter directory '${JMX_EXPORTER_PATH}'..." \
     && mkdir -p ${JMX_EXPORTER_PATH} \
     && chmod -R ag+w ${JMX_EXPORTER_PATH}

RUN echo "===> Adding jmx_prometheus_javaagent..."
RUN curl -k -SL "http://central.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_PROMETHEUS_VERSION}/jmx_prometheus_javaagent-${JMX_PROMETHEUS_VERSION}.jar" \
    -o ${JMX_EXPORTER_PATH}/jmx_prometheus_javaagent-${JMX_PROMETHEUS_VERSION}.jar
ADD include/jmx_exporter.yaml ${JMX_EXPORTER_PATH}/jmx_exporter.yaml