//
//  RouterView.swift
//  ArchitectureBootcamp
//
//  Created by Tom Leer on 06/10/2025.
//

/*
 RouterView - @Environemnt
    ProfileView
        RouterView - @Environemnt
            SettingsView
                RouterView - @Environemnt
                    AccountView
 */

import SwiftUI

@MainActor
public struct RouterView<Content: View>: View, @MainActor Router {
    @Environment(\.dismiss) private var dismiss
    @State private var path: [AnyDestination] = []
    
    @State private var showSheet: AnyDestination? = nil
    @State private var showFullScreenCover: AnyDestination? = nil
    
    @State private var alert: AnyAppAlert? = nil
    @State private var alertOption: AlertType = .alert
    
    @State private var modalBackgroundColor: Color = Color.black.opacity(0.6)
    @State private var modalTransition: AnyTransition = .opacity
    @State private var modal: AnyDestination? = nil
    
    // Binding to the view stack from previous RouterViews
    @Binding var screenStack: [AnyDestination]
    
    var addNavigationView: Bool = true
    @ViewBuilder var content: (Router) -> Content
    
    public init(
        screenStack: (Binding<[AnyDestination]>)? = nil,
        addNavigationView: Bool = true,
        content: @escaping (Router) -> Content
    ) {
        self._screenStack = screenStack ?? .constant([])
        self.addNavigationView = addNavigationView
        self.content = content
    }
    
    public var body: some View {
        NavigationStackIfNeeded(path: $path, addNavigationView: addNavigationView) {
            content(self)
                .sheetViewModifier(screen: $showSheet)
                .fullScreenCoverViewModifier(screen: $showFullScreenCover)
                .showCustomAlert(type: alertOption, alert: $alert)
        }
        .modalViewModifier(backgroundColor: modalBackgroundColor, transition: modalTransition, screen: $modal)
        .environment(\.router, self)
    }
    
    public func showScreen<T: View>(_ option: SegueOption, @ViewBuilder destination: @escaping (Router) -> T) {
        let screen = RouterView<T>(
            screenStack: option.shouldAddNewNavigationView ? nil : screenStack.isEmpty ? $path : $screenStack,
            addNavigationView: option.shouldAddNewNavigationView
        ) { newRouter in
            destination(newRouter)
        }
        let destination = AnyDestination(destination: screen)
        
        switch option {
        case .push:
            if screenStack.isEmpty {
                // This means we are in the first RouterView
                path.append(destination)
            } else {
                // This means we are in a secondary RouterView
                screenStack.append(destination)
            }
            path.append(destination)
        case .sheet:
            showSheet = destination
        case .fullScreenCover:
            showFullScreenCover = destination
        }
    }
    
    public func dismissScreen() {
        dismiss()
    }
    
    public func showAlert(_ option: AlertType, title: String, message: String? = nil, buttons: (@Sendable () -> AnyView)? = nil) {
        self.alertOption = option
        self.alert = AnyAppAlert(title: title, message: message, buttons: buttons)
    }
    
    public func dismissAlert() {
        alert = nil
    }
    
    public func showModal<T: View>(backgroundColor: Color, transition: AnyTransition, @ViewBuilder destination: @escaping () -> T) {
        self.modalBackgroundColor = backgroundColor
        self.modalTransition = transition
        let destination = AnyDestination(destination: destination())
        self.modal = destination
    }
    
    public func dismissModal() {
        modal = nil
    }
}
