//
//  ISBN.swift
//  
//
//  Created by Rajee Jones on 6/21/21.
//

import Foundation

/// International Standard Book Number (ISBN) data type wrapper
public struct ISBN: Identifiable, Equatable, CustomStringConvertible {
    /// ISBN formats
    public enum ISBNFormat {

        case isbn10
        case isbn13

        internal func pattern() -> String {
            switch self {
            case .isbn10:
                return #"""
                (?<isbn10_Value>(?=[0-9X]{10}(?:\\s)|(?=(?:[0-9]+[-\\s]){3}[-\\s0-9X]{13}(?:\\s))[0-9]{1,5}[-\\s]?[0-9]+[-\\s]?[0-9]+[-\\s]?[0-9X])
                """#
            case .isbn13:
                return #"""
                (?<isbn13_Value>(?=[0-9]{13}(?:\\s)|(?=(?:[0-9]+[-\\s]){4})[-\\s0-9]{17}(?:\\s))97[89][-\\s]?[0-9]{1,5}[-\\s]?[0-9]+[-\\s]?[0-9]+[-\\s]?[0-9])
                """#
            }
        }
    }

    /// ISBN numerical raw value without dashes or spaces. i.e "9781595620156"
    public private(set) var rawNumericalValue: String

    /// ISBN formatted value with "ISBN" text as displayed on printed material . i.e "ISBN: 9781595620156"
    public var displayValue: String {
        return "ISBN: \(rawNumericalValue)"
    }

    /// `ISBNFormat` for this ISBN
    public private(set) var format: ISBNFormat

    /// Identifiable ID
    public var id: String {
        return rawNumericalValue
    }

    internal init(string: String, format: ISBNFormat) {
        self.rawNumericalValue = string.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
        self.format = format
    }

    public var description: String {
        return displayValue
    }

    public func convertedTo(format: ISBNFormat) -> String {
        guard self.format != format else {
            return rawNumericalValue
        }

        switch format {
        case .isbn10:
            // remove first 3 chars
            var body = String(rawNumericalValue.dropFirst(3))
            body = String(body.dropLast())

            return body + checksum(value: body, format: .isbn10)
        case .isbn13:
            // add 978
            var body = "978" + rawNumericalValue
            body = String(body.dropLast())

            return body + checksum(value: body, format: .isbn13)
        }

    }

    private func checksum(value: String, format: ISBNFormat) -> String {
        // raw value no spaces
        var sum = 0
        for (index, letter) in value.enumerated() {
            switch format {
            case .isbn10:
                let digit = 10 - index
                sum += digit * (Int(String(letter)) ?? 0)
            case .isbn13:
                let digit = index % 2 == 0 ? 1 : 3
                sum += digit * (Int(String(letter)) ?? 0)
            }
        }

        switch format {
        case .isbn10:
            let result = (11 - (sum % 11))
            return result == 11 ? "0" : (result == 10 ? "X" : String(result))
        case .isbn13:
            let result = (10 - (sum % 10))
            return result == 10 ? "0" : String(result)
        }
    }
}
