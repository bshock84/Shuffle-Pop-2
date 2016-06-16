//
//  FileSystemWatcher.swift
//  Shuffle Pop 2
//
//  Created by Ben Shockley on 6/14/16.
//  Copyright © 2016 Ben Shockley. All rights reserved.
//

import Foundation
import CoreServices

public class FileSystemWatcher {
    
    // MARK: - Initialization / Deinitialization
    
    public init(pathsToWatch: [String], sinceWhen: FSEventStreamEventId) {
        self.lastEventId = sinceWhen
        self.pathsToWatch = pathsToWatch
    }
    
    convenience public init(pathsToWatch: [String]) {
        self.init(pathsToWatch: pathsToWatch, sinceWhen: FSEventStreamEventId(kFSEventStreamEventIdSinceNow))
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Private Properties
    
    private let eventCallback: FSEventStreamCallback = { (stream: ConstFSEventStreamRef, contextInfo: UnsafeMutablePointer<Void>, numEvents: Int, eventPaths: UnsafeMutablePointer<Void>, eventFlags: UnsafePointer<FSEventStreamEventFlags>, eventIds: UnsafePointer<FSEventStreamEventId>) in
        print("***** FSEventCallback Fired *****", true)
        
        let fileSystemWatcher: FileSystemWatcher = unsafeBitCast(contextInfo, FileSystemWatcher.self)
        let paths = unsafeBitCast(eventPaths, NSArray.self) as! [String]
        
        for index in 0..<numEvents {
            fileSystemWatcher.processEvent(eventIds[index], eventPath: paths[index], eventFlags: eventFlags[index])
        }
        
        fileSystemWatcher.lastEventId = eventIds[numEvents - 1]
    }
    private let pathsToWatch: [String]
    private var started = false
    private var streamRef: FSEventStreamRef!
    
    // MARK: - Private Methods
    
    private func processEvent(eventId: FSEventStreamEventId, eventPath: String, eventFlags: FSEventStreamEventFlags) {
        print("\t\(eventId) - \(eventFlags) - \(eventPath)", true)
    }
    
    // MARK: - Pubic Properties
    
    public private(set) var lastEventId: FSEventStreamEventId
    
    // MARK: - Pubic Methods
    
    public func start() {
        guard started == false else { print("something went wrong"); return }
        
        var context = FSEventStreamContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutablePointer<Void>(unsafeAddressOf(self))
        let flags = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)
        streamRef = FSEventStreamCreate(kCFAllocatorDefault, eventCallback, &context, pathsToWatch, lastEventId, 0, flags)
        
        FSEventStreamScheduleWithRunLoop(streamRef, CFRunLoopGetMain(), kCFRunLoopDefaultMode)
        FSEventStreamStart(streamRef)
        
        started = true
    }
    
    public func stop() {
        guard started == true else { return }
        
        FSEventStreamStop(streamRef)
        FSEventStreamInvalidate(streamRef)
        FSEventStreamRelease(streamRef)
        streamRef = nil
        
        started = false
    }
    
}