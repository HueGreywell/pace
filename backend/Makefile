build:
	@go build -o bin/me main.go

test:
	@go test -v ./...

swagger:
	@swag init
	@echo "http://localhost:8080/swagger/index.html"
	
run: build swagger
	@./bin/me

migration:
	@migrate create -ext sql -dir cmd/migrate/migrations $(filter-out $@,$(MAKECMDGOALS))

migrate-up:
	@go run cmd/migrate/main.go up

migrate-down:
	@go run cmd/migrate/main.go down
