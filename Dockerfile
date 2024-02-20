FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:latest

RUN apt-get update 
RUN apt-get install -y mariadb-client