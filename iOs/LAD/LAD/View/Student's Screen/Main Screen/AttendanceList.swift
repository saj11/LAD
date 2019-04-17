//
//  AttendanceList.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/16/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

class AttendanceList: UITableViewController {
    
    //MARK: Properties
    var delegate: AttendanceListDelegate?
    
    private var number:Int = 0
    private var listCourses:Array<(Curso, Int, String)> = Array<(Curso, Int, String)>()
    private var cellSpacingHeight: CGFloat = 0
    
    //MARK: Actions
    
    override func viewDidLoad() {
        
        self.tableView.flashScrollIndicators()
        
        //(number, listCourses) = self.controller.numberOfCourse()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return number
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section >= 1{
            let cell = Bundle.main.loadNibNamed("CustomTableViewCell2", owner: self, options: nil)?.first as! CustomTableViewCell2
            //let cell = tableView.dequeueReusableCell(withIdentifier: "CourseItem", for: indexPath)
            //let curso: Curso = self.listCourses[indexPath.section].0
            //let image = UIImage.gradientImageWithBounds(bounds: cell.bounds)
            
            //cell.viewWithTag(2)?.backgroundColor = .clear
            //cell.viewWithTag(3)?.backgroundColor = .clear
            //cell.backgroundView = UIImageView(image: image)
            
            //cell.title?.text = curso.nombre
            //cell.title?.lineBreakMode = .byWordWrapping
            //cell.title?.backgroundColor = .clear
            
            //cell.subtitle?.text = self.listCourses[indexPath.section].2
            //cell.subtitle?.backgroundColor = .clear
            
            //cell.numberGroup?.text = String("0\(self.listCourses[indexPath.section].1)")
            
            //cell.groupLabel?.textAlignment = .center
            
            //cell.layer.borderColor = UIColor.white.cgColor
            //cell.layer.borderWidth = 1
            //cell.layer.cornerRadius = 8
            
            cell.clipsToBounds = true
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "staticItem", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(indexPath.row == 1){
            // tell the delegate (view controller) to perform logoutTapped() function
            if let delegate = delegate {
                delegate.showMoreInfo()
            }
        }
    }
}

protocol AttendanceListDelegate {
    func showMoreInfo()
}
