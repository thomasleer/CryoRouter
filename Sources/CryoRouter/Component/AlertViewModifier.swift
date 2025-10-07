//
//  AlertViewModifier.swift
//  ArchitectureBootcamp
//
//  Created by Tom Leer on 06/10/2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func showCustomAlert(type: AlertType = .alert, alert: Binding<AnyAppAlert?>) -> some View {
        switch type {
        case .alert:
            self
                .alert(alert.wrappedValue?.title ?? "", isPresented: Binding(ifNotNil: alert)) {
                    alert.wrappedValue?.buttons()
                } message: {
                    if let message = alert.wrappedValue?.message {
                        Text(message)
                    }
                }
        case .confirmationDialog:
            self
                .confirmationDialog(alert.wrappedValue?.title ?? "", isPresented: Binding(ifNotNil: alert)) {
                    alert.wrappedValue?.buttons()
                } message: {
                    if let message = alert.wrappedValue?.message {
                        Text(message)
                    }
                }
        }
    }
}
