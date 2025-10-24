start-docs-server:
	python3 -m http.server 8000 --directory docs

install-mock-server:
	npm install -g @stoplight/prism-cli

start-mock-server:
	prism mock docs/v1/st-spec-v1.json

validate:
	npx @redocly/cli lint docs/v1/st-spec-v1.json
	openapi-generator validate -i docs/v1/st-spec-v1.json

generate-csharp-nswag:
	(cd v1/client-generation && \
	rm -rf generated/csharp-nswag && \
	nswag run nswag.json)

CLIENT_GENERATORS = csharp go java javascript php python python-pydantic-v1 ruby typescript-angular typescript-fetch typescript-jquery typescript-node

generate-all-clients:
	@cd v1/client-generation && \
	for NAME in $(CLIENT_GENERATORS); do \
		echo "Generating client for $$NAME..."; \
		rm -rf generated/$$NAME && \
		openapi-generator generate \
			-i ../../docs/v1/st-spec-v1.json \
			-g $$NAME \
			-o generated/$$NAME; \
	done

generate-clients: generate-csharp-nswag generate-all-clients

SERVER_GENERATORS = aspnetcore go-server java-play-framework php-symfony php-laravel python-flask python-fastapi nodejs-express-server ruby-on-rails ruby-sinatra spring typescript-nestjs-server

generate-all-servers:
	@cd v1/server-generation && \
	for NAME in $(SERVER_GENERATORS); do \
		echo "Generating server for $$NAME..."; \
		rm -rf generated/$$NAME && \
		openapi-generator generate \
			-i ../../docs/v1/st-spec-v1.json \
			-g $$NAME \
			-o generated/$$NAME; \
	done

generate-servers: generate-all-servers
