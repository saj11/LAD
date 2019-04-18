//
//  ListScreen.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/15/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit


class ListScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    private let controller: MasterController = MasterController.shared
    @IBOutlet weak var tableView: UITableView!
    
    private var number:Int = 0
    private var listCourses:Array<(Curso, Int, String)> = Array<(Curso, Int, String)>()
    private var cellSpacingHeight: CGFloat = 0
    
    //MARK: Actions
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(title: "Materias", image: UIImage(named: "student-list-icon"), tag: 2)
        
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        //self.tabBarItem.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setNavBar()
        
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.myRightSideBarButtonItemTapped(_:)))
        rightBarButton.image = UIImage(named: "user-icon")
        rightBarButton.tintColor = #colorLiteral(red: 0.02945959382, green: 0.5178381801, blue: 0.9889006019, alpha: 1)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.cellSpacingHeight = 0
        cellSpacingHeight = 10
        
        self.tableView.separatorStyle = .none
        self.tableView.flashScrollIndicators()
        self.automaticallyAdjustsScrollViewInsets = false
        
        (number, listCourses) = self.controller.numberOfCourse()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return number
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
        let cell = Bundle.main.loadNibNamed("CustomTableViewCell", owner: self, options: nil)?.first as! CustomTableViewCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CourseItem", for: indexPath)
        let curso: Curso = self.listCourses[indexPath.section].0
        let image = UIImage.gradientImageWithBounds(bounds: cell.bounds)
        
        cell.viewWithTag(2)?.backgroundColor = .clear
        cell.viewWithTag(3)?.backgroundColor = .clear
        cell.backgroundView = UIImageView(image: image)
        
        cell.title?.text = curso.nombre
        cell.title?.lineBreakMode = .byWordWrapping
        cell.title?.backgroundColor = .clear
        
        cell.subtitle?.text = self.listCourses[indexPath.section].2
        cell.subtitle?.backgroundColor = .clear
        
        cell.numberGroup?.text = String("0\(self.listCourses[indexPath.section].1)")
        
        //cell.groupLabel?.textAlignment = .center
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.controller.setCurso(curso: self.listCourses[indexPath.section].0)
        self.controller.setNumberGroup(number: self.listCourses[indexPath.section].1)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailList: UIViewController = storyboard.instantiateViewController(withIdentifier: "ListDetailScreen")
        self.navigationController!.pushViewController(detailList, animated: true)
    }
    
    @objc func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let perfilScreen: UIViewController = storyboard.instantiateViewController(withIdentifier: "PerfilScreen")
        self.navigationController!.pushViewController(perfilScreen, animated: true)
    }
}
