//
//  CursoScreen.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/1/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

class GrupoScreen: UITableViewController {
    //MARK: Properties
    private let controller: MasterController = MasterController.shared
    private var number:Int = 0
    private var listGroups:Array<Grupo> = Array<Grupo>()
    
    var cellSpacingHeight: CGFloat = 0
    //@IBOutlet strong var tableView: UITableView!
    
    //MARK: Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cellSpacingHeight = 5
        //self.navigationItem.prompt = controller.getProfesor().nombre
        
        (self.number, self.listGroups) = self.controller.groupsOf()
        
        self.navigationItem.title = self.controller.getCurso().nombre
        
        
        let leftBarButton = UIBarButtonItem(title: "Cursos", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.myLeftSideBarButtonItemTapped(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
 
        
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.done, target: self, action: nil)
        rightBarButton.image = UIImage(named: "plus-icon")
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.tableView.flashScrollIndicators()
        self.tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.number
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupItem", for: indexPath)
        cell.textLabel?.text = String(format: "Grupo %d", indexPath.section+1)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = .center
        
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        
        cell.textLabel?.backgroundColor = .clear
        cell.detailTextLabel?.backgroundColor = .clear
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        cell.clipsToBounds = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.controller.setGrupo(grupo: self.listGroups[indexPath.section])
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let principalScreen = storyboard.instantiateViewController(withIdentifier: "PrincipalScreen") as! UITableViewController
        self.navigationController!.pushViewController(principalScreen, animated: true)
    }
    
    @objc func myLeftSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        self.navigationController!.popViewController(animated: true)
    }
}
