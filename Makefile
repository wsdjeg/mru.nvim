.PHONY: test clean install-deps install-luaunit help

# Default target
help:
	@echo "Available targets:"
	@echo "  test             - Run all tests (or specific tests with PATTERN=...)"
	@echo "  clean            - Clean test cache files"
	@echo "  install-deps     - Download all test dependencies"
	@echo "  install-luaunit  - Download luaunit test framework"
	@echo ""
	@echo "Examples:"
	@echo "  make test                                # Run all tests"
	@echo "  make test PATTERN=utils                  # Match test/**/*utils*_spec.lua"
	@echo "  make test PATTERN=mru                    # Match test/**/*mru*_spec.lua"
	@echo "  make test PATTERN=test/mru_spec.lua      # Full path"

# Install all test dependencies (cross-platform, uses Lua)
install-deps:
	@nvim --headless -u test/minimal_init.lua -c "lua dofile('test/install_deps.lua')" -c "qa!"

# Alias for individual dependency install (same cross-platform Lua script)
install-luaunit: install-deps

# Run tests with nvim headless
# Supports PATTERN parameter to run specific test file(s)
# Examples:
#   make test PATTERN=test/mru_spec.lua
#   make test PATTERN=utils  (shorthand for test/**/*utils*_spec.lua)
test: install-deps
	@echo "Running tests with nvim --headless..."
	@nvim --headless -u test/minimal_init.lua \
		-c "lua _G.TEST_PATTERN = '$(PATTERN)'" \
		-c "lua dofile('test/run.lua')" \
		-c "qa!"

# Clean generated files
clean:
	@echo "Cleaning up..."
	@rm -rf test/*.lua~
	@rm -rf test/*.out
	@rm -rf *.swp
	@rm -rf /tmp/*_mru_nvim_test* 2>/dev/null || true

