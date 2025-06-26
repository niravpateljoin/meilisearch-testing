# Initialize the project
init: composer-install up wait-db migrate run-fixture

# Bring up containers
composer-install:
	@composer install

up:
	@composer docker-compose-up

wait-db:
	@echo "⏳ Waiting for database on 127.0.0.1:3308..."
	@until docker compose exec database mysqladmin ping -h 127.0.0.1 -P 3306 --user=$(DB_USER) --password=$(DB_PASSWORD) --silent; do sleep 1; done
	@echo "✅ MySQL is up — sleeping 3s for init..."
	@sleep 3

# Run migrations
migrate:
	@composer migrate-migration

run-fixture:
	@echo "Running Fixture in 3s"
	@sleep 3
	@composer fix-load
# Bring everything down
down:
	@composer docker-compose-down
