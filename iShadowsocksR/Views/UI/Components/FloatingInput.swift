//
//  PasswordField.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 05/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI
import UIKit

struct FloatingInput: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    @Binding var secureInput: Bool
    @State private var isEditing = false
    var onKeyboardShowHide: ((Bool) -> Void)? // Closure to handle keyboard show/hide
    
    init(_ placeholder: String, text: Binding<String>, secureInput: Binding<Bool>) {
        self._text = text
        self.placeholder = placeholder
        self._secureInput = secureInput
    }
    
    func makeUIView(context: Context) -> FloatingInputField {
        let field = FloatingInputField()
        field.title.text = placeholder
        field.input.placeholder = placeholder
        field.input.isSecureTextEntry = secureInput
        field.input.delegate = context.coordinator
        field.title.isHidden = true
        field.input.font = .systemFont(ofSize: 19)
        context.coordinator.field = field
        field.inputHeightConstraint.constant = 47
        
        return field
    }
    
    func updateUIView(_ uiView: FloatingInputField, context: Context) {
        uiView.input.text = text
        uiView.input.isSecureTextEntry = secureInput
        if isEditing {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: FloatingInput
        var field: FloatingInputField?
        init(_ parent: FloatingInput) {
            self.parent = parent
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text,
               let swiftRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: swiftRange, with: string)
                parent.text = updatedText
            }
            return true
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            field?.inputHeightConstraint.constant = 30
            field?.input.placeholder = ""
            field?.title.isHidden = false
            field?.input.font = .systemFont(ofSize: 17)
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            field?.inputHeightConstraint.constant = 47
            field?.input.placeholder = parent.placeholder
            field?.title.isHidden = true
            field?.input.font = .systemFont(ofSize: 19)
        }
    }
}
