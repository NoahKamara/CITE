//
//  CrossrefMetaData.swift
//  CITE
//
//  Created by Noah Kamara on 19.07.20.
//

import Foundation

// MARK: - CrossrefMetaData
struct CrossrefMetaData: Codable {
    let status, messageType, messageVersion: String
    let message: Message
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageType = "message-type"
        case messageVersion = "message-version"
        case message
    }
}

// MARK: - Message
struct Message: Codable {
    let indexed: Created
    let referenceCount: Int
    let publisher, issue: String
    let contentDomain: ContentDomain
    let shortContainerTitle: [String]
    let publishedPrint: Issued
    let doi, type: String
    let created: Created
    let page, source: String
    let isReferencedByCount: Int
    let title: [String]
    let messagePrefix, volume: String
    let author: [Author]
    let member: String
    let containerTitle: [String]
    let originalTitle: [JSONAny]
    let link: [Link]
    let deposited: Created
    let score: Int
    let subtitle, shortTitle: [JSONAny]
    let issued: Issued
    let referencesCount: Int
    let journalIssue: JournalIssue
    let url: String
    let relation: Relation
    let issn: [String]
    let issnType: [IssnType]
    
    enum CodingKeys: String, CodingKey {
        case indexed
        case referenceCount = "reference-count"
        case publisher, issue
        case contentDomain = "content-domain"
        case shortContainerTitle = "short-container-title"
        case publishedPrint = "published-print"
        case doi = "DOI"
        case type, created, page, source
        case isReferencedByCount = "is-referenced-by-count"
        case title
        case messagePrefix = "prefix"
        case volume, author, member
        case containerTitle = "container-title"
        case originalTitle = "original-title"
        case link, deposited, score, subtitle
        case shortTitle = "short-title"
        case issued
        case referencesCount = "references-count"
        case journalIssue = "journal-issue"
        case url = "URL"
        case relation
        case issn = "ISSN"
        case issnType = "issn-type"
    }
}

// MARK: - Author
struct Author: Codable {
    let given, family, sequence: String
    let affiliation: [JSONAny]
}

// MARK: - ContentDomain
struct ContentDomain: Codable {
    let domain: [JSONAny]
    let crossmarkRestriction: Bool
    
    enum CodingKeys: String, CodingKey {
        case domain
        case crossmarkRestriction = "crossmark-restriction"
    }
}

// MARK: - Created
struct Created: Codable {
    let dateParts: [[Int]]
    let dateTime: Date
    let timestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case dateParts = "date-parts"
        case dateTime = "date-time"
        case timestamp
    }
}

// MARK: - IssnType
struct IssnType: Codable {
    let value, type: String
}

// MARK: - Issued
struct Issued: Codable {
    let dateParts: [[Int]]
    
    enum CodingKeys: String, CodingKey {
        case dateParts = "date-parts"
    }
}

// MARK: - JournalIssue
struct JournalIssue: Codable {
    let issue: String
}

// MARK: - Link
struct Link: Codable {
    let url: String
    let contentType, contentVersion, intendedApplication: String
    
    enum CodingKeys: String, CodingKey {
        case url = "URL"
        case contentType = "content-type"
        case contentVersion = "content-version"
        case intendedApplication = "intended-application"
    }
}

// MARK: - Relation
struct Relation: Codable {
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {
    
    let value: Any
    
    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }
    
    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }
    
    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }
    
    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }
    
    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }
    
    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}