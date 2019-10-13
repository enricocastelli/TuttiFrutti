//
//  CardCell.swift
//  TuttiFrutti
//
//  Created by Enrico Castelli on 13/10/2019.
//  Copyright © 2019 EC. All rights reserved.
//

import UIKit

fileprivate let userColor = UIColor.blue.withAlphaComponent(0.2)
fileprivate let opponentColor = UIColor.red.withAlphaComponent(0.2)
class CardCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var angleStack: UIStackView!
    @IBOutlet var angles: [UILabel]!
    
    var item: Card? {
        didSet {
            guard let item = item else { return }
            if let fruitImage = UIImage(named: item.name.lowercased()) {
                image.image = fruitImage
            }
            for angle in item.angles {
                angles[angle.intValue()].alpha = 1
            }
            changeColor(item.isUser)
            if item.power < 0 {
                invertColor()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        layer.borderWidth = 0.5
        resetAngles()
    }
    
    override func prepareForReuse() {
        image.image = nil
        resetAngles()
        self.backgroundColor = .white
    }
    
    func changeColor(_ userWon: Bool) {
        guard item != nil else { return }
        self.backgroundColor = userWon ? userColor :
            opponentColor
    }
    
    private func invertColor() {
        backgroundColor = backgroundColor == userColor ?
            opponentColor : userColor
    }
    
    func resetAngles() {
        for angle in angles {
            angle.alpha = 0
        }
    }
}
