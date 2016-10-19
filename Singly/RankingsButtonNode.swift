//
//  RankingsButtonNode.swift
//  OneByOne
//
//  Created by Satbir Tanda on 1/1/16.
//  Copyright © 2016 Satbir Tanda. All rights reserved.
//

import SpriteKit
import GameKit

class RankingsButtonNode: SKNode, GKGameCenterControllerDelegate
{
    private var rankings_button_node: SKShapeNode!
    private var rankings_button_path_node: SKShapeNode!
    
    convenience init(rect: CGRect)
    {
        self.init()
        
        rankings_button_node = SKShapeNode(rect: rect, cornerRadius: rect.width/8.0)
        rankings_button_node.fillColor = SKColor.whiteColor()
        rankings_button_node.strokeColor = SKColor.blackColor()
        self.addChild(rankings_button_node!)
        
        let rankings_path = UIBezierPath()
        let width_offset = rect.width/4.0
        let height_offset = rect.height/4.0
        let rankings_width = rect.width/2.0
        let rankings_height = rect.height/2.0
        rankings_path.lineWidth = 1.0;
        rankings_path.moveToPoint(CGPointMake(rect.origin.x + width_offset, rect.origin.y + height_offset))
        rankings_path.addLineToPoint(CGPointMake(rect.origin.x + width_offset, rect.origin.y + height_offset + rankings_height/3.0))
        rankings_path.addLineToPoint(CGPointMake(rect.origin.x + width_offset + rankings_width/3.0, rect.origin.y + height_offset + rankings_height/3.0))
        rankings_path.addLineToPoint(CGPointMake(rect.origin.x + width_offset + rankings_width/3.0, rect.origin.y + height_offset + rankings_height))
        rankings_path.addLineToPoint(CGPointMake(rect.origin.x + width_offset + rankings_width*2.0/3.0, rect.origin.y + height_offset + rankings_height))
        rankings_path.addLineToPoint(CGPointMake(rect.origin.x + width_offset + rankings_width*2.0/3.0, rect.origin.y + height_offset + rankings_height*2.0/3.0))
        rankings_path.addLineToPoint(CGPointMake(rect.origin.x + width_offset + rankings_width, rect.origin.y + height_offset + rankings_height*2.0/3.0))
        rankings_path.addLineToPoint(CGPointMake(rect.origin.x + width_offset + rankings_width, rect.origin.y + height_offset))
        rankings_path.closePath()
        
        
        rankings_button_path_node = SKShapeNode(path: rankings_path.CGPath)
        rankings_button_path_node.fillColor = SKColor(red: 1.0, green: 99.0/255.0, blue: 71.0/255.0, alpha: 1.0)
        rankings_button_path_node.strokeColor = SKColor.blackColor()
        rankings_button_node.addChild(rankings_button_path_node)
        
        self.userInteractionEnabled = true
        
    }
    
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if let scene = self.scene
        {
            scene.runAction(SKAction.playSoundFileNamed("light_switch.mp3", waitForCompletion: false))
            if scene.view?.window?.rootViewController != nil
            {
                let gcVC: GKGameCenterViewController = GKGameCenterViewController()
                gcVC.gameCenterDelegate = self
                gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
                gcVC.leaderboardIdentifier = "singly.top.scores"
                scene.view?.window?.rootViewController!.presentViewController(gcVC, animated: true, completion: nil)
            }
        }

    }
}
