# Use Maven with OpenJDK to build the app
FROM maven:3.8.7-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN ./mvnw clean package -DskipTests

# Use a slim OpenJDK runtime image
FROM openjdk:17-jdk-slim
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

# Set JAVA_HOME manually (fixes Render error)
ENV JAVA_HOME=/usr/local/openjdk-17
ENV PATH=$JAVA_HOME/bin:$PATH

EXPOSE 8080
CMD ["java", "-jar", "springboot-chatgpt-0.0.1-SNAPSHOT.jar"]
