//
//  ContentView.swift
//  Shared
//
//  Created by Quentin Eude on 17/04/2022.
//

import SwiftUI
import SwiftDown

struct ContentView: View {
  @State private var text: String = ""
  
  var body: some View {
    SwiftDownEditor(text: $text)
      .insetsSize(40)
      .theme(Theme.BuiltIn.defaultDark.theme())
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
