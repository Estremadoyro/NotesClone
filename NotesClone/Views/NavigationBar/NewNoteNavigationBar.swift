//
//  NewNoteNavigation.swift
//  NotesClone
//
//  Created by Leonardo  on 19/02/22.
//

import UIKit

class NewNoteNavigationBar {
  weak var newNoteVC: UIViewController?
  weak var newNoteDelegate: NewNoteDelegate?

  init(newNoteVC: UIViewController) {
    self.newNoteVC = newNoteVC
  }

  open func buildNavigationItems() {
    let moreButtonImage = UIImage(systemName: "square.and.arrow.up")?.withRenderingMode(.alwaysTemplate)

    let shareNoteButton = UIBarButtonItem(image: moreButtonImage, style: .plain, target: self, action: #selector(shareNoteAction))
    shareNoteButton.tintColor = UIColor.systemYellow

    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
    doneButton.tintColor = UIColor.systemYellow

    let rightBarItems = [doneButton, shareNoteButton]
    newNoteVC?.navigationItem.rightBarButtonItems = rightBarItems
    newNoteVC?.navigationItem.backBarButtonItem?.tintColor = UIColor.systemYellow
  }

  deinit { print("NewNavigationBar deinited") }
}

extension NewNoteNavigationBar {
  @objc
  private func shareNoteAction() {
    print("sharing note")
    newNoteDelegate?.didShareNote()
  }

  @objc
  private func doneButtonAction() {
    print("will save note")
    newNoteDelegate?.willSaveNewNote()
  }
}
