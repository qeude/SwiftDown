import XCTest

@testable import SwiftDown

final class ThemeTests: XCTestCase {
  func testParsingTheme() {
    let theme = Theme.BuiltIn.defaultDark.theme()
    XCTAssertEqual(theme.backgroundColor, UniversalColor(hexString: "#1D1F21"))
    XCTAssertEqual(theme.tintColor, UniversalColor(hexString: "#A1A8B5"))
    XCTAssertEqual(theme.cursorColor, UniversalColor(hexString: "#A1A8B5"))
  }
  
  func testParsingThemeStyles() {
    let theme = Theme.BuiltIn.defaultDark.theme()
    XCTAssertEqual(theme.styles.count, 15)
  }
  
  static var allTests = [
    (
      "testParsingTheme", testParsingTheme,
      "testParsingThemeStyles", testParsingThemeStyles
     )
  ]
}
