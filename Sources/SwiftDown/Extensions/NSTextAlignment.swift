//
//  NSTextAlignment.swift
//  SampleApp
//
//  Created by Quentin Eude on 01/02/2021.
//
import Foundation
import SwiftUI

#if os(macOS)
  import AppKit
  typealias LayoutDirection = NSUserInterfaceLayoutDirection
#else
  import UIKit
  typealias LayoutDirection = UIUserInterfaceLayoutDirection
#endif

extension NSTextAlignment {
  internal init(
    textAlignment: TextAlignment, userInterfaceLayoutDirection direction: LayoutDirection
  ) {
    switch textAlignment {
    case .center:
      self.init(rawValue: NSTextAlignment.center.rawValue)!
    case .leading:
      self.init(rawValue: NSTextAlignment.natural.rawValue)!
    case .trailing:
      if direction == .leftToRight {
        self.init(rawValue: NSTextAlignment.right.rawValue)!
      } else {
        self.init(rawValue: NSTextAlignment.left.rawValue)!
      }
    }
  }
}
