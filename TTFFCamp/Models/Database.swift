//
//  Database.swift
//  TTFFCamp
//
//  Created by Jimmy Nguyen on 3/10/16.
//  Copyright © 2016 The Taylor Family Foundation. All rights reserved.
//

import Foundation

class Database {
    // get the full path to the Documents folder
    static func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    // get the full path to file of project
    static func dataFilePath(_ schema: String) -> String {
        return "\(Database.documentsDirectory())/\(schema)"
    }
    
    static func save(_ arrayOfObjects: [AnyObject], toSchema: String, forKey: String) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(arrayOfObjects, forKey: "\(forKey)")
        archiver.finishEncoding()
        data.write(toFile: Database.dataFilePath(toSchema), atomically: true)
        //print("saved data", data)
    }
    
    
    static func all() -> [Plant] {
        var plants = [Plant]()
        
        let path = Database.dataFilePath(Plant.schema)
        if FileManager.default.fileExists(atPath: path) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                plants = unarchiver.decodeObject(forKey: Plant.key) as! [Plant]
                unarchiver.finishDecoding()
            }
        }
        return plants
    }

}
