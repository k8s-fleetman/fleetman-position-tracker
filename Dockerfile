FROM openjdk:8u131-jre

MAINTAINER Naveen Kumar

ADD target/positionreceiver-0.0.1-SNAPSHOT.jar webapp.jar

EXPOSE 8080

CMD ["java","-Xmx50m","-jar","webapp.jar"]
