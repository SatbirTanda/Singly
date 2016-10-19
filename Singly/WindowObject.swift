//
//  WindowObject.swift
//  OneByOne
//
//  Created by Satbir Tanda on 12/31/15.
//  Copyright © 2015 Satbir Tanda. All rights reserved.
//

import Foundation

class WindowObject {
    
    private var light = true
    
    init()
    {
        light = true
    }
    
    func lightIsOn() -> Bool
    {
        return light
    }
    
    func setLight(value: Bool)
    {
        light = value
    }
}