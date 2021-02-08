//
//  MdRegex.swift
//  SampleApp
//
//  Created by Quentin Eude on 01/02/2021.
//

import Foundation
import SwiftUI

struct SwiftDownRule {
  let regex: NSRegularExpression

  let formattingRules: [SwiftyTextFormattingRule]

  init(regex: NSRegularExpression, formattingRule: SwiftyTextFormattingRule) {
    self.init(regex: regex, formattingRules: [formattingRule])
  }

  init(regex: NSRegularExpression, formattingRules: [SwiftyTextFormattingRule]) {
    self.regex = regex
    self.formattingRules = formattingRules
  }
}

extension SwiftDownRule {
  #if os(macOS)
    private static let headingTraits: NSFontDescriptor.SymbolicTraits = [.bold, .expanded]
    private static let codeFont = NSFont.monospacedSystemFont(
      ofSize: NSFont.systemFontSize, weight: .thin)
    private static let boldTraits: NSFontDescriptor.SymbolicTraits = [.bold]
    private static let emphasisTraits: NSFontDescriptor.SymbolicTraits = [.italic]
    private static let boldEmphasisTraits: NSFontDescriptor.SymbolicTraits = [.bold, .italic]
    private static let lighterColor = NSColor.lightGray
    private static let secondaryBackground = NSColor.windowBackgroundColor
    private static let textColor = NSColor.labelColor
  #else
    private static let headingTraits: UIFontDescriptor.SymbolicTraits = [
      .traitBold, .traitExpanded,
    ]
    private static let codeFont = UIFont.monospacedSystemFont(
      ofSize: UIFont.systemFontSize, weight: .thin)
    private static let boldTraits: UIFontDescriptor.SymbolicTraits = [.traitBold]
    private static let emphasisTraits: UIFontDescriptor.SymbolicTraits = [.traitItalic]
    private static let boldEmphasisTraits: UIFontDescriptor.SymbolicTraits = [
      .traitBold, .traitItalic,
    ]
    private static let lighterColor = UIColor.lightGray
    private static let secondaryBackground = UIColor.secondarySystemBackground
    private static let textColor = UIColor.label
  #endif

}

extension SwiftDownRule {
  static func h1(with font: SystemFontAlias) -> SwiftDownRule {
    return SwiftDownRule(
      regex: SwiftDownRegex.h1,
      formattingRules: [
        SwiftyTextFormattingRule(fontTraits: headingTraits),
        SwiftyTextFormattingRule(key: .kern, value: 0.5),
        SwiftyTextFormattingRule(key: .font, value: font.withSize(font.pointSize + 15)),
      ])
  }
  static func h2(with font: SystemFontAlias) -> SwiftDownRule {
    return SwiftDownRule(
      regex: SwiftDownRegex.h2,
      formattingRules: [
        SwiftyTextFormattingRule(fontTraits: headingTraits),
        SwiftyTextFormattingRule(key: .kern, value: 0.5),
        SwiftyTextFormattingRule(key: .font, value: font.withSize(font.pointSize + 8)),
      ])
  }
  static func h3(with font: SystemFontAlias) -> SwiftDownRule {
    return SwiftDownRule(
      regex: SwiftDownRegex.h3,
      formattingRules: [
        SwiftyTextFormattingRule(fontTraits: headingTraits),
        SwiftyTextFormattingRule(key: .kern, value: 0.5),
        SwiftyTextFormattingRule(key: .font, value: font.withSize(font.pointSize + 5)),
      ])
  }
  static func h4(with font: SystemFontAlias) -> SwiftDownRule {
    return SwiftDownRule(
      regex: SwiftDownRegex.h4,
      formattingRules: [
        SwiftyTextFormattingRule(fontTraits: headingTraits),
        SwiftyTextFormattingRule(key: .kern, value: 0.5),
        SwiftyTextFormattingRule(key: .font, value: font.withSize(font.pointSize + 2)),
      ])
  }
  static let h5 = SwiftDownRule(
    regex: SwiftDownRegex.h5,
    formattingRules: [
      SwiftyTextFormattingRule(fontTraits: headingTraits),
      SwiftyTextFormattingRule(key: .kern, value: 0.5),
    ]
  )
  static let h6 = SwiftDownRule(
    regex: SwiftDownRegex.h6,
    formattingRules: [
      SwiftyTextFormattingRule(fontTraits: headingTraits),
      SwiftyTextFormattingRule(key: .kern, value: 0.5),
    ]
  )

