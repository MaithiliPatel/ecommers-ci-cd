FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# copy the built jar from Maven target
# this will take whatever jar is generated
COPY target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
