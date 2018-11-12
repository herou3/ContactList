//
//  String+Contains.swift
//  Contact List
//
//  Created by Pavel Kurilov on 09.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation

extension String {
    
    func contains(find: String?) -> Bool {
        guard let containString = find else { return false }
        return self.range(of: containString) != nil
    }
    
    func sanitizedPhoneNumber() -> String {
        guard !isEmpty else { return self }
        let range = startIndex..<index(startIndex, offsetBy: count)
        return replacingOccurrences(of: "[^+0-9]", with: "",
                                    options: .regularExpression,
                                    range: range)
    }
}
