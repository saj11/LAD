//
//  TableViewCell3.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/18/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import UIKit

protocol ButtonsDelegate{
    func stateTapped(_ tag: Int)
}

class TableViewCell3: UITableViewCell {

    enum State: String{
        case Presente = "P"
        case Tardia = "T"
        case Ausente = "A"
    }
    
    var actualState: State = .Ausente
    var delegate: ButtonsDelegate!
    var buttonAvailable: Bool = true
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var state: UIButton!
    
    override func awakeFromNib() {
        actualState = .Ausente
        
        state.layer.masksToBounds = false
        state.layer.cornerRadius = state.frame.width / 2
        state.layer.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        state.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        delegate?.stateTapped(sender.tag)
        next()
    }
    
    func makeButtonAvailable(){
        state.isEnabled = buttonAvailable
    }
    
    func setState(stateInput: String){
        switch stateInput {
        case State.Presente.rawValue:
            actualState = .Presente
            state.backgroundColor = #colorLiteral(red: 0, green: 0.9769522548, blue: 0.1877456605, alpha: 1)
            state.borderColor = #colorLiteral(red: 0, green: 0.9769522548, blue: 0.1877456605, alpha: 1)
            break
        case State.Tardia.rawValue:
            actualState = .Tardia
            state.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            state.borderColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            break
        case State.Ausente.rawValue:
            actualState = .Ausente
            state.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            state.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            break
        default:
            actualState = .Ausente
            state.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            state.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
    }
    
    func next(){
        switch actualState {
        case .Presente:
            actualState = .Tardia
            state.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            state.borderColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            break
        case .Tardia:
            actualState = .Ausente
            state.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            state.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            
            break
        case .Ausente:
            actualState = .Presente
            state.backgroundColor = #colorLiteral(red: 0, green: 0.9769522548, blue: 0.1877456605, alpha: 1)
            state.borderColor = #colorLiteral(red: 0, green: 0.9769522548, blue: 0.1877456605, alpha: 1)
            break
        }
    }
    
}
