//
//  Created by Tom Baranes on 23/08/16.
//  Copyright (c) 2016 IBAnimatable. All rights reserved.
//

import UIKit

public class ActivityIndicatorAnimationBallZigZagDeflect: ActivityIndicatorAnimating {
  
  // MARK: Properties
  
  fileprivate let duration: CFTimeInterval = 0.7
  
  // MARK: ActivityIndicatorAnimating
  
  public func configAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
    
    let circleSize: CGFloat = size.width / 5
    let duration: CFTimeInterval = 0.75
    let deltaX = size.width / 2 - circleSize / 2
    let deltaY = size.height / 2 - circleSize / 2
    let frame = CGRect(x: (layer.bounds.size.width - circleSize) / 2, y: (layer.bounds.size.height - circleSize) / 2, width: circleSize, height: circleSize)
    
    // Circle 1
    let animation = CAKeyframeAnimation(keyPath:"transform")
    animation.keyTimes = [0.0, 0.33, 0.66, 1.0]
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animation.values = [NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0)),
                        NSValue(caTransform3D: CATransform3DMakeTranslation(-deltaX, -deltaY, 0)),
                        NSValue(caTransform3D: CATransform3DMakeTranslation(deltaX, -deltaY, 0)),
                        NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0))]
    animation.duration = duration
    animation.repeatCount = .infinity
    animation.autoreverses = true
    animation.isRemovedOnCompletion = false
    circleAt(frame: frame, layer: layer, size: CGSize(width: circleSize, height: circleSize), color: color, animation: animation)
    
    // Circle 2
    animation.values = [NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0)),
                        NSValue(caTransform3D: CATransform3DMakeTranslation(deltaX, deltaY, 0)),
                        NSValue(caTransform3D: CATransform3DMakeTranslation(-deltaX, deltaY, 0)),
                        NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0))]
    circleAt(frame: frame, layer: layer, size: CGSize(width: circleSize, height: circleSize), color: color, animation: animation)
  }
  
}

// MARK: - Setup

fileprivate extension ActivityIndicatorAnimationBallZigZagDeflect {
  
  func circleAt(frame: CGRect, layer: CALayer, size: CGSize, color: UIColor, animation: CAAnimation) {
    let circle = ActivityIndicatorShape.Circle.makeLayer(size: size, color: color)
    circle.frame = frame
    circle.add(animation, forKey: "animation")
    layer.addSublayer(circle)
  }
  
}
