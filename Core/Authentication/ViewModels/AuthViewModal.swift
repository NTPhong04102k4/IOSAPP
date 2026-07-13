//
//  AuthViewModal.swift
//  AppIos
//
//  Created by ghmsoft on 10/7/26.
//

import SwiftUI

/// View state + input for the login screen.
@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
}
