//
//  ModelKeyEnums.swift
//  CollectionViewDynamicHeight
//
//  Created by Admin on 16/11/19.
//  Copyright © 2019 Piyush. All rights reserved.
//
import UIKit

/// useful keys
struct ModelKeys {
    
    ///
    struct ApiHeaderKeys {
        static let contentType = "Content-Type"
        static let applicationOrJson = "application/json"
        static let multipartOrFormData = "multipart/form-data"
        static let token = "x-access-token"
    }
    
    /// response keys
    struct ResponseKeys {
        static let status = "status"
        static let result = "result"
        static let message = "message"
    }
}
