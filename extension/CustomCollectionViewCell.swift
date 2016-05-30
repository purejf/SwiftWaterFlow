//
//  CustomCollectionViewCell.swift
//  extension
//
//  Created by Charles on 16/5/30.
//  Copyright © 2016年 Charles. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    
    var itemModel: ItemModel? {
        didSet {
         // 设置数据 展示UI
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - 20)
        self.bottomLabel.frame = CGRect(x: 0, y: self.frame.size.height - 20, width: self.frame.size.width, height: 20)
    }
    
    private lazy var imageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGrayColor()
        return imageView
        
    }()
    
    private lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.orangeColor()
        label.textAlignment = .Center
        return label
    }()
}
