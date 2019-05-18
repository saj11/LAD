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

class PrincipalScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    private let controller: MasterController = MasterController.shared
    @IBOutlet weak var tableView: UITableView!
    
    private var number:Int = 0
    private var listOptions = ["Lista de Asistencia", "Historial Lista de Asistencia", "Estadisticas"]
    private var cellSpacingHeight: CGFloat = 0
    
    //MARK: Actions
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(title: "Materias", image: UIImage(named: "list-icon"), tag: 2)
        
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Opciones"
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0.9769522548, blue: 0.1877456605, alpha: 1)
        
        self.cellSpacingHeight = 0
        cellSpacingHeight = 10
        
        self.tableView.separatorStyle = .none
        self.tableView.flashScrollIndicators()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionItem", for: indexPath)

        let image = UIImage.gradientImageWithBounds(bounds: cell.bounds)
        
        cell.viewWithTag(2)?.backgroundColor = .clear
        cell.viewWithTag(3)?.backgroundColor = .clear
        cell.backgroundView = UIImageView(image: image)
        
        cell.textLabel!.text = listOptions[indexPath.section]
        cell.textLabel!.lineBreakMode = .byWordWrapping
        cell.textLabel!.backgroundColor = .clear
        cell.textLabel!.textColor = .white
        
        cell.selectedBackgroundView = UIImageView(image: image)
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        switch indexPath.section {
        case 0:
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let asistenciaScreen: UIViewController = storyboard.instantiateViewController(withIdentifier: "AsistenciaScreen")
            self.navigationController!.pushViewController(asistenciaScreen, animated: true)
            break
        case 1:
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let historialAsistenciaScreen: UIViewController = storyboard.instantiateViewController(withIdentifier: "HistorialAssistanceScreen")
            self.navigationController!.pushViewController(historialAsistenciaScreen, animated: true)
            break
        case 2:
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let stadisticScreen: UIViewController = storyboard.instantiateViewController(withIdentifier: "StadisticScreen")
            self.navigationController!.pushViewController(stadisticScreen, animated: true)
        default:
            break
        }
        
    }
}

