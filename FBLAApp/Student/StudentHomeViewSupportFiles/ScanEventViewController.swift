//
//  ScanEventViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/27/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseFirestore

class ScanEventViewController: UIDGuardedViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    var nameData:String?
    var emailData:String?
    var count = 0
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            print("QR Code not found")
        } else {
            self.captureSession?.stopRunning()
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if metadataObject.type == AVMetadataObject.ObjectType.qr {
                let eventCode = metadataObject.stringValue!
                let db = Firestore.firestore()
                db.collection("students").document(self.uid!).getDocument { (document, error) in
                    if let documentData = document?.data() {
                        let chapterUID = documentData["chapterUID"]
                        db.collection("chapters").document(chapterUID as! String).collection("events").document("events").getDocument { (chapterEventDocument, error) in
                            if let chapterEventData = chapterEventDocument!.data() {
                                if (chapterEventData[eventCode] != nil) {
                                    if let events = documentData["events"] as! NSMutableDictionary?{
                                        if events.value(forKey: eventCode) == nil {
                                            db.collection("chapters").document(chapterUID as! String).collection("students").document("student").setData([self.uid!:["events":[eventCode:"attended"]]], merge: true){err in
                                                if let err = err {
                                                    print("Error writing request document: \(err)")
                                                } else {
                                                    print("Document succesfully written")
                                                    self.executeSuccessfully()
                                                }
                                            }
                                            db.collection("chapters").document(chapterUID as! String).collection("events").document("events").setData([eventCode:["attendees":[self.uid:"attended"]]], merge: true){err in
                                                if let err = err {
                                                    print("Error writing document: \(err)")
                                                } else {
                                                    print("Document succesfully written")
                                                    self.executeSuccessfully()
                                                }
                                            }
                                            db.collection("students").document(self.uid!).setData(["events" : [eventCode : "attended"]], merge: true){err in
                                                if let err = err {
                                                    print("Error writing request document: \(err)")
                                                } else {
                                                    print("Document succesfully written")
                                                    self.executeSuccessfully()
                                                }
                                            }
                                        } else {
                                            let alert = UIAlertController(title: "You've already signed in!", message: "You have already signed in to this event.", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                                                let storyboard = UIStoryboard(name: "StudentViews", bundle: nil)
                                                let viewController = storyboard.instantiateViewController(identifier: "StudentHomeViewController") as! StudentHomeViewController
                                                viewController.uid = self.uid
                                                viewController.modalPresentationStyle = .fullScreen
                                                self.present(viewController, animated: true, completion: nil)
                                            }))
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                    } else {
                                        db.collection("chapters").document(chapterUID as! String).collection("students").document("student").setData([self.uid!:["events":[eventCode:"attended"]]], merge: true){err in
                                            if let err = err {
                                                print("Error writing request document: \(err)")
                                            } else {
                                                print("Document succesfully written")
                                                self.executeSuccessfully()
                                            }
                                        }
                                        db.collection("chapters").document(chapterUID as! String).collection("events").document("events").setData([eventCode:["attendees":[self.uid:"attended"]]], merge: true){err in
                                            if let err = err {
                                                print("Error writing document: \(err)")
                                            } else {
                                                print("Document succesfully written")
                                                self.executeSuccessfully()
                                            }
                                        }
                                        db.collection("students").document(self.uid!).setData(["events" : [eventCode : "attended"]], merge: true){err in
                                            if let err = err {
                                                print("Error writing request document: \(err)")
                                            } else {
                                                print("Document succesfully written")
                                                self.executeSuccessfully()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func executeSuccessfully() {
        count += 1
        if count == 3 {
            let storyboard = UIStoryboard(name: "StudentViews", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: "StudentHomeViewController") as! StudentHomeViewController
            viewController.uid = self.uid
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
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
