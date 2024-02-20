//
//  UIApplication.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/20.
//

import Foundation
import SwiftUI

// Extend the UIApplication to hide the keyboard when tapping xmark
extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
