//
//  RealmWrapper.swift
//  Contact List
//
//  Created by Pavel Kurilov on 25.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmEntity {
    associatedtype TransientType: TransientEntity where TransientType.RealmType == Self
    
    static func from(transient: TransientType, in realm: Realm) -> Self
    func transient() -> TransientType
}

protocol TransientEntity {
    associatedtype RealmType: RealmEntity where RealmType.TransientType == Self
}

typealias VoidBlock = (() -> Void)
typealias RealmBlock = ((Realm) -> Void)

class RealmWrapper: NSObject {
    
    // MARK: - Properties
    var persistentRealm: Realm
    
    // MARK: - Init
    override init() {
        persistentRealm = Realm.persistentStore()
    }
    
    // MARK: - Internal
    
    func writeAsync(completion: VoidBlock? = nil, writeBlock: @escaping RealmBlock) {
        DispatchQueue.global(qos: .utility).async {
            self.writeSync(block: writeBlock)
            DispatchQueue.main.async {
                self.persistentRealm.refresh()
                completion?()
            }
        }
    }
    
    // MARK: Private
    private func writeSync(block: @escaping RealmBlock) {
        do {
            let persistent = Realm.persistentStore()
            try persistent.write {
                block(persistent)
            }
        } catch let error {
            fatalError("Can't write to Realm instance: \(error)")
        }
    }
}
