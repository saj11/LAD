//
//  DetailList.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/16/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

class DetailList: UIViewController{
    
    //MARK: Properties
    private let controller: MasterController = MasterController.shared
    //UI Properties
    @IBOutlet weak var numeroPresente: UILabel!
    @IBOutlet weak var numeroAusente: UILabel!
    @IBOutlet weak var numeroTardia: UILabel!
    
    private var listViewController: AttendanceList?
    
    //MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        
        listViewController = self.children[0] as? AttendanceList
        listViewController?.delegate = self
    }
    
    private func setNavBar(){
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: 375, height: 100))
        navBar.barTintColor = UIColor.white
        navBar.prefersLargeTitles = true
        view.addSubview(navBar)
        
        let navItem = UINavigationItem(title: "Lista de Asistencia")
        
        let doneItem = UIBarButtonItem(title: "< Atras", style: UIBarButtonItem.Style.done, target: nil, action: #selector(done))
        navItem.leftBarButtonItem = doneItem
        navItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.02945959382, green: 0.5178381801, blue: 0.9889006019, alpha: 1)
        
        navBar.setItems([navItem], animated: false)
    }
    
    @objc func done() { // remove @objc for Swift 3
        
    }
}

extension DetailList: AttendanceListDelegate {
    func showMoreInfo() {
        print("Hola")
    }
}
