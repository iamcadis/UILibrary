//
//  LabelTextFieldNotifier.swift
//  
//
//  Created by Cadis on 20/02/23.
//

import Foundation
import SwiftUI

class FieldProperties: ObservableObject {
    
    //MARK: Properties
    @Published var isRequired = false
    @Published var isLabelHidden = false
    @Published var maxLength = 0
    @Published var placeholder = ""
    @Published var validators = [FieldValidator]()
    @Published var capitalizationType: UITextAutocapitalizationType = .none
}
