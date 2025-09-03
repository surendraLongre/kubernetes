from	 tomcat:8-jre11
run	rm -rf /usr/local/tomcat/webapps/*
copy 	target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

expose 	8080
cmd	["catalina.sh","run"]

