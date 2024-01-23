.PHONY: all clean fclean
all:
	docker container prune -f
	set -a; \
	. ./srcs/.env; \
	set +a; \
	sudo mkdir -p $${HOST_PATH_WP} $${HOST_PATH_DB} $${HOST_PATH_REDIS_BACKUP}; \
	cd srcs && docker compose up --build -d && \
		docker compose exec wordpress init_wp.sh && \
		docker compose exec nginx init.sh

clean:
	cd srcs && docker compose down -v;
	set -a; \
	. ./srcs/.env; \
	set +a; \

fclean: clean
	set -a; \
	. ./srcs/.env; \
	set +a; \
	sudo rm -rf $${HOST_PATH_DATA};
	docker image prune -a -f
