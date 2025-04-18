import CodableWrapper
import Foundation

class StringPrefixTransform: TransformType {
    typealias Object = String
    typealias JSON = String

    let prefix: String

    init(_ prefix: String) {
        self.prefix = prefix
    }

    func transformFromJSON(_ json: String?) -> String {
        return prefix + (json ?? "")
    }

    func transformToJSON(_ object: String) -> String? {
        object.replacing(prefix, with: "")
    }
}

class TimestampTransform: TransformType {
    typealias Object = Date
    typealias JSON = TimeInterval

    func transformToJSON(_ date: Object) -> JSON? {
        date.timeIntervalSince1970
    }

    func transformFromJSON(_ timestamp: JSON?) -> Object {
        return Date(timeIntervalSince1970: timestamp ?? 0)
    }
}

let tupleTransform = TransformOf<(String, String)?, String>(fromJSON: { json in
    if let json = json {
        let comps = json.components(separatedBy: "|")
        return (comps.first ?? "", comps.last ?? "")
    }
    return nil
}, toJSON: { tuple in
    if let tuple = tuple {
        return "\(tuple.0)|\(tuple.1)"
    }
    return nil
})
