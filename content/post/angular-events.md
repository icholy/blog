+++
Categories = ["Development", "AngularJS", "JavaScript"]
Description = ""
Tags = ["Development", "javascript", "angularjs"]
date = "2016-03-23T10:06:22-04:00"
title = "Angular Events"

+++


I've been trying to find an elegant way of dealing with events in AngularJS recently.
If you're not farmiliar with Angular, that's ok, this is a pretty common pattern.

Here I have a controller that registers an event listener:

``` js
function MyController($rootScope) {
  $rootScope.$on('event1', () => {
    console.log('event 1 occured');
  });
}
```

There's an issue with this code. It doesn't unbind the listener when the controller (or its scope) is destroyed.
Let's take care of this.

``` js
function MyController($scope, $rootScope) {
  let unbindEvent1 = $rootScope.$on('event1', () => {
    console.log('event 1 occured');
  });
  $scope.$on('$destroy', unbindEvent1);
}
```

This is ok, but gets unwieldy when you have multiple listeners.

``` js
function MyController($scope, $rootScope) {
  let unbindThisHappened = $rootScope.$on('thisHappened', () => {
    console.log('this happened');
  });
  let unbindThatHappened = $rootScope.$on('thatHappened', () => {
    console.log('that happened');
  });
  let unbindErrorHappened = $rootScope.$on('errorHappened', () => {
    console.log('error happened');
  });
  $scope.$on('$destroy', () => {
    unbindThisHappened();
    unbindThatHappened();
    unbindErrorHappened();
  });
}
```

A better way would be to have something called a `ListenerGroup`. Here's how it would work. 

``` js
function MyController($scope, $rootScope) {
  let listeners = ListenerGroup.for($rootScope);
  listeners.$on('thisHappened', () => console.log('this happened'));
  listeners.$on('thatHappened', () => console.log('that happened'));
  listeners.$on('errorHappened', () => console.log('error happened'));
  $scope.$on('$destroy', () => listeners.unbind());
}
```

If the `ListenerGroup` was made to be angular aware, you could even take it a step further.
I'm not too sure about this, because it's not apparent what `link` does and it doesn't really save that much typing.

``` js
function MyController($scope, $rootScope) {
  let listeners = ListenerGroup.for($rootScope);
  listeners.$on('thisHappened', () => console.log('this happened'));
  listeners.$on('thatHappened', () => console.log('that happened'));
  listeners.$on('errorHappened', () => console.log('error happened'));
  listeners.link($scope);
}
```

Implementing `ListenerGroup` is pretty simple. 

``` js
class ListenerGroup {

  constructor($scope) {
    this._unbinds = [];
    this._scope = $scope;
  }

  $on(event, listener) {
    let unbind = this._scope.$on(event, listener);
    this._unbinds.push(unbind);
  }

  unbind() {
    let unbinds = this._unbinds;
    let length = unbinds.length;
    this._unbinds = [];
    for (let i = 0; i < length; i++) {
      unbinds[i]();
    }
  }

  link($scope) {
    $scope.$on('$destroy', () => this.unbind());
  }
}
```


