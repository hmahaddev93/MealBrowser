//
//  MealCollectionCell.swift
//  MealBrowser
//
//  Created by Khateeb H. on 3/4/22.
//

import UIKit

final class MealCollectionCell: UICollectionViewCell {
    
    var meal: MealSummary? {
        didSet {
            self.nameLabel.text = meal?.title
            
            guard let thumbnailUrl = meal?.thumbURL else {
                return
            }
            self.thumbImageView.loadThumbnail(url: thumbnailUrl)
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let thumbImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: MBLabel = {
        let label = MBLabel(size: 16, isBold: true, alignment: .center)
        label.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        return label
    }()
    
    private func commonInit() {
        backgroundColor = .white
        self.addSubview(thumbImageView)
        self.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            thumbImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0),
            thumbImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0),
            thumbImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            thumbImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0),
            nameLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
