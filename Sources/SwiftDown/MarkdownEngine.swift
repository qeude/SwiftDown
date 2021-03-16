//
//  MarkdownEngine.swift
//
//
//  Created by Quentin Eude on 16/03/2021.
//

import Down
import Foundation

public class MarkdownEngine {
  var text = ""
  var lines: [Int] = []

  public init() {}

  private func toMarkdownNode(_ node: Node) -> MarkdownNode? {
    let p = node.cmarkNode.pointee
    if let type = MarkdownNode.MarkdownType.from(
      rawValue: Int(p.type), with: node.cmarkNode.headingLevel)
    {
      let s = lines[Int(p.start_line) - 1] + Int(p.start_column) - 1
      let e = lines[Int(p.end_line) - 1] + Int(p.end_column) - 1

      let fromIdx = text.index(text.startIndex, offsetBy: s)
      let range =
        text
        .index(text.startIndex, offsetBy: e, limitedBy: text.endIndex)
        .map { NSRange(fromIdx...$0, in: text) } ?? NSRange(fromIdx..<text.endIndex, in: text)
      return MarkdownNode(range: range, type: type, headingLevel: node.cmarkNode.headingLevel)
    } else {
      return nil
    }
  }

  func exploreChildren(_ node: Node) -> [MarkdownNode] {
    node.children.reduce(toMarkdownNode(node).map { c in [c] } ?? []) { (r, c) in
      r + exploreChildren(c)
    }
  }

  public func render(_ markdownString: String) -> [MarkdownNode] {
    text = markdownString
    let lcs = markdownString.components(separatedBy: .newlines).map { $0.count }
    var sum = 0
    var counts: [Int] = []
    for l in lcs {
      counts.append(sum)
      sum += (l + 1)
    }
    lines = counts

    let result = (try? Down(markdownString: markdownString).toDocument(.smart))!

    return exploreChildren(result)
  }
}
