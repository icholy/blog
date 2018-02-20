+++
Categories = ["Development", "Go"]
Description = ""
Tags = ["Development", "go"]
date = "2018-02-19T12:17:21-04:00"
title = "Go: Experiments with http.Handler"

+++

When using `net/http`, handling errors is kinda annoying.

``` go
http.HandleFunc("/foo", func(w http.ResponseWriter, r *http.Request) {
	thing, err := storage.Get("thing")
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	_ = json.NewEncoder(w).Encode(thing)
})
```

Ideally, I could just return an error from the handler. Let's create a type to let that happen.

``` go
type MyHandlerFunc func(w http.ResponseWriter, r *http.Request) error

func (f MyHandlerFunc) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if err := f(w, r); err != nil {
		http.Error(w, err.Error(), 500)
	}
}
```

Here's the previous code refactored to use the new handler.

``` go
http.Handle("/foo", MyHandlerFunc(func(w http.ResponseWriter, r *http.Request) error {
	thing, err := storage.Get("thing")
	if err != nil {
		return err
	}
	return json.NewEncoder(w).Encode(thing)
}))
```

Better, but what if we want to control the error status code? There could be a
special `error` type that `MyHandleFunc` checks for.

``` go
type MyError struct {
	Code int
	Text string
}

func (e MyError) Error() string {
	return fmt.Sprintf("%d: %s", e.Code, e.Text)
}

type MyHandlerFunc func(w http.ResponseWriter, r *http.Request) error

func (f MyHandlerFunc) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if err := f(w, r); err != nil {
		if e, ok := err.(MyError); ok {
			http.Error(w, e.Text, e.Code)
		} else {
			http.Error(w, err.Error(), 500)
		}
	}
}
```

Usage:

``` go
http.Handle("/foo", MyHandlerFunc(func(w http.ResponseWriter, r *http.Request) error {
	thing, err := storage.Get("thing")
	if err != nil {
		return MyError{Code: 400, Text: "SomeError"}
	}
	return json.NewEncoder(w).Encode(thing)
}))
```

This is alright, but we can do better. Let's change the handler function signature so
that it returns another http.Handler. This will give the returned object complete control
over how it's handled.

``` go
type MyHandlerFunc func(w http.ResponseWriter, r *http.Request) http.Handler

func (f MyHandlerFunc) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if handler := f(w, r); handler != nil {
		handler.ServeHTTP(w, r)
	}
}
```

With this in place, we can implement all kinds of interesting helpers.

``` go
func WithStatus(code int, h http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(code)
		h.ServeHTTP(w, r)
	})
}

func Error(err error, code int) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		http.Error(w, err.Error(), code)
	})
}

func JSON(v interface{}) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		_ = json.NewEncoder(w).Encode(v)
	})
}

func Text(v interface{}) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, v)
	})
}
```

Usage example:

``` go
func GetThing(w http.ResponseWriter, r *http.Request) http.Handler {
	thing, err := storage.Get("thing")
	if err != nil {
		return Error(err, 500)
	}
	return JSON(thing)
}

func DeleteThing(w http.ResponseWriter, r *http.Request) http.Handler {
	if err := storage.Delete("thing"); err != nil {
		return Error(err, 400)
	}
	return Text("deleted thing")
}

func HandleThing(w http.ResponseWriter, r *http.Request) http.Handler {
	switch r.Method {
	case http.MethodGet:
		return GetThing(w, r)
	case http.MethodDelete:
		return DeleteThing(w, r)
	default:
		return WithStatus(404, Text("not found"))
	}
}

http.Handle("/thing", MyHandlerFunc(HandleThing))
```

I think that's pretty clean looking.