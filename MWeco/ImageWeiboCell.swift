//
//  ImageWeiboCell.swift
//  MWeco
//
//  Created by Monzy on 15/11/20.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class ImageWeiboCell: UITableViewCell {

    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var sendFromLabel: UILabel!
    @IBOutlet var upvoteButton: UIButton!
    @IBOutlet var transmitButton: UIButton!
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
