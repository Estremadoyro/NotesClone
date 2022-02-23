//
//  NewNoteVC.swift
//  NotesClone
//
//  Created by Leonardo  on 19/02/22.
//

import UIKit

class NewNoteVC: UIViewController {
  @IBOutlet private weak var textView: UITextView!
  @IBOutlet private weak var noteTitleLabel: UITextField!
  @IBOutlet private weak var scrollView: UIScrollView!

  weak var notesDelegate: NotesDelegate?

  weak var notes: Notes? {
    didSet {
      print("notes recieved: \(notes ?? Notes(notes: [Note]()))")
    }
  }

  private lazy var newNoteNavigation = NewNoteNavigationBar(newNoteVC: self)

  override func viewDidLoad() {
    super.viewDidLoad()
    newNoteNavigation.noteDelegate = self
    scrollView.delegate = self
    noteTitleLabel.delegate = self
    configureNavigationBar()
  }

  override func viewDidAppear(_ animated: Bool) {
    noteTitleLabel.becomeFirstResponder()
    print("First line: \(textView.text.getFirstLine3())")
    print("Whol text length: \(textView.text.count)")
  }

  deinit {
    print("\(self) deinited")
  }
}

extension NewNoteVC {
  private func configureNavigationBar() {
    navigationItem.largeTitleDisplayMode = .never
    newNoteNavigation.buildNavigationItems()
  }
}

extension NewNoteVC {
  @objc
  private func dismissKeyboardTouchOutside() {
    textView.endEditing(true)
    noteTitleLabel.endEditing(true)
  }
}

extension NewNoteVC: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    textView.resignFirstResponder()
    noteTitleLabel.resignFirstResponder()
  }
}

extension NewNoteVC: NewNoteDelegate {
  func willSaveNewNote() {
    guard var title = noteTitleLabel.text?.trimmingCharacters(in: .whitespaces) else { return }
    guard var body = textView.text?.trimmingCharacters(in: .whitespaces) else { return }

    if title == "" {
      title = "Unnamed note"
    }

    if body == "" {
      body = "No content 😢"
    }

    let note = Note(title: title, body: body)
    print("Text to save: \(textView.text ?? "")")
    notes?.notes.append(note)
    navigationController?.popViewController(animated: true)
    notesDelegate?.didSaveNote(note: note)
  }
}

extension NewNoteVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    jumpToNextTextField(textField)
    return true
  }

  func jumpToNextTextField(_ textField: UITextField) {
    switch textField {
      case noteTitleLabel:
        textView.becomeFirstResponder()
      default:
        return
    }
  }
}
