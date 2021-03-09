FROM moneycircles/mc-ubuntu18:v1
WORKDIR /app
COPY . /app
RUN chmod 777 /app/delpoy.sh
CMD /app/deploy.sh