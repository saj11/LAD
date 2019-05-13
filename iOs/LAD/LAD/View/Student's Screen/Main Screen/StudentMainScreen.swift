//
//  StudentMainScreen.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/15/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import AVFoundation
import UIKit

class StudentMainScreen: UIViewController{
    //MARK: Properties
    @IBOutlet weak var camaraView: UIView!
    
    private let controller: MasterController = MasterController.shared
    private var captureSession: AVCaptureSession!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var supportedCodeTypes:[AVMetadataObject.ObjectType]!
    
    //MARK: Actions
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Scan QR", image: UIImage(named: "scanqr-icon"), tag: 2)
        
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        //self.tabBarItem.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        
        camaraView = UIView()
        
        supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                              AVMetadataObject.ObjectType.code39,
                              AVMetadataObject.ObjectType.code39Mod43,
                              AVMetadataObject.ObjectType.code93,
                              AVMetadataObject.ObjectType.code128,
                              AVMetadataObject.ObjectType.ean8,
                              AVMetadataObject.ObjectType.ean13,
                              AVMetadataObject.ObjectType.aztec,
                              AVMetadataObject.ObjectType.pdf417,
                              AVMetadataObject.ObjectType.itf14,
                              AVMetadataObject.ObjectType.dataMatrix,
                              AVMetadataObject.ObjectType.interleaved2of5,
                              AVMetadataObject.ObjectType.qr]
        
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self as AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        //view.bringSubview(toFront: messageLabel)
        //view.bringSubview(toFront: topbar)
        
        // Initialize QR Code Frame to highlight the QR code
        
        if camaraView != nil{
            camaraView.layer.borderColor = UIColor.green.cgColor
            camaraView.layer.borderWidth = 2
            //view.addSubview(camaraView)
            //view.bringSubview(toFront: camaraView)
        }
    }
    
    // MARK: - Helper methods
    
    func launchApp(confirmationMessage: String) {
        //HoraInicio, HoraFinal, NombreProfesor, ApellidoProfesor, Curso, Grupo, Horario(Dia de la semana<Inicial>), Horario(Dia de la semana<Inicial>)
        if presentedViewController != nil {
            return
        }
        
        let regEx1 = "[0-9]+:[0-9]+,[0-9]+:[0-9]+,[a-zA-Z]+,[a-zA-Z]+,[a-zA-Z]+,[0-9]+,[A-Z]{1},[A-Z]{1}"
        let regEx2 = "[0-9]+:[0-9]+,[0-9]+:[0-9]+,[a-zA-Z]+,[a-zA-Z]+,[a-zA-Z]+,[0-9]+,[A-Z]{1}"
        
        let pred1 = NSPredicate(format:"SELF MATCHES %@", regEx1)
        let pred2 = NSPredicate(format:"SELF MATCHES %@", regEx2)
        
        if pred1.evaluate(with: confirmationMessage) || pred2.evaluate(with: confirmationMessage){
            var message = confirmationMessage.split(separator: ",")
        
            let alertPrompt = UIAlertController(title: "LAD - Estudiante", message: "Confirmar Asistencia en el Curso: \(message[4]) Grupo: \(message[5]) del Profesor: \(message[2]) \(message[3])", preferredStyle: .alert)
        
            let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
                
                let mensaje: String
                
                if self.controller.confirmPresence(data: message){
                    mensaje = "Su Asistencia se Registro Satisfactoriamente. Puede dirigirse inmediatamente a la zona de Asistencia."
                }else{
                    mensaje = "Su Asistencia NO se Registro Satisfactoriamente."
                }
                
                let alert = UIAlertController(title: "Lista de Asistencia Digital", message: mensaje, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
            })
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
            alertPrompt.addAction(confirmAction)
            alertPrompt.addAction(cancelAction)
        
            present(alertPrompt, animated: true, completion: nil)
        }
    }
}

extension StudentMainScreen: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            camaraView?.frame = CGRect.zero
            //messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            camaraView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                launchApp(confirmationMessage: metadataObj.stringValue!)
                //messageLabel.text = metadataObj.stringValue
            }
        }
    }
    
}
