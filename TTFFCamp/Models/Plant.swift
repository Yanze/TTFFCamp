//
//  Plant.swift
//  TTFFCamp
//
//  Created by Jimmy Nguyen on 3/10/16.
//  Copyright © 2016 The Taylor Family Foundation. All rights reserved.
//

import Foundation

class Plant: NSObject, NSCoding {
    
    //variable declaration
    static var key = "Plants"
    static var schema = "PlantSchema"
    var plantName: String
    var location: String
    var origin: String
    var plantDescription: String
    var whenToPlant: String
    var coolFact: String
    var moreFacts: String
    var images: [String]
    var createdAt: Date
    var captions: [String]
    
    //init method for new obj instances
    override init (){
        self.plantName = ""
        self.location = ""
        self.origin = ""
        self.plantDescription = ""
        self.whenToPlant = ""
        self.coolFact = ""
        self.moreFacts = ""
        self.images = []
        self.captions = []
        createdAt = Date()
    }
    
    // MARK: - NSCoding protocol
    // used for encoding (saving) objects
    func encode(with aCoder: NSCoder) {
        aCoder.encode(plantName, forKey: "plantName")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(origin, forKey: "origin")
        aCoder.encode(plantDescription, forKey: "plantDescription")
        aCoder.encode(whenToPlant, forKey: "whenToPlant")
        aCoder.encode(coolFact, forKey: "coolFact")
        aCoder.encode(moreFacts, forKey: "moreFacts")
        aCoder.encode(images, forKey: "images")
        aCoder.encode(captions, forKey: "captions")
        aCoder.encode(createdAt, forKey:  "createdAt")
    }
    // used for decoding (loading) objects
    required init?(coder aDecoder: NSCoder) {
        plantName = aDecoder.decodeObject(forKey: "plantName") as! String
        location = aDecoder.decodeObject(forKey: "location") as! String
        origin = aDecoder.decodeObject(forKey: "origin") as! String
        plantDescription = aDecoder.decodeObject(forKey: "plantDescription") as! String
        whenToPlant = aDecoder.decodeObject(forKey: "whenToPlant") as! String
        coolFact = aDecoder.decodeObject(forKey: "coolFact") as! String
        moreFacts = aDecoder.decodeObject(forKey: "moreFacts") as! String
        images = aDecoder.decodeObject(forKey: "images") as! [String]
        captions = aDecoder.decodeObject(forKey: "captions") as! [String]
        createdAt = aDecoder.decodeObject(forKey: "createdAt") as! Date
        super.init()
    }
    
    
}
