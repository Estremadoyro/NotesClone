//
//  HomeVC+Table.swift
//  NotesClone
//
//  Created by Leonardo  on 21/02/22.
//

import UIKit

extension HomeVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeConstants.notesCellId, for: indexPath) as? NoteCellView else {
      fatalError("Error dequeing \(HomeConstants.notesCellId)")
    }
    let note = filteredNotes.reversed()[indexPath.row]
    cell.note = note
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredNotes.count
  }
}

extension HomeVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteActionCompletion: (UIContextualAction, UIView, @escaping (Bool) -> Void) -> Void = { [unowned self] _, _, completion in
      self.notes.notes.remove(at: indexPath.row)
      self.filteredNotes.remove(at: indexPath.row)
      self.tableView.deleteRows(at: [indexPath], with: .left)
      homeToolbar.configureHomeToolBar(notes: notes)
      completion(true)
    }

    let moveToFolderActionCompletion: (UIContextualAction, UIView, @escaping (Bool) -> Void) -> Void = { _, _, completion in
      completion(true)
    }

    let shareWithContactActionCompletion: (UIContextualAction, UIView, @escaping (Bool) -> Void) -> Void = { _, _, completion in
      completion(true)
    }

    let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: deleteActionCompletion)
    deleteAction.image = UIImage(systemName: "trash.fill")
    deleteAction.image?.withTintColor(UIColor.yellow)

    let moveToFolderAction = UIContextualAction(style: .normal, title: "Move", handler: moveToFolderActionCompletion)
    moveToFolderAction.image = UIImage(systemName: "folder.fill")
    moveToFolderAction.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.5)

    let shareWithContactAction = UIContextualAction(style: .normal, title: "Share", handler: shareWithContactActionCompletion)
    shareWithContactAction.image = UIImage(systemName: "person.crop.circle.badge.plus")
    shareWithContactAction.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)

    let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction, moveToFolderAction, shareWithContactAction])
    swipeConfig.performsFirstActionWithFullSwipe = false
    return swipeConfig
  }

  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let pinActionCompletion: (UIContextualAction, UIView, @escaping (Bool) -> Void) -> Void = { _, _, completion in
      completion(true)
    }
    let pinAction = UIContextualAction(style: .normal, title: nil, handler: pinActionCompletion)
    pinAction.image = UIImage(systemName: "pin.fill")
    pinAction.backgroundColor = UIColor.systemOrange.withAlphaComponent(1)

    let swipeConfig = UISwipeActionsConfiguration(actions: [pinAction])
    swipeConfig.performsFirstActionWithFullSwipe = true
    return swipeConfig
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    homeSearchBar.resignFirstResponder()
  }
}
