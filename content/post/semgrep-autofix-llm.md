+++
Description = ""
Tags = ["Development", "LLM", "Semgrep"]
Categories = ["Development", "AI", "LLM"]
date = "2024-03-24T12:00:00-05:00"
title = "Semgrep: AutoFixes using LLMs"

+++

### Semgrep:

Semgrep is an incredible tool that allows you to search code by matching against the Abstract Syntax Tree (AST).
For instance, if you want to find all method calls named `get_foo`, you can write a pattern like this:

```
$A.get_foo(...)
```

Test your own patterns using the playground: https://semgrep.dev/playground/new

While there are other tools like this, semgrep is currently the most capable:

- https://ast-grep.github.io/
- https://codeql.github.com/
- https://comby.dev/

### AutoFix:

Semgrep not only searches using patterns but also supports rewriting the matches.
Here's a simple rule definition from their documentation:

```yaml
rules:
- id: use-sys-exit
  languages:
  - python
  message: |
    Use `sys.exit` over the python shell `exit` built-in. `exit` is a helper
    for the interactive shell and is not be available on all Python implementations.
    https://stackoverflow.com/a/6501134
  pattern: exit($X)
  fix: sys.exit($X)
  severity: WARNING
```

This can be invoked by running:

```yaml
semgrep --config ./rule.yml --autofix
```

### LLMs:

Although the built-in autofix feature is powerful, it's limited to simple AST transforms.
I'm currently exploring the idea of fixing semgrep matches using a Large Language Model (LLM).
To make this possible, I've created a tool called [semgrepx](https://github.com/icholy/semgrepx), which can be thought of as [xargs](https://man7.org/linux/man-pages/man1/xargs.1.html) for semgrep.
I then use semgrepx to rewrite the matches using the fantastic [llm](https://llm.datasette.io/en/stable/) tool.
Here's how it works:

```bash
semgrep -l go --pattern 'log.$A(...)' --json > matches.json
cat matches.json | semgrepx llm 'update this go to use log.Printf'
```

![](/images/semgrepx.png)

In my experience, Anthropic's Claude 3 Opus model performs much better at this task compared to GPT4.
