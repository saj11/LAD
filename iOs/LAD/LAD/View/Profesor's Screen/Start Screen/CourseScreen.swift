//
//  CourseScreen2.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/26/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

struct Subject{
    var course: Curso
    var group: Grupo
}

class CourseScreen: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    private var controller: MasterController = MasterController.shared
    private var listSubject: [Grupo]!
    private var slides:[Any]!
    private var slide2: MainSlide!
    private var slide1: DetailSlide!
    private var slide3: TimeSlide!
    
    //MARK: GUI Properties
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    private var subjectPickerView: UIPickerView!
    
    //MARK: Actions
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "QR Code", image: UIImage(named: "qr-icon"), tag: 2)
        
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavBar()
        
        subjectPickerView = UIPickerView()
        subjectPickerView.delegate = self
        
        scrollView.delegate = self
        
        subjectTextField.inputView = subjectPickerView
        
        slide1 = (Bundle.main.loadNibNamed("DetailSlide", owner: self, options: nil)?.first as! DetailSlide)
        slide2 = (Bundle.main.loadNibNamed("MainSlide", owner: self, options: nil)?.first as! MainSlide)
        slide3 = (Bundle.main.loadNibNamed("TimeSlide", owner: self, options: nil)?.first as! TimeSlide)
        
        createSubject()
        setupSlideScrollView(slideList: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
        subjectTextField.isHidden = true
    }
    
    func createNavBar(){
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 44, width: 375, height: 85))
        view.addSubview(navBar)
        navBar.prefersLargeTitles = true
        navBar.barTintColor = .white
        
        let navItem = UINavigationItem(title: "Codigo QR")
        navItem.largeTitleDisplayMode = .always
        
        navBar.setItems([navItem], animated: true)
    }
    
    func createSubject(){
        var listCourses: Array<Curso>
        
        (_, listCourses) = self.controller.numberOfCourse()
        
        if controller.getListGroup()!.isEmpty{
            for course in listCourses{
                self.controller.setCurso(curso: course)
                self.controller.groupsOf()
            }
        }
        listSubject = controller.getListGroup()
        
        setInfo(item: 0)
    }
    
    //MARK: Page Control
    func setupSlideScrollView(slideList : [Any]) {
        scrollView.frame = CGRect(x: 67, y: 162, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        
        for i in 0 ..< slideList.count {
            (slideList[i] as! UIView).frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slideList[i] as! UIView)
        }
    }

    func setInfo(item:Int){
        let grupo = listSubject[item]
        let dates = setCodeDate()
        
        let image = UIImage.gradientImageWithBounds(bounds: slide1.subView.bounds)
        
        slide1.subView.backgroundColor = UIColor(patternImage: image)
        slide1.subjectLabel.text = grupo.getCurse().nombre
        slide1.groupLabel.text = String(grupo.getNumber())
        setSchedule(group: grupo, slide: slide1)
        
        slide2.imageView.layer.magnificationFilter = CALayerContentsFilter.nearest
        slide2.imageView.image = grupo.getCode()?.getUIImage()
        
        slide3.clear()
        slide3.startTimeLabel.text = dates.0
        slide3.endTimeLabel.text = dates.1
        slide3.timerProgressView.useMinutesAndSecondsRepresentation = true
        slide3.timerProgressView.labelTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        slide3.timerProgressView.labelFont = UIFont(name: "HelveticaNeue-Bold", size: 40)
        slide3.timerProgressView.lineWidth = 7
        
        
        slides = [slide1, slide2, slide3]
    }
    
    func setSchedule(group: Grupo, slide: DetailSlide){
        var date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
        
        date = group.getSchedule(numberDay: day).horaInicio
        let hour1 = calendar.component(.hour, from: date)
        let minutes1 = calendar.component(.minute, from: date)
        
        if(minutes1 < 10){
            slide.schedule1Label.text = String(format: "%d:%@", hour1, "0\(minutes1)")
        }else{
            slide.schedule1Label.text = String(format: "%d:%d", hour1, minutes1)
        }
        
        date = group.getSchedule(numberDay: day).horaFinal
        let hour2 = calendar.component(.hour, from: date)
        let minutes2 = calendar.component(.minute, from: date)
        
        if(minutes2 < 10){
            slide.schedule2Label.text = String(format: "%d:%@", hour2, "0\(minutes2)")
        }else{
            slide.schedule2Label.text = String(format: "%d:%d", hour2, minutes2)
        }
    }
    
    func setCodeDate()-> (String, String){
        // Se obtiene la
        let date = Date()
        let calendar = Calendar.current
        var hour:Int, hour2:Int, minutes:Int, minutes2:Int
        var minutesString:String, minutesString2:String
        
        hour = calendar.component(.hour, from: date)
        minutes = calendar.component(.minute, from: date)
        
        if(minutes < 10){
            minutesString = "0"+String(minutes)
        }else{
            minutesString = String(minutes)
        }
        
        hour2 = calendar.component(.hour, from: Date().adding(minutes: 15))
        minutes2 = calendar.component(.minute, from: Date().adding(minutes: 15))
        
        if(minutes2 < 10){
            minutesString2 = "0"+String(minutes2)
        }else{
            minutesString2 = String(minutes2)
        }
        
        return ( String(format: "%d:"+minutesString, hour), String(format: "%d:"+minutesString2, hour2) )
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        pageControl.currentPage = Int(x/w)
    }
    
    // MARK: UIPickerView Delegation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listSubject.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listSubject[row].getCurse().nombre
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        subjectTextField.text = listSubject[row].getCurse().nombre
        
        setInfo(item: row)
        
        self.view.endEditing(true)
        self.view.setNeedsDisplay()
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return listSubject.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseItem", for: indexPath)
        
        cell.textLabel?.text = listSubject[indexPath.section].getCurse().nombre
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setInfo(item: indexPath.section)
    }
}
