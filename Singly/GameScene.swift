//
//  GameScene.swift
//  OneByOne
//
//  Created by Satbir Tanda on 12/27/15.
//  Copyright (c) 2015 Satbir Tanda. All rights reserved.
//

import SpriteKit

protocol TimeSphereDelegate
{
    func gameScene(scene: SKScene, didAddTimeSphere time_sphere_node: SKShapeNode)
    func gameScene(scene: SKScene, didRemoveTimeSphere time_sphere_node: SKShapeNode)
}

class GameScene: SKScene, TimeSphereDelegate, WindowNodeStateDelegate, GameTimeDelegate {
    
    private var timeDelegate: TimeSphereDelegate?
    private var window_nodes = [WindowNode]()
    private var time_sphere_node : SKShapeNode?
    private var time_sphere_action: SKAction?
    private var background_morning_action: SKAction?
    private var background_night_action: SKAction?
    private var game = SinglyGame()
    

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */        
        game.setTimeDelegate(self)
        timeDelegate = self
        setUpScene()
    }
    
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//       /* Called when a touch begins */
//        
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            if let touched_node = self.nodeAtPoint(location) 
//            {
//
//            }
//        }
//    }
   
//    override func update(currentTime: CFTimeInterval) {
//        /* Called before each frame is rendered */
//    }
    
    private func setUpScene()
    {
        let screen_width = self.frame.width
        let screen_height = self.frame.height
        
        self.backgroundColor = SKColor(red: 0.0, green: 191.0/255.0, blue: 255.0, alpha: 1.0)
        print("width: \(screen_width) , height: \(screen_height)")
        
        let sidewalk_node = SKShapeNode(rect: CGRectMake(0.0, 0.0, screen_width, screen_height/8.0))
        sidewalk_node.fillColor = SKColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.0)
        sidewalk_node.strokeColor = SKColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.0)
        self.addChild(sidewalk_node)
        
        let street_node = SKShapeNode(rect: CGRectMake(0.0, 0.0, screen_width, screen_height/17.0))
        street_node.fillColor = SKColor(red: 49.0/255.0, green: 79.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        street_node.strokeColor = SKColor.blackColor()
        sidewalk_node.addChild(street_node)
        
        let street_divider_and_space_width = screen_width/7.0
        let street_divider_width = street_divider_and_space_width*5.0/7.0
        //let street_space = street_divider_and_space_width*2.0/7.0
        let street_divider_height = street_node.frame.height/10.0
        
        for var i: CGFloat = 0.0; i < 7.0; i++
        {
            let street_divider_node = SKShapeNode(rect: CGRectMake(i*street_divider_and_space_width,
            street_node.frame.height/2.0 - street_divider_height/2.0,
            street_divider_width,
            street_divider_height))
            street_divider_node.fillColor = SKColor(red: 1.0, green: 215.0/255.0, blue: 0.0, alpha: 1.0)
            street_divider_node.strokeColor = SKColor.yellowColor()
            
            street_node.addChild(street_divider_node)
        }
        
        
        let building_node = SKShapeNode(rect: CGRectMake(CGRectGetMidX(sidewalk_node.frame)/2.0,
                                                                        sidewalk_node.frame.height - 6.0,
                                                                        0.70*screen_width,
                                                                        0.85*screen_height - sidewalk_node.frame.height))
        building_node.fillColor = SKColor.brownColor()
        building_node.strokeColor = SKColor.brownColor()
        sidewalk_node.addChild(building_node)
        
        //3x4 windows
        
        let window_offset = building_node.frame.width/10.0
        let window_width = (building_node.frame.width - 4.0*window_offset)/3.0
        let window_height = (building_node.frame.height - 5.0*window_offset)/4.0
        
        for var row: CGFloat = 0.0; row < 4.0; row++
        {
            for var col: CGFloat = 0.0; col < 3.0; col++
            {
                let xPostion = building_node.frame.origin.x + window_offset*(col + 1.0) + col*window_width
                let yPosition = building_node.frame.origin.y + window_offset*(row + 1.0) + row*window_height
                //let window_node = SKShapeNode(rect: CGRectMake(xPostion, yPosition, window_width, window_height))
                let window_node = windowSpawner(xPostion, y: yPosition, width: window_width, height: window_height)
                //window_node.fillColor = SKColor.whiteColor()//SKColor(red: 1.0, green: 1.0, blue: 224.0/255.0, alpha: 1.0)
                building_node.addChild(window_node)
                //window_nodes.append(window_node)
            }
        }
        
        spawnTimeSphereNode()
        
    }
    
    private func windowSpawner(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> WindowNode
    {
        let window_rect = CGRectMake(x, y, width, height)
        let window_node = WindowNode(rect: window_rect)
        window_node.setStateDelegate(self)
        window_nodes.append(window_node)
        return window_node
    }
    
    private func spawnTimeSphereNode()
    {
        // three fourths of the width is the vertex of the path of the sphere
        // path is a downward parabola
        // sphere should glow and change form and particles?
        // microsoft windows powerup to slow down time
        if time_sphere_node == nil
        {
            let time_sphere_side = self.frame.width/4.0
            let time_sphere_rect = CGRectMake(0 - time_sphere_side, self.frame.width/2.0 - time_sphere_side/2.0, time_sphere_side, time_sphere_side)
            time_sphere_node = SKShapeNode(ellipseInRect: time_sphere_rect)
            time_sphere_node?.glowWidth = 1.0
            if game.isNight
            {
                time_sphere_node?.fillColor = SKColor(red: 248.0/255.0, green: 248.0/255.0, blue: 1.0, alpha: 1.0)
                time_sphere_node?.strokeColor = SKColor.whiteColor()
            }
            else
            {
                time_sphere_node?.fillColor = SKColor.yellowColor()
                time_sphere_node?.strokeColor = SKColor.clearColor()
            }
            time_sphere_node?.zPosition = -1
            self.addChild(time_sphere_node!)
            gameScene(self, didAddTimeSphere: time_sphere_node!)
        }
    }
    
    internal func gameScene(scene: SKScene, didAddTimeSphere time_sphere_node: SKShapeNode)
    {
        if((time_sphere_action == nil))
        {
            let time_sphere_path = UIBezierPath()
            time_sphere_path.moveToPoint(time_sphere_node.frame.origin)
            let time_sphere_path_endpoint = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame)*0.50)
            let time_sphere_path_controlpoint = CGPointMake(CGRectGetMaxX(self.frame)*0.50, CGRectGetMaxY(self.frame) + time_sphere_node.frame.height)
            time_sphere_path.addQuadCurveToPoint(time_sphere_path_endpoint, controlPoint: time_sphere_path_controlpoint)
            let time_sphere_path_action = SKAction.followPath(time_sphere_path.CGPath, duration: game.getTimeSpeed())
            
            let game_group_action = SKAction.group([time_sphere_path_action])
            time_sphere_action = game_group_action
        }
        
        if(background_morning_action == nil)
        {
            let background_change_time_interval = game.getTimeSpeed()/3.0
            let background_turns_orange_action = SKAction.colorizeWithColor(SKColor.orangeColor(),
                colorBlendFactor: 1.0, duration: background_change_time_interval)
            let background_turns_blue_action = SKAction.colorizeWithColor(SKColor(red: 0.0, green: 191.0/255.0, blue: 255.0, alpha: 1.0),
                colorBlendFactor: 1.0, duration: background_change_time_interval)
            let background_turns_magenta_action = SKAction.colorizeWithColor(SKColor(red: 176.0/255.0, green: 196.0/255.0, blue: 222.0/255.0, alpha: 1.0),
                colorBlendFactor: 1.0, duration: background_change_time_interval)

            let background_color_sequence = SKAction.sequence([background_turns_orange_action, background_turns_blue_action, background_turns_magenta_action])

            background_morning_action = background_color_sequence
        }
        
        if(background_night_action == nil)
        {
            let background_change_time_interval = game.getTimeSpeed()/3.0
            let background_turns_purple_action = SKAction.colorizeWithColor(SKColor.purpleColor(),
                colorBlendFactor: 1.0, duration: background_change_time_interval)
            let background_turns_black_action = SKAction.colorizeWithColor(SKColor.blackColor(),
                colorBlendFactor: 1.0, duration: background_change_time_interval)
            let background_turns_gray_action = SKAction.colorizeWithColor(SKColor.grayColor(),
                colorBlendFactor: 1.0, duration: background_change_time_interval)

            let background_color_sequence = SKAction.sequence([background_turns_purple_action, background_turns_black_action, background_turns_gray_action])
            
            background_night_action = background_color_sequence
        }
        
        
        if !game.isNight { self.runAction(background_morning_action!) }
        else { self.runAction(background_night_action!) }
        
        refreshWindowNodes()
        time_sphere_node.runAction(time_sphere_action!) { () -> Void in
            time_sphere_node.removeAllActions()
            time_sphere_node.removeFromParent()
            self.time_sphere_node = nil
            if self.game.isNight
            {
                if(self.game.allLightsAreOn() )
                {
                    self.game.number_of_nights++
                    print("Nights: \(self.game.number_of_nights)")
                    self.game.isNight = !self.game.isNight
                    self.spawnTimeSphereNode()
                }
                else { self.gameOver() }
            }
            else if !self.game.isNight
            {
                if(self.game.allLightsAreOff() )
                { self.game.number_of_days++
                    print("Days: \(self.game.number_of_days)")
                    self.game.isNight = !self.game.isNight
                    self.spawnTimeSphereNode()
                }
                else { self.gameOver() }
            }
        }
    }
    
    private func refreshWindowNodes()
    {
        for var i = 0; i < self.game.getNumberOfLights(); i++
        {
            let randomNumber = Int(arc4random_uniform(2) + 1)
            if randomNumber % 2 == 0
            {
                game.turnWindowsLightAtIndex(i, value: true)
                window_nodes[i].setWindowNodeFillColor(SKColor.whiteColor())
            }
            else
            {
                game.turnWindowsLightAtIndex(i, value: false)
                window_nodes[i].setWindowNodeFillColor(SKColor.blackColor())
            }
        }
    }
    
    private func gameOver()
    {
        print("Game Over")
        //self.paused = true
        time_sphere_node?.removeAllActions()
        self.removeAllActions()
        // post retry, score,  ads
        game.GameOver()
        let game_over_screen = GameOverNode(rect: self.frame, number_of_days: game.number_of_days, number_of_nights: game.number_of_nights, number_of_ticks: game.number_of_ticks, high_score: game.highScore())
        self.addChild(game_over_screen)
        //presentGameOver()
    }
    
    internal func gameScene(scene: SKScene, didRemoveTimeSphere time_sphere_node: SKShapeNode)
    {
        spawnTimeSphereNode()
    }
    
    func windowNode(window_node: WindowNode, didChangeState:SKColor)
    {
        if !self.paused
        {
            for var i = 0; i < window_nodes.count; i++
            {
                if window_nodes[i] == window_node
                {
                    if(didChangeState == SKColor.whiteColor()) { game.turnWindowsLightAtIndex(i, value: true) }
                    else { game.turnWindowsLightAtIndex(i, value: false) }
                }
            }
            if(game.isNight)
            {
                if(didChangeState == SKColor.blackColor())
                {
                    gameOver()
                }
                else {
                    game.number_of_ticks++
                    print("number of points: \(game.number_of_ticks)")
                }
            }
            else if (!game.isNight)
            {
                if(didChangeState == SKColor.whiteColor())
                {
                    gameOver()
                }
                else {
                    game.number_of_ticks++
                    print("number of points: \(game.number_of_ticks)")
                }
            } 
        }
    }
    
    func timeSpeedDidGetUpdated()
    {
        print("days: \(game.number_of_days)")
        print("speed update")
        time_sphere_action = nil
        background_morning_action = nil
        background_night_action = nil
    }
    
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    

}
