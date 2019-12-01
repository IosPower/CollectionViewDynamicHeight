//
//  DetailCollectionViewCell.swift
//  CollectionViewDynamicHeight
//
//  Created by Admin on 16/11/19.
//  Copyright © 2019 Piyush. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    //MARK: - IBOutlets
    ///
    @IBOutlet weak var imageView: UIImageView!
    ///
    @IBOutlet weak var titleLabel: UILabel!
    ///
    @IBOutlet weak var subTitleLabel: UILabel!
    ///
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
}
