//
//  SwiftyMd.swift
//  SampleApp
//
//  Created by Quentin Eude on 04/02/2021.
//

#if os(macOS)
  import AppKit

  typealias SystemFontAlias = NSFont
  typealias SystemColorAlias = NSColor
  typealias SymbolicTraits = NSFontDescriptor.SymbolicTraits

  let defaultEditorFont = NSFont.systemFont(ofSize: NSFont.systemFontSize)
  let defaultEditorTextColor = NSColor.labelColor
#elseif os(iOS)
  import UIKit

  typealias SystemFontAlias = UIFont
  typealias SystemColorAlias = UIColor
  typealias SymbolicTraits = UIFontDescriptor.SymbolicTraits

  let defaultEditorFont = UIFont.preferredFont(forTextStyle: .body)
  let defaultEditorTextColor = UIColor.label
#endif

struct SwiftDown {
  private var font: SystemFontAlias
  private var fontColor: SystemColorAlias

  private var rules: [SwiftDownRule]

  init() {
    self.init(font: defaultEditorFont, fontColor: defaultEditorTextColor)
  }

  private init(font: SystemFontAlias? = nil, fontColor: SystemColorAlias? = nil) {
    self.font = font ?? defaultEditorFont
    self.fontColor = fontColor ?? defaultEditorTextColor
    self.rules = SwiftDownRules(font: self.font).rules
    print("toto")
  }

  func getFormattedText(from string: String) -> NSMutableAttributedString {
    let formattedString = NSMutableAttributedString(string: string)
    let all = NSRange(location: 0, length: string.count)

    formattedString.addAttribute(.font, value: self.font, range: all)
    formattedString.addAttribute(.foregroundColor, value: self.fontColor, range: all)

    rules.forEach { rule in
      let matches = rule.regex.matches(in: string, options: [], range: all)
      matches.forEach { match in
        rule.formattingRules.forEach { formattingRule in
          var font = SystemFontAlias()
          formattedString.enumerateAttributes(in: match.range, options: []) {
            attributes, range, stop in
            let fontAttribute = attributes.first { $0.key == .font }!
            let previousFont = fontAttribute.value as! SystemFontAlias
            font = previousFont.with(formattingRule.fontTraits)
          }
          formattedString.addAttribute(.font, value: font, range: match.range)
          guard let key = formattingRule.key, let value = formattingRule.value else {
            return
          }
          formattedString.addAttribute(key, value: value, range: match.range)
        }
      }

    }
    return formattedString
  }

  func set(bodySize: CGFloat) -> SwiftDown {
    return SwiftDown(font: self.font.withSize(bodySize), fontColor: self.fontColor)
  }

  func set(fontColor: SystemColorAlias) -> SwiftDown {
    return SwiftDown(font: self.font, fontColor: fontColor)
  }
}

struct SwiftyTextFormattingRule {
  let key: NSAttributedString.Key?
  let value: Any?
  let fontTraits: SymbolicTraits

  public init(key: NSAttributedString.Key, value: Any) {
    self.init(key: key, value: value, fontTraits: [])
  }

  public init(fontTraits: SymbolicTraits) {
    self.init(key: nil, value: nil, fontTraits: fontTraits)
  }

  init(key: NSAttributedString.Key? = nil, value: Any? = nil, fontTraits: SymbolicTraits = []) {
    self.key = key
    self.value = value
    self.fontTraits = fontTraits
  }
}
