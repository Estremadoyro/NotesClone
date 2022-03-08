//
//  HomeActionSheetVC+Gesture.swift
//  NotesClone
//
//  Created by Leonardo  on 26/02/22.
//

import UIKit

enum ConstraintUpdateType {
  case toHidden
  case toMidHeight
  case toFullScreen
}

extension HomeActionSheetVC {
  fileprivate var activateSheetFullScreen: Void {
    alertIsFullHeight.constant = 0
    alertIsFullHeight.isActive = true
    alertIsDisplayed.isActive = false
    alertIsHidden.isActive = false
  }

  fileprivate var activateSheetMidHeight: Void {
    alertIsDisplayed.constant = 0
    alertIsFullHeight.constant = 0
    alertIsDisplayed.isActive = true
    alertIsFullHeight.isActive = false
    alertIsHidden.isActive = false
  }

  internal var activateSheetHidden: Void {
    alertIsDisplayed.constant = 0
    alertIsFullHeight.constant = 0
    alertIsDisplayed.isActive = false
    alertIsFullHeight.isActive = false
    alertIsHidden.isActive = true
  }

  @IBAction func didPanAction(_ gesture: UIPanGestureRecognizer) {
    let dragTranslation = gesture.translation(in: view)
    let actionSheetHeight = homeActionSheetView.frame.size.height
    let masterViewHeight = view.frame.size.height - view.safeAreaInsets.top
    let heightForFullScreenThreshold = masterViewHeight * 4 / 5
    let heightForHiddenThreshold = masterViewHeight / 4
    let heightForBounceBackFullScreenThreshold = masterViewHeight * 4 / 5

    switch gesture.state {
      case .began:
        break
      case .changed:
        if actionSheetHeight < masterViewHeight || dragTranslation.y > 0 {
          print("~ actionSheetHeight: \(actionSheetHeight)")
          if alertIsFullHeight.isActive {
            // Top anchor, must be negative as only option is dragging down
            alertIsFullHeight.constant = dragTranslation.y
          } else {
            // Height anchor, must be positive
            alertIsDisplayed.constant = -dragTranslation.y
          }
        } else {
          print("max dragging reached")
        }

      case .ended:
        print("pan ended")
        if actionSheetHeight <= heightForHiddenThreshold {
          print("hide action")
          constraintsUpdateWithAnimation(updateType: .toHidden) { activateSheetHidden }
        } else if actionSheetHeight > heightForFullScreenThreshold {
          constraintsUpdateWithAnimation(updateType: .toFullScreen) { activateSheetFullScreen }
          homeActionSheetView.superview?.layoutIfNeeded()
        } else if actionSheetHeight > heightForBounceBackFullScreenThreshold {
          print("bounce back to full screen")
          constraintsUpdateWithAnimation(updateType: .toFullScreen) { activateSheetFullScreen }
          homeActionSheetView.superview?.layoutIfNeeded()
        } else {
          print("else go back to original")
          constraintsUpdateWithAnimation(updateType: .toMidHeight) { activateSheetMidHeight }
        }
      case .possible:
        break
      case .cancelled:
        break
      case .failed:
        break
      @unknown default:
        constraintsUpdateWithAnimation(updateType: .toMidHeight) {
          activateSheetMidHeight
        }
        print("pan unkwnown default")
    }
  }
}
