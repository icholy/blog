+++
Categories = ["Development", "GoLang"]
Description = ""
Tags = ["Development", "golang"]
date = "2015-04-10T12:54:44-04:00"
title = "Custom JSON Marshalling in Go"

+++

Go's `encoding/json` package makes it really easy to marshal `struct`s to JSON data.

``` go
package main

import (
	"encoding/json"
	"os"
	"time"
)

type MyUser struct {
	ID       int64     `json:"id"`
	Name     string    `json:"name"`
	LastSeen time.Time `json:"lastSeen"`
}

func main() {
	_ = json.NewEncoder(os.Stdout).Encode(
		&MyUser{1, "Ken", time.Now()},
	)
}
```

Output: 

``` json
{"id":1,"name":"Ken","lastSeen":"2009-11-10T23:00:00Z"}
```

But what if we want to change how one of the field values are displayed? For example, say I wanted `LastSeen` to be a unix timestamp.

The simple solution is to introduce another auxiliary `struct` and populate it with the correctly formatted values in the `MarshalJSON` method.

``` go
func (u *MyUser) MarshalJSON() ([]byte, error) {
	return json.Marshal(&struct {
		ID       int64  `json:"id"`
		Name     string `json:"name"`
		LastSeen int64  `json:"lastSeen"`
	}{
		ID:       u.ID,
		Name:     u.Name,
		LastSeen: u.LastSeen.Unix(),
	})
}
```

This works, but it can get cumbersome when there are lots of fields.
It would be nice if we could embed the original `struct` into the auxiliary `struct` and have it inherit all the fields that do not need to be changed.

``` go
func (u *MyUser) MarshalJSON() ([]byte, error) {
	return json.Marshal(&struct {
		LastSeen int64 `json:"lastSeen"`
		*MyUser
	}{
		LastSeen: u.LastSeen.Unix(),
		MyUser:   u,
	})
}
``` 

The problem here is that the auxiliary `struct` will also inherit the original's `MarshalJSON` method, causing it to go into an infinite loop. The solution is to alias the original type. This alias will have all the same fields, but none of the methods. 

``` go
func (u *MyUser) MarshalJSON() ([]byte, error) {
	type Alias MyUser
	return json.Marshal(&struct {
		LastSeen int64 `json:"lastSeen"`
		*Alias
	}{
		LastSeen: u.LastSeen.Unix(),
		Alias:    (*Alias)(u),
	})
}
```

The same technique can be used for implementing an `UnmarshalJSON` method.

``` go
func (u *MyUser) UnmarshalJSON(data []byte) error {
	type Alias MyUser
	aux := &struct {
		LastSeen int64 `json:"lastSeen"`
		*Alias
	}{
		Alias: (*Alias)(u),
	}
	if err := json.Unmarshal(data, &aux); err != nil {
		return err
	}
	u.LastSeen = time.Unix(aux.LastSeen, 0)
	return nil
}
```
