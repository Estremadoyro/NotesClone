//
//  HomeAlertActionSheetVC.swift
//  NotesClone
//
//  Created by Leonardo  on 25/02/22.
//

import UIKit

protocol IHomeActionSheetGestures {
  func didPanAction(_ gesture: UIPanGestureRecognizer)
  func constraintsUpdateWithAnimation(updateType: ConstraintUpdateType, constraintsUpdates: () -> Void)
  var alertIsDisplayed: NSLayoutConstraint! { get set }
  var alertIsFullHeight: NSLayoutConstraint! { get set }
  var alertIsHidden: NSLayoutConstraint! { get set }
  var homeActionSheetView: HomeActionSheetView! { get set }
}

final class HomeActionSheetVC: UIViewController, IHomeActionSheetGestures {
  @IBOutlet internal weak var homeActionSheetView: HomeActionSheetView!
  @IBOutlet private weak var dismissHomeActionSheetButton: UIButton!
  @IBOutlet internal weak var homeActionSheetHeaderView: UIView!
  // Constraints must have a strong reference? or they get deallocated?
  @IBOutlet internal var alertIsHidden: NSLayoutConstraint!
  @IBOutlet internal var alertIsDisplayed: NSLayoutConstraint!
  @IBOutlet internal var alertIsFullHeight: NSLayoutConstraint!
  @IBOutlet internal var homeActionSheetHeaderViewHeight: NSLayoutConstraint!
  private var didAnimate: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    alertIsDisplayed.isActive = false
    alertIsFullHeight.isActive = false
    dismissHomeActionSheetButton.superview?.layoutIfNeeded()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if !didAnimate {
      didAnimate = true
      animatePresentingView()
      print("did layout subviews")
    }
  }

  deinit { print("\(self) deallocated") }
}

extension HomeActionSheetVC {
  private func animatePresentingView() {
    alertIsDisplayed.isActive = true
    UIView.animate(withDuration: 0.30, delay: 0, animations: { [weak self] in
      self?.homeActionSheetView.superview?.layoutIfNeeded()
    })
  }
}

extension HomeActionSheetVC {
  @IBAction private func dismissHomeAlertActionSheet(_ sender: UIButton) {
    print("dismiss vc")
    constraintsUpdateWithAnimation(updateType: .toHidden) { activateSheetHidden }
  }

  internal func constraintsUpdateWithAnimation(updateType: ConstraintUpdateType = .toHidden, constraintsUpdates: () -> Void) {
    constraintsUpdates()
    let customAnimation: () -> Void = { [weak self] in
      if updateType == .toHidden {
        self?.homeActionSheetHeaderViewHeight.constant = 0
      }
      self?.homeActionSheetView.superview?.layoutIfNeeded()
    }
    let customCompletion: (Bool) -> Void = { [weak self] _ in
      self?.dismiss(animated: true, completion: nil)
    }
    UIView.animate(withDuration: 0.30, delay: 0, options: [], animations: customAnimation, completion: updateType == .toHidden ? customCompletion : nil)
  }
}

extension HomeActionSheetVC {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
    if touch?.view != homeActionSheetView, touch?.view != homeActionSheetHeaderView {
      constraintsUpdateWithAnimation(updateType: .toHidden) { [unowned self] in
        self.activateSheetHidden
      }
    }
  }
}
