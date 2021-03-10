//
//  Editor.swift
//
//
//  Created by Quentin Eude on 10/03/2021.
//
#if os(iOS)
  import UIKit
#elseif os(macOS)
  import AppKit
#endif

class Editor: NSTextStorage {
  var theme: Theme? {
    didSet {
      let wholeRange = NSRange(location: 0, length: (self.string as NSString).length)

      self.beginEditing()
      self.applyStyles(wholeRange)
      self.edited(.editedAttributes, range: wholeRange, changeInLength: 0)
      self.endEditing()
    }
  }

  var backingStore = NSTextStorage()

  override var string: String {
    return backingStore.string
  }

  override init() {
    super.init()
  }

  override init(attributedString attrStr: NSAttributedString) {
    super.init(attributedString: attrStr)
    backingStore.setAttributedString(attrStr)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  required init(itemProviderData data: Data, typeIdentifier: String) throws {
    fatalError("init(itemProviderData:typeIdentifier:) has not been implemented")
  }

  #if os(macOS)
    required init?(pasteboardPropertyList propertyList: Any, ofType type: String) {
      fatalError("init(pasteboardPropertyList:ofType:) has not been implemented")
    }

    required init?(
      pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType
    ) {
      fatalError("init(pasteboardPropertyList:ofType:) has not been implemented")
    }
  #endif

  override func attributes(
    at location: Int, longestEffectiveRange range: NSRangePointer?, in rangeLimit: NSRange
  ) -> [NSAttributedString.Key: Any] {
    return backingStore.attributes(at: location, longestEffectiveRange: range, in: rangeLimit)
  }

  override func replaceCharacters(in range: NSRange, with str: String) {
    self.beginEditing()
    backingStore.replaceCharacters(in: range, with: str)
    let len = (str as NSString).length
    let change = len - range.length
    self.edited([.editedCharacters, .editedAttributes], range: range, changeInLength: change)
    self.endEditing()
  }

  override func setAttributes(_ attrs: [NSAttributedString.Key: Any]?, range: NSRange) {
    self.beginEditing()
    backingStore.setAttributes(attrs, range: range)
    self.edited(.editedAttributes, range: range, changeInLength: 0)
    self.endEditing()
  }

  override func attributes(at location: Int, effectiveRange range: NSRangePointer?)
    -> [NSAttributedString.Key: Any]
  {
    return backingStore.attributes(at: location, effectiveRange: range)
  }

  override func processEditing() {
    let backingString = backingStore.string
    if let nsRange = backingString.range(from: NSMakeRange(NSMaxRange(editedRange), 0)) {
      let indexRange = backingString.lineRange(for: nsRange)
      let extendedRange: NSRange = NSUnionRange(
        editedRange, backingString.nsRange(from: indexRange))
      applyStyles(extendedRange)
    }
    super.processEditing()
  }

  func applyStyles(_ range: NSRange) {
    guard let theme = self.theme else { return }

    let backingString = backingStore.string
    backingStore.setAttributes(theme.body.attributes, range: range)

    theme.styles.forEach { style in
      style.regex.enumerateMatches(
        in: backingString, options: .withoutAnchoringBounds, range: range,
        using: { (match, flags, stop) in
          guard let match = match else { return }
          backingStore.addAttributes(style.attributes, range: match.range(at: 0))
        })
    }
  }
}
