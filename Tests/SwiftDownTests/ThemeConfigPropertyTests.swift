import XCTest
import Nimble

@testable import SwiftDown

final class ThemConfigPropertyTests: XCTestCase {
  func testUnknowConfigProperty() {
    expect(ConfigProperty.from(rawValue: "test")).to(equal(.unknown))
  }
  
  func testUnknowEditorConfigProperty() {
    expect(EditorConfigProperty.from(rawValue: "test")).to(equal(.unknown))
  }
  
  func testUnknowStyleConfigPropertyProperty() {
    expect(StyleConfigProperty.from(rawValue: "test")).to(equal(.unknown))
  }
  
  func testUnknowTraitConfigPropertyPropertyProperty() {
    expect(TraitConfigProperty.from(rawValue: "test")).to(equal(.unknown))
  }
}
