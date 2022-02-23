//
//  ViewController.swift
//  NotesClone
//
//  Created by Leonardo  on 18/02/22.
//

import UIKit

class HomeVC: UIViewController {
  @IBOutlet weak var tableView: HomeTableView!
  @IBOutlet weak var homeSearchBar: UISearchBar!
  @IBOutlet weak var homeToolbar: HomeToolBarView!

  lazy var notes = Notes()

  lazy var filteredNotes: [Note] = notes.copy(with: nil) as? [Note] ?? [Note]()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    homeSearchBar.delegate = self
    configureNavigationBar()
    configureGestures()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    print("preparing for segue")
    if segue.identifier == HomeConstants.goToNewNoteVCSegueId {
      let newNoteVC = segue.destination as? NewNoteVC
      newNoteVC?.notes = notes
      newNoteVC?.notesDelegate = self
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    homeToolbar.configureHomeToolBar(notes: notes)
  }

  deinit { print("\(self) deinited") }
}

extension HomeVC {
  private func configureNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    HomeNavigationBar(homeTableVC: self).buildNavigationBarItems()
  }
}

extension HomeVC: NotesDelegate {
  func didSaveNote(note: Note) {
    filteredNotes.append(note)
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
  }
}
