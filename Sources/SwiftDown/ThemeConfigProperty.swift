//
//  ThemeConfigProperty.swift
//
//
//  Created by Quentin Eude on 10/03/2021.
//

import Foundation

// MARK: - ConfigProperty
enum ConfigProperty {
  case editor
  case styles
  case unknown

  static func from(rawValue: String) -> ConfigProperty {
    return mapping[rawValue] ?? .unknown
  }

  private static let mapping: [String: ConfigProperty] = [
    "editor": .editor,
    "styles": .styles
  ]

}

// MARK: - EditorConfigProperty
enum EditorConfigProperty {
  case backgroundColor
  case tintColor
  case cursorColor
  case unknown

  static func from(rawValue: String) -> EditorConfigProperty {
    return mapping[rawValue] ?? .unknown
  }

  private static let mapping: [String: EditorConfigProperty] = [
    "backgroundColor": .backgroundColor,
    "tintColor": .tintColor,
    "cursorColor": .cursorColor
  ]
}

// MARK: - StyleConfigProperty
enum StyleConfigProperty {
  case font
  case size
  case color
  case traits
  case unknown

  static func from(rawValue: String) -> StyleConfigProperty {
    return mapping[rawValue] ?? .unknown
  }

  private static let mapping: [String: StyleConfigProperty] = [
    "font": .font,
    "size": .size,
    "color": .color,
    "traits": .traits
  ]
}

// MARK: - TraitConfigProperty
enum TraitConfigProperty {
  case bold
  case italic
  case expanded
  case condensed
  case unknown

  static func from(rawValue: String) -> TraitConfigProperty {
    return mapping[rawValue] ?? .unknown
  }

  private static let mapping: [String: TraitConfigProperty] = [
    "bold": .bold,
    "italic": .italic,
    "expanded": .expanded,
    "condensed": .condensed
  ]

}
