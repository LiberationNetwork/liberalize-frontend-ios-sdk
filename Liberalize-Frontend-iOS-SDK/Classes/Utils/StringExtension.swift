//
//  StringExtension.swift
//  libralizetest
//
//  Created by Libralize on 06/10/2021.
//

import Foundation

extension String {
    var base64: String? {
        return Data(utf8).base64EncodedString()
    }

    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
        let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
        return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
        }.joined().dropFirst())
    }
}
