GO ?= go
BINARY_NAME ?= tictactoe
CMD_PATH ?= ./cmd/tictactoe
BUILD_DIR ?= bin
DEFAULT_VERSION ?= 0.0.0-dev
GIT_DESCRIBE := $(shell git describe --tags --dirty --always 2>/dev/null)
VERSION ?= $(GIT_DESCRIBE)
BUILD_VERSION := $(if $(strip $(VERSION)),$(VERSION),$(DEFAULT_VERSION))
ifeq ($(strip $(GIT_DESCRIBE)),)
ifeq ($(strip $(VERSION)),)
$(warning git describe failed; falling back to $(DEFAULT_VERSION))
endif
endif
LDFLAGS ?= -X main.version=$(BUILD_VERSION)
GOCACHE ?= $(CURDIR)/.gocache
GOMODCACHE ?= $(CURDIR)/.gomodcache
GOLANGCI_LINT ?= golangci-lint
GOLANGCI_LINT_ARGS ?= -E gocritic -E gocyclo -E gosec -E mnd -E goconst -E err113
GOLANGCI_LINT_CACHE ?= $(CURDIR)/.golangci-lint-cache

.PHONY: all build test vet tidy ci clean

all: build

build:
	mkdir -p $(BUILD_DIR)
	GOCACHE=$(GOCACHE) GOMODCACHE=$(GOMODCACHE) $(GO) build -ldflags "$(LDFLAGS)" -o $(BUILD_DIR)/$(BINARY_NAME) $(CMD_PATH)

test:
	GOCACHE=$(GOCACHE) GOMODCACHE=$(GOMODCACHE) $(GO) test ./...

vet:
	GOCACHE=$(GOCACHE) GOMODCACHE=$(GOMODCACHE) $(GO) vet ./...
	GOCACHE=$(GOCACHE) GOMODCACHE=$(GOMODCACHE) GOLANGCI_LINT_CACHE=$(GOLANGCI_LINT_CACHE) \
		$(GOLANGCI_LINT) run $(GOLANGCI_LINT_ARGS) ./...

tidy:
	GOCACHE=$(GOCACHE) GOMODCACHE=$(GOMODCACHE) $(GO) mod tidy

ci: vet test build

clean:
	rm -rf $(BUILD_DIR) $(GOCACHE) $(GOMODCACHE) $(GOLANGCI_LINT_CACHE)
