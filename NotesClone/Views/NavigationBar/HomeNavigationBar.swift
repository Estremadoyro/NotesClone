//
//  HomeTableNavigation.swift
//  NotesClone
//
//  Created by Leonardo  on 19/02/22.
//

import UIKit

class HomeNavigationBar {
  weak var homeTableVC: UIViewController?

  init(homeTableVC: UIViewController) {
    self.homeTableVC = homeTableVC
  }

  deinit {
    print("\(self) deinited")
  }
}

extension HomeNavigationBar {
  open func buildNavigationBarItems() {
    let moreButtonImage = UIImage(systemName: "ellipsis.circle")?.withRenderingMode(.alwaysTemplate)

    let moreButton = UIBarButtonItem(image: moreButtonImage, style: .plain, target: self, action: #selector(showMoreOptions))
    moreButton.tintColor = UIColor.systemYellow
    let rightBarItems: [UIBarButtonItem] = [moreButton]
    homeTableVC?.navigationItem.rightBarButtonItems = rightBarItems
  }
}

extension HomeNavigationBar {
  @objc
  private func showMoreOptions() {
    print("show more buttons")
    let homeAlertActionSheetVC = UIStoryboard(name: "HomeActionSheet", bundle: .main).instantiateViewController(withIdentifier: "HomeAlertActionSheetVC") as! HomeActionSheetVC
    homeTableVC?.present(homeAlertActionSheetVC, animated: true, completion: nil)
  }
}
