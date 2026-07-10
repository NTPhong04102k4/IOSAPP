# AppIos — developer tasks
#
# Run `make help` to list available targets.

SWIFTFORMAT := swiftformat
SWIFTLINT   := swiftlint

# Xcode build settings — override on the command line, e.g. `make build DESTINATION='platform=iOS Simulator,name=iPhone 16 Pro'`
XCODEBUILD    := xcodebuild
PROJECT       := AppIos.xcodeproj
SCHEME        := AppIos
DESTINATION   := platform=iOS Simulator,name=iPhone 17 Pro
BUILD_DIR     := build

.DEFAULT_GOAL := help

.PHONY: help bootstrap format format-check lint lint-fix check build build-test build-prod clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

bootstrap: ## Install swiftformat & swiftlint via Homebrew
	@bash Scripts/bootstrap.sh

format: ## Format all Swift sources in place
	@$(SWIFTFORMAT) .

format-check: ## Verify formatting without writing changes (CI-friendly)
	@$(SWIFTFORMAT) --lint .

lint: ## Run SwiftLint
	@$(SWIFTLINT) lint --quiet

lint-fix: ## Autocorrect lint violations where possible
	@$(SWIFTLINT) --fix

check: format-check lint ## Run all read-only checks (formatting + lint)

build: ## Build the app (Debug) for the simulator
	@$(XCODEBUILD) build \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration Debug \
		-destination '$(DESTINATION)'

build-test: ## Build & run tests (Debug) on the simulator
	@$(XCODEBUILD) test \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration Debug \
		-destination '$(DESTINATION)'

build-prod: ## Build a Release archive for production
	@$(XCODEBUILD) archive \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration Release \
		-destination 'generic/platform=iOS' \
		-archivePath $(BUILD_DIR)/$(SCHEME).xcarchive

clean: ## Clean build artifacts
	@$(XCODEBUILD) clean -project $(PROJECT) -scheme $(SCHEME)
	@rm -rf $(BUILD_DIR)
