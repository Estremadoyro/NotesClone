//
//  NewNoteNavigation.swift
//  NotesClone
//
//  Created by Leonardo  on 19/02/22.
//

import UIKit

class NewNoteNavigationBar {
  weak var newNoteVC: UIViewController?
  weak var noteDelegate: NewNoteDelegate?

  init(newNoteVC: UIViewController) {
    self.newNoteVC = newNoteVC
  }

  open func buildNavigationItems() {
    let moreButtonImage = UIImage(systemName: "ellipsis.circle")?.withRenderingMode(.alwaysTemplate)

    let moreOptionsButton = UIBarButtonItem(image: moreButtonImage, style: .plain, target: self, action: #selector(showMoreOptions))
    moreOptionsButton.tintColor = UIColor.systemYellow

    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
    doneButton.tintColor = UIColor.systemYellow

    let rightBarItems = [doneButton, moreOptionsButton]
    newNoteVC?.navigationItem.rightBarButtonItems = rightBarItems
    newNoteVC?.navigationItem.backBarButtonItem?.tintColor = UIColor.systemYellow
  }

  deinit {
    print("\(self) deinited")
  }
}

extension NewNoteNavigationBar {
  @objc
  private func showMoreOptions() {
    print("show more options")
  }

  @objc
  private func doneButtonAction() {
    noteDelegate?.willSaveNewNote()
    print("will save note")
  }
}
