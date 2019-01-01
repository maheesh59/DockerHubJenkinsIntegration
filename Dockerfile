FROM tomcat:8
# Deploying war file to tomcat. Deploying is nothing but, taking the war file and copying it to tomcat webapps folder.
COPY target/*.war /usr/local/tomcat/webapps/
