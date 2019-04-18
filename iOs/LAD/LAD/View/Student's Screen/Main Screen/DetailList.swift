//
//  DetailList.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/16/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

class DetailList: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: Properties
    private let controller: MasterController = MasterController.shared
    //UI Properties
    @IBOutlet weak var numeroPresente: UILabel!
    @IBOutlet weak var numeroAusente: UILabel!
    @IBOutlet weak var numeroTardia: UILabel!
    @IBOutlet weak var ladTable: UITableView!
    
    var cellSpacingHeight: CGFloat = 0
    private var number: Int = 0
    private var ladDia1: Array<String> = Array<String>()
    private var ladDia2: Array<String> = Array<String>()
    
    //MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Lista de Asistencia"
        
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.02945959382, green: 0.5178381801, blue: 0.9889006019, alpha: 1)
        (number, ladDia1, ladDia2) = self.controller.getAttendanceList()
        
        self.numeroPresente.text = String(hasElement(element: "P", list: ladDia1) + hasElement(element: "P", list: ladDia2))
        self.numeroAusente.text = String(hasElement(element: "A", list: ladDia1) + hasElement(element: "A", list: ladDia2))
        self.numeroTardia.text = String(hasElement(element: "T", list: ladDia1) + hasElement(element: "T", list: ladDia2))
        
        self.numeroPresente.textColor = #colorLiteral(red: 0, green: 0.9769522548, blue: 0.1877456605, alpha: 1)
        self.numeroAusente.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        self.numeroTardia.textColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    }
    
    func hasElement(element: String, list:Array<String>)-> Int{
        var count: Int = 0
        for item in list{
            if item.elementsEqual(element){ count+=1 }
        }
        return count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return max(ladDia1.count, ladDia2.count)
        //return self.listConfig.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CustomTableViewCell2", owner: self, options: nil)?.first as! CustomTableViewCell2
        
        print("%%%%%%%%%%%%")
        print(ladDia1)
        print(ladDia2)
        cell.title.text = String("Semana \(indexPath.section)")
        if !ladDia1.isEmpty{
            switch ladDia1[indexPath.section]{
            case "P":
                cell.dia1View.backgroundColor = #colorLiteral(red: 0, green: 0.9769522548, blue: 0.1877456605, alpha: 1)
                break
            case "A":
                cell.dia1View.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                break
            case "T":
                cell.dia1View.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                break
            default:
                cell.dia1View.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }else{
            cell.dia1View.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        
        if !ladDia2.isEmpty{
            switch ladDia2[indexPath.section]{
            case "P":
                cell.dia2View.backgroundColor = #colorLiteral(red: 0, green: 0.9769522548, blue: 0.1877456605, alpha: 1)
                break
            case "A":
                cell.dia2View.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                break
            case "T":
                cell.dia2View.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                break
            default:
                cell.dia2View.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                break
            }
        }else{
            cell.dia2View.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        
        return cell
    }
}
