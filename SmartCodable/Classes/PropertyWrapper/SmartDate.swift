//
//  SmartDate.swift
//  SmartCodable
//
//  Created by qixin on 2025/4/30.
//

import Foundation
import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

@propertyWrapper
public struct SmartDate: Codable {
    public var wrappedValue: Date?
    private var encodeFormat: DateEncodeFormat?

    public init(wrappedValue: Date?, encodeFormat: DateEncodeFormat? = nil) {
        self.wrappedValue = wrappedValue
        self.encodeFormat = encodeFormat
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let timestamp = try? container.decode(Double.self) {
            // 判断是否为毫秒
            if timestamp > 1_000_000_000_000 {
                self.wrappedValue = Date(timeIntervalSince1970: timestamp / 1000)
                self.encodeFormat = .timestampMilliseconds
            } else {
                self.wrappedValue = Date(timeIntervalSince1970: timestamp)
                self.encodeFormat = .timestamp
            }
            return
        }

        let raw = try container.decode(String.self)
        guard let (date, format) = SmartDate.detectAndParse(from: raw) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported date format: '\(raw)'")
        }
        self.wrappedValue = date
        
        
        if encodeFormat == nil {
            self.encodeFormat = format
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        guard let date = wrappedValue else {
            return try container.encodeNil()
        }

        let format = encodeFormat ?? .iso8601
        
        switch format {
        case .timestamp:
            try container.encode(date.timeIntervalSince1970)
        case .timestampMilliseconds:
            try container.encode(Int(date.timeIntervalSince1970 * 1000))
        case .iso8601:
            let formatter = ISO8601DateFormatter()
            try container.encode(formatter.string(from: date))
        case .formatted(let format):
            try container.encode(format.string(from: date))
        }
    }
}


extension SmartDate {
    public enum DateEncodeFormat {
        case timestamp                  // seconds
        case timestampMilliseconds      // milliseconds
        case iso8601
        case formatted(DateFormatter)   // custom date format
    }
}




extension SmartDate {
    static func detectAndParse(from string: String) -> (Date, DateEncodeFormat)? {
        let formats: [String] = [
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd",
            "yyyy/MM/dd",
            "MM/dd/yyyy",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        ]

        let formatter = DateFormatter()
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: string) {
                return (date, .formatted(formatter))
            }
        }

        // Try ISO8601
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: string) {
            return (date, .iso8601)
        }

        return nil
    }
}
