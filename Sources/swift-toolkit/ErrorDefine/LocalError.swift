//
//  LocalError.swift
//  FirebaseLogin
//
//  Created by Tom.Liu on 2024/9/20.
//

import UIKit

class LocalError: Error, Equatable, @unchecked Sendable {
    
    static func == (lhs: LocalError, rhs: LocalError) -> Bool {
        return lhs.title == rhs.title && lhs.description == rhs.description
    }
    
    var message: String {
        return description ?? "An unexpected error occur: \(String(describing: self))"
    }
    
    private(set) var title: String? = "Unexpected Error"
    private var description: String?
    
    init(title: String? = nil, description: String? = nil) {
        self.title = title
        self.description = description
    }

    static let unknown = LocalError(title: "Unknown error")
}
