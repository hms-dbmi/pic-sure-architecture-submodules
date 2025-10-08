# PIC-SURE Application Stack Makefile
# Centralized version and build management

# Define versions for each component
PIC_SURE_VERSION := v2.20.4
PIC_SURE_AUTH_VERSION := v3.6.7
PIC_SURE_FRONTEND_VERSION := v2.1.2
PIC_SURE_HPDS_VERSION := v4.7.7
PICSURE_DICTIONARY_VERSION := v1.4.8

.PHONY: help init update-versions checkout-versions build clean status

help:
	@echo "PIC-SURE Application Stack - Available targets:"
	@echo ""
	@echo "  make init              - Initialize submodules"
	@echo "  make checkout-versions - Checkout all submodules to defined versions"
	@echo "  make update-versions   - Update submodules and commit version changes"
	@echo "  make build             - Build all components"
	@echo "  make clean             - Clean all build artifacts"
	@echo "  make status            - Show current submodule versions"
	@echo "  make help              - Show this help message"
	@echo ""
	@echo "Current versions:"
	@echo "  pic-sure:              $(PIC_SURE_VERSION)"
	@echo "  pic-sure-auth:         $(PIC_SURE_AUTH_VERSION)"
	@echo "  frontend:              $(PIC_SURE_FRONTEND_VERSION)"
	@echo "  pic-sure-hpds:         $(PIC_SURE_HPDS_VERSION)"
	@echo "  picsure-dictionary:    $(PICSURE_DICTIONARY_VERSION)"

init:
	@echo "Initializing submodules..."
	git submodule update --init --recursive
	@echo "Submodules initialized!"

checkout-versions:
	@echo "Checking out defined versions..."
	@cd pic-sure && git fetch --all --tags && git checkout $(PIC_SURE_VERSION)
	@cd pic-sure-auth-microapp && git fetch --all --tags && git checkout $(PIC_SURE_AUTH_VERSION)
	@cd PIC-SURE-Frontend && git fetch --all --tags && git checkout $(PIC_SURE_FRONTEND_VERSION)
	@cd pic-sure-hpds && git fetch --all --tags && git checkout $(PIC_SURE_HPDS_VERSION)
	@cd picsure-dictionary && git fetch --all --tags && git checkout $(PICSURE_DICTIONARY_VERSION)
	@echo "All submodules checked out to specified versions!"

update-versions: checkout-versions
	@echo "Staging submodule updates..."
	git add pic-sure pic-sure-auth-microapp PIC-SURE-Frontend pic-sure-hpds picsure-dictionary
	@echo "Submodules staged. Run 'git commit' to commit the changes."
	@echo "Suggested commit message:"
	@echo "  Update submodule versions"

build: init checkout-versions
	@echo "Building PIC-SURE Application Stack..."
	@./build.sh

clean:
	@echo "Cleaning build artifacts..."
	mvn clean
	@if [ -d "PIC-SURE-Frontend" ]; then \
		cd PIC-SURE-Frontend && rm -rf node_modules dist build .pnpm-store; \
	fi
	@echo "Clean complete!"

status:
	@echo "=========================================="
	@echo "PIC-SURE Application Stack Version Status"
	@echo "=========================================="
	@echo ""
	@echo "Component                  | Staged (Makefile)     | Current (Checked Out)"
	@echo "---------------------------|----------------------|------------------------"
	@printf "%-26s | %-20s | " "pic-sure" "$(PIC_SURE_VERSION)"
	@cd pic-sure 2>/dev/null && ( \
		BRANCH=$$(git symbolic-ref --short HEAD 2>/dev/null); \
		if [ -n "$$BRANCH" ]; then \
			TAG=$$(git describe --tags --exact-match 2>/dev/null); \
			if [ -n "$$TAG" ]; then \
				echo "$$BRANCH ($$TAG)"; \
			else \
				HASH=$$(git rev-parse --short HEAD 2>/dev/null); \
				echo "$$BRANCH ($$HASH)"; \
			fi; \
		else \
			git rev-parse --short HEAD 2>/dev/null || echo "not initialized"; \
		fi \
	) || echo "not initialized"
	@printf "%-26s | %-20s | " "pic-sure-auth-microapp" "$(PIC_SURE_AUTH_VERSION)"
	@cd pic-sure-auth-microapp 2>/dev/null && ( \
		BRANCH=$$(git symbolic-ref --short HEAD 2>/dev/null); \
		if [ -n "$$BRANCH" ]; then \
			TAG=$$(git describe --tags --exact-match 2>/dev/null); \
			if [ -n "$$TAG" ]; then \
				echo "$$BRANCH ($$TAG)"; \
			else \
				HASH=$$(git rev-parse --short HEAD 2>/dev/null); \
				echo "$$BRANCH ($$HASH)"; \
			fi; \
		else \
			git rev-parse --short HEAD 2>/dev/null || echo "not initialized"; \
		fi \
	) || echo "not initialized"
	@printf "%-26s | %-20s | " "PIC-SURE-Frontend" "$(PIC_SURE_FRONTEND_VERSION)"
	@cd PIC-SURE-Frontend 2>/dev/null && ( \
		BRANCH=$$(git symbolic-ref --short HEAD 2>/dev/null); \
		if [ -n "$$BRANCH" ]; then \
			TAG=$$(git describe --tags --exact-match 2>/dev/null); \
			if [ -n "$$TAG" ]; then \
				echo "$$BRANCH ($$TAG)"; \
			else \
				HASH=$$(git rev-parse --short HEAD 2>/dev/null); \
				echo "$$BRANCH ($$HASH)"; \
			fi; \
		else \
			git rev-parse --short HEAD 2>/dev/null || echo "not initialized"; \
		fi \
	) || echo "not initialized"
	@printf "%-26s | %-20s | " "pic-sure-hpds" "$(PIC_SURE_HPDS_VERSION)"
	@cd pic-sure-hpds 2>/dev/null && ( \
		BRANCH=$$(git symbolic-ref --short HEAD 2>/dev/null); \
		if [ -n "$$BRANCH" ]; then \
			TAG=$$(git describe --tags --exact-match 2>/dev/null); \
			if [ -n "$$TAG" ]; then \
				echo "$$BRANCH ($$TAG)"; \
			else \
				HASH=$$(git rev-parse --short HEAD 2>/dev/null); \
				echo "$$BRANCH ($$HASH)"; \
			fi; \
		else \
			git rev-parse --short HEAD 2>/dev/null || echo "not initialized"; \
		fi \
	) || echo "not initialized"
	@printf "%-26s | %-20s | " "picsure-dictionary" "$(PICSURE_DICTIONARY_VERSION)"
	@cd picsure-dictionary 2>/dev/null && ( \
		BRANCH=$$(git symbolic-ref --short HEAD 2>/dev/null); \
		if [ -n "$$BRANCH" ]; then \
			TAG=$$(git describe --tags --exact-match 2>/dev/null); \
			if [ -n "$$TAG" ]; then \
				echo "$$BRANCH ($$TAG)"; \
			else \
				HASH=$$(git rev-parse --short HEAD 2>/dev/null); \
				echo "$$BRANCH ($$HASH)"; \
			fi; \
		else \
			git rev-parse --short HEAD 2>/dev/null || echo "not initialized"; \
		fi \
	) || echo "not initialized"
	@echo ""
	@echo "=========================================="
	@echo ""
	@echo "Tip: Run 'make checkout-versions' to align current with staged versions"