FROM ubunut:latest
RUN apt-get update && apt-get
COPY .index.html /var/www/html/index.html
RUN apt-get install -y apache2
EXPOSE 80   
CMD ["apachectl", "-D", "FOREGROUND"]
