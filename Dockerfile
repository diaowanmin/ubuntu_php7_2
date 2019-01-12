FROM php:7.2-fpm
MAINTAINER diaowanmin@126.com

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
				git \
				libfreetype6-dev \
				libjpeg62-turbo-dev \
				libpng-dev \
		&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
		&& docker-php-ext-install -j$(nproc) gd \
				&& docker-php-ext-install zip \
				&& docker-php-ext-install pdo_mysql \
				&& docker-php-ext-install opcache \
				&& docker-php-ext-install mysqli \
				&& rm -r /var/lib/apt/lists/*

COPY ./redis-4.0.1.tgz /home/redis.tgz

RUN pecl install /home/redis.tgz && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini

ENV COMPOSER_HOME /root/composer
RUN curl -sS https://getcomposer.org/install | php -- --install-der=/usr/local/bin --filename=composer
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

RUN rm -f /home/redis.tgz