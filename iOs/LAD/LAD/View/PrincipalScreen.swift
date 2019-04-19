//
//  File.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/2/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation

//
//  PrincipalScreen.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/1/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

class PrincipalScreen: UITableViewController {
    //MARK: Properties
    
    private let controller: MasterController = MasterController.shared
    private var number:Int = 0
    private var listOptions:Array<String> = ["Asistencia", "Historial de Asistencia"]
    
    var cellSpacingHeight: CGFloat = 0
    
    //MARK: Actions
    
    func asistencia(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let asistenciaScreen = storyboard.instantiateViewController(withIdentifier: "AsistenciaScreen") as! UITableViewController
        self.navigationController!.pushViewController(asistenciaScreen, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cellSpacingHeight = 5
        
        self.navigationItem.title = String(format: "Grupo %d",self.controller.getGrupo().getNumber())
        
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.myRightSideBarButtonItemTapped(_:)))
        rightBarButton.image = UIImage(named: "qr-icon")
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.tableView.flashScrollIndicators()
        self.tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.listOptions.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75 //or whatever you need
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionItem", for: indexPath)
        let image = UIImage.gradientImageWithBounds(bounds: cell.bounds)
        
        cell.backgroundView = UIImageView(image: image)
        cell.selectedBackgroundView = UIImageView(image: image)
        
        cell.textLabel?.text = self.listOptions[indexPath.section]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = .center
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        cell.clipsToBounds = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        print("Hey You tapped cell number \(indexPath.section).")
        switch listOptions[indexPath.section] {
        case "Asistencia":
                self.asistencia()
                break
        case "Historial de Asistencia":
            break
        default:
            break
        }
    }
    
    @objc func myLeftSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        print("myLeftSideBarButtonItemTapped")
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        if (!self.controller.getGrupo().validateSchedule()) {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let qrScreen: UIViewController = storyboard.instantiateViewController(withIdentifier: "qrScreen")
            self.navigationController!.pushViewController(qrScreen, animated: true)
        }else{
            let alert = UIAlertController(title: "Generador de Codigo", message: "Error: No se puede generar el codigo ya que se encuentra fuera del horario establecido.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
