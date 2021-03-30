import XCTest

@testable import SwiftDown

final class UtilsTests: XCTestCase {
  func testColorFrom12bitsHexa() {
    let color = UniversalColor(hexString: "#E0D")
    XCTAssertEqual(color, UniversalColor(red: 238/255, green: 0, blue: 221/255, alpha: 1))
  }
  
  func testColorFrom24bitsHexa() {
    let color = UniversalColor(hexString: "#F703EC")
    XCTAssertEqual(color, UniversalColor(red: 247/255, green: 3/255, blue: 236/255, alpha: 1))
  }
  
  func testColorFrom32bitsHexa() {
    let color = UniversalColor(hexString: "#FF8D73AD")
    XCTAssertEqual(color, UniversalColor(red: 141/255, green: 115/255, blue: 173/255, alpha: 1))
  }
  
  func testColorFromHexaFallback() {
    let color = UniversalColor(hexString: "#F3")
    XCTAssertEqual(color, UniversalColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1))
  }
  
  func testNSRangeFromRange() {
    let string = "Test string"
    let range = string.range(of: "str")
    let nsRange = string.nsRange(from: range!)
    XCTAssertEqual(nsRange, NSRange(location: 5, length: 3))
  }
  
  func testRangeFromNSRange() {
    let string = "Test string"
    let nsRange = NSRange(location: 5, length: 3)
    let range = string.range(from: nsRange)
    let expectedRange = string.range(of: "str")
    XCTAssertEqual(range, expectedRange)
  }
  
  func testGetParagraph() {
    let string = "Test string \n\n Test string second line \n\n Test string third line"
    let range = NSRange(location: 29, length: 6)
    let paragraphRange = string.paragraph(for: range)
    XCTAssertEqual(paragraphRange, NSRange(location: 14, length: 25))
  }
  
  func testGetParagraphFirstParagraph() {
    let string = "Test string \n\n Test string second line \n\n Test string third line"
    let range = NSRange(location: 5, length: 6)
    let paragraphRange = string.paragraph(for: range)
    XCTAssertEqual(paragraphRange, NSRange(location: 0, length: 12))
  }
  
  func testGetParagraphLastParagraph() {
    let string = "Test string \n\n Test string second line \n\n Test string third line"
    let range = NSRange(location: 51, length: 6)
    let paragraphRange = string.paragraph(for: range)
    XCTAssertEqual(paragraphRange, NSRange(location: 41, length: 23))
  }
  
  func testGetParagraphRangeNil() {
    let string = "Test string \n\n Test string second line \n\n Test string third line"
    let range = string.paragraph(for: nil)
    XCTAssertEqual(range, NSRange(location: 0, length: string.utf16.count))
  }
  
  
  func testFontFromTraitsAndSize() {
    let font = UniversalFont.systemFont(ofSize: 14)
    let updatedFont = font.with(traits: "bold", size: 16)
    XCTAssertEqual(updatedFont?.fontDescriptor.pointSize, 16)
    XCTAssertEqual(updatedFont?.fontDescriptor.symbolicTraits.rawValue, font.fontDescriptor.symbolicTraits.rawValue + UniversalFontDescriptor.SymbolicTraits.bold.rawValue)
  }
  
  func testFontFromTraitsAndSizeWithUnknownTraits() {
    let font = UniversalFont.systemFont(ofSize: 14)
    let updatedFont = font.with(traits: "test", size: 16)
    XCTAssertEqual(updatedFont?.fontDescriptor.pointSize, 16)
    XCTAssertEqual(updatedFont?.fontDescriptor.symbolicTraits.rawValue, font.fontDescriptor.symbolicTraits.rawValue)
  }

  static var allTests = [
    ("testColorFrom12bitsHexa", testColorFrom12bitsHexa,
     "testColorFrom24bitsHexa", testColorFrom24bitsHexa,
     "testColorFrom32bitsHexa", testColorFrom32bitsHexa,
     "testColorFromHexaFallback", testColorFromHexaFallback,
     "testNSRangeFromRange", testNSRangeFromRange,
     "testRangeFromNSRange", testRangeFromNSRange,
     "testGetParagraph", testGetParagraph,
     "testGetParagraphFirstParagraph", testGetParagraphFirstParagraph,
     "testGetParagraphLastParagraph", testGetParagraphLastParagraph,
     "testGetParagraphRangeNil", testGetParagraphRangeNil,
     "testFontFromTraitsAndSize", testFontFromTraitsAndSize,
     "testFontFromTraitsAndSizeWithUnknownTraits", testFontFromTraitsAndSizeWithUnknownTraits
     )
  ]
}
