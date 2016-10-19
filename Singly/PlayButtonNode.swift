//
//  PlayButtonNode.swift
//  OneByOne
//
//  Created by Satbir Tanda on 1/1/16.
//  Copyright © 2016 Satbir Tanda. All rights reserved.
//

import SpriteKit

class PlayButtonNode: SKNode
{
    private var play_button_node: SKShapeNode!
    private var play_button_path_node: SKShapeNode!
    
    convenience init(rect: CGRect)
    {
        self.init()
        
        play_button_node = SKShapeNode(rect: rect, cornerRadius: rect.width/8.0)
        play_button_node.fillColor = SKColor.whiteColor()
        play_button_node.strokeColor = SKColor.blackColor()
        self.addChild(play_button_node)
        
        let play_path = UIBezierPath()
        let offset = rect.width/25.0
        play_path.lineWidth = 1.0;
        play_path.moveToPoint(CGPointMake(rect.origin.x + rect.width/2.0 - rect.width*1.0/8.0 + offset, rect.origin.y + rect.height - rect.height*1.0/4.0))
        play_path.addLineToPoint(CGPointMake(rect.origin.x + rect.width/2.0 - rect.width*1.0/8.0 + offset, rect.origin.y + rect.height*1.0/4.0))
        play_path.addLineToPoint(CGPointMake(rect.origin.x + rect.width/2.0 + rect.width*1.0/8.0 + offset, rect.origin.y + rect.height/2.0))
        play_path.closePath()
        
        play_button_path_node = SKShapeNode(path: play_path.CGPath)
        play_button_path_node.fillColor = SKColor(red: 34.0/255.0, green: 139.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        play_button_path_node.strokeColor = SKColor.blackColor()
        play_button_node.addChild(play_button_path_node!)
        
        self.userInteractionEnabled = true
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if let scene = self.scene
        {
            scene.runAction(SKAction.playSoundFileNamed("light_switch.mp3", waitForCompletion: false))
            let rect = scene.frame
            let game_scene = GameScene(size: rect.size)
            if let skView = scene.view
            {
                let transition = SKTransition.fadeWithColor(randomColor(), duration: 1.0)
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                game_scene.scaleMode = .AspectFill
                scene.removeAllChildren()
                skView.presentScene(game_scene, transition: transition)
            }
                
        }
 
    }
    
    private func randomColor() -> SKColor
    {
        let colors = [SKColor.whiteColor(), SKColor.blackColor(), SKColor.redColor(), SKColor.blueColor(), SKColor.greenColor(),
            SKColor.purpleColor(), SKColor.magentaColor(), SKColor.cyanColor(), SKColor.yellowColor()]
        let randomIndex = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[randomIndex]
    }

}
