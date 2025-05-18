+++
Tags = ["Development", "LLM", "AI"]
Categories = ["Development"]
date = "2025-05-18T16:31:05-04:00"
title = "Agent Recursion"
+++ 

When AI agents start using tools, the context window fills up fast.
Each `run_command` or `read_file` tool call dumps a lot of text that quickly loses relevance in subsequent steps.

I've been experimenting with the idea of "recursive agents" to mitigate this issue.
The idea is simple: **An agent can kick off new instances of itself to handle specific subtasks**.

The key part is that, when a child agent finishes, it doesn’t send its entire operational log or full tool output back to the parent; instead, it returns only a brief summary of the results.

This does two important things:

1. Keeps the parent agent's context window usage down.
2. Helps the parent agent stay focused on the overall objective.

I've implemented this idea here: https://github.com/icholy/sloppy.
The agent is simply provided with a `run_agent` tool.

``` json
{
  "name": "run_agent",
  "description": "Delegates a sub-task to a new child agent. Plan and break down work; use new, uniquely named agents for distinct sub-tasks or repetitive instances (min 3). Don't delegate the entire core task.",
  "parameters": {
    "type": "object",
    "properties": {
      "name": {
        "type": "string",
        "description": "A unique, short, and descriptive name for the child agent instance."
      },
      "prompt": {
        "type": "string",
        "description": "Instructions for the new child agent, or follow-up questions for a previously created agent."
      }
    },
    "required": ["name", "prompt"]
  }
}
```

**Note**: The `description` fields included here are abbreviated.