.PHONY: build clean contrib_check coverage docker-build docker-install help install isntall lint run size test uninstall

export GOPROXY = https://proxy.golang.org,direct

GOBIN := ${GOBIN}

# -------------------- Actions -------------------- #

## build: builds a local version
build:
	@echo "Building..."
	go build -o bin/wtf
	@echo "Done building"

## clean: removes old build cruft
clean:
	rm -rf ./dist
	rm -rf ./bin/wtf
	@echo "Done cleaning"

## coverage: figures out and displays test code coverage
coverage:
	go test -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out

## gosec: runs the gosec static security scanner against the source code
gosec: $(GOBIN)/gosec
	gosec -tests ./...

$(GOBIN)/gosec:
	cd && go install github.com/securego/gosec/v2/cmd/gosec@latest

## help: prints this help message
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

## install: installs a local version of the app
install:
	@go clean
	@go install -ldflags="-s -w"
	$(eval INSTALLPATH = $(shell which wtf))
	@echo "wtf installed into ${INSTALLPATH}"

## lint: runs a number of code quality checks against the source code
lint: $(GOBIN)/golangci-lint
	golangci-lint cache clean
	golangci-lint run

$(GOBIN)/golangci-lint:
	cd && go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

## run: executes the locally-installed version
run: build
	bin/wtf

## test: runs the test suite
test: build
	go test ./...

## uninstall: uninstals a locally-installed version
uninstall:
	@rm -i $(GOBIN)/wtf
