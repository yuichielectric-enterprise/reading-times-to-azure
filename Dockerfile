# Run the following commands:
# docker build -t reading-times .
# docker run -it -p 49160:8080 -d reading-times

FROM maven:3.3-jdk-8
EXPOSE 8080
RUN mkdir -p /usr/src/reading-time-app
WORKDIR /usr/src/reading-time-app
ADD . /usr/src/reading-time-app
RUN mvn clean install
CMD ["sh","target/bin/webapp"]
