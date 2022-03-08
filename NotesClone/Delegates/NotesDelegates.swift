//
//  NoteDelegate.swift
//  NotesClone
//
//  Created by Leonardo  on 20/02/22.
//

import UIKit

protocol NewNoteDelegate: AnyObject {
  func willSaveNewNote()
  func didClearNewNote()
  func didShareNote()
}

protocol NewNoteDataSource: AnyObject {
  func getNewNoteLength() -> Int
}

protocol NotesDelegate: AnyObject {
  func didSaveNote(note: Note)
  func didEditNote(noteIndexPath: IndexPath, title: String, body: String)
}
