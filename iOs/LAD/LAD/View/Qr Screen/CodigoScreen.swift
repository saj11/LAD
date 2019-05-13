//
//  CodigoScreen.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/6/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

class CodigoScreen: UIViewController{
    //MARK:
    private let controller: MasterController = MasterController.shared
    
    //UI
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var horaInicioLabel: UILabel!
    @IBOutlet weak var horaFinalLabel: UILabel!
    @IBOutlet weak var profesorLabel: UILabel!
    @IBOutlet weak var cursoLabel: UILabel!
    @IBOutlet weak var grupoLabel: UILabel!
    @IBOutlet weak var horario1Label: UILabel!
    @IBOutlet weak var horario2Label: UILabel!
    
    //MARK: Actions
    
    @IBAction func exportar(_ sender: Any) {
        let image = self.controller.getGrupo().getCode()?.getUIImage().generatePNGRepresentation()
        
        let activityViewController = UIActivityViewController(activityItems: [ UIImage(data: image!)! ], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "QR Code"
        //let listaDia = [ "D", "L", "K", "M", "J", "V", "S"]
        var date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
        var hour:Int
        var minutes:Int
        
        if self.controller.getTimeAlive() == nil {
            hour = calendar.component(.hour, from: date)
            minutes = calendar.component(.minute, from: date)
            
            self.horaInicioLabel.text = String(format: "%d:%d", hour, minutes)
            self.horaFinalLabel.text = String(format: "%d:%d", hour, minutes+15)
            
            self.controller.setTimeAlive(hour: hour, minute: minutes)
        }else{
            
            (hour, minutes) = self.controller.getTimeAlive()!
            
            self.horaInicioLabel.text = String(format: "%d:%d", hour, minutes)
            self.horaFinalLabel.text = String(format: "%d:%d", hour, minutes+15)
        }
        
        self.profesorLabel.text = self.controller.getProfesor().nombre
        self.cursoLabel.text = self.controller.getCurso().nombre
        self.grupoLabel.text = String(self.controller.getGrupo().getNumber())
        
        date = self.controller.getGrupo().getSchedule(numberDay: day).horaInicio
        let hour1 = calendar.component(.hour, from: date)
        let minutes1 = calendar.component(.minute, from: date)
        
        if(minutes1 < 10){
            self.horario1Label.text = String(format: "%d:%@", hour1, "0\(minutes1)")
        }else{
            self.horario1Label.text = String(format: "%d:%d", hour1, minutes1)
        }
        
        date = self.controller.getGrupo().getSchedule(numberDay: day).horaFinal
        let hour2 = calendar.component(.hour, from: date)
        let minutes2 = calendar.component(.minute, from: date)
        
        if(minutes2 < 10){
            self.horario2Label.text = String(format: "%d:%@", hour2, "0\(minutes2)")
        }else{
            self.horario2Label.text = String(format: "%d:%d", hour2, minutes2)
        }
        
        let info = String(format: "%@,%@,%@,%@,%@,%@,%@", String(format: "%d:%d", hour, minutes), String(format: "%d:%d", hour, minutes+15), String("\(self.controller.getProfesor().nombre) \(self.controller.getProfesor().apellidos)"), self.controller.getCurso().nombre, String(self.controller.getGrupo().getNumber()), String("\(self.controller.getGrupo().getSchedule().dia1.diaSemana)"), String("\(self.controller.getGrupo().getSchedule().dia2.diaSemana)"))
        
        print("!!!!!!!!!")
        print(info)
        if((self.controller.getGrupo().getCode()?.getData().isEmpty)!){
            self.controller.crearCodigo(data: NativeEncryption.encrypt(message: info))
        }
        
        self.qrImage.layer.magnificationFilter = CALayerContentsFilter.nearest
        self.qrImage.image = self.controller.getGrupo().getCode()?.getUIImage()
        
        //self.controller.crearListaAsistencia(fecha: String(format: "%@-%d:%d", listaDia[day-1], hour, minutes))
    }
    
    func displayQRCodeImage()-> UIImage {
        let scaleX = self.qrImage.frame.size.width / (self.controller.getGrupo().getCode()?.getCIImage().extent.size.width)!
        let scaleY = self.qrImage.frame.size.height / (self.controller.getGrupo().getCode()?.getCIImage().extent.size.height)!
        
        print(scaleX, scaleY)
        let transformedImage = self.controller.getGrupo().getCode()?.getCIImage().transformed(by: CGAffineTransform(scaleX: 10 , y: 10))
        
        return UIImage(ciImage: transformedImage!)
        
    }
    
    
}
