//
//  Realm+Init.swift
//  Contact List
//
//  Created by Pavel Kurilov on 25.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {

    class func inMemoryStore(inMemoryIdentifier: String = Constant.realmInMemoryStoreIdentifier) -> Realm {
        do {
            let realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: inMemoryIdentifier))
            return realm
        } catch let error as NSError {
            fatalError("Error while creating Realm in-memory store: \(error)")
        }
    }
    
    class func persistentStore() -> Realm {
        do {
            var configuration = Realm.Configuration(
                schemaVersion: Constant.currentRealmSchemaVersion,
                migrationBlock: nil)
            configuration.deleteRealmIfMigrationNeeded = false
            let realm = try Realm(configuration: configuration)
            return realm
        } catch {
            fatalError("Error while creating Realm persistent store: \(error)")
        }
    }
}
