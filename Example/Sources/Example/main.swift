import SwiftMarkdown

let markdown = try SwiftMarkdown.markdown("Hello, World!")
print(markdown.html)

let string = """
---
tags: news, swift
date: 2021-02-04
---

# Hello world
Foo bar.

~~strikethrough~~ via own extension!

``` swift
let markdownWithMetadata = try SwiftMarkdown.markdown(string, extensions: [.meta])
```
"""

let extensionConfig = [
  "codehilite": ["css_class": "highlight"]
]

let markdownWithMetadata = try SwiftMarkdown.markdown(
  string,
  extensions: [.meta, .fencedCode, .codehilite, .title],
  extensionConfig: extensionConfig
)

print("Title:")
print(markdownWithMetadata.title ?? "(none)")
print("\nHtml:") // Hello world
print(markdownWithMetadata.html) // This does NOT include <h1>Hello world</h1>
print("\nMetadata:")
print(markdownWithMetadata.metadata) // ["tags": "news, swift", "date": "2021-02-04"]


let string2 = """
``` swift
print("Hello World")
```
"""

let result = try SwiftMarkdown.markdown(string2, extensions: [.fencedCode, .codehilite])

// A parser can be reused
let parser = try SwiftMarkdown(extensions: [.nl2br])
print(parser.markdown(string2))
print(parser.markdown(string2))
print(parser.markdown(string2))
