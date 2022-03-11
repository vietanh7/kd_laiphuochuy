//
//  StringExtension.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/11/22.
//

import UIKit

extension String {
    private func RegexMatch(format: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", format)
        return predicate.evaluate(with: self)
    }
    
    var isValidEmail: Bool {
        return RegexMatch(format: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    }

    var isValidPassword: Bool {
        return RegexMatch(format: "^.{1,}$")
    }
}
