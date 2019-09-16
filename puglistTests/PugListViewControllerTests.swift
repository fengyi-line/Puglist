//
//  puglistTests.swift
//  puglistTests
//
//  Created by ST20991 on 2019/08/28.
//  Copyright © 2019 fengyi. All rights reserved.
//

import XCTest
@testable import puglist

class PugListViewControllerTests: XCTestCase {

    func testEmpty() {
        let api = API()
        api.getPugList = { $0(nil,[]) }
        
        let vc = PugListViewController(api: api)
        _ = vc.view
        if case PugListViewControllerState.empty = vc.state {
            
        } else {
            XCTFail("PugList is not empty")
        }
    }

    func testError() {
        let api = API()
        api.getPugList = { $0(NSError(domain: "", code: 0, userInfo: nil),nil) }

        let vc = PugListViewController(api: api)
        _ = vc.view
        if case PugListViewControllerState.error(_) = vc.state {
            
        } else {
            XCTFail("PugList is not error")
        }
    }

    func testNormal() {
        let api = API()
        api.getPugList = { $0(nil,[.init(pugId: "", name: "", photo: "")]) }

        let vc = PugListViewController(api: api)
        _ = vc.view
        if case PugListViewControllerState.normal(let pugs) = vc.state {
            XCTAssertFalse(pugs.isEmpty)
        } else {
            XCTFail("PugList is not normal")
        }
    }
}
