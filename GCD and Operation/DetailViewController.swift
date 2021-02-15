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
                    print(error.errorDescription!)
                }
            })
            
        }
    }
    
    private func getURL(completion: (Result<[String], AppErrors>) -> Void) {
        
        var isLoadingSuccess = false
      
        let urlArray = try? getArray()
        
        if urlArray != nil {
            isLoadingSuccess = true
        } else {
            print(AppErrors.invalidModel.errorDescription!)
        }
        
        if isLoadingSuccess {
            completion(.success(urlArray!))
        } else {
            completion(.failure(.notFoundURLs))
            showAlert()
        }
        
    }
    
    private func getArray() throws -> [String] {
        
        guard let url = apiUrl else { throw AppErrors.notFoundURLs }
        
        let data = try? Data(contentsOf: url)
        
        guard let dataUnwrapping = data else { throw AppErrors.invalidModel }
        
        guard let json = try? JSON(data: dataUnwrapping) else { throw AppErrors.invalidModel }
        
        guard let array = json.array else { throw AppErrors.invalidModel }
        
         let urlArray = array.compactMap({
            $0["url"].rawString()
        })
        return urlArray
    }
    
    private func showAlert() {
        let alertVC = UIAlertController(title: nil, message: "No internet connection", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) {_ in
            preconditionFailure("No internet connection")
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        cell?.selectionStyle = .none
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.text = urlObjects[indexPath.row]
        return cell!
    }
    
    
}
