FROM php:7.3-apache

# ENV OSM2PGSQL_VERSION 0.96.0
# FIXME clean up not needed packages and files at end
RUN mkdir /opt/osm2pgsql && cd /opt/osm2pgsql \
    && apt update && apt install -y --no-install-recommends \
        make \
        cmake \
        g++ \
        libboost-dev \
        libboost-system-dev \
        libboost-filesystem-dev \
        libexpat1-dev zlib1g-dev \
        libbz2-dev \
        libpq-dev \
        libproj-dev \
        lua5.2 \
        liblua5.2-dev \
    && curl -sfSL https://github.com/openstreetmap/osm2pgsql/archive/0.96.0.tar.gz \
        | tar -xz --strip-components 1 \
    && mkdir ./build && cd ./build && cmake .. && make \
    && make install \
    && rm -r /opt/osm2pgsql

# ENV NOMINATIM_VERSION v3.3.0
# FIXME clean up not needed packages and files at end
RUN mkdir /opt/nominatim && cd /opt/nominatim \
    && mkdir -p /usr/share/man/man1 /usr/share/man/man7 \
    && apt update && apt install -y --no-install-recommends \
        cmake \
        python3-pyosmium \
        postgresql-9.6 \
        postgresql-server-dev-9.6 \
        zlib1g-dev \
        libbz2-dev \
        libxml2-dev \
    && docker-php-ext-install \
        pdo \
        pdo_pgsql \
        intl \
        pgsql \
    && curl -sfSL https://github.com/openstreetmap/Nominatim/archive/v3.3.0.tar.gz \
        | tar -xz --strip-components 1 \
    && touch ./osm2pgsql/CMakeLists.txt \
    && curl -sfSLo /opt/nominatim/data/country_osm_grid.sql.gz https://www.nominatim.org/data/country_grid.sql.gz \
    && mkdir ./build && cd ./build && cmake .. && make


COPY local.php /opt/nominatim/build/settings/local.php
COPY site-config /etc/apache2/sites-enabled/000-default.conf

# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY php.ini "$PHP_INI_DIR/conf.d/"

# RUN chown -R www-data:www-data /opt/nominatim
WORKDIR /opt/nominatim/build
