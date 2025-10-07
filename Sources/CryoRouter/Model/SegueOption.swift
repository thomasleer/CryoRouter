//
//  SegueOption.swift
//  ArchitectureBootcamp
//
//  Created by Tom Leer on 06/10/2025.
//

import SwiftUI

public enum SegueOption {
    case push
    case sheet
    case fullScreenCover
    
    var shouldAddNewNavigationView: Bool {
        switch self {
        case .push:
            return false
        case .sheet:
            return true
        case .fullScreenCover:
            return true
        }
    }
}
