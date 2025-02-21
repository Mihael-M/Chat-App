//
//  CloseKeyboard.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 21.02.25.
//

import Foundation
import SwiftUI

extension View {
    func dismissKeyboardOnDrag() -> some View {
        self.gesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.height > 10 { // Detect downward drag
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
        )
    }
}
