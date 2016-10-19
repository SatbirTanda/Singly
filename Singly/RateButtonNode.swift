//
//  RatingsButtonNode.swift
//  OneByOne
//
//  Created by Satbir Tanda on 1/1/16.
//  Copyright © 2016 Satbir Tanda. All rights reserved.
//

import UIKit
import SpriteKit

class RateButtonNode: SKNode
{
    private var rate_button_node: SKShapeNode!
    private var rate_label_node: SKLabelNode!
    
    convenience init(rect: CGRect)
    {
        self.init()
        
        rate_button_node = SKShapeNode(rect: rect, cornerRadius: rect.width/8.0)
        rate_button_node.fillColor = SKColor.whiteColor()
        rate_button_node.strokeColor = SKColor.blackColor()
        self.addChild(rate_button_node)
        
        rate_label_node = SKLabelNode(text: "Rate!")
        rate_label_node.fontSize = rect.width/3.0
        rate_label_node.fontName = "Optima-ExtraBlack"
        rate_label_node.fontColor = SKColor(red: 1.0, green: 215.0/255.0, blue: 0, alpha: 1.0)
        rate_label_node.position = CGPointMake(rect.origin.x  + rect.width/2.0, rect.origin.y + rect.height/2.0 - rect.height/5.0 )
        rate_button_node.addChild(rate_label_node)
        
        self.userInteractionEnabled = true

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {

        if let rate_link = NSURL(string:"itms-apps://itunes.apple.com/app/id1071632575")
        {
            let application = UIApplication.sharedApplication()
            if (application.canOpenURL(rate_link))
            {
                application.openURL(rate_link)
            }
        }
        
    }
    
}
