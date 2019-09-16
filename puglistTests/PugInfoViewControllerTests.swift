//
//  puglistTests.swift
//  puglistTests
//
//  Created by ST20991 on 2019/08/28.
//  Copyright © 2019 fengyi. All rights reserved.
//

import XCTest
@testable import puglist

class PugInfoViewControllerTests: XCTestCase {

    func testError() {
        let api = API()
        api.getPugInfo = { $1(NSError(domain: "", code: 0, userInfo: nil),nil) }
        
        let vc = PugInfoViewController(pugId: "pugId" ,api: api)
        _ = vc.view
        if case PugInfoViewControllerState.error(_) = vc.state {
            
        } else {
            XCTFail("PugList is not error")
        }
    }

    func testNormal() {
        let api = API()
        api.getPugInfo = { $1(nil,.init(pugId: "", name: "", photo: "", birthday: "", gender: "")) }
        
        let vc = PugInfoViewController(pugId: "pugId" ,api: api)
        _ = vc.view
        if case PugInfoViewControllerState.normal(_) = vc.state {
            
        } else {
            XCTFail("PugList is not normal")
        }
    }
}
