//
//  LocalError.swift
//  FirebaseLogin
//
//  Created by Tom.Liu on 2024/9/20.
//

import Foundation

public class LocalError: Error, Equatable, @unchecked Sendable {
    
    public static func == (lhs: LocalError, rhs: LocalError) -> Bool {
        return lhs.title == rhs.title && lhs.description == rhs.description
    }
    
    public var message: String {
        return description ?? "An unexpected error occur: \(String(describing: self))"
    }
    
    public private(set) var title: String? = "Unexpected Error"
    private var description: String?
    
    public init(title: String? = nil, description: String? = nil) {
        self.title = title
        self.description = description
    }

    public static let unknown = LocalError(title: "Unknown error")
}
