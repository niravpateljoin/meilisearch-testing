# Initialize project inside Docker
init: up wait-db composer-install post-install-scripts migrate run-fixture

# Bring up containers
up:
	@docker compose --env-file .env up -d

# Wait for DB
wait-db:
	@echo "⏳ Waiting for database container to be ready..."
	@until docker exec mariadb mysqladmin ping -h"127.0.0.1" -P3306 --user=$$(grep DB_USER .env | cut -d '=' -f2) --password=$$(grep DB_PASSWORD .env | cut -d '=' -f2) --silent; do \
		sleep 1; \
	done
	@echo "✅ MySQL is up — sleeping 3s for init..."
	@sleep 3

# Run composer install INSIDE the PHP container
composer-install:
	@docker exec php composer install --no-scripts --no-interaction

# Symfony scripts inside PHP container
post-install-scripts:
	@docker exec php php bin/console cache:clear --no-warmup
	@docker exec php php bin/console assets:install public --symlink --relative
	@docker exec php php bin/console importmap:install

# Run migrations
migrate:
	@docker exec php php bin/console doctrine:migrations:migrate --no-interaction

# Run fixtures
run-fixture:
	@echo "⏳ Running Fixtures in 3s..."
	@sleep 3
	@docker exec php php bin/console doctrine:fixtures:load --no-debug --no-interaction

# Bring everything down
down:
	@docker compose --env-file .env down -v

# Import Meilisearch data
meili-import:
	@docker exec php php -d memory_limit=1G bin/console meilisearch:import --no-debug
