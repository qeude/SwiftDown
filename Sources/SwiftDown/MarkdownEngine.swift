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

  private func toMarkdownNode(_ node: Node, offset: Int) -> MarkdownNode? {
    let p = node.cmarkNode.pointee
    if let type = MarkdownNode.MarkdownType.from(
      rawValue: Int(p.type), with: node.cmarkNode.headingLevel) {
      let s = lines[Int(p.start_line) - 1] + Int(p.start_column) - 1
      let e = lines[Int(p.end_line) - 1] + Int(p.end_column) - 1

      let fromIdx = text.utf8.index(text.utf8.startIndex, offsetBy: s)
      let range =
        text.utf8
        .index(text.utf8.startIndex, offsetBy: max(0, e), limitedBy: text.utf8.endIndex)
        .flatMap {
          if ($0 < text.utf8.endIndex && $0 > fromIdx) {
            let range = NSRange(fromIdx...$0, in: text)
            return NSRange(location: range.location + offset, length: range.length)
          } else {
            return nil
          }
        } ?? NSRange(fromIdx..<text.utf8.endIndex, in: text)
      return MarkdownNode(range: range, type: type, headingLevel: node.cmarkNode.headingLevel)
    } else {
      return nil
    }
  }

  func exploreChildren(_ node: Node, offset: Int) -> [MarkdownNode] {
    node.children.reduce(toMarkdownNode(node, offset: offset).map { c in [c] } ?? []) { (r, c) in
      r + exploreChildren(c, offset: offset)
    }
  }

  public func render(_ markdownString: String, offset: Int) -> [MarkdownNode] {
    text = markdownString
    let lcs = markdownString.components(separatedBy: .newlines).map { $0.utf8.count }
    var sum = 0
    var counts: [Int] = []
    for l in lcs {
      counts.append(sum)
      sum += (l + 1)
    }
    lines = counts

    let result = (try? Down(markdownString: markdownString).toDocument(.smart))!

    return exploreChildren(result, offset: offset)
  }
}
