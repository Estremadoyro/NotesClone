//
//  NewNoteToolBarView.swift
//  NotesClone
//
//  Created by Leonardo  on 21/02/22.
//

import UIKit

class NewNoteToolBarView: UIToolbar {
  @IBOutlet weak var enumarateNoteItem: UIBarButtonItem!
  @IBOutlet weak var pictureNoteItem: UIBarButtonItem!
  @IBOutlet weak var drawNoteItem: UIBarButtonItem!
  @IBOutlet weak var clearNoteItem: UIBarButtonItem!

  weak var newNoteDataSource: NewNoteDataSource?
  weak var newNoteDelegate: NewNoteDelegate?

  override func awakeFromNib() {
    super.awakeFromNib()
    enumarateNoteItem.isEnabled = false
    pictureNoteItem.isEnabled = false
    drawNoteItem.isEnabled = false
  }

  deinit { print("NewNoteToolBarView deintied") }
}

extension NewNoteToolBarView {
  @IBAction func clearNoteItemTapped() {
    newNoteDelegate?.didClearNewNote()
    clearNoteItem.isEnabled = false
  }

  func setClearItemState() {
    guard let newNoteCharsLength = newNoteDataSource?.getNewNoteLength() else {
      clearNoteItem.isEnabled = false
      return
    }
//    print("Note chars length: \(newNoteCharsLength)")
    clearNoteItem.isEnabled = newNoteCharsLength > 0
  }
}
