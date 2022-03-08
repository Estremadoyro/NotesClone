//
//  HomeTableToolbarView.swift
//  NotesClone
//
//  Created by Leonardo  on 18/02/22.
//

import UIKit

class HomeToolBarView: UIToolbar {
  @IBOutlet weak var newNoteItem: UIBarButtonItem!
  @IBOutlet weak var notesAmountItem: UIBarButtonItem!

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  deinit { print("\(self) deinited") }
}

extension HomeToolBarView {
  public func configureHomeToolBar(notes: Notes) {
    notesAmountItem.title = "\(notes.notes.count) Notes"
  }
}
