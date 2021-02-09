# SwiftMarkdown

A Swift wrapper for [Python-Markdown](https://github.com/Python-Markdown/markdown), using [PythonKit](https://github.com/pvieito/PythonKit).

You'll need to install Python-Markdown (and optionally pygments) yourself.

## Usage

``` swift
import SwiftMarkdown

let markdown = try SwiftMarkdown.markdown("Hello, World!")
print(markdown.html)

let string = """
---
tags: news, swift
date: 2021-02-04
---
# Hello world
This uses metadata
"""

let markdownWithMetadata = try SwiftMarkdown.markdown(string, extensions: [.meta])
print(markdownWithMetadata.metadata) // ["tags": "news, swift", "date": "2021-02-04"]

```

See https://python-markdown.github.io/extensions for documentation on the "extensions".

SwiftMarkdown also comes bundles with its own three extensions:

- `.title`, which removes the first title from the html output and instead makes it available as `result.title`
- `.strikethrough`, which turns `~~text~~` into ~~text~~
- `.urlize`, which turns naked links into clickable links


## Installation

Using Swift Package Manager

```
.package(url: "https://github.com/loopwerk/SwiftMarkdown", from: "0.4.0"),
```
