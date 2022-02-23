//
//  NoteDelegate.swift
//  NotesClone
//
//  Created by Leonardo  on 20/02/22.
//

import UIKit

protocol NewNoteDelegate: AnyObject {
  func willSaveNewNote()
}

protocol NotesDelegate: AnyObject {
  func didSaveNote(note: Note)
}
