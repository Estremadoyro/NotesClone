//
//  Utils.swift
//  NotesClone
//
//  Created by Leonardo  on 4/03/22.
//

import UIKit

class Utils {
  static func createDummyData(_ notesAmount: Int = 0) -> [Note] {
    let alphabet: String = "abcdefghijklmnopqrstuvwxyz"
    var notesList = [Note]()
    for i in 0 ..< notesAmount {
      let letter: Character = alphabet[alphabet.index(alphabet.startIndex, offsetBy: (notesAmount - 1) - i)]
      let dummyNote = Note(title: String(letter).uppercased(), body: String(letter))
      notesList.append(dummyNote)
    }
    print("dummy notes: \(notesList.map { $0.title })")
    return notesList
  }

  static func dateFormater(date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    let dateToString: String = dateFormatter.string(from: date)
    return dateToString
  }
}
