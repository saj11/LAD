//
//  CursoScreen.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/1/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

class AsistenciaScreen: UITableViewController, ButtonsDelegate {
    
    //MARK: Properties
    private let controller: MasterController = MasterController.shared
    private var number:Int = 0
    private var listStudents:Array<(String, String)> = Array<(String, String)>()
    
    var cellSpacingHeight: CGFloat = 0
    
    //MARK: Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellSpacingHeight = 5
        
        navigationItem.title = "Asistencia"
        
        tableView.allowsSelection = false
        
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.done, target: self, action: #selector(refreshLAData(_:)))
        rightBarButton.image = UIImage(named: "refresh-icon")
        
        self.navigationItem.rightBarButtonItem = rightBarButton

        (_, listStudents) = controller.getStudentsFrom(date: "")
    }
    
    //Refresh Functions
    @objc private func refreshLAData(_ sender: Any) {
        // Fetch New LA Data
        (_, listStudents) = controller.getStudentsFrom(date: "")
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return listStudents.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 //or whatever you need
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
        let cell = Bundle.main.loadNibNamed("TableViewCell3", owner: self, options: nil)?.first as! TableViewCell3
        
        cell.delegate = self
        cell.setState(stateInput: listStudents[indexPath.section].1)
        cell.state.tag = indexPath.section
        
        cell.studentName.text = listStudents[indexPath.section].0
        cell.studentName?.textColor = UIColor.black
        cell.studentName?.textAlignment = .left
        
        cell.backgroundColor = .clear
        
        cell.clipsToBounds = true
        
        return cell
    }
    
    func stateTapped(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
    }
    
    @objc func myLeftSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        self.navigationController!.popViewController(animated: true)
    }
}
