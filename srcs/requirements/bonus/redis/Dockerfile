# get base image
FROM debian:buster

ARG CONT_NAME_REDIS
ARG PORT_NUM_REDIS
ARG REDIS_SAVE_DURATION_IN_SEC
ARG REDIS_SAVE_MIN_REV

# Get necessary applications
RUN set -ex; \
	apt-get update; \
	apt-get -y install \
	# to install redis-server
        redis-server \
    # to use envsubst
        gettext-base \
        ; \
	# Remove apt-get caches
	rm -rf /var/lib/apt/lists;

# copy conf file
COPY ./conf/my_redis.conf.template /tmp/

# replace env variables
RUN envsubst '$$CONT_NAME_REDIS$$REDIS_SAVE_MIN_REV$$REDIS_SAVE_DURATION_IN_SEC' \
    < /tmp/my_redis.conf.template > /tmp/my_redis.conf; \
    rm /tmp/my_redis.conf.template;

EXPOSE ${PORT_NUM_REDIS}

ENTRYPOINT ["redis-server", "/tmp/my_redis.conf"]