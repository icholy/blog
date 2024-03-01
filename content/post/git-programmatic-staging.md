+++
Description = ""
Tags = ["Development", "git", "grep", "monorepo", "refactor"]
Categories = ["Development", "Git"]
date = "2024-03-01T11:57:11-04:00"
title = "Git: programmatic staging"
+++

In the past year, I’ve been using a lot of tools to automatically rewrite/refactor code. These include  [semgrep](https://semgrep.dev/), [ast-grep](https://ast-grep.github.io/), LLMs, and one-off scripts. After running these tools on a large code-base, you usually end up with lots of additional unintended changes. These range from formatting/whitespace to unrequested modifications by LLMs.

The “cleanup” step is a very manual and tedious process. I’m essentially running `git add -p` and staging hunks one at a time. At times it feels like this step offsets the productivity gain from the rewrite tool itself.

After doing this several times, I realized that most of the hunks I was staging included some common text. If I could automatically stage hunks containing a search term, I could automate a lot of this work! Git does not natively support this, but it can be easily accomplished using the [expect](https://linux.die.net/man/1/expect) tool:

```bash
#!/usr/bin/expect -f

# Set timeout to prevent the script from hanging
set timeout -1

# Get the search pattern as a command line argument
if {[llength $argv] != 0} {
   set pattern [lindex $argv 0]
} else {
   puts "Error: search pattern not provided"
   exit 1
}

# Open the interaction with git add -p
spawn git add -p

# This is the main loop that handles the user interaction
expect {
  # This expect block is for the hunk that contains the provided pattern
  "*$pattern*Stage this hunk*" {
    send "y\r"
    exp_continue
  }
  # This expect block is for continuing to the next hunk
  "*Stage this hunk*" {
    send "n\r"
    exp_continue
  }
  eof
}
```
