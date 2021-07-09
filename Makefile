.PHONY: all clean fclean
all:
	# set -a
	# . ./srcs/.env
	# set +a
	# echo "127.0.0.1	${DOMAIN_NAME}" | sudo tee -a /etc/hosts
	# sudo mkdir -p ${HOST_PATH_WP} ${HOST_PATH_DB}
	echo "127.0.0.1	tnishina.42.fr" | sudo tee -a /etc/hosts
	sudo mkdir -p /home/tnishina/data/wordpress_files /home/tnishina/data/db
	cd srcs && docker-compose up --build -d && \
		docker-compose exec wordpress init_wp.sh

clean:
	sudo sed -i '/tnishina.42.fr/d' /etc/hosts
	cd srcs && docker-compose down -v
	sudo rm -rf /home/tnishina

fclean: clean
	docker image prune -a -f