//
//  ViewController.swift
//  extension
//
//  Created by Charles on 16/5/30.
//  Copyright © 2016年 Charles. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.customView)
        
        
        
    }
    
    
    private lazy var customView: CustomView = {
        
        let customView = CustomView()
        customView.frame = self.view.bounds
        return customView
    }()
}


