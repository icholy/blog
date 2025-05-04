all: build

build:
	go tool github.com/gohugoio/hugo

serve:
	go tool github.com/gohugoio/hugo serve

new:
	hugo new post/new.md
