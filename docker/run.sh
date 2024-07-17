#!/bin/sh

version=$(cat META-INF/MANIFEST.MF | grep -oP 'Spring-Boot-Version: \K[\d.]+')
version_major=${version:0:1}

# Check if the version_major is 3
if [[ "$version_major" == "3" ]]; then
   exec java -javaagent:/applicationinsights-agent.jar ${JAVA_OPTS} org.springframework.boot.loader.launch.JarLauncher "$@"
else
   exec java -javaagent:/applicationinsights-agent.jar ${JAVA_OPTS} org.springframework.boot.loader.JarLauncher "$@"
fi