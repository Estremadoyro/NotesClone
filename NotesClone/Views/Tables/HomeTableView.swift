//
//  HomeTableView.swift
//  NotesClone
//
//  Created by Leonardo  on 19/02/22.
//

import UIKit

class HomeTableView: UITableView {
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    configureTable()
  }
}

extension HomeTableView {
  private func configureTable() {
    self.layer.cornerRadius = 10
    self.layer.masksToBounds = true
  }
}
