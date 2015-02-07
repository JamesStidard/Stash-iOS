//
//  ScryptTests.swift
//  stash
//
//  Created by James Stidard on 26/01/2015.
//  Copyright (c) 2015 James Stidard. All rights reserved.
//

import UIKit
import XCTest

class ScryptTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        SodiumUtilities.initialiseSodium()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScryptPasswordNilSaltNilN512r256p1() {
        let expectedOut :[UInt8] = [
            0xa8, 0xea, 0x62, 0xa6, 0xe1, 0xbf, 0xd2, 0x0e,
            0x42, 0x75, 0x01, 0x15, 0x95, 0x30, 0x7a, 0xa3,
            0x02, 0x64, 0x5c, 0x18, 0x01, 0x60, 0x0e, 0xf5,
            0xcd, 0x79, 0xbf, 0x9d, 0x88, 0x4d, 0x91, 0x1c
        ]
        let expectedOutData = NSData(bytes: expectedOut, length: expectedOut.count)
        
        if let actualOutData = Scrypt.salsa208Sha256(nil, salt: nil, N: UInt64(512), r: UInt32(256), p: UInt32(1)) {
            
            if expectedOutData.isEqualToData(actualOutData) {
                XCTAssertTrue(true, "Pass")
                return
            }
        }
        
        XCTAssertTrue(false, "Scrypt.salsa208Sha256 returning incorrect data")
    }
}