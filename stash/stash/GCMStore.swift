//
//  GCMStore.swift
//  stash
//
//  Created by James Stidard on 09/02/2015.
//  Copyright (c) 2015 James Stidard. All rights reserved.
//

import CoreData

class GCMStore: SecureStore {
    @NSManaged var nonce: NSData
    @NSManaged var identity: Identity
}