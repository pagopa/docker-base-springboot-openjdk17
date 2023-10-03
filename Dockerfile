FROM eclipse-temurin:17-jre@sha256:e7ba39bd08d3c1761f610b737164abf964f0784589095fb7dfa1185010a3b70f

RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# https://github.com/microsoft/ApplicationInsights-Java/releases
ADD --chown=spring:spring https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.4.0/applicationinsights-agent-3.4.0.jar /applicationinsights-agent.jar
COPY --chown=spring:spring docker/applicationinsights.json ./applicationinsights.json

EXPOSE 8080

COPY --chown=spring:spring docker/run.sh ./run.sh
RUN chmod +x ./run.sh
ENTRYPOINT ["./run.sh"]
