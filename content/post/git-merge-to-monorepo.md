+++
Description = ""
Tags = ["Development", "golang"]
Categories = ["Development", "GoLang"]
date = "2018-08-13T12:04:56-04:00"
title = "Merging Multiple Git Repositories Into A MonoRepo"

+++

**Note:** Replace `thing` with your own repo name in the examples.

### 1. Create a repository which will store all your code

```
mkdir monorepo && cd monorepo
git init .
echo "# MonoRepo" > README.md
git add .
git commit -m "first commit"
```

### 2. Clone one of the existing repositories to a temporary location

Example Remote: `ssh://git@code.company.com/thing.git`

``` sh
mkdir /tmp/thing
git clone ssh://git@code.company.com/thing.git /tmp/thing
cd /tmp/thing
```

### 3. Use [git filter-branch](https://git-scm.com/docs/git-filter-branch) to rewrite the history into a sub-directory.

**Note:** this step can take a very long time

```
export REPO_NAME="thing" 

git filter-branch -f --prune-empty --tree-filter '
    mkdir -p "$REPO_NAME"
    git ls-tree --name-only $GIT_COMMIT | xargs -I{} mv {} "$REPO_NAME"
'
```

### 4. Merge the rewritten repository into the monorepo

```
cd monorepo
git remote add thing /tmp/thing
git fetch thing
git merge thing/master
```

### 5. Clean up

```
git remote rm thing
rm -rf /tmp/thing
```

### Here's a script that performs all the steps

```
cd monorepo
./merge_repos.sh ssh://git@code.company.com/thing.git
```

{{< gist icholy 6491787bbb6894dbf4fe69a743975332 >}}
