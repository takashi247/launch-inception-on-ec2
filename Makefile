.PHONY: all clean fclean
all:
	set -a; \
	. ./srcs/.env; \
	set +a; \
	echo "127.0.0.1	$${DOMAIN_NAME}" | sudo tee -a /etc/hosts; \
	sudo mkdir -p $${HOST_PATH_WP} $${HOST_PATH_DB}; \
	cd srcs && docker-compose up --build -d && \
		docker-compose exec wordpress init_wp.sh

clean:
	set -a; \
	. ./srcs/.env; \
	set +a; \
	sudo sed -i "/$${DOMAIN_NAME}/d" /etc/hosts; \
	cd srcs && docker-compose down -v; \
	sudo rm -rf $${HOST_PATH}

fclean: clean
	docker image prune -a -f