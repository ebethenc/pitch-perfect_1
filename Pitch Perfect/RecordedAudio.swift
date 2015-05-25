//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by A H on 5/24/15.
//  Copyright (c) 2015 Bobiu. All rights reserved.
//

import Foundation

/**
    Model for the Recorded Audio that must go from RecordSoundVC to PlaySoundVC
*/
class RecordedAudio: NSObject {
    var filePathURL: NSURL!
    var title: String!

   	override init() {
        filePathURL = NSURL()
        title = "No Title"
    }
    
    init(filePathURL:NSURL, title:String) {
        self.filePathURL = filePathURL
        self.title = title
    }
}