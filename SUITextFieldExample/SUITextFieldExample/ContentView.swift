//
//  ContentView.swift
//  SUITextFieldExample
//
//  Created by Rico Crescenzio on 31/03/22.
//

import SwiftUI
import SwiftUITextField

struct ContentView: View {

    @State private var toggleFont = false
    @State private var color = Color.red
    @State private var text = "A test text"
    @ResponderState var focus: Responder?
    @ResponderState var isFocused: Bool
    @State private var toggle = false
    @State private var date = Date()

    var body: some View {
        ScrollView {
            VStack {
                SUITextField(text: .constant(date.description))
                    .inputAccessoryView {
                        accessoryView
                    }
                    .inputView {
                        DatePicker("Select date", selection: $date)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                    }
                    .responder($focus, equals: .first)
                SUITextField(text: $text)
                    .inputAccessoryView {
                        accessoryView
                    }
                    .inputView {
                        keyPadInputView
                    }
                    .responder($focus, equals: .second)
                SUITextField(text: $text)
                    .inputAccessoryView {
                        accessoryView
                    }
                    .onReturnKeyPressed {
                        focus = nil
                        isFocused = false
                    }
                    .responder($isFocused)
                Button(action: { toggleFont.toggle() }) {
                    Text("Change font")
                }
                accessoryView
            }
            .padding()
        }
        .background(Color.yellow.edgesIgnoringSafeArea(.all))
        .uiTextFieldFont(toggleFont ? .monospacedSystemFont(ofSize: 50, weight: .medium) : nil)
        .uiTextFieldBorderStyle(.roundedRect)
    }

    var accessoryView: some View {
        VStack {
            HStack {
                Button(action: goPrevious) {
                    Text("<")
                        .frame(width: 30, height: 30)
                }
                .disabled(focus == .first)
                Button(action: goNext) {
                    Text(">")
                        .frame(width: 30, height: 30)
                }
                .disabled(focus == .second)
                Spacer()
                Text(text)
                Spacer()
                Button(action: {
                    focus = nil
                    isFocused = false
                }) {
                    Text("Dismiss")
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity)
        .background(Color.green.edgesIgnoringSafeArea(.horizontal))
    }

    func goNext() {
        focus = .second
    }

    func goPrevious() {
        focus = .first
    }

    @ViewBuilder
    var keyPadInputView: some View {
        if #available(iOS 14, *) {
            VStack {
                ForEach(1...3, id: \.self) { row in
                    HStack {
                        ForEach(1...3, id: \.self) { col in
                            Button {
                                text += (row * col).description
                            } label: {
                                Text((row * col).description).frame(width: 30, height: 30)
                            }

                        }
                    }
                }
            }
            .padding()
        }
    }

}

enum Responder {
    case first
    case second
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
