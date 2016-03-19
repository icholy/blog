+++
Categories = ["Development", "GoLang"]
Description = ""
Tags = ["Development", "golang"]
date = "2016-03-19T15:41:44-04:00"
title = "TypeScript: Working with JSON"

+++

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

The way I went about fixing this is by introducing a `UserData` interface.  
Since it only contains primitives, it can be converter to and from JSON without altering it.

``` ts
interface UserData {
  name:    string;
  age:     number;
  created: string;
}
```

Then I convert from `User` -> `UserData` before converting to JSON
and convert from `UserData` -> `User` after parsing from JSON.
Here's an example of some client code doing this.

``` ts
function getUsers(): Promise<User[]> {
  return ajax.get<UserData[]>('/users').then(data => {
    return data.data.map(decodeUser);
  });
}

function updateUser(id: number|string, user: User): Promise<{}> {
  return ajax.put<{}>(`/users/${id}`, encodeUser(user));
}
```

Here are the conversion functions.

``` ts
function encodeUser(user: User): UserData {
  return {
    name:    user.name,
    age:     user.age,
    created: user.created.toString()
  };
}

function decodeUser(data: UserData): User {
  return {
    name:    user.name,
    age:     user.age,
    created: new Date(data.created)
  };
}
```

This works, but it's a contrived example.
In real cases, there will be a lot more properties and this quickly turns into a huge pain in the ass.
Let's use `Object.assign` to clean it up a bit.  

``` ts
function encodeUser(user: User): UserData {
  return Object.assign({}, user, {
    created: user.created.toString()
  });
}

function decodeUser(data: UserData): User {
  return Object.assign({}, data, {
    created: new Date(data.created)
  });
}
```

So far so good, but what happens when `User` is a `class`?

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
function decodeUser(data: UserData): User {
  let user = Object.create(User.prototype);
  return Object.assign(user, data, {
    created: new Date(data.created)
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

  encode(): UserData {
    return Object.assign({}, this, {
      created: this.created.toString()
    });
  }

  static decode(data: UserData): User {
    let user = Object.create(User.prototype);
    return Object.assign(user, data, {
      created: new Date(data.created)
    });
  }
}
```

The nice thing about using this pattern is that it composes very well.  
Say the user had an `account` property which contained an instance of `Account`.

``` ts
class User {

  private account: Account;

  /* ... */
  
  encode(): UserData {
    return Object.assign({}, this, {
      created: this.created.toString(),
      account: this.account.encode()
    });
  }

  static decode(data: UserData): User {
    let user = Object.create(User.prototype);
    return Object.assign(user, data, {
      created: new Date(data.created),
      account: Account.decode(data.account)
    });
  }
}
```

