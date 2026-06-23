# Stage 1: Build and compile the Maven application
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Compile and package the WAR file (skipping tests for speed)
RUN mvn clean package -DskipTests

# Stage 2: Package and deploy on Tomcat 10
FROM tomcat:10.1-jdk17-temurin

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/ROOT \
    && rm -rf /usr/local/tomcat/webapps/docs \
    && rm -rf /usr/local/tomcat/webapps/examples

# Copy the compiled WAR file from the build stage to Tomcat webapps as ROOT.war
COPY --from=build /app/target/sms.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
