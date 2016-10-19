//
//  MenuScene.swift
//  OneByOne
//
//  Created by Satbir Tanda on 1/1/16.
//  Copyright © 2016 Satbir Tanda. All rights reserved.
//

import SpriteKit
import GameKit


class MenuScene: SKScene, TimeSphereDelegate
{
    private var timeDelegate: TimeSphereDelegate?
    private var time_sphere_action: SKAction?
    //private var play_button_mask_node: SKShapeNode?
    private var play_button_node: PlayButtonNode?
    private var rankings_button_node: RankingsButtonNode?
    private var rate_button_node: RateButtonNode?

    private var singly_label_node: SKLabelNode?
    private var time_sphere_node : SKShapeNode?

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        timeDelegate = self
        setupScene()
    }


//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//       /* Called when a touch begins */
//
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            if let touched_node = self.nodeAtPoint(location) as? SKShapeNode
//            {
//                if touched_node == play_button_mask_node
//                {
//                    let game_scene = GameScene(size: self.frame.size)
//                    // Configure the view.
//                    if let skView = self.view
//                    {
//                        let transition = SKTransition.fadeWithColor(randomColor(), duration: 1.0)
//                        /* Sprite Kit applies additional optimizations to improve rendering performance */
//                        skView.ignoresSiblingOrder = true
//                        
//                        /* Set the scale mode to scale to fit the window */
//                        game_scene.scaleMode = .AspectFill
//                        
//                        skView.presentScene(game_scene, transition: transition)
//                    }
//                }
//            }
//        }
//    }

