FROM eclipse-temurin:17-jdk-jammy
COPY target/ecommerce-Service-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
