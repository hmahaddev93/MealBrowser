//
//  MealImageCell.swift
//  MealBrowser
//
//  Created by Khateeb H. on 3/4/22.
//

import UIKit

final class MealImageCell: UITableViewCell {

    var meal: Meal? {
        didSet {
            guard let thumbnailUrl = meal?.thumbURL else {
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    
    private func commonInit() {
        backgroundColor = .white
        self.addSubview(thumbImageView)
        
        NSLayoutConstraint.activate([
            thumbImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0),
            thumbImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0),
            thumbImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            thumbImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