//    override func update(currentTime: CFTimeInterval) {
//        /* Called before each frame is rendered */
//    }
//    
    private func setupScene()
    {
        spawnTimeSphereNode()
        
        self.backgroundColor = SKColor(red: 135.0/255.0, green: 206.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        let sand_shape_node = SKShapeNode(rect: CGRectMake(0, 0, self.frame.width, self.frame.height*3.0/16.0))
        sand_shape_node.fillColor = SKColor(red: 244.0/255.0, green: 164.0/255.0, blue: 96.0/255.0, alpha: 1.0)
        self.addChild(sand_shape_node)
        
        
        let button_width = CGRectGetMaxX(self.frame)*1/3
        let button_height = CGRectGetMaxY(self.frame)*1/8
        if play_button_node == nil
        {
            let play_button_rect = CGRectMake(CGRectGetMaxX(self.frame)*1/15.0, CGRectGetMaxY(self.frame)*1.0/5.25, button_width, button_height)
            play_button_node = PlayButtonNode(rect: play_button_rect)
            //play_button_mask_node = SKShapeNode(rect: play_button_rect)
            //play_button_mask_node?.fillColor = SKColor.clearColor()
            //play_button_mask_node?.strokeColor = SKColor.clearColor()
            //play_button_mask_node?.zPosition = 1.0
            self.addChild(play_button_node!)
            //self.addChild(play_button_mask_node!)
        }
        
        if rankings_button_node == nil
        {
            let rankings_button_rect = CGRectMake(CGRectGetMaxX(self.frame) - CGRectGetMaxX(self.frame)*1/15.0 - button_width, CGRectGetMaxY(self.frame)*1.0/5.25, button_width, button_height)
            
            rankings_button_node = RankingsButtonNode(rect: rankings_button_rect)
            self.addChild(rankings_button_node!)
            
        }
        
        if rate_button_node == nil
        {
            let width = button_width/2.0
            let height = button_height/2.0
            let rate_button_rect = CGRectMake((self.frame.width - width)/2.0, CGRectGetMaxY(self.frame)*1.0/5.5 + button_height + self.frame.height/25, width, height)
            rate_button_node = RateButtonNode(rect: rate_button_rect)
            self.addChild(rate_button_node!)
        }
        
        if singly_label_node == nil
        {
            singly_label_node = SKLabelNode(text: "Singly")
            singly_label_node!.fontSize = self.frame.width/3.0
            singly_label_node!.fontName = "Futura-CondensedExtraBold"
            singly_label_node!.position = CGPointMake(self.frame.width/2.0, self.frame.height*2.0/3.0)
            self.addChild(singly_label_node!)
            singly_label_node!.runAction(SKAction.repeatActionForever(SKAction.customActionWithDuration(5.0, actionBlock: {
                node, elapsedTime in
                
                if let label = node as? SKLabelNode
                {
                    let toColorComponents = CGColorGetComponents(self.randomColor().CGColor)
                    let fromColorComponents = CGColorGetComponents(label.fontColor?.CGColor)
                    
                    let finalRed = fromColorComponents[0] + (toColorComponents[0] - fromColorComponents[0])*CGFloat(elapsedTime / CGFloat(5.0))
                    let finalGreen = fromColorComponents[1] + (toColorComponents[1] - fromColorComponents[1])*CGFloat(elapsedTime / CGFloat(5.0))
                    let finalBlue = fromColorComponents[2] + (toColorComponents[2] - fromColorComponents[2])*CGFloat(elapsedTime / CGFloat(5.0))
                    let finalAlpha = fromColorComponents[3] + (toColorComponents[3] - fromColorComponents[3])*CGFloat(elapsedTime / CGFloat(5.0))
                    
                    self.singly_label_node!.fontColor = SKColor(red: finalRed, green: finalGreen, blue: finalBlue, alpha: finalAlpha)
                }
                
            }) ))
        }
        
        let how_to_line_one_node = SKLabelNode(text: "Tap all of the white lights in the morning.")
        how_to_line_one_node.position = CGPointMake(self.frame.width/2.0, self.frame.height/2.0 + self.frame.height/25)
        how_to_line_one_node.fontSize = self.frame.width/19.0
        how_to_line_one_node.fontName = "KannadaSangamMN-Bold "
        self.addChild(how_to_line_one_node)
        
        let how_to_line_two_node = SKLabelNode(text: "Tap all of the black lights in the night.")
        how_to_line_two_node.position = CGPointMake(self.frame.width/2.0, self.frame.height/2.0 - self.frame.height/25)
        how_to_line_two_node.fontSize = self.frame.width/19.0
        how_to_line_two_node.fontName = "KannadaSangamMN-Bold "
        self.addChild(how_to_line_two_node)

        
        let copyright_label_node = SKLabelNode(text: "© SST1337 2015-2016")
        copyright_label_node.fontSize = self.frame.width/30.0
        copyright_label_node.fontName = "Menlo-Italic"
        copyright_label_node.position = CGPointMake(self.frame.width/2.0, self.frame.height*1.0/8.0)
        self.addChild(copyright_label_node)

    }

    private func randomColor() -> SKColor
    {
        let colors = [SKColor.whiteColor(), SKColor.blackColor(), SKColor.redColor(), SKColor.blueColor(), SKColor.greenColor(),
                        SKColor.purpleColor(), SKColor.magentaColor(), SKColor.cyanColor(), SKColor.yellowColor(), SKColor.brownColor(),
                        SKColor.grayColor()]
        let randomIndex = Int(arc4random_uniform(11))
        return colors[randomIndex]
    }
    
    private func spawnTimeSphereNode()
    {
        if time_sphere_node == nil
        {
            let time_sphere_side = self.frame.width/4.0
            let time_sphere_rect = CGRectMake(0 - time_sphere_side, self.frame.height/2.0 - time_sphere_side/2.0, time_sphere_side, time_sphere_side)
            time_sphere_node = SKShapeNode(ellipseInRect: time_sphere_rect)
            time_sphere_node?.glowWidth = 1.0
            time_sphere_node?.fillColor = SKColor.yellowColor()
            time_sphere_node?.strokeColor = SKColor.clearColor()
            time_sphere_node?.zPosition = -1
            self.addChild(time_sphere_node!)
            gameScene(self, didAddTimeSphere: time_sphere_node!)
        }
    }
    
    internal func gameScene(scene: SKScene, didRemoveTimeSphere time_sphere_node: SKShapeNode)
    {
        spawnTimeSphereNode()
    }
    
    internal func gameScene(scene: SKScene, didAddTimeSphere time_sphere_node: SKShapeNode)
    {
        if((time_sphere_action == nil))
        {
            let time_sphere_path = UIBezierPath()
            time_sphere_path.moveToPoint(time_sphere_node.frame.origin)
            let time_sphere_path_endpoint = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame)/2.0)
            let time_sphere_path_controlpoint = CGPointMake(CGRectGetMidX(self.frame)/2.0, CGRectGetMaxY(self.frame) - time_sphere_node.frame.width)
            time_sphere_path.addQuadCurveToPoint(time_sphere_path_endpoint, controlPoint: time_sphere_path_controlpoint)
            let time_sphere_path_action = SKAction.followPath(time_sphere_path.CGPath, duration: 2.0)
            
            let game_group_action = SKAction.group([time_sphere_path_action])
            time_sphere_action = game_group_action
        }
        
            time_sphere_node.runAction(time_sphere_action!) { () -> Void in
            time_sphere_node.removeAllActions()
            time_sphere_node.removeFromParent()
            self.time_sphere_node = nil
            self.spawnTimeSphereNode()
        }
    }

}
