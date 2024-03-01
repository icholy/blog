all: build

build:
	go run github.com/gohugoio/hugo

serve:
	go run github.com/gohugoio/hugo serve

new:
	go run github.com/gohugoio/hugo new content post/new.md
