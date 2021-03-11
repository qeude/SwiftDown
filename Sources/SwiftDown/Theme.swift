//
//  Theme.swift
//
//
//  Created by Quentin Eude on 10/03/2021.
//

#if os(iOS)
  import UIKit
#elseif os(macOS)
  import AppKit
#endif

public struct Theme {
  public enum BuiltIn: String {
    case defaultDark = "default-dark"

    public func theme() -> Theme {
      return Theme(self.rawValue)
    }
  }

  var body: Style = Style()
  var backgroundColor: UniversalColor = UniversalColor.clear
  var tintColor: UniversalColor = UniversalColor.blue
  var cursorColor: UniversalColor = UniversalColor.blue
  var styles: [Style] = []

  init(_ name: String) {
    let bundle = Bundle.module

    guard let path = bundle.path(forResource: "Themes/\(name)", ofType: "json") else {
      print("[SwiftDown] Unable to load your theme file.")
      assertionFailure()
      return
    }

    if let data = convertFile(path) {
      configure(data)
    }
  }

  init(themePath: String) {
    if let data = convertFile(themePath) {
      configure(data)
    }
  }

  init() {}

  mutating func configure(_ data: [String: AnyObject]) {
    data.forEach { key, value in
      switch ConfigProperty.from(rawValue: key) {
      case .editor:
        if let editorStyles = value as? [String: String] {
          configureEditor(editorStyles)
        }
      case .styles:
        if let styles = value as? [String: AnyObject] {
          configureStyles(styles)
        }
      case .unknown:
        break
      }
    }
  }

  mutating private func configureStyles(_ attributes: [String: AnyObject]) {
    attributes.forEach { key, value in
      if let value = value as? [String: AnyObject],
        let style = configureStyle(value as [String: AnyObject])
      {
        if let regexString = attributes["regex"] as? String {
          let regex = regexString.toRegex()
          styles.append(Style(regex: regex, attributes: style))
        } else {

          if key == "body" {
            body.attributes = style
          } else {
            styles.append(Style(element: Element.from(string: key), attributes: style))
          }
        }
      }
    }
  }

  mutating private func configureStyle(_ attributes: [String: AnyObject]) -> [NSAttributedString
    .Key: Any]?
  {
    var stringAttributes: [NSAttributedString.Key: Any] = [:]
    var fontSize: CGFloat = 15
    var font: UniversalFont? = UniversalFont.systemFont(ofSize: fontSize)
    var fontTraits = ""
    attributes.forEach { key, value in
      switch StyleConfigProperty.from(rawValue: key) {
      case .color:
        if let color = value as? String {
          stringAttributes[NSAttributedString.Key.foregroundColor] = UniversalColor(
            hexString: color)
        }
      case .font:
        if let fontName = value as? String, fontName != "System" {
          font = UniversalFont(name: fontName, size: fontSize) ?? font
        }
      case .size:
        if let size = value as? CGFloat {
          fontSize = size
        }
      case .traits:
        if let traits = value as? String {
          fontTraits = traits
        }
      case .unknown:
        break
      }
    }
    font = font?.with(traits: fontTraits, size: fontSize)
    stringAttributes[NSAttributedString.Key.font] = font
    return stringAttributes
  }

  mutating private func configureEditor(_ attributes: [String: String]) {
    attributes.forEach { key, value in
      switch EditorConfigProperty.from(rawValue: key) {
      case .backgroundColor:
        backgroundColor = UniversalColor(hexString: value)
      case .tintColor:
        tintColor = UniversalColor(hexString: value)
      case .cursorColor:
        cursorColor = UniversalColor(hexString: value)
      case .unknown:
        break
      }
    }
  }

  func convertFile(_ path: String) -> [String: AnyObject]? {
    do {
      let json = try String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
      if let data = json.data(using: .utf8) {
        do {
          return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
        } catch let error as NSError {
          print(error)
        }
      }
    } catch let error as NSError {
      print(error)
    }

    return nil
  }
}
