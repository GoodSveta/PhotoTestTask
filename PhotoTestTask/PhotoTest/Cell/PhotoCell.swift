//
//  PhotoCell.swift
//  PhotoTest
//
//  Created by mac on 9.10.23.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
   
    var error = [Error]()
    
    var name: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Thonburi", size: 17)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        [name, image].forEach({ contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false })
        
        setupLayout()
        prepareForReuse()
    }
    
    private func setupLayout() {
        contentView.addConstraints([
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            
            image.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 7),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
    }
    
    func setupCell(with photo: Content) {
        
        name.text = photo.name
        
        DispatchQueue.global().async { [weak self] in
            if let urlToImage = URL(string: photo.image ?? ""),
               let data = try? Data(contentsOf: urlToImage, options: .alwaysMapped) {
                DispatchQueue.main.async {
                    self?.image.image = UIImage(data: data)
                }
            }
        }
    }
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



