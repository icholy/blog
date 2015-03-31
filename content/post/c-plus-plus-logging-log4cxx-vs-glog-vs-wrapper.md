+++
Categories = ["Development", "C++"]
Description = ""
Tags = ["Development", "cpp"]
date = "2012-12-03T11:44:06-04:00"
title = "C++ Log4cxx vs Glog vs Boost.log vs Wrapper"

+++

It seems that logging in C++ isn’t a much discused topic when compared to a language like java. In a recent C++ project, I needed to add real logging support. Up till this point, the following was good enough (don’t judge).

``` cpp
#ifdef DEBUG
    std::cerr << "some error" << std::endl;
#endif 
```

I started googling and the following to be the most popular and mature.

### glog 

[homepage](http://code.google.com/p/google-glog/)

glog was my first choice because it’s the simplest one to set up and it has hardly any dependencies. The interface is also nice to use.

``` cpp
LOG(INFO) << "this is a test" << 123;
```

If you need simple and robust logging in a standalone application then glog is the way to go. However if you’re using it in a library and want to let your users configure logging options, it starts getting problematic. You can only initialze glog once, so having your library set its own default can get more complicated than it should be.

### Boost.Log

[homepage](http://boost-log.sourceforge.net/libs/log/doc/html/index.html)

I didn’t get too far with this library. It’s simply overwhelming! If you want simple logging then it can do that.

``` cpp
BOOST_LOG_TRIVIAL(info) << "this is a test" << 123
```

But if you want anything more, get ready to read a LOT of documentation. Boost.Log is more a framework to build your own logging library as opposed to a logging library in an of itself.

### log4cxx

[homepage](http://logging.apache.org/log4cxx/)

I’m not a big fan of java and initially I wasn’t too thrilled about the idea of something that copies log4j. Another thing that turned me off was that it has some pretty heavy [dependencies](https://svn.apache.org/repos/asf/logging/site/trunk/docs/log4cxx/dependencies.html). I eventually decided to give it a try and it wasn’t all that bad.

``` cpp
log4cxx::LoggerPtr logger(log4cxx::Logger::getLogger("bar.foo"));

LOG4CXX_INFO(logger, "this is a test" << 123);
```

The advantage here is that you can configure the system anywhere. All loggers inherit from the root logger `log4cxx::Logger::getRootLogger()`. In my example, `bar` is `foo`’s parent. So any setting given to bar will be inherited by `foo`.

### custom wrapper

Soon after starting my search I came up with an awesome idea. Why not just build my own, back-end agnostic, wrapper. Then provide an abstract Logger interface which the user can extend with the underlying logging back end. This would be both flexible and let me make my own beautiful api.

``` cpp
log::error << "this is a test" << 123;
```

… just don’t do it. Doing it right is harder than it seems.

### Conclusion

I ended up going with log4cxx. In my opinion, it strikes a nice balance between flexibility and simplicity.
