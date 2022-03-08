//
//  Notes.swift
//  NotesClone
//
//  Created by Leonardo  on 20/02/22.
//

import Foundation

final class Notes: Codable {
  var notes: [Note]

  init() {
    self.notes = UserDefaults.standard.load(key: DefaultKeys.NOTES_KEY, obj: Notes.self)?.notes ?? [Note]()
    notes.forEach { print("Note loaded: \($0.title)") }
  }

  // needed for copying (not deep)
  init(notes: [Note]) {
    self.notes = notes
  }
}

extension Notes {
  var pinnedNotes: [Note] { notes.filter { $0.pinned } }
  var notPinnedNotes: [Note] { notes.filter { !$0.pinned } }
}

extension Notes: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    let copiedNotes = Notes(notes: notes)
    return copiedNotes
  }
}

extension Notes {
  fileprivate func logUpdatedList() {
    // log new notes after any CRUD operation
    print("[CRUD] Notes: \(notes.map { "\($0.title) (P: \($0.pinned))" })")
  }

  public func saveNotesToLocal() {
    // save Notes into UserDefaults
    UserDefaults.standard.save(key: DefaultKeys.NOTES_KEY, obj: self)
    logUpdatedList()
  }
}

extension Notes: NotesCRUD {
  public func insertNewNote(_ filteredNotes: inout [Note], _ isFiltering: Bool, note: Note) {
    // insert new note
    notes.insert(note, at: pinnedNotes.count == 0 ? 0 : pinnedNotes.count)
    print("did insert new note: \(note.title)")
    if !isFiltering {
      filteredNotes = notes
    } else {
      filteredNotes.insert(note, at: 0)
    }
    saveNotesToLocal()
  }

  public func updateNote(_ filteredNotes: inout [Note], _ isFiltering: Bool, noteIndex: Int, title: String, body: String) {
    // update note
    let filteredNoteToEdit: Note = filteredNotes[noteIndex]
    filteredNoteToEdit.title = title
    filteredNoteToEdit.body = body

//    if !isFiltering {
//      filteredNotes = notes
//    } else {
//      let filteredNoteToEdit: Note = filteredNotes[noteIndex]
//      filteredNoteToEdit.title = title
//      filteredNoteToEdit.body = body
//    }
    saveNotesToLocal()
  }

  public func deleteNote(_ filteredNotes: inout [Note], _ isFiltering: Bool, noteIndex: Int) {
    // delete note
    let noteToDelete: Note = filteredNotes[noteIndex]
    notes.removeAll(where: { $0.id == noteToDelete.id })
    if !isFiltering {
      filteredNotes = notes
    } else {
      filteredNotes.removeAll(where: { $0.id == noteToDelete.id })
    }
    saveNotesToLocal()
  }

  public func pinNote(_ filteredNotes: inout [Note], noteIndex: Int) {
    // pin note
    let noteToPin: Note = notes[noteIndex]
    noteToPin.pinned = true
    notes.remove(at: noteIndex)
    notes.insert(noteToPin, at: 0)
    filteredNotes = notes
    saveNotesToLocal()
  }

  public func unPinNote(_ filteredNotes: inout [Note], noteIndex: Int) {
    // unpin note
    guard let noteToUnPin: Note = notes.first(where: { $0.id == notes[noteIndex].id }) else { return }
    noteToUnPin.pinned = false
    notes.remove(at: noteIndex)
    notes.insert(noteToUnPin, at: pinnedNotes.count == 0 ? 0 : pinnedNotes.count)
    filteredNotes = notes
    saveNotesToLocal()
  }
}
