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

class ViewController: NSViewController, DirectoryMonitorDelegate {
    
    
    
    
    
    var path: String = "/users/benshockley/Documents/pictures"
    let directoryMonitor = DirectoryMonitor(URL: .fileURLWithPath("nil"))
    var randomIndex: Int = 0
    let mainView = NSView(frame: CGRect(x: 0.0, y: 0.0, width: 600.0, height: 600.0))
    let imageBox = NSImageView(frame: CGRect(x: 100.0, y: 0.0, width: 400.0, height: 600.0))
    var previouslyUsedNumbers: [Int] = []
    var imageArray: [String] = []
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    func customizeMenu() {
        let availableDisplaysByName = screenNames()
        let displayMenu = NSMenu(title: "Display")
        let chooseDisplay = NSMenuItem(title: "Choose Display", action: nil, keyEquivalent: "chooseDisplay")
        let displayMenuItem = NSMenuItem(title: "Display", action: nil, keyEquivalent: "display")
        let displayChoiceMenu = NSMenu(title: "Choose Display")
        
        displayMenu.addItem(chooseDisplay)
        displayMenuItem.submenu = displayMenu
        NSApp.mainMenu?.addItem(displayMenuItem)
        
        //for display in availableDisplaysByName {
         //   displayChoiceMenu.addItemWithTitle(display, action: #selector(ViewController.displayOnScreen(_:)), keyEquivalent: display)
          //  chooseDisplay.submenu = displayChoiceMenu
            //print(display)
        
        if availableDisplaysByName.count > 0 {
            displayChoiceMenu.addItemWithTitle(availableDisplaysByName[0], action: #selector(ViewController.displayOnScreenOne), keyEquivalent: "d1")
            chooseDisplay.submenu = displayChoiceMenu
        } else {
            print("Apparently there isn't a screen attached to this comptuer.  That is strange.")
        }
        if availableDisplaysByName.count > 1 {
            displayChoiceMenu.addItemWithTitle(availableDisplaysByName[1], action: #selector(ViewController.displayOnScreenTwo), keyEquivalent: "d2")
            chooseDisplay.submenu = displayChoiceMenu
        }
        if availableDisplaysByName.count > 2 {
            displayChoiceMenu.addItemWithTitle(availableDisplaysByName[2], action: #selector(ViewController.displayOnScreenThree), keyEquivalent: "d3")
            chooseDisplay.submenu = displayChoiceMenu
        }
        if availableDisplaysByName.count > 3 {
            displayChoiceMenu.addItemWithTitle(availableDisplaysByName[3], action: #selector(ViewController.displayOnScreenFour), keyEquivalent: "d4")
            chooseDisplay.submenu = displayChoiceMenu
        }
        if availableDisplaysByName.count > 4 {
            displayChoiceMenu.addItemWithTitle(availableDisplaysByName[4], action: #selector(ViewController.displayOnScreenFive), keyEquivalent: "d5")
            chooseDisplay.submenu = displayChoiceMenu
        }
        }
    


    func displayOnScreenOne() {
        print("Selected Screen 1")
    }
    func displayOnScreenTwo() {
        print("Selected Screen 2")
        
    }
    func displayOnScreenThree() {
        print("Selected Screen 3")
        
    }
    func displayOnScreenFour() {
        print("Selected Screen 4")
        
    }
    func displayOnScreenFive() {
        print("Selected Screen 5")
        
    }

    func displayOnScreen(index: Int) {
        print("displaying on this screen \(index)")
        
    }
    
    func listDisplays() {
        print("menu selected")
        
    }
    
    func updateArray() {
        let qualityOfServiceClass = QOS_CLASS_UTILITY
        let newQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(newQueue, reCreateImageArray)
        dispatch_async(dispatch_get_main_queue(), { print("Image array has been rebuilt")})
        
        //randomIndex = 0
        //previouslyUsedNumbers = []
    }
    
    func directoryMonitorDidObserveChange(directoryMonitor: DirectoryMonitor) {
        print("Directory contents have changed, refreshing the array.")
        updateArray()
    }
    
    func endDirectoryMonitor() {
        directoryMonitor.stopMonitoring()
    }
    
    func initiateDirectoryMonitor() {
        directoryMonitor.URL = NSURL(fileURLWithPath: path)
        directoryMonitor.delegate = self
        directoryMonitor.startMonitoring()
    }
    
    func configureImageBox() {
        view.addSubview(mainView)
        //mainView.translatesAutoresizingMaskIntoConstraints = false

        mainView.addSubview(imageBox)
        //imageBox.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints([
        mainView.topAnchor.constraintEqualToAnchor(view.topAnchor),
        mainView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
        mainView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
        mainView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)])
        
        //NSLayoutConstraint.activateConstraints([
        //imageBox.topAnchor.constraintEqualToAnchor(mainView.topAnchor),
        //imageBox.leftAnchor.constraintEqualToAnchor(mainView.leftAnchor),
        //imageBox.rightAnchor.constraintEqualToAnchor(mainView.rightAnchor),
        //imageBox.bottomAnchor.constraintEqualToAnchor(mainView.bottomAnchor)])
        
        //imageBox.setFrameSize(CGSize(width: 400, height: 1200))
        imageBox.imageScaling = NSImageScaling.ScaleProportionallyUpOrDown
    }
    
    func getRandomInt() -> Int {
        var didFindNumber = false
        var randomIndex: Int = 0
        
        while didFindNumber == false {
            randomIndex = GKRandomSource.sharedRandom().nextIntWithUpperBound(imageArray.count)
            
            if previouslyUsedNumbers.contains(randomIndex) {
                if imageArray.count == previouslyUsedNumbers.count {
                    previouslyUsedNumbers = []
                    print("\n**** End of array has been reached.  Starting over.****\n")
                } else {
                    didFindNumber = false
                }
            } else {
                didFindNumber = true
                previouslyUsedNumbers.append(randomIndex)
            }
            
        }
        
        return randomIndex
    }
    
    func displayRandomImage() {
        let fileName: String = "\(path)/\(imageArray[randomIndex])"
        //print("The current file is located at \(fileName)\n")
        imageBox.image = NSImage(contentsOfFile: fileName)
        randomIndex = getRandomInt()

        
    }
    
    func reCreateImageArray() {
        imageArray = []
        createImageArray()
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
        
        
        
        customizeMenu()
        
        createImageArray()
        configureImageBox()
        displayRandomImage()
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.displayRandomImage), userInfo: nil, repeats: true)
        initiateDirectoryMonitor()

        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
}

