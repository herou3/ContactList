//
//  String.swift
//  Contact List
//
//  Created by Pavel Kurilov on 09.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation

extension String {
    
    func contains(find: String?) -> Bool {
        let find = find ?? "test"
        return self.range(of: find) != nil
    }
}
