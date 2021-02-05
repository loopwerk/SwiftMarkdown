import XCTest
@testable import SwiftMarkdown

final class SwiftMarkdownTests: XCTestCase {
  func testBasic() {
    XCTAssertEqual(try SwiftMarkdown.markdown("Hello, World!").html, "<p>Hello, World!</p>")
  }

  func testMetadata() {
    let string = """
---
tag: swift
date: 2021-02-04
---
# Hello World
Foo bar
"""

    let result = try! SwiftMarkdown.markdown(string, extensions: [.meta])

    XCTAssertEqual(result.html, "<h1>Hello World</h1>\n<p>Foo bar</p>")
    XCTAssertEqual(result.metadata, ["tag": "swift", "date": "2021-02-04"])
  }

  func testCodeHighlight() {
    let string = """
``` swift
print("Hello World")
```
"""

    let result = try! SwiftMarkdown.markdown(string, extensions: [.fencedCode, .codehilite])

    XCTAssertEqual(result.html, "<div class=\"codehilite\"><pre><span></span><code><span class=\"bp\">print</span><span class=\"p\">(</span><span class=\"s\">&quot;Hello World&quot;</span><span class=\"p\">)</span>\n</code></pre></div>")
  }

  func testCodeHighlightDifferentClass() {
    let string = """
``` swift
print("Hello World")
```
"""

    let config = [
      "codehilite": ["css_class": "highlight"]
    ]

    let result = try! SwiftMarkdown.markdown(string, extensions: [.fencedCode, .codehilite], extensionConfig: config)

    XCTAssertEqual(result.html, "<div class=\"highlight\"><pre><span></span><code><span class=\"bp\">print</span><span class=\"p\">(</span><span class=\"s\">&quot;Hello World&quot;</span><span class=\"p\">)</span>\n</code></pre></div>")
  }

  func testTitleAndStrikethroughExtensions() {
    let string = """
# Title
Text ~~strike~~

# Second title
Hello
"""

    let result = try! SwiftMarkdown.markdown(string, extensions: [.title, .strikethrough])

    XCTAssertEqual(result.html, "<p>Text <del>strike</del></p>\n<h1>Second title</h1>\n<p>Hello</p>")
    XCTAssertEqual(result.title, "Title")
  }

  static var allTests = [
    ("testBasic", testBasic),
    ("testMetadata", testMetadata),
    ("testCodeHighlight", testCodeHighlight),
    ("testCodeHighlightDifferentClass", testCodeHighlightDifferentClass),
    ("testTitleAndStrikethroughExtensions", testTitleAndStrikethroughExtensions),
  ]
}

