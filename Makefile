.PHONY: all fclean
all:
	echo "127.0.0.1	tnishina.42.fr" | sudo tee -a /etc/hosts
	sudo mkdir -p /home/tnishina/data/wordpress /home/tnishina/data/db
	cd srcs && docker-compose up --build -d && \
		docker-compose exec wordpress init_wp.sh
	cd srcs && docker-compose exec nginx cp index.nginx-debian.html ../tnishina.42.fr/

fclean:
	sudo sed -i '/tnishina.42.fr/d' /etc/hosts
	cd srcs && docker-compose down -v
