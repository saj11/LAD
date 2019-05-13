//
//  TimeSlide.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 5/1/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import UIKit
import SRCountdownTimer

class TimeSlide: UIView {

    //MARK: Properties - Outlets
    @IBOutlet weak var timerProgressView: SRCountdownTimer!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    //MARK: Properties
    private var controller: MasterController = MasterController.shared
    
    //MARK: Functions - Outlets
    @IBAction func play(_ sender: Any) {
        controller.crearListaAsistencia(fecha: String(format: "%@-%@-%@", getDay(), startTimeLabel.text!, endTimeLabel.text!))
        
        timerProgressView.isLabelHidden = false
        timerProgressView.start(beginingValue: controller.getProfesor().tiempoTardiaCodigo*60, interval: 1)
        playButton.isHidden = true
    }
    
    //MARK: Functios
    func clear(){
        timerProgressView.pause()
        timerProgressView.isLabelHidden = true
        playButton.isHidden = false
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
        
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
        
        return WeekDay[day]!
    }
    
}
