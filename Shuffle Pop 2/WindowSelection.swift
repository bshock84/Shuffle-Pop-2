//
//  WindowSelection.swift
//  Shuffle Pop 2
//
//  Created by Ben Shockley on 6/22/16.
//  Copyright © 2016 Ben Shockley. All rights reserved.
//

import Foundation
import AppKit



func screenNames() -> [String] {
    
// This code is courtesy of vadian from stackoverflow.com
    
    var names = [String]()
    var object : io_object_t
    var serialPortIterator = io_iterator_t()
    let matching = IOServiceMatching("IODisplayConnect")
    
    let kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault,
                                                  matching,
                                                  &serialPortIterator)
    if KERN_SUCCESS == kernResult && serialPortIterator != 0 {
        repeat {
            object = IOIteratorNext(serialPortIterator)
            let info = IODisplayCreateInfoDictionary(object, UInt32(kIODisplayOnlyPreferredName)).takeRetainedValue() as NSDictionary as! [String:AnyObject]
            if let productName = info["DisplayProductName"] as? [String:String],
                let firstKey = Array(productName.keys).first {
                names.append(productName[firstKey]!)
            }
            
        } while object != 0
    }
    IOObjectRelease(serialPortIterator)
    return names
}

let names = screenNames()

let menu = NSMenu()
func findTheCorrectMenu(tag: Int) {
    let index = menu.indexOfItemWithTag(tag)
    print(index)
}