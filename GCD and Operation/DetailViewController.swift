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
        
        let myOperation = OperationQueue()
        
        myOperation.addOperation {
            
            self.getURL(completion: { (result) in
                switch result {
                case .success(let array):
                    self.urlObjects = array
                case .failure(let error):
                    if let errorDescription = error.errorDescription {
                        print(errorDescription)
                    }
                }
            })
            
        }
    }
    
    private func getURL(completion: (Result<[String], AppErrors>) -> Void) {
        
        guard let urlArray = try? getArray() else {
            completion(.failure(.notFoundURLs))
            showAlert()
            return
        }
        
        completion(.success(urlArray))
        
        
    }
    
    private func getArray() throws -> [String] {
        
        guard let url = apiUrl else { throw AppErrors.notFoundURLs }
        
        let data = try Data(contentsOf: url)
        
        let json = try JSON(data: data)
        
        guard let array = json.array else { throw AppErrors.invalidModel }
        
         let urlArray = array.compactMap({
            $0["url"].rawString()
        })
        return urlArray
    }
    
    private func showAlert() {
        let alertVC = UIAlertController(title: nil, message: AppErrors.noInternetConnection.errorDescription, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alertVC.addAction(okButton)
        present(alertVC, animated: true, completion: nil)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = urlObjects[indexPath.row]
        return cell
    }
    
    
}
