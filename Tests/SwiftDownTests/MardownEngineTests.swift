import XCTest
import Nimble

@testable import SwiftDown

final class MarkdownEngineTests: XCTestCase {
  func testRender() {
    let string = "# H1\n## H2\n### H3\n#### H4\n##### H5\n###### H6\n**bold** __bold__\n*italic* _italic_\n`inline code`\n```\ncode block\n```\n\n> block quote\n\n- list\n\n1. list\n\n[link](link)\n\nbody"
    let mardownNodes = MarkdownEngine().render(string, offset: 0)
    expect(mardownNodes).to(haveCount(16))
    let expectedMarkdownNodes = [
      MarkdownNode(range:NSRange(location : 0, length : 4), type:.header1, headingLevel:1),
      MarkdownNode(range:NSRange(location : 5, length : 5), type:.header2, headingLevel:2),
      MarkdownNode(range:NSRange(location : 11, length : 6), type:.header3, headingLevel:3),
      MarkdownNode(range:NSRange(location : 18, length : 7), type:.header4, headingLevel:4),
      MarkdownNode(range:NSRange(location : 26, length : 8), type:.header5, headingLevel:5),
      MarkdownNode(range:NSRange(location : 35, length : 9), type:.header6, headingLevel:6),
      MarkdownNode(range:NSRange(location : 45, length : 8), type:.bold, headingLevel:0),
      MarkdownNode(range:NSRange(location : 54, length : 8), type:.bold, headingLevel:0),
      MarkdownNode(range:NSRange(location : 63, length : 8), type:.italic, headingLevel:0),
      MarkdownNode(range:NSRange(location : 72, length : 8), type:.italic, headingLevel:0),
      MarkdownNode(range:NSRange(location : 82, length : 11), type:.code, headingLevel:0),
      MarkdownNode(range:NSRange(location : 95, length : 18), type:.codeBlock, headingLevel:0),
      MarkdownNode(range:NSRange(location : 115, length : 13), type:.quote, headingLevel:0),
      MarkdownNode(range:NSRange(location : 130, length : 7), type:.list, headingLevel:0),
      MarkdownNode(range:NSRange(location : 138, length : 8), type:.list, headingLevel:0),
      MarkdownNode(range:NSRange(location : 147, length : 12), type:.link, headingLevel:0)
    ]
    expect(mardownNodes).to(equal(expectedMarkdownNodes))
  }
  
  func testRenderWithOffset() {
    let string = "# H1\n## H2\n### H3\n#### H4\n##### H5\n###### H6\n**bold** __bold__\n*italic* _italic_\n`inline code`\n```\ncode block\n```\n\n> block quote\n\n- list\n\n1. list\n\n[link](link)\n\nbody"
    let mardownNodes = MarkdownEngine().render(string, offset: 10)
    expect(mardownNodes).to(haveCount(16))
    let expectedMarkdownNodes = [
      MarkdownNode(range:NSRange(location : 10, length : 4), type:.header1, headingLevel:1),
      MarkdownNode(range:NSRange(location : 15, length : 5), type:.header2, headingLevel:2),
      MarkdownNode(range:NSRange(location : 21, length : 6), type:.header3, headingLevel:3),
      MarkdownNode(range:NSRange(location : 28, length : 7), type:.header4, headingLevel:4),
      MarkdownNode(range:NSRange(location : 36, length : 8), type:.header5, headingLevel:5),
      MarkdownNode(range:NSRange(location : 45, length : 9), type:.header6, headingLevel:6),
      MarkdownNode(range:NSRange(location : 55, length : 8), type:.bold, headingLevel:0),
      MarkdownNode(range:NSRange(location : 64, length : 8), type:.bold, headingLevel:0),
      MarkdownNode(range:NSRange(location : 73, length : 8), type:.italic, headingLevel:0),
      MarkdownNode(range:NSRange(location : 82, length : 8), type:.italic, headingLevel:0),
      MarkdownNode(range:NSRange(location : 92, length : 11), type:.code, headingLevel:0),
      MarkdownNode(range:NSRange(location : 105, length : 18), type:.codeBlock, headingLevel:0),
      MarkdownNode(range:NSRange(location : 125, length : 13), type:.quote, headingLevel:0),
      MarkdownNode(range:NSRange(location : 140, length : 7), type:.list, headingLevel:0),
      MarkdownNode(range:NSRange(location : 148, length : 8), type:.list, headingLevel:0),
      MarkdownNode(range:NSRange(location : 157, length : 12), type:.link, headingLevel:0)
    ]
    expect(mardownNodes).to(equal(expectedMarkdownNodes))
  }
  
  static var allTests = [
    (
      "testRender", testRender,
      "testRenderWithOffset", testRenderWithOffset
     )
  ]
}
