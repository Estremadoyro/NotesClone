//
//  Sandbox.swift
//  NotesClone
//
//  Created by Leonardo  on 20/02/22.
//

import UIKit

class SandBox {
  let headerAttributes = [kCTFontAttributeName: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
  let bodyAttributes = [kCTFontAttributeName: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]

  private func highlightFirstLineInTextView(textView: UITextView) {
    let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
    let textAsNSString = textView.text as NSString
    let boldFont = UIFont.boldSystemFont(ofSize: 24) as Any
    let normalFont = UIFont.preferredFont(forTextStyle: .body) as Any
    let lineBreakRange = NSRange(textView.text!.lineRange(for: ..<textView.text!.startIndex), in: textView.text!)
    let boldRange: NSRange
    let normalRange: NSRange

    print("line break range: \(lineBreakRange.location)")
    print("nsstring length: \(textAsNSString.length)")
    if lineBreakRange.location < textAsNSString.length {
      boldRange = NSRange(location: 0, length: lineBreakRange.location)
      normalRange = NSRange(location: lineBreakRange.location, length: attributedText.length)
    } else {
      boldRange = NSRange(location: 0, length: attributedText.length)
      normalRange = NSRange(location: 0, length: 0)
    }

    attributedText.addAttribute(NSAttributedString.Key.font, value: boldFont, range: boldRange)
    attributedText.addAttribute(NSAttributedString.Key.font, value: normalFont, range: normalRange)
    textView.attributedText = attributedText
  }
}

extension SandBox {
  // find pin, expensive, but there is a simpler way with 2 lists (pinned and not pinned)
//          let noteToPin: Note = notes.first(where: { $0.id == strongSelf.notPinnedNotes[globalIndex - pinnedNotes].id }) ?? Note(title: "error", body: "error")
}
