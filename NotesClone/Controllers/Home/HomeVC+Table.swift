//
//  HomeVC+Table.swift
//  NotesClone
//
//  Created by Leonardo  on 21/02/22.
//

import UIKit

extension HomeVC: UITableViewDataSource {
  internal func getIndexForSection(in indexPath: IndexPath) -> Int {
    var sumRowsBySection: Int = 0
    for section in 0 ..< indexPath.section {
      sumRowsBySection += tableView.numberOfRows(inSection: section)
    }
    return sumRowsBySection + indexPath.row
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeConstants.notesCellId, for: indexPath) as? NoteCellView else {
      fatalError("Error dequeing \(HomeConstants.notesCellId)")
    }
    let globalIndex: Int = getIndexForSection(in: indexPath)
    let note = filteredNotes[globalIndex]
    print("LOADED NOTE: \(note.title)")
    cell.note = note
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return tableSectionsAmount
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard tableView.numberOfSections > 1 else { return filteredNotes.count }

    var rowsInSection: Int {
      // pinned section
      if tableView.numberOfSections == 2, section == 0 {
        print("PINNED ROWS AMOUNT: \(notes.pinnedNotes.count)")
        return notes.pinnedNotes.count
      }
      // not pinned
      print("NOT PINNED ROWS AMOUNT: \(notes.notPinnedNotes.count)")
      return notes.notPinnedNotes.count
    }

    return rowsInSection
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard tableView.numberOfSections == 2 else {
      return ""
    }
    return section == 0 ? "Pinned" : "Notes"
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 1 }
}

extension HomeVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteActionCompletion: (UIContextualAction, UIView, @escaping (Bool) -> Void) -> Void = { [unowned self] _, _, completion in
      defer {
        homeToolbar.configureHomeToolBar(notes: notes)
        completion(true)
      }
      let globalIndex: Int = self.getIndexForSection(in: indexPath)
      self.notes.deleteNote(&self.filteredNotes, isFiltering, noteIndex: globalIndex)

      self.tableView.deleteRows(at: [indexPath], with: .left)

      if tableView.numberOfSections == 2, notes.pinnedNotes.count == 0 {
        self.tableSectionsAmount = 1
        tableView.deleteSections(IndexSet(arrayLiteral: 0), with: .left)
      }
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
    let pinActionCompletion: (UIContextualAction, UIView, @escaping (Bool) -> Void) -> Void = { [weak self] _, _, completion in
      guard let strongSelf = self else { return }
      defer { completion(true) }

      if tableView.numberOfSections < 2 {
        strongSelf.tableSectionsAmount = 2
        tableView.insertSections(IndexSet(arrayLiteral: 0), with: .left)
      }

      // Global index to update with the Notes' list
      let globalIndex: Int = strongSelf.getIndexForSection(in: indexPath)
      var pinnedIndexPath = IndexPath(row: 0, section: 0)
      var notPinnedIndexPath = indexPath

      // If note is first to be pinned, manually update indexPath.section -> 1 (indexPath is not yet aware of the new section created)
      if strongSelf.notes.pinnedNotes.count == 0 {
        notPinnedIndexPath = IndexPath(row: indexPath.row, section: 1)
      }

      // Note is already pinned
      if tableView.numberOfSections == 2, notPinnedIndexPath.section == 0 {
        pinnedIndexPath = indexPath
        notPinnedIndexPath = IndexPath(row: 0, section: 1)
        strongSelf.notes.unPinNote(&strongSelf.filteredNotes, noteIndex: globalIndex)
        tableView.moveRow(at: pinnedIndexPath, to: notPinnedIndexPath)
      } else {
        strongSelf.notes.pinNote(&strongSelf.filteredNotes, noteIndex: globalIndex)
        tableView.moveRow(at: notPinnedIndexPath, to: pinnedIndexPath)
      }

      if tableView.numberOfSections == 2, strongSelf.notes.pinnedNotes.count == 0 {
        strongSelf.tableSectionsAmount = 1
        tableView.deleteSections(IndexSet(arrayLiteral: 0), with: .left)
      }
    }
    let pinAction = UIContextualAction(style: .normal, title: nil, handler: pinActionCompletion)
    let pinImageName = tableSectionsAmount > 1 && indexPath.section == 0 ? "pin.slash.fill" : "pin.fill"
    pinAction.image = UIImage(systemName: pinImageName)
    pinAction.backgroundColor = UIColor.systemOrange.withAlphaComponent(1)
    let actions = [pinAction]

    let swipeConfig = UISwipeActionsConfiguration(actions: isFiltering ? [] : actions)
    swipeConfig.performsFirstActionWithFullSwipe = true
    return swipeConfig
  }
}

extension HomeVC {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    homeSearchBar.resignFirstResponder()
  }
}

extension HomeVC {
  func setupInitialSections() {
    if tableView.numberOfSections == 1, notes.pinnedNotes.count > 0, !didSetupSections {
      print("SETUP - sections: \(tableView.numberOfSections) | pinnedNotesCount: \(notes.pinnedNotes.count) | didSetupSections: \(didSetupSections)")
      tableSectionsAmount = 2
      didSetupSections = true
    }
  }
}
