//
//  CursoScreen.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/1/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit
import Floaty

class CursoScreen: UITableViewController, FloatyDelegate {
    //MARK: Properties
    private let controller: MasterController = MasterController.shared
    private var number:Int = 0
    private var listCourses:Array<Curso> = Array<Curso>()
    private let floaty = Floaty()
    
    var cellSpacingHeight: CGFloat = 0
    
    //MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Cursos"
        
        self.cellSpacingHeight = 5
        
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.myRightSideBarButtonItemTapped(_:)))
        rightBarButton.image = UIImage(named: "user-icon")
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.tableView.separatorStyle = .none
        self.tableView.flashScrollIndicators()
        
        floaty.buttonColor = UIColor.green
        floaty.sticky = true
        self.tableView!.addSubview(floaty)
        
        (self.number, self.listCourses) = self.controller.numberOfCourse()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("1. N\(number)")
        return self.number
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("2")
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("3")
        return 75
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("4")
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        print("5")
        return cellSpacingHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("6")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseItem", for: indexPath)
        let curso: Curso = self.listCourses[indexPath.section]
        cell.textLabel?.text = curso.nombre
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = .center
        
        cell.backgroundColor = UIColor.gray
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        cell.clipsToBounds = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("7")
        if !self.listCourses[indexPath.section].codigo.isEmpty{
            self.controller.setCurso(curso: self.listCourses[indexPath.section])
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let grupoScreen = storyboard.instantiateViewController(withIdentifier: "GroupScreen") as! UITableViewController
            self.navigationController!.pushViewController(grupoScreen, animated: true)
        }
    }
    
    @objc func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        print("8")
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let perfilScreen: UIViewController = storyboard.instantiateViewController(withIdentifier: "PerfilScreen")
        self.navigationController!.pushViewController(perfilScreen, animated: true)
    }
}
