COFFEE_FILES = $(shell find ./src -type f -name '*.coffee')

test:
	TEST_ROOT="src" ./node_modules/.bin/mocha

test-coverage:
	$(MAKE) clean
	$(MAKE) lib
	mkdir -p ./artifacts/tests
	TEST_ROOT="lib" ./node_modules/.bin/istanbul cover ./node_modules/.bin/_mocha

travis:
	$(MAKE) clean
	$(MAKE) lib
	mkdir -p ./artifacts/tests
	TEST_ROOT="lib" ./node_modules/.bin/istanbul cover --report lcovonly ./node_modules/.bin/_mocha
	./node_modules/.bin/coveralls < ./coverage/lcov.info

lib: $(COFFEE_FILES)
	./node_modules/.bin/coffee -co lib src

clean:
	rm -rf ./lib
	rm -rf ./artifacts

.PHONY: test test-coverage travis clean
