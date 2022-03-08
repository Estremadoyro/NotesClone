//
//  HomeConstants.swift
//  NotesClone
//
//  Created by Leonardo  on 22/02/22.
//

import Foundation

enum HomeConstants {
  static let notesCellId: String = "NOTES_CELL"
  static let goToNewNoteVCSegueId: String = "goToNewNoteVC"
  static let goToEditNoteSegueId: String = "goToEditNoteVC"
}

enum NoteSceneType {
  case isCreatingNewNote
  case isEditingNote
}
