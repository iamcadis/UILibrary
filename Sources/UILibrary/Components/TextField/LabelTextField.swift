//
//  LabelTextField.swift
//
//
//  Created by Cadis on 20/02/23.
//

import SwiftUI
import Combine

public struct LabelTextField: View {
    @ObservedObject var notifier = LabelTextFieldNotifier()
    
    private let label: String
    @Binding var text: String
    @State private var hasChanged = false
    
    public init(_ label: String, text: Binding<String>) {
        self.label = label
        self._text = text
    }
    
    private var placeholder: String {
        if notifier.placeholder.isEmpty {
            return "\(label)\(notifier.isRequired ? "*" : "")"
        } else {
            return notifier.placeholder
        }
    }
    
    private var hideLabel: Bool {
        if notifier.isLabelHidden {
            return true
        }
        
        if !text.isEmpty {
            return false
        }
        
        return notifier.placeholder.isEmpty
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            labelText()
                .opacity(0.6)
                .gone(hideLabel)
            
            textField(placeholder, text: $text)
                .onReceive(Just(text), perform: setMaxLength)
                .onChange(of: text, perform: onTextChanged)

            if validator.isValid == false {
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
        Text(notifier.isRequired ? "*" : "")
            .font(.caption)
            .foregroundColor(.red)
    }
    
    @ViewBuilder
    private func textField(_ placeholder: String, text: Binding<String>) -> some View {
        if #available(iOS 15.0, *) {
            TextField(placeholder, text: text)
                .textInputAutocapitalization(TextInputAutocapitalization(notifier.capitalizationType))
        } else {
            TextField(placeholder, text: text)
                .autocapitalization(notifier.capitalizationType)
        }
    }
    
    private func setMaxLength(_ value: String) {
        if notifier.maxLength == 0 { return }
        
        if value.count > notifier.maxLength  {
            self.text = String(value.prefix(notifier.maxLength))
            return
        }
    }
    
    private func onTextChanged(_ value: String) {
        self.hasChanged = true
    }
    
    private var validator: Validator {
        if hasChanged {
            if notifier.isRequired && text.isBlank {
                return .init(isValid: false, message: notifier.requiredMessage.isEmpty ? "\(label.lowercased().capitalized) cannot be blank or empty" : notifier.requiredMessage)
            }
            
            if let firstError = notifier.validators.filter({ $0.isValid == false }).first {
                return firstError
            }
        }
        
        return .init(isValid: true, message: "")
    }
    
}

public extension LabelTextField {
    
    /// Set label text field to required
    func required(_ required: Bool) -> Self {
        notifier.isRequired = required
        return self
    }
    
    /// Set placeholder text field
    func placeholder(_ placeholder: String) -> Self {
        notifier.placeholder = placeholder
        return self
    }
    
    /// Set maximal lenght text field
    func setMaxLength(_ length: Int) -> Self {
        notifier.maxLength = length
        return self
    }
    
    /// Set label to hidden
    func labelIsHidden() -> Self {
        notifier.isLabelHidden = true
        return self
    }
    
    /// Add new validation condition to show error message.
    func addValidation(_ condition: Bool, message: String) -> Self {
        notifier.validators.append(.init(isValid: condition, message: message))
        return self
    }
    
    /// Override required message when condition fulfilled
    /// use this when you using translation
    ///
    /// default message: \(`label`) cannot be blank or empty
    ///
    func requiredMessage(_ message: String) -> Self {
        notifier.requiredMessage = message
        return self
    }
    
    /// The ``capitalization`` struct defines the available
    /// autocapitalizing behavior with backward compatibility for ios 14
    ///
    /// - Parameter type: One of the capitalizing behaviors
    /// default is using `none`
    func capitalization(_ type: UITextAutocapitalizationType) -> Self {
        notifier.capitalizationType = type
        return self
    }
}

