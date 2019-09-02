//
//  ViewController.swift
//  Shapes&Gestures
//
//  Created by Andre Sarokhanian on 9/1/19.
//  Copyright © 2019 Andre Sarokhanian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.view.addGestureRecognizer(tapGesture)
    }
  
  
    
    @objc func didTap(tapGesture: UITapGestureRecognizer) {
        let tapPoint = tapGesture.location(in: self.view)
        let shapeView = ShapeView(origin: tapPoint)
        self.view.addSubview(shapeView)
    }
}

