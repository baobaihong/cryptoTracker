//
//  String.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/26.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
