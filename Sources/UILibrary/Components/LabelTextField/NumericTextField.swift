//
//  NumericTextField.swift
//
//
//  Created by Cadis on 19/05/23.
//

import SwiftUI
import Combine

public struct NumericTextField<Value>: View {
    @ObservedObject var props = FieldProperties()
    
    private let label: String
    @Binding var value: Value?
    
    // state
    @State private var string: String
    @State private var hasChanged = false
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    public init(_ label: String, value: Binding<Value?>) {
        self.label = label
        self._value = value
        if let newValue = value.wrappedValue, let number = newValue as? NSNumber, let string = numberFormatter.string(from: number) {
            _string = State(initialValue: string)
        } else {
            _string = State(initialValue: "")
        }
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
        
        return props.placeholder.isEmpty
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            labelText()
                .opacity(0.6)
                .gone(if: hideLabel)
            
            TextField(placeholder, text: $string)
                .onChange(of: string, perform: numberChanged)

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
    
    private var validator: FieldValidator {
        if hasChanged {
            if let firstError = props.validators.filter({ $0.condition }).first {
                return firstError
            }
        }
        
        return .init(condition: false, message: "")
    }
    
    private func numberChanged(newValue: String) {
        let numeric = newValue.numericValue(allowDecimalSeparator: true)
        if newValue != numeric {
            string = numeric
        }
        value = numberFormatter.number(from: string) as? Value
    }
    
}

struct NumericTextField_Previews: PreviewProvider {
    static var previews: some View {
        NumericTextField("Quantity", value: .constant(1000.4))
    }
}


public extension String {
    func numericValue(allowDecimalSeparator: Bool) -> String {
        var hasFoundDecimal = false
        return self.filter {
            if $0.isWholeNumber {
                return true
            } else if allowDecimalSeparator && String($0) == (Locale.current.decimalSeparator ?? ".") {
                defer { hasFoundDecimal = true }
                return !hasFoundDecimal
            }
            return false
        }
    }
}

