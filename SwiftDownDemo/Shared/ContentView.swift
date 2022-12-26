//
//  ContentView.swift
//  Shared
//
//  Created by Quentin Eude on 17/04/2022.
//

import SwiftUI
import SwiftDown

struct ContentView: View {
  @State private var text: String = "# H1\n## H2\n### H3\n#### H4\n##### H5\n###### H6\n**bold** __bold__\n*italic* _italic_\n`inline code`\n```\ncode block\n```\n\n> block quote\n\n- list\n\n1. list\n\n[link](link)\n\nbody"
  @FocusState private var focusedField: FocusField?

  var body: some View {
    VStack {
      SwiftDownEditor(text: $text, onTextChange: { text in
        print("onTextChange")
      })
      .focused($focusedField, equals: .field)
      .frame(height: 400)
      .onAppear {
        self.focusedField = .field
      }
      TextField("", text: $text).frame(height: 50)
      Button {
        self.text = ""
      } label: {
        Text("Clear")
      }
    }
  }
}

extension ContentView {
  enum FocusField: Hashable {
    case field
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
