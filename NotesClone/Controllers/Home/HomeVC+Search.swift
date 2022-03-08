//
//  HomeSearchVC.swift
//  NotesClone
//
//  Created by Leonardo  on 20/02/22.
//

import UIKit

extension HomeVC: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print("Search text: \(searchText)")
    filteredNotes = [Note]()
    tableSectionsAmount = 1

    DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
      if searchText == "" {
        self.filteredNotes = notes.notes
        self.isFiltering = false
        if self.notes.pinnedNotes.count > 0 {
          self.tableSectionsAmount = 2
        }
      } else {
        self.isFiltering = true
        self.notes.notes.forEach { note in
          if note.title.lowercased().contains(searchText.lowercased()) || note.body.lowercased().contains(searchText.lowercased()) {
            print("NOTE FILTERED: \(note.title)")
            self.filteredNotes.append(note)
          }
        }
      }
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
}

extension HomeVC {
  func configureGestures() {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchBarDismissKeyboardTouchOutside))
    gestureRecognizer.cancelsTouchesInView = false
    view.addGestureRecognizer(gestureRecognizer)
  }

  @objc
  private func searchBarDismissKeyboardTouchOutside() {
    homeSearchBar.endEditing(true)
  }
}
