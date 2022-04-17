//
//  ContentView.swift
//  Shared
//
//  Created by Quentin Eude on 17/04/2022.
//

import SwiftUI
import SwiftDown

struct ContentView: View {
  @State private var text: String = "Reply"
  
  var body: some View {
    VStack {
      SwiftDownEditor(text: $text).frame(height: 50)
      TextField("", text: $text).frame(height: 50)
      Button {
        self.text = ""
      } label: {
        Text("Clear")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
