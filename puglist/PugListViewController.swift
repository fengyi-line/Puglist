//
//  ViewController.swift
//  puglist
//
//  Created by ST20991 on 2019/08/28.
//  Copyright © 2019 fengyi. All rights reserved.
//

import UIKit

struct Pug: Codable {
    let pugId: String
    let name: String
    let photo: String
}

enum PugListViewControllerState {
    case normal([Pug])
    case error(Error)
    case empty
    case loading
}

class PugListViewController: UIViewController {
    
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
    
    var state: PugListViewControllerState = .loading {
        didSet {
            switch state {
            case .normal(let items):
                centerLabel.text = nil
                self.navigationItem.title = "PUG (\(items.count))"
            case .error(_):
                centerLabel.text = "ERROR"
                self.navigationItem.title = "PUG"
            case .empty:
                centerLabel.text = "EMPTY"
                self.navigationItem.title = "PUG"
            case .loading:
                centerLabel.text = "LOADING..."
                self.navigationItem.title = "PUG"
            }
            self.tableView.reloadData()
        }
    }
    
    var pugs:[Pug] {
        switch state {
        case .normal(let items):
            return items
        case .error(_):
            return []
        case .empty:
            return []
        case .loading:
            return []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "REFRESH", style: .plain, target: self, action: #selector(refresh))

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
        API.getPugList {[weak self] (error, pugs) in
            if let error = error {
                self?.state = .error(error)
                return
            }
            guard let pugs = pugs, !pugs.isEmpty else {
                self?.state = .empty
                return
            }
            self?.state = .normal(pugs)
        }
    }
}


extension PugListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pugItem = pugs[indexPath.row]
        self.navigationController?.pushViewController(PugInfoViewController(pugId: pugItem.pugId), animated: true)
    }
}


extension PugListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        let pugItem = pugs[indexPath.row]
        cell.textLabel?.text = pugItem.name
        cell.selectionStyle = .none
        if let imageView = cell.imageView {
            ImageHandler.shared.updateImageView(imageView, from: URL(string: pugItem.photo)!, placeholder: UIImage(named: "placeholder"))
            imageView.contentMode = .scaleAspectFill
        }

        return cell
    }
}
