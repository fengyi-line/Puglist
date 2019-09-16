//
//  PugInfoViewController.swift
//  puglist
//
//  Created by ST20991 on 2019/09/13.
//  Copyright © 2019 fengyi. All rights reserved.
//

import UIKit

struct PugInfo: Codable {
    let pugId: String
    let name: String
    let photo: String
    let birthday: String
    let gender: String
}

enum PugInfoViewControllerState {
    case normal(PugInfo)
    case error(Error)
    case loading
}

class PugInfoViewController: UIViewController {
    
    lazy var centerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        label.textAlignment = .center
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    var state: PugInfoViewControllerState = .loading {
        didSet {
            switch state {
            case .normal(_):
                centerLabel.text = nil
            case .error(_):
                centerLabel.text = "ERROR"
            case .loading:
                centerLabel.text = "LOADING..."
            }
            self.tableView.reloadData()
        }
    }
    
    var pugInfo:PugInfo? {
        switch state {
        case .normal(let info):
            return info
        case .error(_):
            return nil
        case .loading:
            return nil
        }
    }
    
    let pugId: String
    let api: API
    
    init(pugId: String, api:API) {
        self.pugId = pugId
        self.api = api
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.frame = self.view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)

        centerLabel.frame = self.view.bounds
        self.view.addSubview(centerLabel)

        self.refresh()
    }

    @objc
    func refresh() {
        state = .loading
        api.getPugInfo(pugId) {[weak self] (error, pugInfo) in
            if let error = error {
                self?.state = .error(error)
                return
            }

            guard let pugInfo = pugInfo else {
                self?.state = .error(NSError.init(domain: "", code: 0, userInfo: nil))
                return
            }

            self?.state = .normal(pugInfo)
        }
    }
}


extension PugInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.bounds.width
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension PugInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let photo = pugInfo?.photo, let url = URL(string: photo) else {
            return nil
        }
        
        let imageView = UIImageView.init(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        
        ImageHandler.shared.updateImageView(imageView, from: url, placeholder: UIImage(named: "placeholder"))
        return imageView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if case PugInfoViewControllerState.normal(_) = state {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case PugInfoViewControllerState.normal(_) = state {
            return 3
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .value2, reuseIdentifier: "cell")

        guard let cellType = CellType(rawValue: indexPath.row) else {
            return cell
        }
        cell.selectionStyle = .none
        switch cellType {
        case .name:
            cell.textLabel?.text = "NAME"
            cell.detailTextLabel?.text = pugInfo?.name
        case .gender:
            cell.textLabel?.text = "GENDER"
            cell.detailTextLabel?.text = pugInfo?.gender
        case .birthday:
            cell.textLabel?.text = "BIRTHDAY"
            cell.detailTextLabel?.text = pugInfo?.birthday
        }

        return cell
    }
}

enum CellType: Int {
    case name, gender, birthday
}
