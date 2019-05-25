//
//  CourseListScreen.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 5/1/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit
import DTZFloatingActionButton

class CourseListScreen: UIViewController {
    
    //MARK: IBOutlet - Properties
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    private let controller: MasterController = MasterController.shared
    private var number:Int = 0
    private var listSubject: [Grupo]!
    private var cellSpacingHeight: CGFloat = 0
    
    //MARK: Actions
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(title: "Materias", image: UIImage(named: "list-icon"), tag: 2)
        
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if controller.getCreateGroup(){
            
            listSubject = controller.getListGroup()
                
            tableView.reloadData()
        }
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.myRightSideBarButtonItemTapped(_:)))
        rightBarButton.image = UIImage(named: "user-icon")
        rightBarButton.tintColor = #colorLiteral(red: 0, green: 0.9769522548, blue: 0.1877456605, alpha: 1)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.cellSpacingHeight = 0
        cellSpacingHeight = 10
        
        self.tableView.separatorStyle = .none
        self.tableView.flashScrollIndicators()
        
        listSubject = controller.getListGroup()
        
        let actionButton = DTZFloatingActionButton()
        actionButton.handler = {
            button in
            self.floatButtonTapped()
        }
        actionButton.isScrollView = true
        self.view.addSubview(actionButton)
    }
    
    func floatButtonTapped()
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let createCurseScreen: UIViewController = storyboard.instantiateViewController(withIdentifier: "createCurseScreen")
        self.navigationController!.pushViewController(createCurseScreen, animated: true)
    }
    
    //MARK: OBJ-C
    @objc func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let perfilScreen: UIViewController = storyboard.instantiateViewController(withIdentifier: "PerfilScreen")
        self.navigationController!.pushViewController(perfilScreen, animated: true)
    }
}

extension CourseListScreen: UITableViewDelegate, UITableViewDataSource{
    //MARK: Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return listSubject.count
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
        
        let grupo = listSubject![indexPath.section]
        let curso: Curso = grupo.getCurse()
        let image = UIImage.gradientImageWithBounds(bounds: cell.bounds)
        
        cell.viewWithTag(2)?.backgroundColor = .clear
        cell.viewWithTag(3)?.backgroundColor = .clear
        cell.backgroundView = UIImageView(image: image)
        
        cell.title?.text = curso.nombre
        cell.title?.lineBreakMode = .byWordWrapping
        cell.title?.backgroundColor = .clear
        
        cell.subtitle?.text = ""
        cell.subtitle?.backgroundColor = .clear
        
        cell.numberGroup?.text = String("0\(grupo.getNumber())")
        
        cell.selectedBackgroundView = UIImageView(image: image)
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.controller.setCurso(curso: listSubject[indexPath.section].getCurse())
        self.controller.setGrupo(grupo: listSubject[indexPath.section])
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let principalScreen: UIViewController = storyboard.instantiateViewController(withIdentifier: "PrincipalScreen")
        self.navigationController!.pushViewController(principalScreen, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            controller.setGrupo(grupo: listSubject[indexPath.section])
            
            let alert = UIAlertController(title: "Eliminar Grupo", message: "¿Esta Seguro que desea borrar este curso?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { alert -> Void in
                if !self.controller.deleteGroup(){
                    let alert2 = UIAlertController(title: "Eliminar Grupo", message: "Error: No se pudo eliminar el grupo.", preferredStyle: .alert)
                    alert2.addAction(UIAlertAction(title: "Ok", style: .default))
                    
                    self.present(alert2, animated: true, completion: nil)
                }else{
                    self.listSubject.remove(at: indexPath.section)
                    
                    self.controller.removeGroup(pos: indexPath.section)
                    
                    let indexSetTable = IndexSet(arrayLiteral: indexPath.section)
                    self.tableView.deleteSections(indexSetTable, with: .fade)
                    
                    self.controller.setCreateGroup(value: true)
                }
            }))
            alert.addAction(UIAlertAction(title: "NO", style: .cancel))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
