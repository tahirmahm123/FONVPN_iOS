//
//  PasswordValidation.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 11/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct PasswordValidation: View {
    @Binding var text: String
    
    @State private var lengthCheck = false
    @State private var uppercaseCheck = false
    @State private var specialCheck = false
    @State private var numberCheck = false
    
    var completion: (Bool) -> Void
    init(text: Binding<String>, completion: @escaping (Bool) -> Void) {
        self._text = text
        self.completion = completion
    }
    var allowRegister: Bool {
        return lengthCheck && uppercaseCheck && numberCheck && specialCheck
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your password must contain:")
                .foregroundColor(.secondary)
                .font(Font.custom("Urbanist", size: 14))
            HStack {
                if lengthCheck {
                    Image("FulfilledCheck")
                } else {
                    Image("UnfulfilledCheck")
                }
                Text("Between 8 to 20 character")
                    .font(Font.custom("Urbanist", size: 14))
                Spacer()
            }
            HStack {
                if uppercaseCheck {
                    Image("FulfilledCheck")
                } else {
                    Image("UnfulfilledCheck")
                }
                Text("1 upper case letter")
                    .font(Font.custom("Urbanist", size: 14))
                Spacer()
            }
            HStack {
                if specialCheck {
                    Image("FulfilledCheck")
                } else {
                    Image("UnfulfilledCheck")
                }
                Text("1 or more special character")
                    .font(Font.custom("Urbanist", size: 14))
                Spacer()
            }
            HStack {
                if numberCheck {
                    Image("FulfilledCheck")
                } else {
                    Image("UnfulfilledCheck")
                }
                Text("1 or more numbers")
                    .font(Font.custom("Urbanist", size: 14))
                Spacer()
            }
        }
        .onChange(of: text, perform: { newValue in
            lengthCheck = newValue.count >= 8 && newValue.count <= 20
            uppercaseCheck = containsUppercaseLetter(text: newValue)
            specialCheck = containsSpecialLetter(text: newValue)
            numberCheck = containsNumber(text: newValue)
            completion(allowRegister)
        })
    }
    
    
    func containsUppercaseLetter(text: String) -> Bool {
        let uppercaseSet = CharacterSet.uppercaseLetters
        for character in text {
            if uppercaseSet.contains(character.unicodeScalars.first!) {
                return true
            }
        }
        return false
    }
    
    func containsSpecialLetter(text: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9 ]", options: [])
        let range = NSRange(location: 0, length: text.utf16.count)
        let matches = regex.matches(in: text, options: [], range: range)
        return matches.count > 0
    }
    
    func containsNumber(text: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*\\d.*")
        let range = NSRange(location: 0, length: text.utf16.count)
        let matches = regex.matches(in: text, range: range)
        
        return matches.count > 0
    }
}


struct PasswordValidation_Previews: PreviewProvider {
    static var previews: some View {
        @State var text = ""
        PasswordValidation(text: $text, completion: {allowed in
            
        })
    }
}


