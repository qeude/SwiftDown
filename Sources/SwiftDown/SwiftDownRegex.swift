//
//  SwiftDownRegex.swift
//  SampleApp
//
//  Created by Quentin Eude on 04/02/2021.
//

import Foundation

struct SwiftDownRegex {
  static let h1 = try! NSRegularExpression(pattern: "^#{1}\\s.*$", options: [.anchorsMatchLines])
  static let h2 = try! NSRegularExpression(pattern: "^#{2}\\s.*$", options: [.anchorsMatchLines])
  static let h3 = try! NSRegularExpression(pattern: "^#{3}\\s.*$", options: [.anchorsMatchLines])
  static let h4 = try! NSRegularExpression(pattern: "^#{4}\\s.*$", options: [.anchorsMatchLines])
  static let h5 = try! NSRegularExpression(pattern: "^#{5}\\s.*$", options: [.anchorsMatchLines])
  static let h6 = try! NSRegularExpression(pattern: "^#{6}\\s.*$", options: [.anchorsMatchLines])

  static let inlineCode = try! NSRegularExpression(pattern: "`[^`]*`", options: [])
  static let codeBlock = try! NSRegularExpression(
    pattern: "(`){3}((?!\\1).)+\\1{3}", options: [.dotMatchesLineSeparators])

  static let linkOrImage = try! NSRegularExpression(
    pattern: "!?\\[([^\\[\\]]*)\\]\\((.*?)\\)", options: [])
  static let linkOrImageTag = try! NSRegularExpression(
    pattern: "!?\\[([^\\[\\]]*)\\]\\[(.*?)\\]", options: [])

  static let bold = try! NSRegularExpression(pattern: "((\\*|_){2})((?!\\1).)+\\1", options: [])
  static let underscoreEmphasis = try! NSRegularExpression(
    pattern: "(?<!_)_[^_]+_(?!\\*)", options: [])
  static let asteriskEmphasis = try! NSRegularExpression(
    pattern: "(?<!\\*)(\\*)((?!\\1).)+\\1(?!\\*)", options: [])
  static let boldEmphasisAsterisk = try! NSRegularExpression(
    pattern: "(\\*){3}((?!\\1).)+\\1{3}", options: [])

  static let blockquote = try! NSRegularExpression(pattern: "^>.*", options: [.anchorsMatchLines])
  static let horizontalRule = try! NSRegularExpression(
    pattern: "\n\n(-{3}|\\*{3})\n", options: [])

  static let unorderedList = try! NSRegularExpression(
    pattern: "^(\\-|\\*)\\s", options: [.anchorsMatchLines])
  static let orderedList = try! NSRegularExpression(
    pattern: "^\\d*\\.\\s", options: [.anchorsMatchLines])

  static let button = try! NSRegularExpression(
    pattern: "<\\s*button[^>]*>(.*?)<\\s*/\\s*button>", options: [])
  static let strikethrough = try! NSRegularExpression(pattern: "(~)((?!\\1).)+\\1", options: [])
  static let tag = try! NSRegularExpression(
    pattern: "^\\[([^\\[\\]]*)\\]:", options: [.anchorsMatchLines])
  static let footnote = try! NSRegularExpression(pattern: "\\[\\^(.*?)\\]", options: [])
  static let html = try! NSRegularExpression(
    pattern: "<([A-Z][A-Z0-9]*)\\b[^>]*>(.*?)</\\1>",
    options: [.dotMatchesLineSeparators, .caseInsensitive])
}
