//
//  CustomButton.swift
//  AppIos
//

import SwiftUI

/// Reusable primary button used across the app.
struct CustomButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    CustomButton(title: "Continue") {}
        .padding()
}
