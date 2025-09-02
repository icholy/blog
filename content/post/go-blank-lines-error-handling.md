+++
Description = ""
Tags = ["Development", "go"]
Categories = ["Development", "Go"]
date = "2025-09-02T08:17:34-04:00"
title = "Go: Blank Lines and Error Handling Syntax"
+++ 


When writing Go, I generally don't include a lot of blank lines. Here's an example (ignore the lack of error wrapping/annotation):

```go
func zipmod(dir, modpath, version string) ([]byte, error) {
	var buf bytes.Buffer
	zw := zip.NewWriter(&buf)
	err := filepath.WalkDir(dir, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.IsDir() {
			return nil
		}
		relpath, err := filepath.Rel(dir, path)
		if err != nil {
			return err
		}
		// Create zip entry with module@version prefix
		dst, err := zw.Create(modpath + "@" + version + "/" + filepath.ToSlash(relpath))
		if err != nil {
			return err
		}
		src, err := os.Open(path)
		if err != nil {
			return err
		}
		defer src.Close()
		if _, err := io.Copy(dst, src); err != nil {
			return err
		}
		return src.Close()
	})
	if err != nil {
		return nil, err
	}
	if err := zw.Close(); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}
```

The `if err != nil` blocks already serve the purpose of visually splitting up the operations, so adding additional whitespace feels redundant. Now let's imagine Go had a `try` keyword for error checking.

```go
func zipmod(dir, modpath, version string) ([]byte, error) {
	var buf bytes.Buffer
	zw := zip.NewWriter(&buf)
	try filepath.WalkDir(dir, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.IsDir() {
			return nil
		}
		// Create zip entry with module@version prefix
		relpath := try filepath.Rel(dir, path)
		dst := try zw.Create(modpath + "@" + version + "/" + filepath.ToSlash(relpath))
		src := try os.Open(path)
		defer src.Close()
		try io.Copy(dst, src)
		try src.Close()
		return nil
	})
	try zw.Close()
	return buf.Bytes(), nil
}
```

All of a sudden, I get the urge to start breaking things up using blank lines. But if we begin adding blank lines, that starts to undo the LOC savings we get from the `try`. 

**Note:** This isn't meant to be an argument for or against `try` or similar langauge features.