//
//  HiddenMenuViewController.swift
//  TTFFCamp
//
//  Created by yanze on 3/13/16.
//  Copyright © 2016 The Taylor Family Foundation. All rights reserved.
//

import UIKit
import Alamofire
import Foundation


class HiddenMenuViewController: UIViewController {
    
    @IBOutlet weak var userInputLabel: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var passwordInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.hidden = true
        messageLabel.textColor = UIColor.redColor()
        userInputLabel.attributedPlaceholder = NSAttributedString(string:"Please enter your IP address",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        passwordInput.attributedPlaceholder = NSAttributedString(string:"Please enter your password",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])

        
    }
    
    @IBAction func clickToSynchronize(sender: UIButton) {
        
        let ipCheck = regExIpAddressCheck(userInputLabel.text!)

        if ipCheck && passwordInput.text == "ttff" {
            messageLabel.text = "Downloading..."
            messageLabel.textColor = UIColor.blueColor()
            messageLabel.hidden = false
            var successCheck = false
            
            Alamofire.request(.GET, "http://\(userInputLabel.text!):8001/getAllPlants")
                .responseJSON { response in
                    if let JSON = response.result.value {
                        var plantArray = [Plant]()
                    
                        // parse JSON data and create new Plant objs and Plant array
                        for anItem in JSON as! [Dictionary<String, AnyObject>] {
                            let plantObj = Plant()
                            if let newName = anItem["name"] {
                                plantObj.plantName = newName as! String
                            }
                            if let newLocation = anItem["location"] {
                                plantObj.location = newLocation as! String
                            }
                            if let newOrigin = anItem["origin"] {
                                plantObj.origin = newOrigin as! String
                            }
                            if let newDesc = anItem["description"] {
                                plantObj.plantDescription = newDesc as! String
                            }
                            if let newWTP = anItem["whenToPlant"] {
                                plantObj.whenToPlant = newWTP as! String
                            }
                            if let newCF = anItem["coolFact"] {
                                plantObj.coolFact = newCF as! String
                            }
                            if let newMF = anItem["moreFact"] {
                                plantObj.moreFacts = newMF as! String
                            }
                            if let newImage1 = anItem["imgStr1"] {
                                let image1 = newImage1 as! String
                                if image1 != ""{
                                    plantObj.images.append(image1)
                                }
                            }
                            if let newImage2 = anItem["imgStr2"] {
                                let image2 = newImage2 as! String
                                if image2 != ""{
                                    plantObj.images.append(image2)
                                }
                            }
                            if let newImage3 = anItem["imgStr3"] {
                                let image3 = newImage3 as! String
                                if image3 != ""{
                                    plantObj.images.append(image3)
                                }
                            }
                            if let newImage4 = anItem["imgStr4"] {
                                let image4 = newImage4 as! String
                                if image4 != ""{
                                    plantObj.images.append(image4)
                                }
                            }
                            
                            if let newCaption1 = anItem["imgname1"] {
                                let caption1 = newCaption1 as! String
                                if caption1 != "" {
                                    plantObj.captions.append(caption1)
                                }
                            }
                            
                            if let newCaption2 = anItem["imgname2"] {
                                let caption2 = newCaption2 as! String
                                if caption2 != "" {
                                    plantObj.captions.append(caption2)
                                }
                            }
                            
                            if let newCaption3 = anItem["imgname3"] {
                                let caption3 = newCaption3 as! String
                                if caption3 != "" {
                                    plantObj.captions.append(caption3)
                                }
                            }
                            
                            if let newCaption4 = anItem["imgname4"] {
                                let caption4 = newCaption4 as! String
                                if caption4 != "" {
                                    plantObj.captions.append(caption4)
                                }
                            }

                            plantArray.append(plantObj)
                                            
                        }
                        
                        print("new plant array", plantArray)
                                        
                        Database.save(plantArray, toSchema: Plant.schema, forKey: Plant.key) // save all to local storage
                        
                        successCheck = true
                    }
                    if successCheck {
                        self.messageLabel.text = "COMPLETE"
                        successCheck = false
                    } else {
                        self.messageLabel.text = "ERROR"
                        self.messageLabel.textColor = UIColor.redColor()
                    }
                }
        }
        else {
            messageLabel.text = "Wrong Entry"
            messageLabel.hidden = false
            messageLabel.textColor = UIColor.redColor()
        }
        
    }
    
    
    func regExIpAddressCheck(ipAddress: String) -> Bool {
        let validIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
        
        if ipAddress.rangeOfString(validIpAddressRegex, options: .RegularExpressionSearch) != nil {
            print("IP is valid")
            return true
        } else {
            print("IP is NOT valid")
            return false
        }
        
    }
    

    
    
}