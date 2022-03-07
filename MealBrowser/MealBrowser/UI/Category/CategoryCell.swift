//
//  CategoryCell.swift
//  MealBrowser
//
//  Created by Khateeb H. on 3/4/22.
//

import UIKit

final class CategoryCell: UITableViewCell {

    var category: MealCategory? {
        didSet {
            self.nameLabel.text = category?.name
            
            guard let thumbnailUrl = category?.thumbURL else {
                return
            }
            self.thumbImageView.loadThumbnail(url: thumbnailUrl)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
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
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let nameLabel = MBLabel(size: 16, isBold: true)
    
    private func commonInit() {
        backgroundColor = .white
        self.addSubview(thumbImageView)
        self.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            thumbImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            thumbImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            thumbImageView.widthAnchor.constraint(equalToConstant: 60),
            thumbImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: thumbImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameLabel.centerYAnchor.constraint(equalTo: thumbImageView.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
