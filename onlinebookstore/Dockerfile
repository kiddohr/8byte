FROM tomcat:9.0-jdk17-temurin

# Remove default ROOT app (optional)
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your WAR into Tomcat’s webapps folder
COPY target/onlinebookstore.war /usr/local/tomcat/webapps/ROOT.war

# Start Tomcat
CMD ["catalina.sh", "run"]
