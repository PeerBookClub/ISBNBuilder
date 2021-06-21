import Foundation

/// Validator for validating formats of a `ISBN`
public final class ISBNBuilder {
    public enum ISBNError: Error {
        case notFound
        case invalid(value: String)
    }

    internal enum ValidationFormat {
        case explicit
        case nonExplicit

        func pattern() -> String {
            switch self {
            case .explicit:
                return #"""
                (?:(?<isbn10Text>(?<isbn10Identifier>ISBN(?:-10)?:?\s?)(?<isbn10Value>(?=[0-9X]{10}(?:\s|$)|(?=(?:[0-9]+[-\s]){3})[-\s0-9X]{13}(?:\s|$))[0-9]{1,5}[-\s]?[0-9]+[-\s]?[0-9]+[-\s]?[0-9X]))|(?<isbn13Text>(?<isbn13Identifier>ISBN(?:-13)?:?\s?)(?<isbn13Value>(?=[0-9]{13}(?:\s|$)|(?=(?:[0-9]+[-\s]){4})[-\s0-9]{17}(?:\s|$))97[89][-\s]?[0-9]{1,5}[-\s]?[0-9]+[-\s]?[0-9]+[-\s]?[0-9])))
                """#
            case .nonExplicit:
                return  #"(?:(?<isbn10Value>(?=[0-9X]{10}(?:\s|$)|(?=(?:[0-9]+[-\s]){3})[-\s0-9X]{13}(?:\s|$))[0-9]{1,5}[-\s]?[0-9]+[-\s]?[0-9]+[-\s]?[0-9X])|(?<isbn13Value>(?=[0-9]{13}(?:\s|$)|(?=(?:[0-9]+[-\s]){4})[-\s0-9]{17}(?:\s|$))97[89][-\s]?[0-9]{1,5}[-\s]?[0-9]+[-\s]?[0-9]+[-\s]?[0-9]))"#
            }
        }
    }

    internal enum NamedCaptureGroup: String, RawRepresentable, CaseIterable {
        case isbn10Text
        case isbn13Text
        case isbn10Identifier
        case isbn13Identifier
        case isbn10Value
        case isbn13Value

        public var isbnFormat: ISBN.ISBNFormat {
            switch self {
            case .isbn10Text:
                return .isbn10
            case .isbn13Text:
                return .isbn13
            case .isbn10Identifier:
                return .isbn10
            case .isbn13Identifier:
                return .isbn13
            case .isbn10Value:
                return .isbn10
            case .isbn13Value:
                return .isbn13
            }
        }
    }

    /// Checks for validity of an International Standard Book Number and creates `ISBN` based on input
    /// - Parameter rawValue: Raw String of the ISBN value to validate
    /// - Returns: `Result<ISBN, ISBNError>` of the result of the found `ISBN`
    public static func buildISBN(rawValue: String) -> Result<ISBN, ISBNError> {
        let range = NSRange(
            rawValue.startIndex..<rawValue.endIndex,
            in: rawValue
        )

        let explicitRegex = try! NSRegularExpression(pattern: ValidationFormat.explicit.pattern(), options: [])
        let looseRegex = try! NSRegularExpression(pattern: ValidationFormat.nonExplicit.pattern(), options: [])

        var match: NSTextCheckingResult

        if let explicitMatch = explicitRegex.firstMatch(in: rawValue, options: [], range: range) {
            match = explicitMatch
        }
        else if let nonExplicitMatch = looseRegex.firstMatch(in: rawValue, options: [], range: range) {
            match = nonExplicitMatch
        } else {
            // Handle error
            return .failure(.notFound)
        }

        // Extract the value
        if let isbn10SubstringRange = Range(match.range(withName: NamedCaptureGroup.isbn10Value.rawValue), in: rawValue) {
            return .success(ISBN(string: String(rawValue[isbn10SubstringRange]), format: .isbn10))
        } else if let isbn13SubstringRange = Range(match.range(withName: NamedCaptureGroup.isbn13Value.rawValue), in: rawValue) {
            return .success(ISBN(string: String(rawValue[isbn13SubstringRange]), format: .isbn13))
        } else {
            return .failure(.notFound)
        }
    }
}
