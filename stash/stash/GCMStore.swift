//
//  GCMStore.swift
//  stash
//
//  Created by James Stidard on 11/02/2015.
//  Copyright (c) 2015 James Stidard. All rights reserved.
//

import Foundation
import CoreData

@objc(GCMStore)
class GCMStore: SecureStore {

    @NSManaged var nonce: NSData
    @NSManaged var identity: Identity?

}
