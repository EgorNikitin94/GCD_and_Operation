//
//  ViewController.swift
//  GCD and Operation
//
//  Created by Егор Никитин on 29.01.2021.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    private lazy var showImagesButton: UIButton = {
        $0.setTitle("Show images", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemRed
        $0.layer.cornerRadius = 6
        $0.addTarget(self, action: #selector(tapShowImagesButton), for: .touchUpInside)
        return $0
    }(UIButton())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FirstVC"
        view.backgroundColor = .white
        setupLayoutButton()
    }
    
    
    private func setupLayoutButton() {
        view.addSubview(showImagesButton)
        
        showImagesButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-60)
            make.height.equalTo(50)
        }
        
    }
    
    @objc private func tapShowImagesButton() {
        let photosViewController = PhotosViewController()
        navigationController?.pushViewController(photosViewController, animated: true)
    }

}

