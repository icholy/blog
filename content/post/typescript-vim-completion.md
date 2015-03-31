+++
Categories = ["Development", "TypeScript"]
Description = ""
Tags = ["Development", "TypeScript"]
date = "2015-03-31T10:17:00-04:00"
title = "TypeScript completion in Vim"

+++

One of the main advantages of using static types is that you get much better support from your tools.
I recently got [TypeScript](http://www.typescriptlang.org/) auto-completion working in vim and I'm documenting how to do it here.

### Demo:

![demo](http://i.imgur.com/zIiGauZ.gif)

### 1. Install TSS

``` sh
git clone https://github.com/clausreinke/typescript-tools.git
cd typescript-tools
git checkout testing_ts1.4
sudo npm install -g
```

### 2. Install Vim Plugin

I'm using [Vundle](https://github.com/gmarik/Vundle.vim) to manage my plugins.

``` vim
Bundle "icholy/typescript-tools.git"
au BufRead,BufNewFile *.ts  setlocal filetype=typescript
```

### 3. Install TSD

``` sh
sudo npm install tsd@next -g
```

### 4. Create Project

``` sh
mkdir project
cd project
tsd init

tsd install jquery --save
tsd install angularjs --save
```

### 5. Create `tsconfig.json`

``` json
{
  "compilerOptions": {
    "target": "es5",
    "noImplicitAny": false,
  },
  "files": [
    "typings/tsd.d.ts",

    "all.ts", "your.ts",
    "other.ts", "files.ts"
  ]
}
```

### 6. Start TSS in vim

Make sure you're cwd is somewhere in the directory containing `tsconfig.json`

``` vim
:TSSstart
```

You might get some errors, but it should still work.

### 7. (Optional) Making it work with [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)

``` vim
if !exists("g:ycm_semantic_triggers")
   let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers['typescript'] = ['.']
set completeopt-=preview
```

