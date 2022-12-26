//
//  SwiftDownDemoApp.swift
//  Shared
//
//  Created by Quentin Eude on 17/04/2022.
//

import SwiftUI

@main
struct SwiftDownDemoApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        List {
          ForEach((0..<10).indices, id: \.self) { item in
            NavigationLink("\(item)") {
              ContentView()
            }
          }
        }
      }
    }
  }
}
