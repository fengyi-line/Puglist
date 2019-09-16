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
        let vc = PugListViewController(api: APIEmpty.self)
        _ = vc.view
        if case PugListViewControllerState.empty = vc.state {
            
        } else {
            XCTFail("PugList is not empty")
        }
    }

    func testError() {
        let vc = PugListViewController(api: APIError.self)
        _ = vc.view
        if case PugListViewControllerState.error(_) = vc.state {
            
        } else {
            XCTFail("PugList is not error")
        }
    }

    func testNormal() {
        let vc = PugListViewController(api: APINormal.self)
        _ = vc.view
        if case PugListViewControllerState.normal(_) = vc.state {
            
        } else {
            XCTFail("PugList is not normal")
        }
    }
}

private class APIEmpty : APIProtocol {
    static func getPugList(_ callback: @escaping (Error?, [Pug]?) -> ()) {
        callback(nil,[])
    }
    
    static func getPugInfo(_ pugId: String, _ callback: @escaping (Error?, PugInfo?) -> ()) {
    }
}

private class APIError : APIProtocol {
    static func getPugList(_ callback: @escaping (Error?, [Pug]?) -> ()) {
        callback(NSError.init(domain: "", code: 0, userInfo: nil),nil)
    }
    
    static func getPugInfo(_ pugId: String, _ callback: @escaping (Error?, PugInfo?) -> ()) {
    }
}

private class APINormal : APIProtocol {
    static func getPugList(_ callback: @escaping (Error?, [Pug]?) -> ()) {
        callback(nil,[.init(pugId: "1", name: "1", photo: "1")])
    }
    
    static func getPugInfo(_ pugId: String, _ callback: @escaping (Error?, PugInfo?) -> ()) {
    }
}

