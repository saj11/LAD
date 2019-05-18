//
//  SpecificStadisticView.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 5/12/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

class SpecificStadisticView: UIView {
    //MARK: IBOutlet Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var presenteLabel: UILabel!
    @IBOutlet weak var tardiaLabel: UILabel!
    @IBOutlet weak var ausenciaLabel: UILabel!
    
    //MARK: Properties
    private var controller: MasterController = MasterController.shared
    private var cellSpacingHeight: CGFloat = 0
    private var number: Int = 0
    private var dicStudents:Dictionary<String, [Int]> = [:]
    private var dicKeys:[String]!
    
    //MARK: Functions
    override func awakeFromNib() {
        dicStudents = controller.getStudentsFrom()
        dicKeys = [String](dicStudents.keys)
    }
    
    func setInfo(numberStudent: Int){
        let name = dicKeys[numberStudent]
        print(name)
        
        presenteLabel.text = String(dicStudents[name]![0])
        ausenciaLabel.text = String(dicStudents[name]![1])
        tardiaLabel.text = String(dicStudents[name]![2])
    }
    
    func hasElement(element: String, list:Array<String>)-> Int{
        var count: Int = 0
        for item in list{
            if item.elementsEqual(element){ count+=1 }
        }
        return count
    }
}

extension SpecificStadisticView: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return dicStudents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell3", owner: self, options: nil)?.first as! TableViewCell3
        
        cell.studentName.text = dicKeys[indexPath.section]
        cell.studentName?.textColor = UIColor.black
        cell.studentName?.textAlignment = .left
        
        cell.state.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setInfo(numberStudent: indexPath.section)
    }
}

