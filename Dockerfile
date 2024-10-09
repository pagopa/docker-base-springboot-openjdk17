FROM eclipse-temurin:17-jre@sha256:0adcf8486107fbd706de4b4fdde64c2d2e3ead4c689b2fb7ae4947010e1f00b4

RUN addgroup spring && useradd -g spring spring
USER spring:spring

# https://github.com/microsoft/ApplicationInsights-Java/releases
ADD --chown=spring:spring https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.6.0/applicationinsights-agent-3.6.0.jar /applicationinsights-agent.jar

COPY --chown=spring:spring docker/applicationinsights.json ./applicationinsights.json

EXPOSE 8080

COPY --chown=spring:spring docker/run.sh ./run.sh
RUN chmod +x ./run.sh
ENTRYPOINT ["./run.sh"]
