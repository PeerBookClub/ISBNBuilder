import XCTest
@testable import ISBNBuilder

final class ISBNBuilderTests: XCTestCase {
    func testValidISBN10() throws {
        let input = "ISBN: 0-596-52068-9"
        let result = ISBNBuilder.buildISBN(rawValue: input)
        let expected = "ISBN: 0596520689"

        switch result {
        case .success(let isbn):
            XCTAssert(isbn.displayValue == expected)
        case .failure:
            XCTFail()
        }
    }

    func testValidISBN10_Alt1() throws {
        let input = "ISBN 0-596-52068-9"
        let result = ISBNBuilder.buildISBN(rawValue: input)
        let expected = "ISBN: 0596520689"

        switch result {
        case .success(let isbn):
            XCTAssert(isbn.displayValue == expected)
        case .failure:
            XCTFail()
        }
    }

    func testValidISBN10_Alt2() throws {
        let input = "0-596-52068-9"
        let result = ISBNBuilder.buildISBN(rawValue: input)
        let expected = "ISBN: 0596520689"

        switch result {
        case .success(let isbn):
            XCTAssert(isbn.displayValue == expected)
        case .failure:
            XCTFail()
        }
    }

    func testValidConversion() throws {
        let input = "0-596-52068-9"
        let isbn = ISBN(string: input, format: .isbn10)
        let expected = "9780596520687"

        XCTAssert(isbn.convertedTo(format: .isbn10) == "0596520689")
        let isbn13Value = isbn.convertedTo(format: .isbn13)
        let isbn10Value = isbn.convertedTo(format: .isbn10)

        XCTAssert(isbn13Value == expected)
        XCTAssert(isbn10Value == "0596520689")
    }

    func testValidISBN10_Alt3() throws {
        let input = "0596520689"
        let result = ISBNBuilder.buildISBN(rawValue: input)
        let expected = "ISBN: 0596520689"

        switch result {
        case .success(let isbn):
            XCTAssert(isbn.displayValue == expected)
        case .failure:
            XCTFail()
        }
    }

    func testInValidISBN10() throws {
        let expected = "ISBN-10 0-596dadf-52068-9"
        let result = ISBNBuilder.buildISBN(rawValue: expected)

        switch result {
        case .success:
            XCTFail()
        case .failure:
            print("Expected")
        }
    }

    func testValidISBN13() throws {
        let input = "ISBN 978-0-596-52068-7"
        let result = ISBNBuilder.buildISBN(rawValue: input)
        let expected = "ISBN: 9780596520687"

        switch result {
        case .success(let isbn):
            XCTAssert(isbn.displayValue == expected)
            XCTAssert(isbn.format == .isbn13)
        case .failure:
            XCTFail()
        }
    }

}
