//
//  NoteCellView.swift
//  NotesClone
//
//  Created by Leonardo  on 19/02/22.
//

import UIKit

class NoteCellView: UITableViewCell {
  @IBOutlet weak var noteTitleLabel: UILabel!
  @IBOutlet weak var noteBodyLabel: UILabel!
  @IBOutlet weak var noteDateLabel: UILabel!

  var note: Note? {
    didSet {
      configureTitleLabel(text: note?.title)
      configureBodyLabel(text: note?.body)
      configureDateLabel(date: note?.date)
    }
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

extension NoteCellView {
  private func configureTitleLabel(text: String?) {
    guard let text = text else { return }
    noteTitleLabel.text = text
  }

  private func configureBodyLabel(text: String?) {
    guard let text = text else { return }
    noteBodyLabel.text = text
  }

  private func configureDateLabel(date: Date?) {
    guard let date = date else { return }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yy"
    let dateToString: String = dateFormatter.string(from: date)
    noteDateLabel.text = dateToString
  }
}
