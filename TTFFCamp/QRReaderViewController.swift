//
//  QRReaderViewController.swift
//  TTFFCamp
//
//  Created by yanze on 3/9/16.
//  Copyright © 2016 The Taylor Family Foundation. All rights reserved.
//

import UIKit
import AVFoundation

class QRReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, BackButtonDelegate {
    
    
    @IBOutlet weak var welcomeBannerLabel: UILabel!
    var objCaptureSession: AVCaptureSession?
    var objCaptureVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    var vwQRCode: UIView?
    var detectedText = ""
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        print("WE UNWOUND!!!!~~~~~~~~~~~")
        self.configureVideoCapture()
        print("after configurevideocapture")
        self.addVideoPreviewLayer()
        print("after addvideopreviewlayer")
        self.initializeQRView()
        print("after initializeQRView")
    }
    
    @IBOutlet weak var planListButton: UIButton!
    
    
    override func viewDidLoad() {
        print("QRReaderViewController loaded")
        print("DID THIS AGAIN!!!!")
        super.viewDidLoad()
        print("after view did load")
        self.configureVideoCapture()
        print("after configurevideocapture")
        self.addVideoPreviewLayer()
        print("after addvideopreviewlayer")
        self.initializeQRView()
        print("after initializeQRView")
        self.navigationItem.setHidesBackButton(true, animated: false)
        print("after sethidesbackbutton")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        print("after addgesturerecognizer")
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        print("after if")
    }
    
    func backButtonPressed(controller: UITableViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.navigationItem.setHidesBackButton(editing, animated: animated)
    }
    
    
    func configureVideoCapture() {
        
        let objCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        print("set objCaptureDevice to some stuff",objCaptureDevice as Any)
        var error: NSError?
        
        let objCaptureDeviceInput: AnyObject!
        
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice) as AVCaptureDeviceInput
        } catch let error1 as NSError {
            print("there was an error trying to set objCaptureDevice as AVCaptureDeviceInput")
            error = error1
            objCaptureDeviceInput = nil
        }
        
        if (error != nil) {
            let alertController:UIAlertController = UIAlertController(title: "Device Error", message: "Device not Supported for this Application", preferredStyle: .alert)
            
            let cancelAction:UIAlertAction = UIAlertAction(title: "Ok Done", style: .cancel, handler: { (alertAction) -> Void in
                alertController.dismiss(animated: true, completion: nil)
            })
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        
        objCaptureSession = AVCaptureSession()
//        print("objectcapturedevice is :",objCaptureDevice)
        
        objCaptureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)

        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        objCaptureSession?.addOutput(objCaptureMetadataOutput)
        
        
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    
    func addVideoPreviewLayer() {
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession)
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        objCaptureVideoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(objCaptureVideoPreviewLayer!)
        objCaptureSession?.startRunning()
        customBanner()
        customPlantListButton()
        self.view.bringSubview(toFront: welcomeBannerLabel)
        self.view.bringSubview(toFront: planListButton)

    }
    
    func initializeQRView() {
        vwQRCode = UIView()
        vwQRCode?.layer.borderColor = UIColor.green.cgColor
        vwQRCode?.layer.borderWidth = 5
        self.view.addSubview(vwQRCode!)
        self.view.bringSubview(toFront: vwQRCode!)
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            vwQRCode?.frame = CGRect.zero
            return
        }
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode {
            let objBarCode = objCaptureVideoPreviewLayer?.transformedMetadataObject(for: objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            vwQRCode?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                print("THIS STUFF IS HAPPENING KILLING CAMERA NOW!")
                detectedText = objMetadataMachineReadableCodeObject.stringValue
                objCaptureSession?.stopRunning()
                self.performSegue(withIdentifier: "showInfo", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "plantList"){
            print("test, this is the segue to the plant list`````````````")
            let nav = segue.destination as! UINavigationController
            let controller = nav.topViewController as! PlantListTableViewController
            controller.backDelegate = self
        }
        
        if(segue.identifier! == "showInfo"){
            let plantInfoVC = segue.destination as! PlantInfoViewController
            plantInfoVC.detectedText = detectedText
        }
    }
    
    func customBanner() {
        welcomeBannerLabel.layer.backgroundColor = UIColor.green.cgColor
        welcomeBannerLabel.textColor = UIColor.white
        welcomeBannerLabel.layer.cornerRadius = 10
        welcomeBannerLabel.font = UIFont(name: "Chalkduster", size: 45)
        welcomeBannerLabel.layer.borderWidth = 2
        welcomeBannerLabel.layer.borderColor = UIColor.white.cgColor
    }
    
    
    @IBAction func clickToPlantList(_ sender: UIButton) {
        objCaptureSession?.stopRunning()
    }
    
    func customPlantListButton(){
        planListButton.layer.backgroundColor = UIColor.green.cgColor
        planListButton.setTitleColor(UIColor.white, for: UIControlState())
        planListButton.layer.cornerRadius = 10
        planListButton.titleLabel!.font =  UIFont(name: "Chalkduster", size: 36)
        planListButton.layer.borderWidth = 2
        planListButton.layer.borderColor = UIColor.white.cgColor
    }

    

    
}

