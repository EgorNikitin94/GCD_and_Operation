//
//  PhotosViewController.swift
//  GCD and Operation
//
//  Created by Егор Никитин on 29.01.2021.
//

import UIKit
import SnapKit
import SwiftyJSON

final class PhotosViewController: UIViewController {
    
    //MARK: - Properties
    
    private let apiUrl: URL? = URL(string: "https://jsonplaceholder.typicode.com/photos")
    
    private var objects: [URL] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private lazy var infoButton: UIBarButtonItem = {
        $0.title = "info"
        $0.target = self
        $0.style = .plain
        $0.action = #selector(infoButtonTapped)
        return $0
    }(UIBarButtonItem())
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PhotosCollectionViewCell.self))
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = infoButton
        setupViews()
        view.backgroundColor = .white
        self.navigationItem.title = "Photo Gallery"
        loadingImagesUrl()
    }
    
    //MARK: SetupViews
    
    private func setupViews() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    private func loadingImagesUrl() {
        
        DispatchQueue.global().async {
            
            self.getURL(completion: { (result) in
                switch result {
                case .success(let array):
                    self.objects = array
                case .failure(let error):
                    print(error.errorDescription!)
                }
            })
            
        }
    }
    
    private func getURL(completion: (Result<[URL], AppErrors>) -> Void) {
        
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
    
    private func getArray() throws -> [URL] {
        
        guard let url = apiUrl else { throw AppErrors.notFoundURLs }
        
        let data = try? Data(contentsOf: url)
        
        guard let dataUnwrapping = data else { throw AppErrors.invalidModel }
        
        guard let json = try? JSON(data: dataUnwrapping) else { throw AppErrors.invalidModel }
        
        guard let array = json.array else { throw AppErrors.invalidModel }
        
        let urlArray = array.compactMap({
            URL(string: $0["url"].rawString() ?? "unknown")
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
    
    @objc private func infoButtonTapped() {
        let detailViewController = DetailViewController()
        detailViewController.apiUrl = apiUrl
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

//MARK: - DataSource and DelegateFlowLayout

extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotosCollectionViewCell.self), for: indexPath) as! PhotosCollectionViewCell
        
        let url = objects[indexPath.item]
        
        cell.imageURL = url
        
        return cell
    }
    
    
}


extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    private var baseInset: CGFloat { return 8 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.size.width - baseInset * 4) / 3
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return baseInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return baseInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: baseInset, left: baseInset, bottom: baseInset, right: baseInset)
    }
}