  static let inlineCode = SwiftDownRule(
    regex: SwiftDownRegex.inlineCode,
    formattingRule: SwiftyTextFormattingRule(
      key: .font,
      value: codeFont
    ))

  static let codeBlock = SwiftDownRule(
    regex: SwiftDownRegex.codeBlock,
    formattingRules: [
      SwiftyTextFormattingRule(key: .font, value: codeFont),
      SwiftyTextFormattingRule(key: .foregroundColor, value: lighterColor),
    ])

  static let html = SwiftDownRule(
    regex: SwiftDownRegex.html,
    formattingRules: [
      SwiftyTextFormattingRule(key: .font, value: codeFont),
      SwiftyTextFormattingRule(key: .foregroundColor, value: lighterColor),
    ])

  static let linkOrImage = SwiftDownRule(
    regex: SwiftDownRegex.linkOrImage,
    formattingRule: SwiftyTextFormattingRule(
      key: .underlineStyle, value: NSUnderlineStyle.single.rawValue)
  )
  static let linkOrImageTag = SwiftDownRule(
    regex: SwiftDownRegex.linkOrImageTag,
    formattingRule: SwiftyTextFormattingRule(
      key: .underlineStyle, value: NSUnderlineStyle.single.rawValue)
  )
  static let blockquote = SwiftDownRule(
    regex: SwiftDownRegex.blockquote,
    formattingRule: SwiftyTextFormattingRule(key: .backgroundColor, value: secondaryBackground)
  )
  static let bold = SwiftDownRule(
    regex: SwiftDownRegex.bold,
    formattingRule: SwiftyTextFormattingRule(fontTraits: boldTraits)
  )
  static let strikethrough = SwiftDownRule(
    regex: SwiftDownRegex.strikethrough,
    formattingRules: [
      SwiftyTextFormattingRule(
        key: .strikethroughStyle, value: NSUnderlineStyle.single.rawValue),
      SwiftyTextFormattingRule(key: .strikethroughColor, value: textColor),
    ]
  )
  static let underscoreEmphasis = SwiftDownRule(
    regex: SwiftDownRegex.underscoreEmphasis,
    formattingRule: SwiftyTextFormattingRule(fontTraits: emphasisTraits)
  )
  static let asteriskEmphasis = SwiftDownRule(
    regex: SwiftDownRegex.asteriskEmphasis,
    formattingRule: SwiftyTextFormattingRule(fontTraits: boldEmphasisTraits)
  )
  static let boldEmphasisAsterisk = SwiftDownRule(
    regex: SwiftDownRegex.boldEmphasisAsterisk,
    formattingRule: SwiftyTextFormattingRule(fontTraits: boldTraits)
  )

  static let unorderedList = SwiftDownRule(
    regex: SwiftDownRegex.unorderedList,
    formattingRule: SwiftyTextFormattingRule(key: .foregroundColor, value: lighterColor)
  )
  static let orderedList = SwiftDownRule(
    regex: SwiftDownRegex.orderedList,
    formattingRule: SwiftyTextFormattingRule(key: .foregroundColor, value: lighterColor))

  static let horizontalRule = SwiftDownRule(
    regex: SwiftDownRegex.horizontalRule,
    formattingRule: SwiftyTextFormattingRule(key: .foregroundColor, value: lighterColor))
  static let button = SwiftDownRule(
    regex: SwiftDownRegex.button,
    formattingRule: SwiftyTextFormattingRule(key: .foregroundColor, value: lighterColor))
  static let tag = SwiftDownRule(
    regex: SwiftDownRegex.tag,
    formattingRule: SwiftyTextFormattingRule(key: .foregroundColor, value: lighterColor))
  static let footnote = SwiftDownRule(
    regex: SwiftDownRegex.footnote,
    formattingRule: SwiftyTextFormattingRule(key: .foregroundColor, value: lighterColor))
}

struct SwiftDownRules {
  var font: SystemFontAlias

  var rules: [SwiftDownRule] {
    return [
      .h1(with: font),
      .h2(with: font),
      .h3(with: font),
      .h4(with: font),
      .h5,
      .h6,
      .inlineCode,
      .codeBlock,
      .html,
      .linkOrImage,
      .linkOrImageTag,
      .blockquote,
      .bold,
      .strikethrough,
      .underscoreEmphasis,
      .asteriskEmphasis,
      .boldEmphasisAsterisk,
      .unorderedList,
      .orderedList,
      .horizontalRule,
      .button,
      .tag,
      .footnote,
    ]
  }

}
