//
//  PhotosCollectionViewCell.swift
//  GCD and Operation
//
//  Created by Егор Никитин on 29.01.2021.
//

import UIKit
import SnapKit

final class PhotosCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    
    public var imageURL: URL? {
        didSet{
            photoImageView.image = nil
            updateUI()
        }
    }
    
    private lazy var photoImageView: UIImageView = {
        $0.backgroundColor = .gray
        return $0
    }(UIImageView())
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configure UI
    private func updateUI() {
        guard let url = imageURL else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            let contentsOfURL = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if url == self.imageURL {
                    guard let imageData = contentsOfURL else { return }
                    self.photoImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    //MARK: Layout
    func setupLayout() {
        contentView.addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
