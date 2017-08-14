//
//  AtivarFilhoViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 12/05/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit
import AVFoundation

class AtivarFilhoViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate{
    @IBOutlet weak var QRReaderView: UIView!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.backgroundColor();
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationItem.title = "Ativar Filho"
        self.navigationItem.backBarButtonItem?.title = ""
        
        QRReaderView.backgroundColor = AppColors.backgroundColor()
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        
        captureSession = AVCaptureSession()
        
        var input: AnyObject?
        
        do{
            input = try AVCaptureDeviceInput.init(device: captureDevice) as AVCaptureDeviceInput
        }catch let error as NSError { print(error) }
        
        
        
        // Set delegate and use the default dispatch queue to execute the call back

        
        // Initialize the captureSession object.
        
        // Set the input device on the capture session.
        
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        // Do any additional setup after loading the view.
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = QRReaderView.layer.bounds
        QRReaderView.layer.addSublayer(videoPreviewLayer!)
        
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        QRReaderView.addSubview(qrCodeFrameView!)
        QRReaderView.bringSubview(toFront: qrCodeFrameView!)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       captureSession?.startRunning()
    }
    func getQRValues(_ valor:String){
        let values = valor.components(separatedBy: ";")
        UserDefaultsProvider.setDispID(values[0])
        UserDefaultsProvider.setGerenteID(values[1])
        FirebaseDatabaseProvider.sharedInstance.linkLido(UserDefaultsProvider.getDispID()!, UserDefaultsProvider.getGerenteID()!)
    }
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        getQRValues(metadataObj.stringValue)
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds
            
            if metadataObj.stringValue != nil {
                print(metadataObj.stringValue)
            }
        }
        leituraQRCodeFinalizada(true)
    }
    
    func leituraQRCodeFinalizada(_ success: Bool){
        if success{
            captureSession?.stopRunning()
           
            LoginCoordinatior.pushNavegadorViewController(navigationController: self.navigationController)
            //StartCoordinatior.pushAtivarMDMViewController(navigationController: self.navigationController)
        }else{
            
        }
        
    }

    @IBAction func testeButton(_ sender: Any) {
                    StartCoordinatior.pushAtivarMDMViewController(navigationController: self.navigationController)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
