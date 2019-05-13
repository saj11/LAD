//
//  File.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 5/11/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit
import Koyomi

var year:Dictionary = [
    "1" : "Enero",
    "2" : "Febero",
    "3" : "Marzo",
    "4" : "Abril",
    "5" : "Mayo",
    "6" : "Junio",
    "7" : "Julio",
    "8" : "Agosto",
    "9" : "Setiembre",
    "10" : "Octubre",
    "11" : "Noviembre",
    "12" : "Diciembre"
]

class HistorialAssistanceScreen: UIViewController {
    
    //MARK: Properties - IBOutlet
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var koyomi: Koyomi!
    @IBOutlet weak var AssistanceTableView: UITableView!
    
    
    //MARK: Properties
    private let refreshControl = UIRefreshControl()
    private var controller: MasterController = MasterController.shared
    private var calendar: Calendar!
    private var currentDate: Int!
    private var number:Int = 0
    private var listStudents: Array<(String, String)> = Array<(String, String)>()
    private var availableLA: Array<String> = Array<String>()
    private var cellSpacingHeight: CGFloat!
    private var selectedDate: Array<String.SubSequence>!
    
    //MARK: Functions
    func getYear()->String{
        return String(Int(koyomi.currentDateString().split(separator: "/")[1])!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation
        self.navigationItem.title = "Historial"
        
        //Calendar
        koyomi.calendarDelegate = self
        
        let customColorScheme = (dayBackgrond: #colorLiteral(red: 0.9592562318, green: 0.9592562318, blue: 0.9592562318, alpha: 1),
                                 weekBackgrond: UIColor.red,
                                 week: UIColor.white,
                                 weekday: UIColor.black,
                                 holiday: (saturday: #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1), sunday: #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)),
                                 otherMonth: UIColor.lightGray,
                                 separator: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
        
        koyomi.style = KoyomiStyle.custom(customColor: customColorScheme)
        
        koyomi.weeks = ("D", "L", "K", "M", "J", "V", "S")
        koyomi.isHiddenOtherMonth = true
        koyomi.selectionMode = .single(style: .circle)
        
        currentDate = Int(koyomi.currentDateString().split(separator: "/")[0])!
        monthLabel.text = String(format: "%@ %@", year[String(currentDate)]!, getYear())
        
        //Gestures
        let left = UISwipeGestureRecognizer(target : self, action : #selector(self.leftSwipe))
        left.direction = .left
        koyomi.addGestureRecognizer(left)
        
        let right = UISwipeGestureRecognizer(target : self, action : #selector(self.rightSwipe))
        right.direction = .right
        koyomi.addGestureRecognizer(right)
        
        //Refresh Control
        if #available(iOS 10.0, *) {
            AssistanceTableView.refreshControl = refreshControl
        } else {
            AssistanceTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshLAData(_:)), for: .valueChanged)
        
        //Tablew View
        availableLA = controller.getAvailableLA()
        print(availableLA)
        
        cellSpacingHeight = 5
        AssistanceTableView.isHidden = true
        AssistanceTableView.allowsSelection = false
    }
    
    //MARK: Gestures
    @objc
    func leftSwipe(){
        koyomi.display(in: .next)
        if currentDate < 12 {
            currentDate += 1
        }else{
            currentDate = 1
        }
        print(currentDate)
        monthLabel.text = String(format: "%@ %@", year[String(currentDate)]!, getYear())
    }
    
    @objc
    func rightSwipe(){
        koyomi.display(in: .previous)
        if currentDate > 1 {
            currentDate -= 1
        }else{
            currentDate = 12
        }
        print(currentDate)
        monthLabel.text = String(format: "%@ %@", year[String(currentDate)]!, getYear())
    }
    
    //Refresh Functions
    @objc private func refreshLAData(_ sender: Any) {
        // Fetch New LA Data
        if selectedDate != nil{
            (number, listStudents) = controller.getStudentsFrom(date: String(selectedDate![0]))
            
            AssistanceTableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
}

extension HistorialAssistanceScreen: KoyomiDelegate {
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        selectedDate = (date?.description.split(separator: " "))!
        
        var selectedDate2 = "2019-04-30"
        //if availableLA.contains(String(selectedDate![0])){
        if availableLA.contains(selectedDate2){
            //(number, listStudents) = controller.getStudentsFrom(date: String(selectedDate![0]))
            AssistanceTableView.isHidden = false

            (number, listStudents) = controller.getStudentsFrom(date: selectedDate2)
            print(number, listStudents)
            
            AssistanceTableView.reloadData()
        }else{
            AssistanceTableView.isHidden = true
        }
    }
}

extension HistorialAssistanceScreen: UITableViewDelegate, UITableViewDataSource, ButtonsDelegate {
    func stateTapped(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell3", owner: self, options: nil)?.first as! TableViewCell3
        
        if !listStudents.isEmpty {
            cell.delegate = self
            cell.setState(stateInput: listStudents[indexPath.section].1)
            cell.state.tag = indexPath.section
            
            cell.studentName.text = listStudents[indexPath.section].0
            cell.studentName?.textColor = UIColor.black
            cell.studentName?.textAlignment = .left
            
            cell.backgroundColor = .clear
            
            cell.clipsToBounds = true
        }
        
        return cell
    }
    
    
}
