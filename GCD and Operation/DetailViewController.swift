//
//  URLViewController.swift
//  GCD and Operation
//
//  Created by Егор Никитин on 30.01.2021.
//

import UIKit
import SnapKit
import SwiftyJSON

class DetailViewController: UIViewController {
    
    public var apiUrl: URL?
    
    private let tableView = UITableView()
    
    private var urlObjects: [String] = [] {
        didSet{
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    private let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingUrl()
        title = "URLs"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
    }
    
    private func loadingUrl() {

        guard let url = apiUrl else {return}
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, responce, error) in

            guard let data = data else { return }

            let json = try! JSON(data: data)

            guard let array = json.array else { return }

            self?.urlObjects = array.compactMap({
                $0["url"].rawString()
            })

        }
        dataTask.resume()
    }
    
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}


extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        cell?.selectionStyle = .none
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.text = urlObjects[indexPath.row]
        return cell!
    }
    
    
}
