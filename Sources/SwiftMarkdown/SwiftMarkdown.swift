import PythonKit
import Foundation

public struct Markdown {
  /// The HTML representation of the Markdown, ready to
  /// be rendered in a web browser.
  public let html: String

  /// The inferred title of the document, from any top-level
  /// heading found when parsing. If the Markdown text contained
  /// two top-level headings, then this property will contain
  /// the first one.
  /// You'll need to use the `title` extension for this to work.
  public let title: String?

  /// Any metadata values found at the top of the Markdown document.
  /// See https://python-markdown.github.io/extensions/meta_data/ for more information.
  /// You'll need to use the `meta` extension for this to work.
  public let metadata: [String : String]

  internal init(html: String, title: String?, metadata: [String : String]) {
    self.html = html
    self.title = title
    self.metadata = metadata
  }
}

public struct SwiftMarkdown {
  public enum Extension: String {
    case extra = "extra"
    case abbr = "abbr"
    case attrList = "attr_list"
    case defList = "def_list"
    case fencedCode = "fenced_code"
    case footnotes = "footnotes"
    case mdInHtml = "md_in_html"
    case tables = "tables"
    case admonition = "admonition"
    case codehilite = "codehilite"
    case legacyAttrs = "legacy_attrs"
    case legacyEm = "legacy_em"
    case meta = "meta"
    case nl2br = "nl2br"
    case saneLists = "sane_lists"
    case smarty = "smarty"
    case wikilinks = "wikilinks"
    case toc = "toc"
    case strikethrough = "Extensions:StrikeThrough" // this is an extension offered by SwiftMarkdown
    case title = "Extensions:TitleExtension" // this is an extension offered by SwiftMarkdown
  }

  let parser: PythonObject
  let extensions: [Extension]

  public init(extensions: [Extension] = [], extensionConfig: [String: [String: String]] = [String: [String: String]]()) throws {
    // We take the path of the current file (SwiftMarkdown.swift),
    // and go up the path until we're in the folder where Extensions is
    let rootPath = URL(fileURLWithPath: #file)
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .pathComponents
      .joined(separator: "/")
      .dropFirst()

    let sys = Python.import("sys")
    sys.path.append(String(rootPath))

    let markdown = try Python.attemptImport("markdown")

    parser = markdown.Markdown.dynamicallyCall(withKeywordArguments: ["extensions": extensions.map(\.rawValue), "output_format": "html5", "extension_configs": extensionConfig])
    self.extensions = extensions
  }

  public func markdown(_ string: String) -> Markdown {
    let html = String(parser.convert(string))

    var title: String? = nil
    if extensions.contains(.title) {
      title = String(parser.Title)
    }

    var metadata: [String: String] = [:]
    if extensions.contains(.meta) {
      let tempMetadata: [String: [String]] = Dictionary(parser.Meta) ?? [:]
      metadata = tempMetadata.mapValues { $0.joined(separator: ", ") }
    }

    return Markdown(html: html ?? "", title: title, metadata: metadata)
  }

  public static func markdown(_ string: String, extensions: [Extension] = [], extensionConfig: [String: [String: String]] = [String: [String: String]]()) throws -> Markdown {
    let instance = try SwiftMarkdown(extensions: extensions, extensionConfig: extensionConfig)
    return instance.markdown(string)
  }
}
