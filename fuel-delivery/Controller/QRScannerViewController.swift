//
//  QRScannerViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 07/12/2020.
//

import UIKit
import AVFoundation
import SCLAlertView
import Firebase
import Cosmos

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var order: Order!
    
    private var userListener: ListenerRegistration!
    private var overallRating: Double!
    private var totalRating: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getAcceptorDetails(order: self.order)
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
            
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
            } else {
                failed()
                return
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
            captureSession.startRunning()
    }
    
    func getAcceptorDetails(order: Order) {
        let userId = order.acceptedBy!
            userListener = Firestore.firestore().collection(USERS_REF).document(userId).addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                } else {
                    let user = User.parseData(snapshot: snapshot)
                    self.overallRating = user.overallRating
                    self.totalRating = user.totalRating
                }
            })
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            if (captureSession?.isRunning == true) {
                captureSession.stopRunning()
            }
        }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            captureSession.stopRunning()

            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(code: stringValue)
            }

            dismiss(animated: true)
        }

    func found(code: String) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true
        )

        let alert = SCLAlertView(appearance: appearance)
        let subview = UIView(frame: CGRect(x: 0,y: 0,width: 216,height: 70))

        let cosmosView = CosmosView()
        cosmosView.settings.updateOnTouch = true
        cosmosView.settings.fillMode = .full
        cosmosView.settings.starSize = 40

        subview.addSubview(cosmosView)
        
        alert.customSubview = subview
        
        let alertView = SCLAlertView()
        if code == self.order.documentId && self.order.status != DELIVERED {
            alert.addButton("Confirm") {
                self.markOrderAsDelivered()
                self.rateUser(cosmosView: cosmosView)
            }
            alert.showSuccess("Mark order as delivered?", subTitle: "Rate delivery")
        } else {
            alertView.showError("Error", subTitle: "Invalid order", closeButtonTitle: "Okay")
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func markOrderAsDelivered() {
        Firestore.firestore().collection(ORDERS_REF).document(order.documentId)
            .updateData([
                STATUS: DELIVERED])
            { (error) in
                if let error = error {
                    debugPrint("Unable to update data: \(error.localizedDescription)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
    }
    
    func rateUser(cosmosView: CosmosView) {
        
        let total = (self.overallRating * self.totalRating) + cosmosView.rating
        let up = totalRating + 1
        let newRating = total / up

        Firestore.firestore().collection(USERS_REF).document(self.order.acceptedBy)
            .updateData([
                OVERALL_RATING: newRating,
                TOTAL_RATING: totalRating + cosmosView.rating
            ])
            { (error) in
                if let error = error {
                    debugPrint("Unable to update data: \(error.localizedDescription)")
                } else {
                    print("success")
                }
            }
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
