//
//  AuthUser.swift
//  AppIos
//
//  Created by ghmsoft on 10/7/26.
//

import Foundation

/// Domain model representing an authenticated user.
struct AuthUser: Identifiable, Codable, Equatable {
    let id: String
    let email: String
    var displayName: String?
}
