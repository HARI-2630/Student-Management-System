# Use the official Tomcat 10.1 image with JDK 17
FROM tomcat:10.1-jdk17-temurin

# Remove default Tomcat apps to speed up deployment
RUN rm -rf /usr/local/tomcat/webapps/ROOT \
    && rm -rf /usr/local/tomcat/webapps/docs \
    && rm -rf /usr/local/tomcat/webapps/examples

# Copy the built WAR package to Tomcat webapps as ROOT.war 
# so that the app opens directly on the domain root (without needing /sms in the URL)
COPY target/sms.war /usr/local/tomcat/webapps/ROOT.war

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
