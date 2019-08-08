#!/usr/bin/make
.PHONY: buildout cleanall test instance

buildout.cfg:
	ln -s dev.cfg buildout.cfg

bin/pip:
	if [ -f /usr/bin/virtualenv ] ; then virtualenv .;else virtualenv -p python2 .;fi
	touch $@

bin/buildout: bin/pip
	./bin/pip install -r requirements.txt
	touch $@

buildout: bin/buildout buildout.cfg
	./bin/buildout -t 7

test: buildout
	./bin/test

instance: buildout
	./bin/instance fg

docker-build:
	docker-compose down
	docker-compose build --no-cache
	docker-compose up -d

cleanall:
	rm -rf bin develop-eggs downloads include lib parts .installed.cfg .mr.developer.cfg bootstrap.py parts/omelette

bash:
	docker-compose run --rm -p 8080:8080 --name instance instance bash
