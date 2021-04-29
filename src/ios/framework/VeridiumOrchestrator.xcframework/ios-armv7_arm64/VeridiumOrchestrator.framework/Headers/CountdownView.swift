//
//  CountdownView.swift
//  VeridiumOrchestrator
//
//  Created by Alex ILIE on 22/04/2019.
//  Copyright © 2019 Veridium. All rights reserved.
//

import Foundation

public class CountdownView: UIView {

    private static let defaultStrokeColor = UIColor(red: 63.0/255.0, green: 191.0/255.0, blue: 201.0/255.0, alpha: 1.0)
    
    private static let animationIdentifier = "drawLineAnimation"
    private static let animationKeyPath = "transform.rotation.z"
    
    public private(set) var isAnimationStarted = false
    
    var shapeLayer = CAShapeLayer()
    
    var strokeColor: UIColor = defaultStrokeColor {
        didSet {
            setNeedsLayout()
            restartAnimationIfStarted()
        }
    }
    
    var doesSpinClockwise: Bool = true {
        didSet {
            restartAnimationIfStarted()
        }
    }
    
    public var duration: UInt = 30 {
        didSet {
            restartAnimationIfStarted()
        }
    }

    public var startAt: UInt = 0 {
        didSet {
            restartAnimationIfStarted()
        }
    }

    // This method is being called when the SpinnverView is being added to its parent view
    override public func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.sublayers?.removeAll()
        
        let center = CGPoint(x: 0.0, y: 0.0)
        let radius = (frame.size.height) / 2
        let startAngle = CGFloat(-.pi / 2.0)
        let endAngle = CGFloat(1.5 * .pi)
        
        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = self.strokeColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = frame.width
        shapeLayer.lineCap = .butt
        shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        self.layer.addSublayer(shapeLayer)

        restartAnimationIfStarted()
    }
    
    private func restartAnimationIfStarted() {
        if isAnimationStarted {
            stopAnimation()
            startAnimation()
        }
    }
    
    public func startAnimation() {
        if !isAnimationStarted {
            let animation = CABasicAnimation(keyPath: "strokeStart")
            /* set up animation */
            let from = Double(startAt % duration) / Double(duration)
            let to = 1.0
            let adjustedDuration = (to - from) * Double(duration)
            
            animation.fromValue = from
            animation.toValue = to
            animation.duration = CFTimeInterval(adjustedDuration)
            animation.isRemovedOnCompletion = false
            animation.fillMode = .forwards
            shapeLayer.add(animation, forKey: CountdownView.animationIdentifier)
            isAnimationStarted = true
        }
    }

    public func stopAnimation() {
        if isAnimationStarted {
            shapeLayer.removeAnimation(forKey: CountdownView.animationIdentifier)
            isAnimationStarted = false
        }
    }
}
