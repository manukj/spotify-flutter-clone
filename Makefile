.PHONY: setup clean test coverage lint build_runner watch format

# Setup and Dependencies
setup: clean
	flutter pub get
	flutter pub run build_runner build --delete-conflicting-outputs

# Cleaning
clean:
	flutter clean
	rm -rf coverage
	rm -rf build
	rm -rf .dart_tool
	rm -rf pubspec.lock

# Testing
test:
	flutter test

test-watch:
	flutter test --watch

coverage:
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html

# Code Generation
build_runner:
	dart run build_runner build --delete-conflicting-outputs

watch_runner:
	dart run build_runner watch --delete-conflicting-outputs


# Development
run-dev:
	flutter run --flavor development --target lib/main.dart

run-prod:
	flutter run --flavor production --target lib/main.dart

# Build
build-apk:
	flutter build apk --release

build-ios:
	flutter build ios --release

# Help
help:
	@echo "Available commands:"
	@echo "setup         - Clean and setup project with dependencies"
	@echo "clean         - Clean project artifacts"
	@echo "test          - Run all tests"
	@echo "test-watch    - Run tests in watch mode"
	@echo "coverage      - Generate and open test coverage report"
	@echo "build_runner  - Run build_runner once"
	@echo "watch_runner  - Run build_runner in watch mode"
	@echo "run-dev       - Run app in development mode"
	@echo "run-prod      - Run app in production mode"
	@echo "build-apk     - Build Android APK"
	@echo "build-ios     - Build iOS app"