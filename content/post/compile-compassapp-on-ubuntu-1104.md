+++
Categories = ["Development", "CSS"]
Description = ""
Tags = ["Development", "css", "scss"]
date = "2012-09-20T12:27:52-04:00"
title = "Compile CompassApp on Ubuntu 11.04"

+++

{{< youtube pFCYhy9N6co >}}

### 1. Install RVM

``` sh
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm);
echo 'if [[ -s "$HOME/.rvm/scripts/rvm" ]]  ; then source "$HOME/.rvm/scripts/rvm" ; fi' > ~/.bashrc
rvm install 1.9.2
```

### 2. Install jRuby

``` sh
rvm install jruby
cd ~/.rvm/bin/jruby-1.6.4 -S gem install rawr
```

### 3. Get and Compile CompassApp

``` sh
git clone https://github.com/handlino/CompassApp.git
cd CompassApp
bin/build-all.sh
```

### 4. Run CompassApp

``` sh
cd package/compass.app/
./run.sh
```

