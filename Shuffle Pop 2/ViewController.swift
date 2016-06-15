//
//  ViewController.swift
//  Shuffle Pop 2
//
//  Created by Ben Shockley on 6/13/16.
//  Copyright © 2016 Ben Shockley. All rights reserved.
//
import Cocoa
import Foundation
import AppKit
import GameKit

class ViewController: NSViewController {
    var path: String = "/users/benshockley/Documents/pictures"
    var randomIndex: Int = 0
    let mainView = NSView(frame: CGRect(x: 0.0, y: 0.0, width: 600.0, height: 600.0))
    let imageBox = NSImageView(frame: CGRect(x: 0.0, y: 0.0, width: 600.0, height: 600.0))
    var previouslyUsedNumbers: [Int] = []
    var imageArray: [String] = []
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    
    func configureImageBox() {
        view.addSubview(mainView)
        //mainView.translatesAutoresizingMaskIntoConstraints = false

        mainView.addSubview(imageBox)
        imageBox.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints([
        mainView.topAnchor.constraintEqualToAnchor(view.topAnchor),
        mainView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
        mainView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
        mainView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)])
        
        NSLayoutConstraint.activateConstraints([
        imageBox.topAnchor.constraintEqualToAnchor(mainView.topAnchor),
        imageBox.leftAnchor.constraintEqualToAnchor(mainView.leftAnchor),
        imageBox.rightAnchor.constraintEqualToAnchor(mainView.rightAnchor),
        imageBox.bottomAnchor.constraintEqualToAnchor(mainView.bottomAnchor)])
        
        
        imageBox.imageScaling = NSImageScaling.ScaleProportionallyUpOrDown
    }
    
    func getRandomInt() -> Int {
        var foundNumber = false
        var randomIndex: Int = 0
        
        while foundNumber == false {
            randomIndex = GKRandomSource.sharedRandom().nextIntWithUpperBound(imageArray.count)
            
            if previouslyUsedNumbers.contains(randomIndex) {
                if imageArray.count == previouslyUsedNumbers.count {
                    previouslyUsedNumbers = []
                    print("\n**** End of array has been reached.  Starting over.****\n")
                } else {
                    foundNumber = false
                }
            } else {
                foundNumber = true
                previouslyUsedNumbers.append(randomIndex)
            }
            
        }
        return randomIndex
    }
    
    override func viewWillLayout() {
        configureImageBox()
    }

    func displayRandomImage() {
        let fileName: String = "\(path)/\(imageArray[randomIndex])"
        print("The current file is located at \(fileName)\n")
        imageBox.image = NSImage(contentsOfFile: fileName)
        randomIndex = getRandomInt()

        
    }
    
    
    func createImageArray() {
        let fm = NSFileManager.defaultManager()
        let items = try! fm.contentsOfDirectoryAtPath(path)
        
        for image in items {
            if image.containsString(".jpg") {
                imageArray.append(image)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createImageArray()
        configureImageBox()
        displayRandomImage()
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.displayRandomImage), userInfo: nil, repeats: true)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
}

