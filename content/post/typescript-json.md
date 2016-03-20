+++
Categories = ["Development", "GoLang"]
Description = ""
Tags = ["Development", "golang"]
date = "2016-03-19T15:41:44-04:00"
title = "TypeScript: Working with JSON"

+++

**EDITS:**

* I'm aware that calling `toString` on `Date` is redundant.
* There's a full commented example at the end.
* Use `toJSON` method as suggested by [Schipperz](http://choly.ca/post/typescript-json/#comment-2579762437).
* Add `reviver` method as suggested by [Anders Ringqvist](http://choly.ca/post/typescript-json/#comment-2579491209).

---

So you have a `User` type in your code.

``` ts
interface User {
  name:    string;
  age:     number;
  created: Date;
}
```

At some point you're going to want to encode this as JSON.
This works as you'd expect.

``` 
 > JSON.stringify({ name: "bob", age: 34, created: new Date() });
'{"name":"bob","age":34,"created":"2016-03-19T18:15:12.710Z"}'
```

The problem is that the `created` field is no longer a `Date` when you parse it back.

```
> JSON.parse('{"name":"bob","age":34,"created":"2016-03-19T18:15:12.710Z"}')
{ name: 'bob', age: 34, created: '2016-03-19T18:15:12.710Z' }
```

The way I went about fixing this is by introducing a `UserJSON` interface.  
Since it only contains primitives, it can be converter to and from JSON without altering it.

``` ts
interface UserJSON {
  name:    string;
  age:     number;
  created: string;
}
```

Then I convert from `User` -> `UserJSON` before converting to JSON
and convert from `UserJSON` -> `User` after parsing from JSON.
Here's an example of some client code doing this.

``` ts
function getUsers(): Promise<User[]> {
  return ajax.get<UserJSON[]>('/users').then(data => {
    return data.data.map(decodeUser);
  });
}

function updateUser(id: number|string, user: User): Promise<{}> {
  return ajax.put<{}>(`/users/${id}`, encodeUser(user));
}
```

Here are the conversion functions.

``` ts
function encodeUser(user: User): UserJSON {
  return {
    name:    user.name,
    age:     user.age,
    created: user.created.toString()
  };
}

function decodeUser(json: UserJSON): User {
  return {
    name:    json.name,
    age:     json.age,
    created: new Date(json.created)
  };
}
```

This works, but it's a contrived example.
In real cases, there will be a lot more properties and this quickly turns into a huge pain in the ass.
Let's use `Object.assign` to clean it up a bit.  

``` ts
function encodeUser(user: User): UserJSON {
  return Object.assign({}, user, {
    created: user.created.toString()
  });
}

function decodeUser(json: UserJSON): User {
  return Object.assign({}, json, {
    created: new Date(json.created)
  });
}
```

So far so good, but what happens when `User` is a class?

``` ts
class User {

  private created: Date;

  constructor(
    private name: string,
    private age:  string
  ) {
    this.created = new Date();
  }

  getName(): string {
    return this.name;
  }
}
```

For this to work, I use `Object.create` to make a new object who's prototype points to `User.prototype`.
 Then assign the properties to that. The encoding function doesn't change.

``` ts
function decodeUser(json: UserJSON): User {
  let user = Object.create(User.prototype);
  return Object.assign(user, json, {
    created: new Date(json.created)
  });
}
```

Finally, the `encode` and `decode` functions can just be methods on the `User` class.

``` ts
class User {

  private created: Date;

  constructor(
    private name: string,
    private age:  string
  ) {
    this.created = new Date();
  }

  getName(): string {
    return this.name;
  }

  encode(): UserJSON {
    return Object.assign({}, this, {
      created: this.created.toString()
    });
  }

  static decode(json: UserJSON): User {
    let user = Object.create(User.prototype);
    return Object.assign(user, json, {
      created: new Date(json.created)
    });
  }
}
```

When `JSON.stringify` is invoked on an object, it checks for a method called `toJSON`
to convert the data before 'stringifying' it. In light of this, let's rename `encode` and
`decode` to `toJSON` and `fromJSON`.

``` ts
class User {

  /* ... */

  toJSON(): UserJSON {
    return Object.assign({}, this, {
      created: this.created.toString()
    });
  }

  static fromJSON(json: UserJSON): User {
    let user = Object.create(User.prototype);
    return Object.assign(user, json, {
      created: new Date(json.created)
    });
  }
}
```

We don't need to call `user.encode()` explicitly anymore!

``` ts
let data = JSON.stringify(new User("Steve", 39));
let user = User.fromJSON(JSON.parse(data));
```

This is good, but we can do better. `JSON.parse` accepts a second parameter called
`reviver` which is a function that gets called with every key/value pair in the object
as it's being parsed. The root object is passed to `reviver` with an empty string as the key.
Let's add a `reviver` function to our `User` class.

``` ts
class User {

  /* ... */

  static fromJSON(json: UserJSON): User {
    let user = Object.create(User.prototype);
    return Object.assign(user, json, {
      created: new Date(json.created)
    });
  }

  static reviver(key: string, value: any): any {
    return key === "" ? User.fromJSON(value) : value;
  }
}
```

Now we can write:

``` ts
let user = JSON.parse(data, User.reviver);
```

Not too shabby...

One final adjustment is that a client might get confused when `fromJSON` doesn't actually
accept a JSON string. Let's fix that.

``` ts
class User {

  /* ... */
  
  static fromJSON(json: UserJSON|string): User {
    if (typeof json === 'string') {
      return JSON.parse(json, User.reviver);
    } else {
      let user = Object.create(User.prototype);
      return Object.assign(user, json, {
        created: new Date(json.created),
      });
    }
  }
}
```

Let's look at some client code:

``` ts

function getUsers(): Promise<User[]> {
  return ajax.get<UserJSON[]>('/users').then(data => {
    return data.data.map(User.fromJSON);
  });
}

function updateUser(id: number|string, user: User): Promise<{}> {
  return ajax.put<{}>(`/users/${id}`, user);
}

```

The nice thing about using this pattern is that it composes very well.  
Say the user had an `account` property which contained an instance of `Account`.

``` ts
class User {

  private account: Account;

  /* ... */
  
  static fromJSON(json: UserJSON): User {
    let user = Object.create(User.prototype);
    return Object.assign(user, json, {
      created: new Date(json.created),
      account: Account.fromJSON(json.account)
    });
  }
}
```

And here's the full commented `User` class.

``` ts
class User {

  private created: Date;

  constructor(
    private name: string,
    private age:  string
  ) {
    this.created = new Date();
  }

  getName(): string {
    return this.name;
  }

  // toJSON is automatically used by JSON.stringify
  toJSON(): UserJSON {
    // copy all fields from `this` to an empty object and return in
    return Object.assign({}, this, {
      // convert fields that need converting
      created: this.created.toString()
    });
  }

  // fromJSON is used to convert an serialized version
  // of the User to an instance of the class
  static fromJSON(json: UserJSON|string): User {
    if (typeof json === 'string') {
      // if it's a string, parse it first
      return JSON.parse(json, User.reviver);
    } else {
      // create an instance of the User class
      let user = Object.create(User.prototype);
      // copy all the fields from the json object
      return Object.assign(user, json, {
        // convert fields that need converting
        created: new Date(json.created),
      });
    }
  }

  // reviver can be passed as the second parameter to JSON.parse
  // to automatically call User.fromJSON on the resulting value.
  static reviver(key: string, value: any): any {
    return key === "" ? User.fromJSON(value) : value;
  }
}

// A representation of User's data that can be converted to
// and from JSON without being altered.
interface UserJSON {
  name:    string;
  age:     number;
  created: string;
}

```

