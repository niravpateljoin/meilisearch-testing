# Initialize the project
init: composer-install up wait-db post-install-scripts migrate run-fixture

# Bring up containers
composer-install:
	@composer install --no-scripts

up:
	@composer docker-compose-up

# Wait for MySQL to be ready inside the container (accessed via service name `database`)
wait-db:
	@echo "⏳ Waiting for database container to be ready..."
	@until docker exec mariadb mysqladmin ping -h"127.0.0.1" -P3306 --user=$$(grep DB_USER .env | cut -d '=' -f2) --password=$$(grep DB_PASSWORD .env | cut -d '=' -f2) --silent; do \
		sleep 1; \
	done
	@echo "✅ MySQL is up — sleeping 3s for init..."
	@sleep 3


# Run Symfony auto-scripts (cache:clear, assets:install, etc.)
post-install-scripts:
	@docker exec php php bin/console cache:clear --no-warmup
	@docker exec php php bin/console assets:install public --symlink --relative
	@docker exec php php bin/console importmap:install

migrate:
	@docker exec php php bin/console doctrine:migrations:migrate --no-interaction

run-fixture:
	@echo "⏳ Running Fixtures in 3s..."
	@sleep 3
	@docker exec php php bin/console doctrine:fixtures:load --no-debug --no-interaction

meili-import:
	@docker exec php php -d memory_limit=1G bin/console meilisearch:import --no-debug

# Tear down containers
down:
	@composer docker-compose-down
