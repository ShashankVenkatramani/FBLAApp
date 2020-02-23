//
//  ScanClassViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/21/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseFirestore

class ScanClassViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    var nameData:String?
    var emailData:String?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            print("QR Code not found")
        } else {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if metadataObject.type == AVMetadataObject.ObjectType.qr {
                let db = Firestore.firestore()
                let chapterPath = db.collection("chapters").document(metadataObject.stringValue!)
                chapterPath.getDocument(completion: {(document, error) in
                    if let document = document {
                        if document.exists {
                            print("joining chapter \(metadataObject.stringValue!)")
                            self.captureSession?.stopRunning()
                            self.joinWithCode(code: metadataObject.stringValue!)
                        } else {
                            print("Chapter does not exist")
                        }
                    }
                })
            }
        }
    }
    
    func joinWithCode(code:String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "RegisterUserViewController") as! RegisterUserViewController
        viewController.nameData = nameData
        viewController.emailData = emailData
        viewController.centerID = code
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Could not access camera")
            return
        }
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(captureDeviceInput)
        } catch {
            print(error)
            return
        }
        
        let captureMetaDataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetaDataOutput)
        
        captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetaDataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height)
        view.layer.addSublayer(videoPreviewLayer!)
        videoPreviewLayer?.zPosition = 0
        captureSession?.startRunning()
    }
}
