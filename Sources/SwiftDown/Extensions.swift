//
//  Extensions.swift
//
//
//  Created by Quentin Eude on 10/03/2021.
//

import Foundation

#if os(iOS)
  import struct UIKit.CGFloat
#elseif os(macOS)
  import struct AppKit.CGFloat
#endif

extension UniversalColor {
  convenience init(hexString: String) {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt64()
    Scanner(string: hex).scanHexInt64(&int)
    let a: UInt64
    let r: UInt64
    let g: UInt64
    let b: UInt64
    switch hex.count {
    case 3:  // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6:  // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8:  // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    self.init(
      red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255,
      alpha: CGFloat(a) / 255)
  }
}

extension String {
  func nsRange(from range: Range<String.Index>) -> NSRange {
    let from = range.lowerBound.samePosition(in: utf16)
    let to = range.upperBound.samePosition(in: utf16)
    return NSRange(
      location: utf16.distance(from: utf16.startIndex, to: from!),
      length: utf16.distance(from: from!, to: to!))
  }

  func range(from nsRange: NSRange) -> Range<String.Index>? {
    guard
      let from16 = utf16.index(
        utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
      let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
      let from = String.Index(from16, within: self),
      let to = String.Index(to16, within: self)
    else { return nil }
    return from..<to
  }

  func paragraph(for editedRange: NSRange?) -> NSRange {
    guard let editedRange = editedRange else {
      return NSRange(location: 0, length: self.utf16.count)
    }
    let beforeEditingRange = self.range(from: NSRange(location: 0, length: editedRange.lowerBound))
    let afterEditingLength = self.utf16.count - editedRange.upperBound
    let afterEditingRange = self.range(
      from: NSRange(location: editedRange.upperBound, length: afterEditingLength)
    )
    var startPosition = 0
    var endPosition = self.utf16.count
    if let startPositionRange = self.range(of: "\n\n", options: .backwards, range: beforeEditingRange) {
      startPosition = self.nsRange(from: startPositionRange).upperBound
    }
    if let endPositionRange = self.range(of: "\n\n", range: afterEditingRange) {
      endPosition = self.nsRange(from: endPositionRange).lowerBound
    }
    let length = endPosition - startPosition
    return NSRange(location: startPosition, length: length)
  }
}

extension UniversalFont {
  func with(traits: String, size: CGFloat) -> UniversalFont? {
    guard let traits = getTraits(from: TraitConfigProperty.from(rawValue: traits)) else {
      return self.withSize(size)
    }

    let descriptor =
      fontDescriptor.withSymbolicTraits(traits) ?? UniversalFontDescriptor(fontAttributes: [:])

    return UniversalFont(descriptor: descriptor, size: size)
  }

  private func getTraits(from traits: TraitConfigProperty) -> UniversalTraits? {
    #if os(iOS)
      switch traits {
      case .italic: return .traitItalic
      case .bold: return .traitBold
      case .expanded: return .traitExpanded
      case .condensed: return .traitCondensed
      default: return nil
      }
    #elseif os(macOS)
      switch traits {
      case .italic: return .italic
      case .bold: return .bold
      case .expanded: return .expanded
      case .condensed: return .condensed
      default: return nil
      }
    #endif
  }
}
