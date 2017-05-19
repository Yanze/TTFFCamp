//
//  Plant2.swift
//  TTFFCamp
//
//  Created by Marcus Sakoda on 5/11/17.
//  Copyright © 2017 The Taylor Family Foundation. All rights reserved.
//

import Foundation
import CoreData

class Plant2 {
    
    func getAllPlants(completionHandler: @escaping (([NSDictionary]) -> Void)) {
        print("running getAllPlants function")
        let allPlantsURL = URL(string: urlHost + "all")
        let urlRequest = URLRequest(url: allPlantsURL!)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {
            
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    DispatchQueue.main.async {
                        completionHandler(jsonResult as! [NSDictionary])
                    }
                }
            } catch {
                print(error)
            }
            
        })
        
        task.resume()
        
        
    }

}
