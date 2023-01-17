all: build

build:
	go run github.com/gohugoio/hugo

publish: build
	git push origin `git subtree split --prefix public master`:gh-pages --force

serve:
	go run github.com/gohugoio/hugo serve
