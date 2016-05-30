//
//  CustomView.swift
//  extension
//
//  Created by Charles on 16/5/30.
//  Copyright © 2016年 Charles. All rights reserved.
//

import UIKit

protocol CollectionViewLayoutDelegate: NSObjectProtocol {
    func collectionViewLayoutHeight(_: CollectionLayout, atIndexPath: NSIndexPath) -> CGFloat
}


let reuseIdentifier = "reuseIdentifier"
class CollectionLayout: UICollectionViewFlowLayout {
    
    var attributesArray = [UICollectionViewLayoutAttributes]()
    
    var maxYDict = [String: AnyObject]() // 用来计算最大列
    
    var rowMargin: CGFloat = 10.0 // 行间距 类似于 minimumLineSpacing
    
    var colMargin: CGFloat = 10.0 // 列间距 minimumInteritemSpacing
    
    var colCount: Int = 0
    
    var secInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    weak var delegate: CollectionViewLayoutDelegate?
    
    override func prepareLayout() {
        super.prepareLayout()
        
        for index in 0...self.colCount-1 {
            self.maxYDict[String(index)] = "0" // 用来存放最大Y列的字典赋值
        }
        
        let count = (self.collectionView?.numberOfItemsInSection(0))! as Int
        for index in 0...count-1 {
            let attributes = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))
            attributesArray.append(attributes!)
        }
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attributesArray
    }
    
    // 计算每个layout的结构属性
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        print("layoutAttributesForItemAtIndexPath\(indexPath.row)")
        var minCol = "0"
        // 找出最短的列
        for (col, maxY) in self.maxYDict {
            if maxY.floatValue < self.maxYDict[minCol]?.floatValue {
                minCol = col // 如果有比第1列短的，更新最短列标记值
            }
        }
        
        // 计算每个layout的结构信息
        let totalW = (self.collectionView?.frame.size.width)! - self.secInset.left - self.secInset.right - CGFloat(self.colCount - 1) * self.colMargin
        
        let width = totalW / CGFloat(self.colCount)
        var height: CGFloat = 0.0
        height = (self.delegate?.collectionViewLayoutHeight(self, atIndexPath: indexPath))!
        let x = self.secInset.left + (width + self.colMargin) * CGFloat((minCol as NSString).floatValue)
        let y = CGFloat(self.maxYDict[minCol]!.floatValue) + self.rowMargin
        
        
        print("minCol:\(minCol) :  \(x) \(y) \(width) \(height)")
        
        // 更新存放最短列的字典
        self.maxYDict[minCol] = String(y + height)
        
        // 赋值并返回
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.frame = CGRect(x: x, y: y, width: width, height: height)
        
        return attributes
    }
    
    
    // 计算并返回collectionView的容器大小
    override func collectionViewContentSize() -> CGSize {
        var maxCol = "0"
        for(col, maxY) in self.maxYDict {
            if maxY.floatValue > self.maxYDict[maxCol]?.floatValue {
                maxCol = col
            }
        }
        if self.maxYDict.count > 0 {
            return CGSize(width: 0, height: CGFloat((self.maxYDict[maxCol]!.floatValue)!))
        }
        return CGSizeZero
    }
}

class CustomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.collectionV)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK : 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionV.frame = self.bounds
    }
    
    // MARK: 懒加载collectionView
    private lazy var collectionV: UICollectionView = {
        
        // 初始化layout对象
        let collectionLayout = CollectionLayout()
        collectionLayout.colCount = 2
        collectionLayout.delegate = self
        
        // 初始化collectionview
        let collectionV: UICollectionView = UICollectionView(frame: self
            .bounds, collectionViewLayout: collectionLayout)
        collectionV.backgroundColor = UIColor.whiteColor()
        
        // 设置代理和数据源
        collectionV.delegate = self
        collectionV.dataSource = self
        
        // 注册cell
        collectionV.registerClass(CustomCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        return collectionV
    }()

}

//
extension CustomView: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

         let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CustomCollectionViewCell
//        cell.contentView.backgroundColor = UIColor(colorLiteralRed: Float(arc4random_uniform(255)) / 255.0, green:Float( arc4random_uniform(255)) / 255.0, blue: Float(arc4random_uniform(255)) / 255.0, alpha: 1)
        cell.contentView.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.8)
        
        for view in cell.contentView.subviews {
            view .removeFromSuperview()
        }
        let label = UILabel()
        label.textAlignment = .Center
        cell.contentView.addSubview(label)
        label.font = UIFont.systemFontOfSize(18)
        label.text = String(indexPath.row)
        label.textColor = UIColor.blackColor()
        label.frame = cell.contentView.bounds
        
        return cell
    }
    
}

extension CustomView: CollectionViewLayoutDelegate {
    func collectionViewLayoutHeight(_: CollectionLayout, atIndexPath: NSIndexPath) -> CGFloat {
        // 模拟数据
        let height = CGFloat(arc4random_uniform(150))
        if height > 100 {
            return height
        } else {
            return 101
        }
//        return 100.0
    }
}

