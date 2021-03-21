//
//  MarkdownNode.swift
//
//
//  Created by Quentin Eude on 16/03/2021.
//

import Down
import Foundation

public struct MarkdownNode: Equatable {
  public let range: NSRange
  public let rawType: Int
  public let type: MarkdownType
  public let headingLevel: Int

  public init(range: NSRange, type: MarkdownType, headingLevel: Int = 0) {
    self.range = range
    self.rawType = type.rawValue
    self.type = type
    self.headingLevel = headingLevel
  }

  // MARK: - MarkdownType
  public enum MarkdownType: Equatable, CaseIterable {
    case quote
    case list
    case codeBlock
    case header1
    case header2
    case header3
    case header4
    case header5
    case header6
    case code
    case italic
    case bold
    case link
    case image
    case body

    var rawValue: Int {
      switch self {
      case .quote: return 2
      case .list: return 4
      case .codeBlock: return 5
      case .header1: return 9
      case .header2: return 9
      case .header3: return 9
      case .header4: return 9
      case .header5: return 9
      case .header6: return 9
      case .code: return 14
      case .italic: return 17
      case .bold: return 18
      case .link: return 19
      case .image: return 20
      case .body: return 21
      }
    }

    static func from(rawValue: Int, with headingLevel: Int) -> MarkdownType? {
      switch rawValue {
      case 2: return MarkdownType.quote
      case 4: return MarkdownType.list
      case 5: return MarkdownType.codeBlock
      case 9: return MarkdownType.header(for: headingLevel)
      case 14: return MarkdownType.code
      case 17: return MarkdownType.italic
      case 18: return MarkdownType.bold
      case 19: return MarkdownType.link
      case 20: return MarkdownType.image
      case 21: return MarkdownType.body
      default: return nil
      }
    }

    private static func header(for headingLevel: Int) -> MarkdownType {
      switch headingLevel {
      case 1: return header1
      case 2: return header2
      case 3: return header3
      case 4: return header4
      case 5: return header5
      case 6: return header6
      default: return header3
      }
    }

    static func from(string: String) -> MarkdownType? {
      switch string {
      case "body": return MarkdownType.body
      case "h1": return MarkdownType.header1
      case "h2": return MarkdownType.header2
      case "h3": return MarkdownType.header3
      case "h4": return MarkdownType.header4
      case "h5": return MarkdownType.header5
      case "h6": return MarkdownType.header6
      case "inlineCode": return MarkdownType.code
      case "codeBlock": return MarkdownType.codeBlock
      case "link": return MarkdownType.link
      case "image": return MarkdownType.image
      case "bold": return MarkdownType.bold
      case "italic": return MarkdownType.italic
      case "blockQuote": return MarkdownType.quote
      case "list": return MarkdownType.list
      default: return nil
      }
    }
  }
}
