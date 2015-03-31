+++
Categories = ["Development", "C++"]
Description = ""
Tags = ["Development", "cpp"]
date = "2011-09-26T12:23:39-04:00"
title = "Qt Creator + Boost on Ubuntu 11.04"

+++

### 1. make a home for boost

``` sh
sudo mkdir -p /code/include
sudo chown -R YOUR_USER_NAME /code
cd /code/include
```

### 2. download boost

``` sh
sudo apt-get install subversion
svn co http://svn.boost.org/svn/boost/trunk boost
cd boost
```

### 3. compile boost

``` sh
sudo ./bootstrap.sh
sudo ./b2
```

**note:** this will take a while, go get some coffee.

### 4. Include in qt project

Add the following to your `.pro` file.

```
INCLUDEPATH += /code/include/
LIBS += -L/code/include/boost/bin.v2/libs/ -lboost_system -lboost_filesystem -lboost_asio
```

In this example i'm linking `boost::filesystem` and `boost::asio.` 
`boost::system` is required by other boost libraries but if you can compile without it, then trash it.
