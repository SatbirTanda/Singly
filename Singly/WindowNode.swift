//
//  WindowNode.swift
//  OneByOne
//
//  Created by Satbir Tanda on 12/30/15.
//  Copyright © 2015 Satbir Tanda. All rights reserved.
//

import SpriteKit

protocol WindowNodeStateDelegate
{
    func windowNode(window_node: WindowNode, didChangeState:SKColor)
}

class WindowNode: SKNode {
    
    private var window_node: SKShapeNode!
    private var window_barrier_node: SKShapeNode!
    private var stateDelegate: WindowNodeStateDelegate?
    
    convenience init(rect: CGRect) {
        self.init()
        
        window_node = SKShapeNode(rect: rect)
        window_node.fillColor = SKColor.whiteColor()
        window_node.strokeColor = SKColor.blackColor()
        self.addChild(window_node)
        
        let crossPath = UIBezierPath()
        crossPath.lineWidth = 1.0
        let midX = CGRectGetMidX(rect)
        let maxX = CGRectGetMaxX(rect)
        let midY = CGRectGetMidY(rect)
        let quarterY = midY
        let maxY = CGRectGetMaxY(rect)
        let offset = rect.size.width/50.0
        crossPath.moveToPoint(CGPoint(x: midX - offset, y: rect.origin.y))
        crossPath.addLineToPoint(CGPoint(x: midX - offset, y: quarterY - offset))
        crossPath.addLineToPoint(CGPoint(x: rect.origin.x, y: quarterY - offset))
        crossPath.addLineToPoint(CGPoint(x: rect.origin.x, y: quarterY + offset))
        crossPath.addLineToPoint(CGPoint(x: midX - offset, y: quarterY + offset))
        crossPath.addLineToPoint(CGPoint(x: midX - offset, y: maxY))
        crossPath.addLineToPoint(CGPoint(x: midX + offset, y: maxY))
        crossPath.addLineToPoint(CGPoint(x: midX + offset, y: quarterY + offset))
        crossPath.addLineToPoint(CGPoint(x: maxX, y: quarterY + offset))
        crossPath.addLineToPoint(CGPoint(x: maxX, y: quarterY - offset))
        crossPath.addLineToPoint(CGPoint(x: midX + offset, y: quarterY - offset))
        crossPath.addLineToPoint(CGPoint(x: midX + offset, y: rect.origin.y))
        crossPath.closePath()
        
        window_barrier_node = SKShapeNode(path: crossPath.CGPath)
        window_barrier_node.fillColor = SKColor(red: 34.0/255.0, green: 139.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        //window_barrier_node.strokeColor = SKColor(red: 127.0/255.0, green: 1.0, blue: 0, alpha: 1.0)
        window_node.addChild(window_barrier_node)
        
        self.userInteractionEnabled = true

    }
    
    func setWindowNodeFillColor(color: SKColor)
    {
        window_node.fillColor = color
    }
    
    func getWindowNodeFillColor() -> SKColor
    {
        return window_node.fillColor
    }
    
    func setStateDelegate(delegate_implementor: WindowNodeStateDelegate)
    {
        self.stateDelegate = delegate_implementor
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if window_node.fillColor == SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        {
            window_node.runAction(SKAction.playSoundFileNamed("light_off.mp3", waitForCompletion: false))
            window_node.fillColor = SKColor.blackColor()
            stateDelegate?.windowNode(self, didChangeState: SKColor.blackColor())
        }
        else
        {
            window_node.runAction(SKAction.playSoundFileNamed("light_on.mp3", waitForCompletion: false))
            window_node.fillColor = SKColor.whiteColor()
            stateDelegate?.windowNode(self, didChangeState: SKColor.whiteColor())
        }
    }
}
