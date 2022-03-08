//
//  Note.swift
//  NotesClone
//
//  Created by Leonardo  on 20/02/22.
//

import Foundation

class Note: Codable, Identifiable {
  var id = UUID()
  var title: String
  var body: String
  var date = Date()
  var pinned: Bool = false

  init(title: String, body: String) {
    self.title = title
    self.body = body
  }

  deinit {
    print("\(self.title) (\(self.id)) deleted")
  }
}
