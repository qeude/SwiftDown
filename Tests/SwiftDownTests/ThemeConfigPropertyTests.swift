import XCTest

@testable import SwiftDown

final class ThemConfigPropertyTests: XCTestCase {
  func testUnknowConfigProperty() {
    XCTAssertEqual(ConfigProperty.from(rawValue: "test"), .unknown)
  }
  
  func testUnknowEditorConfigProperty() {
    XCTAssertEqual(EditorConfigProperty.from(rawValue: "test"), .unknown)
  }
  
  func testUnknowStyleConfigPropertyProperty() {
    XCTAssertEqual(StyleConfigProperty.from(rawValue: "test"), .unknown)
  }
  
  func testUnknowTraitConfigPropertyPropertyProperty() {
    XCTAssertEqual(TraitConfigProperty.from(rawValue: "test"), .unknown)
  }
  
  static var allTests = [
    (
      "testUnknowConfigProperty", testUnknowConfigProperty,
      "testUnknowEditorConfigProperty", testUnknowEditorConfigProperty,
      "testUnknowStyleConfigPropertyProperty", testUnknowStyleConfigPropertyProperty,
      "testUnknowTraitConfigPropertyPropertyProperty", testUnknowTraitConfigPropertyPropertyProperty
     )
  ]
}
