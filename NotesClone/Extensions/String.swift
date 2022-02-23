//
//  Extensions.swift
//  NotesClone
//
//  Created by Leonardo  on 20/02/22.
//

import Foundation

extension String {
  func getFirstLine() -> NSRange {
    let range = self.lineRange(for: ..<self.startIndex)
    return NSRange(range, in: self)
  }

  func getFirstLine2() -> SubSequence {
    let partialRangeOfFirstLine: PartialRangeUpTo<String.Index> = ..<(rangeOfCharacter(from: .newlines)?.lowerBound ?? endIndex)
    let firstLine: SubSequence = self[partialRangeOfFirstLine]
    return firstLine
  }

  func getFirstLine3() -> String {
    guard let firstParagraph = self.components(separatedBy: CharacterSet.newlines).first else {
      return ""
    }
    return firstParagraph
  }

  func rangeOfFirstLine() -> Range<String.Index> {
    let partialRangeOfFirstLine: PartialRangeUpTo<String.Index> = ..<(rangeOfCharacter(from: .newlines)?.lowerBound ?? endIndex)
    return self.startIndex ..< partialRangeOfFirstLine.upperBound
  }
}
