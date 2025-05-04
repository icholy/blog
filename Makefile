all: build

build:
	go tool github.com/gohugoio/hugo

serve:
	go tool github.com/gohugoio/hugo serve

new:
	go tool github.com/gohugoio/hugo new content post/new.md
