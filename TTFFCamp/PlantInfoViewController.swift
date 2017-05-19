//
//  PlantInfoViewController.swift
//  TTFFCamp
//
//  Created by yanze on 3/9/16.
//  Copyright © 2016 The Taylor Family Foundation. All rights reserved.
//

import UIKit
import AVFoundation


class PlantInfoViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var plantNameButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var originButton: UIButton!
    @IBOutlet weak var descriptionButton: UIButton!
    @IBOutlet weak var whenToPlantButton: UIButton!
    @IBOutlet weak var coolFactButton: UIButton!

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var originTextLabel: UILabel!
    @IBOutlet weak var locationTextLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var whenToPlantTextLabel: UILabel!
    @IBOutlet weak var coolFactsTextView: UITextView!
    
    
    //MARK: NSSpeech
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    var singlePlant = Plant()
    var allPlants: [Plant] = []
    
    var detectedText: String?
    
    
    
    override func viewDidLoad() {
        print("PlantInfoViewController loaded")
        super.viewDidLoad()
        print("got past super view did load")
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        print("got past addGesture")
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        print("got past navigationitem")
        customButtons()
        print("got past custombuttons")
        // get all plants from local storage
        allPlants = Database.all()
        print("got past allPlants")
        if let unwrappedGetPlantByName = detectedText {
            print("inside unwrappedGetPlantByName")
            getPlantByName(unwrappedGetPlantByName)
            initializeScrollView()
        }
        print("got past if let")
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.navigationItem.setHidesBackButton(editing, animated: animated)
    }
    
    
    func initializeScrollView(){
        for i in 0 ..< singlePlant.images.count {
            let label = UILabel(frame: CGRect(x: 120 + (i*500), y: 280, width: 250, height: 40))
            label.text = singlePlant.captions[i]
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.font = UIFont(name: "Verdana", size: 20)
            label.layer.backgroundColor = UIColor.black.cgColor
            label.layer.cornerRadius = 8
            label.layer.borderWidth = 2
            label.layer.borderColor = UIColor.lightGray.cgColor
            
            // Decode Base64 string into NSData
            let imageData = Data(base64Encoded: singlePlant.images[i], options: NSData.Base64DecodingOptions(rawValue: 0))
            
            // Set image variable to UIImage from raw data
            let imageView = UIImageView(frame: CGRect(x: (i*500), y: 0, width: 500, height: 400))
            imageView.image = UIImage(data: imageData!)
            
            scrollView.addSubview(imageView)
            scrollView.addSubview(label)
    
        }
        let scrollViewWidth = CGFloat(singlePlant.images.count * 500)
        scrollView.contentSize = CGSize(width: scrollViewWidth, height: scrollView.frame.size.height);
        scrollView.layer.borderWidth = 3
        scrollView.layer.cornerRadius = 8
        scrollView.layer.borderColor = UIColor.green.cgColor
        
    }
    
    
    func getPlantByName(_ plantName: String){
        // loop through all plants in the local database to find the specific plant scanned or chosen from the list
        for i in 0 ..< allPlants.count {
            if allPlants[i].plantName == plantName {
                singlePlant = allPlants[i]
            }
        }
        
        // Set UILabel properties of a single plant from database
        plantNameButton.setTitle(singlePlant.plantName, for: UIControlState())
        originTextLabel.text = singlePlant.origin
        originTextLabel.numberOfLines = 0
        locationTextLabel.text = singlePlant.location
        locationTextLabel.numberOfLines = 0
        descriptionTextView.text = singlePlant.plantDescription
        whenToPlantTextLabel.text = singlePlant.whenToPlant
        whenToPlantTextLabel.numberOfLines = 0
        coolFactsTextView.text = singlePlant.coolFact
        descriptionTextView.isEditable = false;
        coolFactsTextView.isEditable = false;
    }
    
    // Function for text-to-speech
    @IBAction func textToSpeech(_ sender: UIButton) {
        if !synth.isSpeaking{
            if sender.tag == 0 {
                myUtterance = AVSpeechUtterance(string: plantNameButton.titleLabel!.text!)
            }
            if sender.tag == 1 {
                myUtterance = AVSpeechUtterance(string: "Origin: \(singlePlant.origin)")
            }
            if sender.tag == 2 {
                myUtterance = AVSpeechUtterance(string: "Location: \(singlePlant.location)")
            }
            if sender.tag == 3 {
                myUtterance = AVSpeechUtterance(string: "Description: \(singlePlant.plantDescription)")
            }
            if sender.tag == 4 {
                myUtterance = AVSpeechUtterance(string: "When To Plant: \(singlePlant.whenToPlant)")
            }
            if sender.tag == 5 {
                myUtterance = AVSpeechUtterance(string: "Cool Fact: \(singlePlant.coolFact)")
            }
            
            myUtterance.rate = 0.5
            synth.speak(myUtterance)
        }
        else{
            synth.continueSpeaking()
        }
    }
    
    // Formatting of the buttons used for text-to-speech
    func customButtons() {
        plantNameButton.titleLabel?.textColor = UIColor.green
        plantNameButton.titleLabel?.font = UIFont(name: "Chalkduster", size: 40)
        plantNameButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        plantNameButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        originButton.contentEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        originButton.backgroundColor = UIColor.lightGray
        originButton.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 20)
        originButton.layer.cornerRadius = 8
        originButton.layer.borderWidth = 2
        originButton.layer.borderColor = UIColor.black.cgColor
        
        locationButton.contentEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        locationButton.backgroundColor = UIColor.lightGray
        locationButton.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 20)
        locationButton.layer.cornerRadius = 8
        locationButton.layer.borderWidth = 2
        locationButton.layer.borderColor = UIColor.black.cgColor
        
        descriptionButton.contentEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        descriptionButton.backgroundColor = UIColor.lightGray
        descriptionButton.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 20)
        descriptionButton.layer.cornerRadius = 8
        descriptionButton.layer.borderWidth = 2
        descriptionButton.layer.borderColor = UIColor.black.cgColor
        
        whenToPlantButton.contentEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        whenToPlantButton.backgroundColor = UIColor.lightGray
        whenToPlantButton.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 20)
        whenToPlantButton.layer.cornerRadius = 8
        whenToPlantButton.layer.borderWidth = 2
        whenToPlantButton.layer.borderColor = UIColor.black.cgColor
        
        coolFactButton.contentEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        coolFactButton.backgroundColor = UIColor.lightGray
        coolFactButton.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 20)
        coolFactButton.layer.cornerRadius = 8
        coolFactButton.layer.borderWidth = 2
        coolFactButton.layer.borderColor = UIColor.black.cgColor
        
    }
    
    
    
}
