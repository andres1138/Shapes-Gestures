//
//  ShapeView.swift
//  Shapes&Gestures
//
//  Created by Andre Sarokhanian on 9/1/19.
//  Copyright © 2019 Andre Sarokhanian. All rights reserved.
//

import Foundation
import UIKit


class ShapeView: UIView {
    
    let size: CGFloat = 150.0
    let lineWidth: CGFloat = 2.0
    var fillColor: UIColor!
    var path: UIBezierPath!
   
    init(origin: CGPoint) {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        self.center = origin
        self.backgroundColor = UIColor.clear
        self.fillColor = randomColor()
     
        initGestureRecognizers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
       self.path = randomPath()
       self.fillColor.setFill()
        path.fill()
        
        path.lineWidth = self.lineWidth
        UIColor.black.setStroke()
        path.stroke()
    }
    
    
    func initGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch))
        addGestureRecognizer(pinchGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate))
        addGestureRecognizer(rotationGesture)
    }
    
    @objc func didPan(panGR: UIPanGestureRecognizer) {
        self.superview!.bringSubviewToFront(self)
        var translation = panGR.translation(in: self)
        
        translation = __CGPointApplyAffineTransform(translation, self.transform)
        
        self.center.x += translation.x
        self.center.y += translation.y
        
        panGR.setTranslation(CGPoint.zero, in: self)
    }
    
    @objc func didPinch(pinchGR: UIPinchGestureRecognizer) {
        self.superview!.bringSubviewToFront(self)
     
        if pinchGR.state == .began || pinchGR.state == .changed {
            pinchGR.view?.transform = ((pinchGR.view?.transform.scaledBy(x: pinchGR.scale, y: pinchGR.scale))!)
            pinchGR.scale = 1.0
        }
    }

    @objc func didRotate(rotateGR: UIRotationGestureRecognizer) {
        self.superview!.bringSubviewToFront(self)
        
        if rotateGR.state == .began || rotateGR.state == .changed {
            rotateGR.view?.transform = rotateGR.view!.transform.rotated(by: rotateGR.rotation)
            rotateGR.rotation = 0.0
        }
        
    }
    
    func randomColor() -> UIColor {
        let hue: CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        return UIColor(hue: hue, saturation: 0.8, brightness: 1.0, alpha: 0.8)
    }
    
    func trianglePathInRect(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.width / 2.0, y: rect.origin.y))
        path.addLine(to: CGPoint(x: rect.width,y: rect.height))
        path.addLine(to: CGPoint(x: rect.origin.x,y: rect.height))
        path.close()
        
        
        return path
    }
    
    
    func pointFrom(angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
        return CGPoint(x: radius * cos(angle) + offset.x, y: radius * sin(angle) + offset.y)
    }
    
    func regularPolygonInRect(rect:CGRect) -> UIBezierPath {
        let degree = arc4random() % 10 + 3
        
        let path = UIBezierPath()
        
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        
        var angle:CGFloat = -CGFloat(Double.pi / 2.0)
        let angleIncrement = CGFloat(Double.pi * 2.0 / Double(degree))
        let radius = rect.width / 2.0
        
        path.move(to: pointFrom(angle: angle, radius: radius, offset: center))
        
        for _ in 1...degree - 1 {
            angle += angleIncrement
            path.addLine(to: pointFrom(angle: angle, radius: radius, offset: center))
        }
        
        path.close()
        
        return path
    }
    
    func starPathInRect(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        let starExtrusion:CGFloat = 30.0
        
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        
        let pointsOnStar = 5 + arc4random() % 10
        
        var angle:CGFloat = -CGFloat(Double.pi / 2.0)
        let angleIncrement = CGFloat(Double.pi * 2.0 / Double(pointsOnStar))
        let radius = rect.width / 2.0
        
        var firstPoint = true
        
        for _ in 1...pointsOnStar {
            
            let point = pointFrom(angle: angle, radius: radius, offset: center)
            let nextPoint = pointFrom(angle: angle + angleIncrement, radius: radius, offset: center)
            let midPoint = pointFrom(angle: angle + angleIncrement / 2.0, radius: starExtrusion, offset: center)
            
            if firstPoint {
                firstPoint = false
                path.move(to: point)
            }
            
            path.addLine(to: midPoint)
            path.addLine(to: nextPoint)
            
            angle += angleIncrement
        }
        
        path.close()
        
        
        return path
    }

    func randomPath() -> UIBezierPath {
        
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        let uiinset: UIEdgeInsets = UIEdgeInsets(top: lineWidth, left: lineWidth, bottom: lineWidth, right: lineWidth)
        rect.inset(by: uiinset)
        
      
        let shapeType = arc4random() % 5
        
        
        switch shapeType {
        case 0:
            return UIBezierPath(roundedRect: rect, cornerRadius: 10.0)
        case 1:
            return UIBezierPath(ovalIn: rect)
        case 2:
            return trianglePathInRect(rect: rect)
        case 3:
           return regularPolygonInRect(rect: rect)
        case 4:
           return  starPathInRect(rect: rect)
        default:
           return  trianglePathInRect(rect: rect)
        }
        

    }
}

