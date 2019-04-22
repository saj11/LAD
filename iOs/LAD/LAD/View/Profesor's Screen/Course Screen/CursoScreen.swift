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
        
        (number, listCourses) = self.controller.numberOfCourse()
        
        print(number, listCourses)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return number
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseItem", for: indexPath)
        let curso: Curso = self.listCourses[indexPath.section]
        let image = UIImage.gradientImageWithBounds(bounds: cell.bounds)
        
        cell.backgroundView = UIImageView(image: image)
        cell.selectedBackgroundView = UIImageView(image: image)
        
        cell.textLabel?.text = curso.nombre
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if !self.listCourses[indexPath.section].codigo.isEmpty{
            self.controller.setCurso(curso: self.listCourses[indexPath.section])
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let grupoScreen = storyboard.instantiateViewController(withIdentifier: "GroupScreen") as! UITableViewController
            self.navigationController!.pushViewController(grupoScreen, animated: true)
        }
    }
    
    @objc func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let perfilScreen: UIViewController = storyboard.instantiateViewController(withIdentifier: "PerfilScreen")
        self.navigationController!.pushViewController(perfilScreen, animated: true)
    }
}
