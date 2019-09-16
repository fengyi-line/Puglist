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
        let vc = PugInfoViewController(pugId: "pugId" ,api: APIError.self)
        _ = vc.view
        if case PugInfoViewControllerState.error(_) = vc.state {
            
        } else {
            XCTFail("PugList is not error")
        }
    }

    func testNormal() {
        let vc = PugInfoViewController(pugId: "pugId" ,api: APINormal.self)
        _ = vc.view
        if case PugInfoViewControllerState.normal(_) = vc.state {
            
        } else {
            XCTFail("PugList is not normal")
        }
    }
}

private class APIError : APIProtocol {
    static func getPugList(_ callback: @escaping (Error?, [Pug]?) -> ()) {
    }
    static func getPugInfo(_ pugId: String, _ callback: @escaping (Error?, PugInfo?) -> ()) {
        callback(NSError.init(domain: "", code: 0, userInfo: nil),nil)
    }
}

private class APINormal : APIProtocol {
    static func getPugList(_ callback: @escaping (Error?, [Pug]?) -> ()) {
    }
    static func getPugInfo(_ pugId: String, _ callback: @escaping (Error?, PugInfo?) -> ()) {
        callback(nil, .init(pugId: "", name: "", photo: "", birthday: "", gender: "") )
    }
}
