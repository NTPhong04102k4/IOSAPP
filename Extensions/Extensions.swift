//
//  Extensions.swift
//  AppIos
//
//  Created by ghmsoft on 10/7/26.
//

import SwiftUI
extension View {
    func eraseToAnyView() -> AnyView {
        return .init(self)
    }
}
