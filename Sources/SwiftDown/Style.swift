//
//  Style.swift
//
//
//  Created by Quentin Eude on 10/03/2021.
//

import Foundation

public struct Style {
  var attributes: [NSAttributedString.Key: Any] = [:]

  init(attributes: [NSAttributedString.Key: Any]) {
    self.attributes = attributes
  }

  init() {}
}
