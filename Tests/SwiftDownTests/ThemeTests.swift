import XCTest
import Nimble

@testable import SwiftDown

final class ThemeTests: XCTestCase {
  func testParsingTheme() {
    let theme = Theme.BuiltIn.defaultDark.theme()
    expect(theme.backgroundColor).to(equal(UniversalColor(hexString: "#1D1F21")))
    expect(theme.tintColor).to(equal(UniversalColor(hexString: "#A1A8B5")))
    expect(theme.cursorColor).to(equal(UniversalColor(hexString: "#A1A8B5")))
  }
  
  func testParsingThemeStyles() {
    let theme = Theme.BuiltIn.defaultDark.theme()
    expect(theme.styles).to(haveCount(15))
  }

  #if arch(x86_64)
  func testInitNonExistingFile() {
    expect {
      _ = Theme("non_existing_file")
    }.to(throwAssertion())
  }
  #endif
}
