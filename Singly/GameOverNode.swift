//
//  GameOverNode.swift
//  Singly
//
//  Created by Satbir Tanda on 1/3/16.
//  Copyright © 2016 Satbir Tanda. All rights reserved.
//

import SpriteKit
import iAd

class GameOverNode: SKNode, ADInterstitialAdDelegate
{
    
    private var screen: CGRect!
    // private var reset_button: SKShapeNode!
    private var interstitialAd: ADInterstitialAd?
    private var interstitialAdView: UIView?
    private var closeButton: UIButton?

    
    convenience init(rect: CGRect, number_of_days: Int, number_of_nights: Int, number_of_ticks: Int, high_score: Int)
    {
        self.init()
        screen = rect
        
        let clear_background_node = SKShapeNode(rect: rect)
        clear_background_node.fillColor = SKColor.clearColor()
        clear_background_node.strokeColor = SKColor.clearColor()
        self.addChild(clear_background_node)
        
        let gameover_width = rect.width
        let gameover_height = rect.height/8.0
        let gameover_rect = CGRectMake((rect.width/2.0) - gameover_width/2.0, (rect.height*7.0/8.0) - gameover_height/2.0, gameover_width, gameover_height)
        let gameover_box = SKShapeNode(rect: gameover_rect)
        gameover_box.fillColor = SKColor.blackColor()
        gameover_box.alpha = 0.0
        clear_background_node.addChild(gameover_box)
        
        let gameover_label_node = SKLabelNode(text: "GAME OVER")
        gameover_label_node.fontSize = rect.width/5.50
        gameover_label_node.fontName = "Futura-CondensedExtraBold"
        gameover_label_node.position = CGPointMake(rect.width/2.0, rect.height*7.0/8.0)
        gameover_label_node.fontColor = SKColor.whiteColor()//SKColor(red: 1.0, green: 69.0/255.0, blue: 0, alpha: 1.0)
        gameover_label_node.alpha = 0.0
        clear_background_node.addChild(gameover_label_node)
        
        let box_move = SKAction.moveToY(-rect.height/12.0, duration: 0.25)
        let box_fade = SKAction.fadeAlphaTo(1.0, duration: 0.25)
        let box_group = SKAction.group([box_fade, box_move])
        
        let move_action = SKAction.moveTo(CGPointMake(rect.width/2.0, rect.height*3.0/4.0), duration: 0.25)
        let fade_action = SKAction.fadeAlphaTo(1.0, duration: 0.25)
        let wait_action = SKAction.waitForDuration(0.50)
        let group_action = SKAction.group([move_action, fade_action])
        
        
        
        self.runAction(SKAction.playSoundFileNamed("gameover.mp3", waitForCompletion: false))
        let flash = SKShapeNode(rect: rect)
        flash.fillColor = SKColor.whiteColor()
        flash.alpha = 0.0
        clear_background_node.addChild(flash)
        flash.runAction(SKAction.fadeAlphaTo(0.85, duration: 0.20)) { () -> Void in
            flash.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0.0, duration: 0.1), SKAction.waitForDuration(0.3)]), completion: { () -> Void in
                flash.removeFromParent()
                gameover_box.runAction(box_group)
                self.runAction(SKAction.playSoundFileNamed("light_switch.mp3", waitForCompletion: false))
                gameover_label_node.runAction(SKAction.sequence([group_action, wait_action]))
                    { () -> Void in
                        let score_width = rect.width*3.0/4.0
                        let score_height = rect.height*3.0/8.0
                        let score_rect = CGRectMake((rect.width - score_width)/2.0, (0 - score_height), score_width, score_height)
                        let score_node = SKShapeNode(rect: score_rect, cornerRadius: score_width/8.0)
                        score_node.fillColor = SKColor(red: 218.0/255.0, green: 165.0/255.0, blue: 32.0/255.0, alpha: 1.0)
                        score_node.strokeColor = SKColor.blackColor()
                        clear_background_node.addChild(score_node)
                        score_node.runAction(SKAction.moveToY(rect.height/2.0 + score_height/2.0, duration: 0.15), completion:
                            { () -> Void in
                                //code
                                self.runAction(SKAction.playSoundFileNamed("light_switch.mp3", waitForCompletion: false))
                                let offset = score_node.frame.height/10.0
                                let number_of_days_node = SKLabelNode(text: "NUMBER OF DAYS: \(number_of_days)" )
                                let number_of_nights_node = SKLabelNode(text: "NUMBER OF NIGHTS: \(number_of_nights)" )
                                let number_of_ticks_node = SKLabelNode(text: "NUMBER OF TICKS: \(number_of_ticks)" )
                                let total_node = SKLabelNode(text: "TOTAL: \(number_of_days + number_of_nights + number_of_ticks)" )
                                let best_node = SKLabelNode(text: "BEST TOTAL: \(high_score)" )
                                
                                number_of_days_node.fontName = "Verdana-Bold"
                                number_of_days_node.fontSize = score_node.frame.width/20.0
                                number_of_days_node.position = CGPointMake(rect.width/2.0,  rect.height/2.0 + score_height/2.0 - 2*offset)
                                clear_background_node.addChild(number_of_days_node)
                                
                                number_of_nights_node.fontName = "Verdana-Bold"
                                number_of_nights_node.fontSize = score_node.frame.width/20.0
                                number_of_nights_node.position = CGPointMake(rect.width/2.0,  rect.height/2.0 + score_height/2.0 - 3*offset)
                                clear_background_node.addChild(number_of_nights_node)
                                
                                number_of_ticks_node.fontName = "Verdana-Bold"
                                number_of_ticks_node.fontSize = score_node.frame.width/20.0
                                number_of_ticks_node.position = CGPointMake(rect.width/2.0,  rect.height/2.0 + score_height/2.0 - 4*offset)
                                clear_background_node.addChild(number_of_ticks_node)
                                
                                total_node.fontName = "Verdana-Bold"
                                total_node.fontSize = score_node.frame.width/20.0
                                total_node.position = CGPointMake(rect.width/2.0,  rect.height/2.0 + score_height/2.0 - 5*offset)
                                clear_background_node.addChild(total_node)
                                
                                best_node.fontName = "Verdana-Bold"
                                best_node.fontSize = score_node.frame.width/20.0
                                best_node.position = CGPointMake(rect.width/2.0,  rect.height/2.0 + score_height/2.0 - 6*offset)
                                clear_background_node.addChild(best_node)
                                
                                if(high_score == number_of_ticks + number_of_days + number_of_nights)
                                {
                                    let high_score_width = score_width/2.0
                                    let high_score_height = score_height / 5.0
                                    let high_score_rect = CGRectMake(rect.width/2.0 - high_score_width/2.0,  rect.height/2.0 + score_height/2.0 - 8*offset - high_score_height/2.0, high_score_width, high_score_height)
                                    let high_score_node = SKShapeNode(rect: high_score_rect)
                                    high_score_node.fillColor = SKColor.redColor()
                                    clear_background_node.addChild(high_score_node)
                                    
                                    let high_score_label = SKLabelNode(text: "HIGH SCORE !!!")
                                    high_score_label.fontName = "Verdana-Bold"
                                    high_score_label.fontSize = score_node.frame.width/20.0
                                    high_score_label.position = CGPointMake(rect.width/2.0,  rect.height/2.0 + score_height/2.0 - 8*offset)
                                    clear_background_node.addChild(high_score_label)
                                }
                                self.loadInterstitialAd()
                                
                                
                                
                        })
                        
                        self.runAction(SKAction.waitForDuration(2.0), completion: { () -> Void in
                            let button_width = rect.width/3.0
                            let button_height = rect.height/8.0
                            let play_button_rect = CGRectMake(rect.width/10.0, (rect.height/8.0) - button_height/2.0, button_width, button_height)
                            let play_button_node = PlayButtonNode(rect: play_button_rect)
                            clear_background_node.addChild(play_button_node)
                            
                            let rankings_button_rect = CGRectMake(rect.width - rect.width/10.0 - button_width, (rect.height/8.0) - button_height/2.0, button_width, button_height)
                            let rankings_button_node = RankingsButtonNode(rect: rankings_button_rect)
                            clear_background_node.addChild(rankings_button_node)
                            //                self.reset_button = SKShapeNode(rect: play_button_rect)
                            //                self.reset_button.fillColor = SKColor.clearColor()
                            //                self.reset_button.strokeColor = SKColor.clearColor()
                            //                self.reset_button.zPosition = 1
                            //play_button_node.addChild(self.reset_button)
                            let width = button_width/2.0
                            let height = button_height/2.0
                            let rate_button_rect = CGRectMake((rect.width - width)/2.0, CGRectGetMaxY(rect)*1.0/8.0 + button_height/2.0 + rect.height/25.0, width, height)
                            let rate_button_node = RateButtonNode(rect: rate_button_rect)
                            self.addChild(rate_button_node)
                            self.runAction(SKAction.playSoundFileNamed("light_switch.mp3", waitForCompletion: false))
                        })
                }
            })
        }
        
        
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func loadInterstitialAd() {
        interstitialAd = ADInterstitialAd()
        interstitialAd!.delegate = self
    }
    
    func interstitialAdWillLoad(interstitialAd: ADInterstitialAd!) {
        
    }
    
    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
        interstitialAdView = UIView(frame: screen)
        if self.scene?.view?.window?.rootViewController != nil
        {
            self.scene?.view?.window?.rootViewController!.view.addSubview(interstitialAdView!)
        }
        
        closeButton = UIButton(frame: CGRect(x: 25, y:  25, width: 25, height: 25))
        //add a cross shaped graphics into your project to use as close button
        closeButton?.setBackgroundImage(UIImage(named: "close"), forState: UIControlState.Normal)
        closeButton?.addTarget(self, action: Selector("close"), forControlEvents: UIControlEvents.TouchDown)
        
        if self.scene?.view?.window?.rootViewController != nil
        {
            if closeButton != nil
            {
                self.scene?.view?.window?.rootViewController!.view.addSubview(closeButton!)
            }
        }
        
        interstitialAd.presentInView(interstitialAdView)
        UIViewController.prepareInterstitialAds()
    }
    
    func close() {
        closeButton?.removeFromSuperview()
        closeButton = nil
        interstitialAdView?.removeFromSuperview()
        interstitialAd = nil
        
    }
    
    func interstitialAdActionDidFinish(interstitialAd: ADInterstitialAd!) {
        closeButton?.removeFromSuperview()
        interstitialAdView?.removeFromSuperview()
    }
    
    
    func interstitialAdActionShouldBegin(interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
        
    }
    
    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
        interstitialAdView?.removeFromSuperview()
    }
    

}
