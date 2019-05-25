//
//  TimeSlide.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 5/1/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import UIKit
import SRCountdownTimer

class TimeSlide: UIView, SRCountdownTimerDelegate {

    //MARK: Properties - Outlets
    @IBOutlet var timerProgressView: SRCountdownTimer!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    //MARK: Properties
    private var controller: MasterController = MasterController.shared
    private var hasStarted:Bool = false
    
    //MARK: Functions - Outlets
    @IBAction func play(_ sender: Any) {
        hasStarted = true
        
        if !controller.crearListaAsistencia(fecha: String(format: "%@-%@-%@", getDay(), startTimeLabel.text!, endTimeLabel.text!)){
            let alert = UIAlertController(title: "Cronometro", message: "Error: No se puede crear la Lista de Asistencia.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(alert, animated: true, completion: nil)

        }else{
            timerProgressView.isLabelHidden = false
            timerProgressView.start(beginingValue: controller.getProfesor().tiempoTardiaCodigo*60, interval: 1)
            playButton.isHidden = true
        }
    }
    
    //MARK: Functios
    override func awakeFromNib() {
        timerProgressView.useMinutesAndSecondsRepresentation = true
        timerProgressView.labelTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        timerProgressView.labelFont = UIFont(name: "HelveticaNeue-Bold", size: 40)
        timerProgressView.lineWidth = 7
        
        timerProgressView.delegate = self
    }
    
    func timerDidEnd() {
        print("Aqui")
        hasStarted = false
        playButton.isHidden = false
        timerProgressView.isLabelHidden = true
    }
    
    func getHasStarted() -> Bool {
        return hasStarted
    }
    
    func clear(){
        if hasStarted{
            timerProgressView.pause()
            playButton.isHidden = false
        }
    }
    
    func getDay()-> String{
        var WeekDay:Dictionary = [
            1 : "D",
            2 : "L",
            3 : "K",
            4 : "M",
            5 : "J",
            6 : "V",
            7 : "S"
        ]
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: Date())
        
        return WeekDay[day]!
    }
    
}
