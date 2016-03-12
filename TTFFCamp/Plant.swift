//
//  Plant.swift
//  TTFFCamp
//
//  Created by Jimmy Nguyen on 3/10/16.
//  Copyright © 2016 The Taylor Family Foundation. All rights reserved.
//

import Foundation

class Plant: NSObject {
    
    // Add NSCoding Protocol back once we are ready to use local database file
    
    //variable declaration
    static var key = "Plant"
    static var schema = "PlantSchema"
    var plantName: String
    var location: NSArray
    var origin: String
    var whenToPlant: String
    var coolFact: String
    var moreFacts: NSArray
    var images: NSArray
    var createdAt: NSDate
    
    //init method for new obj instances
    //    init (plantName: String, location: NSArray, origin: String, whenToPlant: String, coolFact: String, moreFacts: NSArray, images: NSArray){
    //        self.plantName = plantName
    //        self.location = location
    //        self.origin = origin
    //        self.whenToPlant = whenToPlantgit
    //        self.coolFact = coolFact
    //        self.moreFacts = moreFacts
    //        self.images = images
    //        createdAt = NSDate()
    //    }
    override init (){
        self.plantName = ""
        self.location = []
        self.origin = ""
        self.whenToPlant = ""
        self.coolFact = ""
        self.moreFacts = []
        self.images = []
        createdAt = NSDate()
    }
    
    // MARK: - NSCoding Protocol
    // used for encoding (saving) objects
    //    func encodeWithCoder(aCoder: NSCoder) {
    //        aCoder.encodeObject(plantName, forKey: "plantName")
    //        aCoder.encodeObject(location, forKey: "location")
    //        aCoder.encodeObject(origin, forKey: "orgin")
    //        aCoder.encodeObject(whenToPlant, forKey: "whenToPlant")
    //        aCoder.encodeObject(coolFact, forKey: "coolFact")
    //        aCoder.encodeObject(moreFacts, forKey: "moreFacts")
    //        aCoder.encodeObject(images, forKey: "images")
    //        aCoder.encodeObject(createdAt, forKey:  "createdAt")
    //    }
    //
    //    // used for decoding (loading) objects
    //    required init?(coder aDecoder: NSCoder) {
    //        plantName = aDecoder.decodeObjectForKey("plantName") as! String
    //        location = aDecoder.decodeObjectForKey("location") as! NSArray
    //        origin = aDecoder.decodeObjectForKey("origin") as! String
    //        whenToPlant = aDecoder.decodeObjectForKey("whenToPlant") as! String
    //        coolFact = aDecoder.decodeObjectForKey("coolFact") as! String
    //        moreFacts = aDecoder.decodeObjectForKey("moreFacts") as! NSArray
    //        images = aDecoder.decodeObjectForKey("images") as! NSArray
    //        createdAt = aDecoder.decodeObjectForKey("createdAt") as! NSDate
    //        super.init()
    //    }
    
    
    static func retrievePlant(plantId: String) {
        
        // Uncomment out once we are ready to make queries to retrieve from actual database
        //        var plants = [Plant]()
        //        let path = Database.dataFilePath(Plant.schema)
        //        if NSFileManager.defaultManager().fileExistsAtPath(path) {
        //            if let data = NSData(contentsOfFile: path) {
        //                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        //                plants = unarchiver.decodeObjectForKey(Plant.key) as! [Plant]
        //                unarchiver.finishDecoding()
        //            }
        //        }
        
        //        return plants
    }
    
    static func sync() {
        // sync function to make AJAX call to localhost server
    }
    
    
    
}