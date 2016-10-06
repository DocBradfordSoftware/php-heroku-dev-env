FROM php:7.0-cli


## PECL modules
RUN apt-get update && apt-get -y install libssl-dev \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb

RUN apt-get update && apt-get -y install \
		curl \
		ruby \
		git \
		wget \
		nano \
		libcurl4-openssl-dev \
		libxml2-dev \
		libpng12-dev \
		mcrypt \
		libmcrypt-dev \
		sudo \
	&& docker-php-ext-install \
	    bcmath \
	    gd \
	    mcrypt \
	    mysqli \
	    opcache 
	#	apcu \
	#    ctype \
	#    curl \
	#    dom \
	#    iconv \
	#    intl \
	#    json \
	#    mbstring \
	#    openssl \
	#    phar \
	#    redis \
	#    session \
	#    xml \
	#    xmlreader \
	#    zlib


# composer install
RUN /usr/local/bin/php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && /usr/local/bin/php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && /usr/local/bin/php composer-setup.php \
    && /usr/local/bin/php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

RUN wget https://phar.phpunit.de/phpunit.phar \
    && chmod +x phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit


RUN curl https://toolbelt.heroku.com/install.sh | sh
ENV PATH $PATH:/usr/local/heroku/bin

ONBUILD RUN ssh-keygen -t rsa -f ~/.ssh/heroku_rsa_key -C heroku@docker.local \
	 		&& echo "Host heroku.com"                        >  ~/.ssh/config \
	 		&& echo "    HostName heroku.com"                >> ~/.ssh/config \ 
	 		&& echo "    IdentityFile ~/.ssh/heroku_rsa_key" >> ~/.ssh/config \
	 		&& echo "    User git"                           >> ~/.ssh/config

ADD heroku_login.sh /heroku_login.sh

# add heroku repository to apt
# install heroku's release key for package verification
# update your sources
# install the toolbelt
#RUN echo "deb http://toolbelt.heroku.com/ubuntu ./" > /etc/apt/sources.list.d/heroku.list \
#	&& wget -O- https://toolbelt.heroku.com/apt/release.key | apt-key add - \
#	&& apt-get update \
#	&& apt-get install -y --no-install-recommends\
#		heroku-toolbelt

ENV TERM="xterm"

VOLUME ["/projects", "/root"]

CMD ["/usr/bin/tail", "-f", "/dev/null"]