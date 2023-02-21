//
//  Validator+Notifier.swift
//  
//
//  Created by Cadis on 20/02/23.
//

import Foundation

struct Validator {
    let isValid: Bool
    let message: String
}

class LabelTextFieldNotifier: ObservableObject {
    
    //MARK: Properties
    @Published var isRequired = false
    @Published var isLabelHidden = false
    @Published var maxLength = 0
    @Published var placeholder = ""
    @Published var validators = [Validator]()
    @Published var requiredMessage = ""
}
