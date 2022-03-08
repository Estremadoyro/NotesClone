//
//  NotesCRUD.swift
//  NotesClone
//
//  Created by Leonardo  on 6/03/22.
//

import Foundation

protocol NotesCRUD {
  func insertNewNote(_ filteredNotes: inout [Note], _ isFiltering: Bool, note: Note)

  func updateNote(_ filteredNotes: inout [Note], _ isFiltering: Bool, noteIndex: Int, title: String, body: String)

  func deleteNote(_ filteredNotes: inout [Note], _ isFiltering: Bool, noteIndex: Int)

  func pinNote(_ filteredNotes: inout [Note], noteIndex: Int)

  func unPinNote(_ filteredNotes: inout [Note], noteIndex: Int)
}
