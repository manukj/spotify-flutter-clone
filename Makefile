.PHONY: flutter_pub_get
flutter_pub_get:
	flutter pub get

.PHONY: build_runner
build_runner:
	dart run build_runner build --delete-conflicting-outputs

.PHONY: watch_runner
watch_runner:
	dart run build_runner watch --delete-conflicting-outputs

.PHONY: clean
clean:
	flutter clean

.PHONY: clean_n_build
clean_n_build: clean flutter_pub_get build_runner