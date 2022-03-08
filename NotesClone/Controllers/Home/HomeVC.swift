//
//  ViewController.swift
//  NotesClone
//
//  Created by Leonardo  on 18/02/22.
//

import UIKit

final class HomeVC: UIViewController {
  @IBOutlet weak var tableView: HomeTableView!
  @IBOutlet weak var homeToolbar: HomeToolBarView!
  @IBOutlet weak var homeSearchBar: UISearchBar!

  var homeNavigationBar: HomeNavigationBar?
  var editIndexPath: IndexPath?
  var insertIndexPath: IndexPath?
  var isFiltering: Bool = false
  var didSetupSections: Bool = false

  var notes = Notes()
  lazy var filteredNotes: [Note] = (notes.copy(with: nil) as? Notes)?.notes ?? [Note]()

  var tableSectionsAmount: Int = 1 {
    didSet {
      assert(tableSectionsAmount <= 2 && tableSectionsAmount > 0, "# Sections can't be \(tableSectionsAmount)")
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
//    UserDefaults.standard.reset()
//    notes.notes = Utils.createDummyData(4).reversed()
    tableView.dataSource = self
    tableView.delegate = self
    homeSearchBar.delegate = self
    configureNavigationBar()
    configureToolbar()
    configureGestures()
    print("Loaded notes: \(notes.notes.map { "\($0.title) (P: \($0.pinned))" })")
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if !didSetupSections {
      print("SETUP - SHOULD RUN ONLY ONCE")
      setupInitialSections()
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if let editIndexPath = editIndexPath {
      tableView.reloadRows(at: [editIndexPath], with: .automatic)
      print("RELOADED INDEXPATH - row: \(editIndexPath.row) | section: \(editIndexPath.section)")
      self.editIndexPath = nil
    }

    if let insertIndexPath = insertIndexPath {
      tableView.insertRows(at: [insertIndexPath], with: .automatic)
      self.insertIndexPath = nil
      homeToolbar.configureHomeToolBar(notes: notes)
    }
  }

  deinit { print("\(self) deinited") }
}

extension HomeVC {
  private func configureNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    homeNavigationBar = HomeNavigationBar(homeTableVC: self)
    homeNavigationBar?.buildNavigationBarItems()
  }

  private func configureToolbar() {
    homeToolbar.configureHomeToolBar(notes: notes)
  }
}

extension HomeVC {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
      case HomeConstants.goToNewNoteVCSegueId:
        // New Note
        print("GO TO NEW NOTE")
        let newNoteVC = segue.destination as? NewNoteVC
        newNoteVC?.notes = notes
        newNoteVC?.notesDelegate = self
      case HomeConstants.goToEditNoteSegueId:
        // Edit Note
        print("GO TO EDIT NOTE")
        let cellSender = sender as? NoteCellView
        let newNoteVC = segue.destination as? NewNoteVC
        guard let indexPath = tableView.indexPathForSelectedRow else {
          fatalError("ERROR PASSING INDEX PATH TO EDIT ROW")
        }
        newNoteVC?.notes = notes
        newNoteVC?.note = cellSender?.note
        newNoteVC?.notesDelegate = self
        newNoteVC?.noteSceneType = .isEditingNote
        newNoteVC?.noteIndexPath = indexPath
      default:
        return
    }
  }
}

extension HomeVC: NotesDelegate {
  func didSaveNote(note: Note) {
    notes.insertNewNote(&filteredNotes, isFiltering, note: note)
    let section: Int = tableSectionsAmount > 1 ? 1 : 0
    insertIndexPath = IndexPath(row: 0, section: section)
  }

  func didEditNote(noteIndexPath: IndexPath, title: String, body: String) {
    print("DID EDIT NOTE")
    let globalIndex: Int = getIndexForSection(in: noteIndexPath)
    notes.updateNote(&filteredNotes, isFiltering, noteIndex: globalIndex, title: title, body: body)
    editIndexPath = noteIndexPath
  }
}
