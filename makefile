COFFEE_FILES = $(shell find ./src -type f -name '*.coffee')

test:
	TEST_ROOT="src" ./node_modules/.bin/mocha

test-coverage:
	rm -rf ./lib
	$(MAKE) lib
	mkdir -p ./artifacts/tests
	TEST_ROOT="lib" ./node_modules/.bin/istanbul cover --root ./lib --dir ./artifacts/tests/coverage ./node_modules/.bin/_mocha

travis:
	$(MAKE) test-coverage
	./node_modules/.bin/coveralls < ./artifacts/tests/coverage/lcov.info

lib: $(COFFEE_FILES)
	./node_modules/.bin/coffee -co lib src

api-documentation: $(COFFEE_FILES)
	mkdir -p ./artifacts/documentation
	./node_modules/.bin/yuidoc --syntaxtype coffee --extension .coffee --outdir ./artifacts/documentation/api --config ./yuidoc.json ./src

clean:
	rm -rf ./lib
	rm -rf ./artifacts

.PHONY: test test-coverage travis clean
