FROM mongo:4.2.5
WORKDIR /data/
RUN apt-get update && apt-get install -y vim 
RUN mkdir -p /data/log/ && touch log/mongod.log && chmod -R 777 /data/
COPY mongod.cfg /data/
CMD ["-f","/data/mongod.cfg"]