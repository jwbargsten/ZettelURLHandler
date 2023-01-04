//
//  ZettelURLHandlerTests.swift
//  ZettelURLHandlerTests
//
//  Created by Joachim Bargsten on 04/01/2023.
//

import XCTest
@testable import ZettelURLHandler

final class ZettelURLHandlerTests: XCTestCase {
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func test1() throws {
    let actual = URL(string: "zettel://abc/def").flatMap { extractZettelLocation(url: $0) }!
    XCTAssertEqual(actual.0, "abc")
    XCTAssertEqual(actual.1, "def")
  }

  func test2() throws {
    XCTAssertNil(extractZettelLocation(url: URL(string: "zettel:///abc/def/ghi")!))
    XCTAssertNil(extractZettelLocation(url: URL(string: "zettel://abc/..")!))
    XCTAssertNil(extractZettelLocation(url: URL(string: "zettel://&/a")!))
    XCTAssertNil(extractZettelLocation(url: URL(string: "zettel:///")!))
    XCTAssertNil(extractZettelLocation(url: URL(string: "zettel://")!))
    XCTAssertNil(extractZettelLocation(url: URL(string: "zettel://a/a=b")!))
    XCTAssertNil(extractZettelLocation(url: URL(string: "abc/def")!))
  }

  func test3() throws {
    XCTAssertEqual(try? getConfigFilePath(), URL(filePath: "/Users/jwb/.config/zettel.yaml"))
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }
}
