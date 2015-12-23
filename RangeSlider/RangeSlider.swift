//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by matsuohiroki on 2015/12/23.
//  Copyright © 2015年 matsuohiroki. All rights reserved.
//

import UIKit

class RangeSlider: UIControl {
    
    var minimumValue: Float?
    var maximumValue: Float?
    var minimumRange: Float?
    var stepValue: Float?
    var stepValueContinuously: Bool?
    var continuous: Bool?
    var lowerValue: Float?
    var upperValue: Float?
    var lowerCenter: CGPoint?
    var upperCenter: CGPoint?
    var lowerMaximumValue: Float?
    var upperMinimumValue: Float?
    var lowerTouchEdgeInsets: UIEdgeInsets?
    var upperTouchEdgeInsets: UIEdgeInsets?
    var lowerHandleHidden: Bool?
    var upperHandleHidden: Bool?
    var lowerHandleHiddenWidth: Float?
    var upperHandleHiddenWidth: Float?
    var lowerHandleImageNormal: UIImage?
    var lowerHandleImageHighlighted: UIImage?
    var upperHandleImageNormal: UIImage?
    var upperHandleImageHighlighted: UIImage?
    var trackImage: UIImage?
    var trackCrossedOverImage: UIImage?
    var trackBackgroundImage: UIImage?
    var lowerHandle: UIImageView?
    var upperHandle: UIImageView?
    
    var lowerTouchOffset: Float?
    var upperTouchOffset: Float?
    var stepValueInternal: Float?
    
    var track:UIImageView?
    var trackBackground:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureView() {
        
        //Setup the default values
        minimumValue = 0.0;
        maximumValue = 1.0;
        minimumRange = 0.0;
        stepValue = 0.0;
        stepValueInternal = 0.0;
        
        continuous = true;
        
        lowerValue = minimumValue;
        upperValue = maximumValue;
        
        lowerMaximumValue = 0/0;
        upperMinimumValue = 0/0;
        upperHandleHidden = false;
        lowerHandleHidden = false;
        
        lowerHandleHiddenWidth = 2.0;
        upperHandleHiddenWidth = 2.0;
        
        lowerTouchEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5);
        upperTouchEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5);
        
        self.addSubviews()
        
        self.lowerHandle?.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
        self.upperHandle?.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            if let object = object as! UIImageView? {
                if object == self.lowerHandle  {
                    self.lowerCenter = lowerHandle?.center
                } else if object == self.upperHandle {
                    self.upperCenter = upperHandle?.center
                }
            }
        }
    }
    
    
    func addSubviews() {
    }
    
    func setLowerValue(lowerValue: Float) {
        var value:Float = lowerValue
        
        if stepValueInternal > 0 {
            value = roundf(value / stepValueInternal!) * stepValueInternal!
        }
        
        value = min(value, maximumValue!)
        value = max(value, minimumValue!)
        
        if lowerMaximumValue?.isNaN == false {
            value = min(value, lowerMaximumValue!)
        }
        
        value = min(value, upperValue! - minimumRange!)
        
        self.lowerValue = value
        
        self.setNeedsLayout()
    }
    
    func setUpperValue(upperValue: Float) {
        var value:Float = upperValue
        
        if stepValueInternal > 0 {
            value = roundf(value / stepValueInternal!) * stepValueInternal!
        }
        
        value = max(value, minimumValue!)
        value = min(value, maximumValue!)
        
        if upperMinimumValue?.isNaN == false {
            value = max(value, upperMinimumValue!)
        }
        
        value = max(value, lowerValue! + minimumRange!)
        
        self.upperValue = value
        
        self.setNeedsLayout()
    }
    
    func setLowerValue(lowerValue: Float, upperValue: Float, animated: Bool) {
        
        if !animated && (isnan(lowerValue) || lowerValue == self.lowerValue) && (isnan(upperValue) || upperValue == self.upperValue) {
            return
        }
        
        if animated {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.layoutSubviews()
                }, completion: { (Bool) -> Void in
            })
        } else {
            self.layoutSubviews()
        }
        
    }
    
    func setUpperValue(lowerValue: Float, upperValue: Float, animated: Bool) {
        
        if !animated && (isnan(lowerValue) || lowerValue == self.lowerValue) && (isnan(upperValue) || upperValue == self.upperValue) {
            return
        }
        
        if animated {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                if !isnan(lowerValue)
                {
                    self.setLowerValue(lowerValue)
                }
                if(!isnan(upperValue))
                {
                    self.setUpperValue(upperValue)
                }
                self.layoutSubviews()
                }, completion: { (Bool) -> Void in
            })
        } else {
            if(!isnan(lowerValue))
            {
                self.setLowerValue(lowerValue)
            }
            if(!isnan(upperValue))
            {
                self.setUpperValue(upperValue)
            }
        }
        
    }
    
    
    func setLowerValue(lowerValue: Float, animated: Bool) {
        self.setLowerValue(lowerValue, upperValue: 0/0, animated: animated)
    }
    
    func setUpperValue(upperValue: Float, animated: Bool) {
        self.setLowerValue(0/0, upperValue: upperValue, animated: animated)
    }
}