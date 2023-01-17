
publish:
	go run github.com/gohugoio/hugo
	git push origin `git subtree split --prefix public master`:gh-pages --force
