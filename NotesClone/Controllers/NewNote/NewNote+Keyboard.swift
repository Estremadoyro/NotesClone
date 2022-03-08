//
//  NewNote+Keyboard.swift
//  NotesClone
//
//  Created by Leonardo  on 7/03/22.
//

import UIKit

extension NewNoteVC {
  @objc
  func adjustKeyboard(notification: Notification) {
    // get keyboard's dimensions value
    guard let keyboardValue: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    // get keyboard's frame
    let keyboardScreenFrame: CGRect = keyboardValue.cgRectValue
    // convert the cgrect to the view's coordinates (x=0,y=0 @ topleft corner)
    let keyboardConvertedFrame = view.convert(keyboardScreenFrame, to: view.window)
    // The Keyboard's height starts from the bottom of the Window
    // Keyboard's height includes: BottomSafeAreaInsets & ToolBar's height
    // The UITextView's height is from the bottom of the SuperView and the Bottom of the UILabel
    // In order to account of the Tooolbar's height, it needs to be substracted from the final BottomInset calculation.
    let textViewBottomInset = keyboardConvertedFrame.height - newNoteToolBarView.frame.height
    // Add insets for both the UITextView and the UIScrollView
    textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: textViewBottomInset, right: 0)
    textView.scrollIndicatorInsets = textView.contentInset
    // Visible part of the UITextView
    let selectedRange = textView.selectedRange
    // Scroll so it is always visible
    textView.scrollRangeToVisible(selectedRange)
  }
}
