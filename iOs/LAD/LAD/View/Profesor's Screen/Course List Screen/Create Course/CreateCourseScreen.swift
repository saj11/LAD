//
//  CreateCourseScreen.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/22/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

var WeekDay:Dictionary = [
    "Domingo" : "D",
    "Lunes" : "L",
    "Martes" : "K",
    "Miercoles" : "M",
    "Jueves" : "J",
    "Viernes" : "V",
    "Sabado" : "S"
]

class CreateCourseScreen: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource{
    
    private var controller: MasterController = MasterController.shared
    private var listCourses: Array<String>!
    private var listGroups: Array<String>!
    private var listDays: Array<String>!
    private var listChoosenDays: Array<String>!
    
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var date1TextField: UITextField!
    @IBOutlet weak var date2TextField: UITextField!
    
    private var subjectPickerView: UIPickerView!
    private var date1PickerView = UIDatePicker()
    private var date2PickerView = UIDatePicker()
    
    private var cellSpacingHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Nuevo Curso"
        
        subjectPickerView = UIPickerView()
        
        subjectPickerView.tag = 1
        
        subjectPickerView.delegate = self
        
        date1PickerView.datePickerMode = .time
        date2PickerView.datePickerMode = .time
        
        date1PickerView.addTarget(self, action: #selector(date1PickerValueChanged), for: UIControl.Event.valueChanged)
        date2PickerView.addTarget(self, action: #selector(date2PickerValueChanged), for: UIControl.Event.valueChanged)
        
        subjectTextField.inputView = subjectPickerView
        date1TextField.inputView = date1PickerView
        date2TextField.inputView = date2PickerView
        
        groupTextField.isEnabled = false
        
        cellSpacingHeight = 0
        
        
        listCourses = controller.getAllNameCourses()
        listGroups = Array<String>()
        listDays = ["Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"]
        listChoosenDays = Array<String>()
    }
    
    // MARK: UIPickerView Delegation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return listCourses.count
        default:
            return 0
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return listCourses[row]
        default:
            return ""
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            subjectTextField.text = listCourses[row]
            //groupTextField.isEnabled = true
            
            let numberOfGroups = controller.numberOfGroups(nameCurse: listCourses[row])
            
            groupTextField.text = String(numberOfGroups)
            
            break
        case 2:
            subjectTextField.text = listCourses[row]
            break
        default:
            break
        }
        
        self.view.endEditing(true)
        self.view.setNeedsDisplay()
    }
    
    @objc func date1PickerValueChanged(sender: UIDatePicker){
        var components = Calendar.current.dateComponents([.minute, .hour], from: date1PickerView.date)
        date1TextField.text = String(format: "%d:%d", components.hour!, components.minute!)
        
        self.view.endEditing(true)
        self.view.setNeedsDisplay()
    }
    
    @objc func date2PickerValueChanged(sender: UIDatePicker){
        var components = Calendar.current.dateComponents([.minute, .hour], from: date2PickerView.date)
        date2TextField.text = String(format: "%d:%d", components.hour!, components.minute!)
        
        self.view.endEditing(true)
        self.view.setNeedsDisplay()
    }
    
    //MARK: Table Delegation
    func numberOfSections(in tableView: UITableView) -> Int {
        return listDays.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "weekDayItem", for: indexPath)
        cell.textLabel?.text = listDays[indexPath.section]
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !listChoosenDays.contains(listDays![indexPath.section]){
            listChoosenDays.append(WeekDay[listDays![indexPath.section]]!)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        listChoosenDays.remove(at: listChoosenDays.firstIndex(of: WeekDay[ listDays![indexPath.section]]!)!)
    }
    
    //MARK: Buttons Functions
    @IBAction func createGroup(_ sender: Any) {
        if listChoosenDays.count == 1{
            listChoosenDays.append("")
        }
        
        let course = subjectTextField.text == nil ? "" : subjectTextField.text!
        if course.count > 0 {
            let group = groupTextField.text == nil ? "" : groupTextField.text!
            if !listChoosenDays.isEmpty{
                let startHour = date1TextField.text == nil ? "" : date1TextField.text!
                let endHour = date2TextField.text == nil ? "" : date2TextField.text!
                
                if startHour.count > 0 && endHour.count > 0 {
                    if controller.addNewCourse(idCurse: course, number: Int(group)!, firstDay: listChoosenDays[0], secondDay: listChoosenDays[1], startTime: startHour, endTime: endHour){
                        let alert = UIAlertController(title: "Nuevo Curso", message: "Curso Nuevo Agregado Satisfactoriamente.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { alert -> Void in
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    
                    }
                }else{
                    let alert = UIAlertController(title: "Nuevo Curso", message: "Error: No ha seleccionado un horario.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "Nuevo Curso", message: "Error: No ha seleccionado al menos un día.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Nuevo Curso", message: "Error: No ha seleccionado un curso.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
