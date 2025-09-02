+++
Description = ""
Tags = ["Development", "go"]
Categories = ["Development", "Go"]
date = "2025-09-02T08:40:07-04:00"
title = "Go: Defer Blocks (idea)"
+++ 


This is an idea that I've had for a while. It's an extension of `defer` that behaves similar to [handle](https://go.googlesource.com/proposal/+/master/design/go2draft-error-handling-overview.md). I'm not sure if it's original, but I thought it was worth writing down.
### Syntax

```go
defer {
    // Code runs at function exit
}

defer (_ string, err error) {
    if err != nil {
        return "", fmt.Errorf("wrapped: %w", err)
    }
}
```

### Semantics

- A `return` inside a defer block overrides earlier return values.
- Optionally binds return values for inspection/modification.
### Example

```go
func CopyFile(dst, src string) error {
	defer (err error) {
		if err != nil {
			return fmt.Errorf("failed to copy %s to %w: %w", src, dst, err)
		}
	}
    in, err  := os.Open(src)
    if err != nil {
	    return err
    }
    defer in.Close()
    out, err := try os.Create(dst)
    if err != nil {
	    return err
    }
	defer (err error) {
		if err != nil {
			_ = os.Remove(dst)
		}
	}
    if _, err := io.Copy(out, in); err != nil {
	    return err
    }
	return out.Close()
}
```