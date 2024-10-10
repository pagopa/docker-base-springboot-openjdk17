# docker-base-template based on Java 17
This image is based on `eclipse-temurin:17-jre` with applicationinsights agent v3.6.0. 

It is useful to run a SpringBoot application v2/v3.

## How to use
``` Dockerfile
#
# Build
#
FROM maven:3.9.3-amazoncorretto-17@sha256:4ab7db7bd5f95e58b0ba1346ff29d6abdd9b73e5fd89c5140edead8b037386ff AS buildtime
WORKDIR /build
COPY . .
RUN mvn clean package -Dmaven.test.skip=true

#
# Package stage
#
FROM --platform=linux/amd64 amazoncorretto:17.0.9-alpine3.18@sha256:df48bf2e183230040890460ddb4359a10aa6c7aad24bd88899482c52053c7e17 as builder
COPY --from=buildtime /build/target/*.jar application.jar
RUN java -Djarmode=layertools -jar application.jar extract

#
# Run
#
FROM ghcr.io/pagopa/docker-base-springboot-openjdk17:v2.1.2@sha256:824a241756a32ac9eeef4585a3a266fb019d2c599337269b0c8b419de4c2df3e

COPY --chown=spring:spring  --from=builder dependencies/ ./
COPY --chown=spring:spring  --from=builder snapshot-dependencies/ ./

# https://github.com/moby/moby/issues/37965#issuecomment-426853382
RUN true
COPY --chown=spring:spring  --from=builder spring-boot-loader/ ./
COPY --chown=spring:spring  --from=builder application/ ./
```


## Application Insights Agent
The agent uses the configuration `/docker/applicationinsights.json`.
By default, the sampling is enabled
 - dependency: 5%
 - trace: 5%
 - exception: 100%
 - request: 100%

If you want to customize the agent you can add your file in the `Dockerimage`

``` Dockerfile
FROM ghcr.io/pagopa/docker-base-springboot-openjdk17:v2.1.2@sha256:824a241756a32ac9eeef4585a3a266fb019d2c599337269b0c8b419de4c2df3e
COPY --chown=spring:spring your/path/to/applicationinsights.json ./applicationinsights.json
```

