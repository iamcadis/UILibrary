//
//  LabelTextField.swift
//
//
//  Created by Cadis on 20/02/23.
//

import SwiftUI
import Combine

public struct LabelTextField: View {
    @ObservedObject var props = FieldProperties()
    
    private let label: String
    @Binding var text: String
    @State private var hasChanged = false
    
    public init(_ label: String, text: Binding<String>) {
        self.label = label
        self._text = text
    }
    
    private var placeholder: String {
        if props.placeholder.isEmpty {
            return "\(label)\(props.isRequired ? "*" : "")"
        } else {
            return props.placeholder
        }
    }
    
    private var hideLabel: Bool {
        if props.isLabelHidden {
            return true
        }
        
        if !text.isEmpty {
            return false
        }
        
        return props.placeholder.isEmpty
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            labelText()
                .opacity(0.6)
                .gone(if: hideLabel)
            
            textField(placeholder, text: $text)
                .onReceive(Just(text), perform: setMaxLength)
                .onChange(of: text, perform: onTextChanged)

            if validator.condition {
                Text(validator.message)
                    .font(.caption2)
                    .foregroundColor(Color.red)
                    .padding(.top, 4)
            }
        }
    }
    
    @ViewBuilder
    private func labelText() -> some View {
        Text(label)
            .font(.caption) +
        Text(props.isRequired ? "*" : "")
            .font(.caption)
            .foregroundColor(.red)
    }
    
    @ViewBuilder
    private func textField(_ placeholder: String, text: Binding<String>) -> some View {
        if #available(iOS 15.0, *) {
            TextField(placeholder, text: text)
                .textInputAutocapitalization(TextInputAutocapitalization(props.capitalizationType))
        } else {
            TextField(placeholder, text: text)
                .autocapitalization(props.capitalizationType)
        }
    }
    
    private func setMaxLength(_ value: String) {
        if props.maxLength == 0 { return }
        
        if value.count > props.maxLength  {
            self.text = String(value.prefix(props.maxLength))
            return
        }
    }
    
    private func onTextChanged(_ value: String) {
        self.hasChanged = true
    }
    
    private var validator: FieldValidator {
        if hasChanged {
            if let firstError = props.validators.filter({ $0.condition }).first {
                return firstError
            }
        }
        
        return .init(condition: false, message: "")
    }
    
}

public extension LabelTextField {
    
    /// Set label text field to required
    func required(_ required: Bool) -> Self {
        props.isRequired = required
        return self
    }
    
    /// Set placeholder text field
    func placeholder(_ placeholder: String) -> Self {
        props.placeholder = placeholder
        return self
    }
    
    /// Set maximal lenght text field
    func setMaxLength(_ length: Int) -> Self {
        props.maxLength = length
        return self
    }
    
    /// Set label to hidden
    func labelIsHidden() -> Self {
        props.isLabelHidden = true
        return self
    }
    
    /// Add condition to show error message below textfield
    ///
    /// - Parameters:
    ///   - condition: A condition to trigger error message
    ///   - message: Error message when `condition` fulfilled
    func addValidation(_ condition: Bool, message: String) -> Self {
        props.validators.append(.init(condition: condition, message: message))
        return self
    }
    
    /// The ``capitalization`` struct defines the available
    /// autocapitalizing behavior with backward compatibility for ios 14
    ///
    /// - Parameter type: One of the capitalizing behaviors
    /// default is using `none`
    func capitalization(_ type: UITextAutocapitalizationType) -> Self {
        props.capitalizationType = type
        return self
    }
}

