//
//  Element.swift
//
//
//  Created by Quentin Eude on 10/03/2021.
//

import Foundation

struct Element {
  var regex: NSRegularExpression

  static let unknown = Element(regex: try! NSRegularExpression(pattern: "x^", options: []))

  static let body = Element(regex: try! NSRegularExpression(pattern: ".*", options: []))

  static let h1 = Element(
    regex: try! NSRegularExpression(pattern: "^#{1}\\s.*$", options: [.anchorsMatchLines]))
  static let h2 = Element(
    regex: try! NSRegularExpression(pattern: "^#{2}\\s.*$", options: [.anchorsMatchLines]))
  static let h3 = Element(
    regex: try! NSRegularExpression(pattern: "^#{3}\\s.*$", options: [.anchorsMatchLines]))
  static let h4 = Element(
    regex: try! NSRegularExpression(pattern: "^#{4}\\s.*$", options: [.anchorsMatchLines]))
  static let h5 = Element(
    regex: try! NSRegularExpression(pattern: "^#{5}\\s.*$", options: [.anchorsMatchLines]))
  static let h6 = Element(
    regex: try! NSRegularExpression(pattern: "^#{6}\\s.*$", options: [.anchorsMatchLines]))

  static let inlineCode = Element(regex: try! NSRegularExpression(pattern: "`[^`]*`", options: []))
  static let codeBlock = Element(
    regex: try! NSRegularExpression(
      pattern: "(`){3}((?!\\1).)+\\1{3}", options: [.dotMatchesLineSeparators]))

  static let linkOrImage = Element(
    regex: try! NSRegularExpression(pattern: "!?\\[([^\\[\\]]*)\\]\\((.*?)\\)", options: []))

  static let bold = Element(
    regex: try! NSRegularExpression(pattern: "((\\*|_){2})((?!\\1).)+\\1", options: []))
  static let strikethrough = Element(
    regex: try! NSRegularExpression(pattern: "(~)((?!\\1).)+\\1", options: []))
  static let italic = Element(
    regex: try! NSRegularExpression(
      pattern: "(?<!_)_[^_]+_(?!\\*)|(?<!\\*)(\\*)((?!\\1).)+\\1(?!\\*)", options: []))
  static let boldItalic = Element(
    regex: try! NSRegularExpression(pattern: "(\\*){3}((?!\\1).)+\\1{3}", options: []))

  static let blockquote = Element(
    regex: try! NSRegularExpression(pattern: "^>.*", options: [.anchorsMatchLines]))

  static let unorderedList = Element(
    regex: try! NSRegularExpression(pattern: "^(\\-|\\*)\\s", options: [.anchorsMatchLines]))
  static let orderedList = Element(
    regex: try! NSRegularExpression(pattern: "^\\d*\\.\\s", options: [.anchorsMatchLines]))

  static let html = Element(
    regex: try! NSRegularExpression(
      pattern: "<([A-Z][A-Z0-9]*)\\b[^>]*>(.*?)</\\1>",
      options: [.dotMatchesLineSeparators, .caseInsensitive]))

  static func from(string: String) -> Element {
    switch string {
    case "unknown": return Element.unknown
    case "body": return Element.body
    case "h1": return Element.h1
    case "h2": return Element.h2
    case "h3": return Element.h3
    case "h4": return Element.h4
    case "h5": return Element.h5
    case "h6": return Element.h6
    case "inlineCode": return Element.inlineCode
    case "codeBlock": return Element.codeBlock
    case "linkOrImage": return Element.linkOrImage
    case "bold": return Element.bold
    case "strikethrough": return Element.strikethrough
    case "italic": return Element.italic
    case "boldItalic": return Element.boldItalic
    case "blockquote": return Element.blockquote
    case "unorderedList": return Element.unorderedList
    case "orderedList": return Element.orderedList
    case "html": return Element.html
    default: return Element.unknown
    }
  }
}
