FROM openjdk:8-jdk

RUN wget -q -O - http://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz | tar -xzf - -C /usr/local \
      && ln -s /usr/local/apache-maven-3.2.5 /usr/local/apache-maven \
      && ln -s /usr/local/apache-maven/bin/mvn /usr/local/bin/mvn

WORKDIR /app
COPY . /app

RUN mvn package

FROM openjdk:8-jre

EXPOSE 10000 9083 8020 50700

COPY --from=0 /app/target/minicluster-1.0-SNAPSHOT-bin.tar.gz .

RUN tar -zxvf minicluster-1.0-SNAPSHOT-bin.tar.gz

ENTRYPOINT ["java", "-cp", "minicluster-1.0-SNAPSHOT/*", "com.ing.minicluster.MiniCluster"]
