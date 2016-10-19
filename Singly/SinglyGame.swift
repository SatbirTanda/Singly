//
//  OneByOneLogic.swift
//  OneByOne
//
//  Created by Satbir Tanda on 12/31/15.
//  Copyright © 2015 Satbir Tanda. All rights reserved.
//

import Foundation
import GameKit

protocol GameTimeDelegate {
    func timeSpeedDidGetUpdated()
}

class SinglyGame {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var isNight = false
    var number_of_days = 0 // adjust speed of time
    {
        didSet
        {
            if number_of_days % 7 == 0
            {
                timeSpeed = timeSpeed*9.0/10.0
                timeDelegate?.timeSpeedDidGetUpdated()
            }
        }
    }
    var number_of_nights = 0 //adjust speed of time
    var number_of_ticks = 0
    private var windows = [WindowObject]()
    private var timeSpeed = 5.0
    private var gameOver = false
    private var timeDelegate: GameTimeDelegate?
    private var number_of_lights = 12
    
    
    init()
    {
        for var i = 0; i < number_of_lights; i++ { windows.append(WindowObject()) }
        if(defaults.objectForKey("High Score") == nil)
        {
            defaults.setInteger(0, forKey: "High Score")
        }
    }
    
    func getTimeSpeed() -> Double
    {
        return timeSpeed
    }
    
    func setTimeDelegate(delegate_implementor: GameTimeDelegate)
    {
        self.timeDelegate = delegate_implementor
    }

    func getNumberOfLights() -> Int
    {
        return number_of_lights
    }
    
    func turnWindowsLightAtIndex(index: Int, value: Bool)
    {
        windows[index].setLight(value)
    }
    
    func allLightsAreOff() -> Bool
    {
        for window in windows
        {
            if window.lightIsOn() == true {return false}
        }
        return true
    }
    
    func allLightsAreOn() -> Bool
    {
        for window in windows
        {
            if window.lightIsOn() == false {return false}

        }
        return true
    }
    
    func GameOver()
    {
        gameOver = true
        if (defaults.objectForKey("High Score") != nil)
        {
            let current_high_score = number_of_days + number_of_nights + number_of_ticks
            if defaults.integerForKey("High Score") < current_high_score
            {
                defaults.setInteger(current_high_score, forKey: "High Score")
                submitScore(current_high_score)
            }
        }
    }
    
    func highScore() -> Int
    {
        if(defaults.objectForKey("High Score") != nil)
        {
            return defaults.integerForKey("High Score")
        }
        return 0
    }
    
    private func submitScore(score: Int)
    {
        let leaderboardID = "singly.top.scores"
        let sScore = GKScore(leaderboardIdentifier: leaderboardID)
        sScore.value = Int64(score)
        
        //let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        GKScore.reportScores([sScore], withCompletionHandler: { (error: NSError?) -> Void in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Score submitted")
                
            }
        })
    }
}