//
//  StadisticView.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 5/12/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import UIKit

class StadisticView: UIView {

    //MARK: IBOutlet Properties
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    //MARK: Properties
    private var controller: MasterController = MasterController.shared
    enum subTitle:String {
        case Total = "Total"
        case Porcentaje = "Promedio"
        case PorMes = "Promedio Por Mes"

    }
    
    typealias stateValue = (name: String, initial: String)
    enum state {
        static let Presente = stateValue("Presente", "P")
        static let Ausente = stateValue("Ausente", "A")
        static let Tardia = stateValue("Tardia", "T")
    }
    
    //MARK: Function
    override func awakeFromNib() {
        let image = UIImage.gradientImageWithBounds(bounds: view.bounds)
        view.backgroundColor = UIColor(patternImage: image)
        
        //Gestures
        let tap = UITapGestureRecognizer(target : self, action : #selector(handleTap(sender:)))
        numberLabel.addGestureRecognizer(tap)
    }
    
    func setInfo(typeNumber: Int){
        var type: String, state: String
        
        switch typeNumber {
        case 1:
            type = StadisticView.subTitle.Total.rawValue
            state = StadisticView.state.Presente.initial
            view.backgroundColor = UIColor.green
            break
        case 2:
            type = StadisticView.subTitle.Total.rawValue
            state = StadisticView.state.Ausente.initial
            view.backgroundColor = UIColor.red
            break
        case 3:
            type = StadisticView.subTitle.Total.rawValue
            state = StadisticView.state.Tardia.initial
            view.backgroundColor = UIColor.orange
            break
        default:
            type = ""
            state = ""
            break
        }
        
        let result: Double = controller.getStadistics(type: type, state: state)
        
        numberLabel.text = result.isDouble() ? String(result) : String(Int(result))
        subTitleLabel.text = type
        
    }
    
    //MARK:IBOutlet - Function
    @IBAction func setState(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        setInfo(typeNumber: button.tag)
    }
    
    //MARK: Gestures
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        print("Tap")
    }
}
