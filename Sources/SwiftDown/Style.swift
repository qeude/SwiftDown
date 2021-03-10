//
//  Style.swift
//
//
//  Created by Quentin Eude on 10/03/2021.
//

import Foundation

struct Style {
  var regex: NSRegularExpression!
  var attributes: [NSAttributedString.Key: Any] = [:]

  init(element: Element, attributes: [NSAttributedString.Key: Any]) {
    self.regex = element.regex
    self.attributes = attributes
  }

  init(regex: NSRegularExpression, attributes: [NSAttributedString.Key: Any]) {
    self.regex = regex
    self.attributes = attributes
  }

  init() {
    self.regex = Element.unknown.regex
  }
}
