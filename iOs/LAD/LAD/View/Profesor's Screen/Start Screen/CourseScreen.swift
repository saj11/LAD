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

class CourseScreen: UIViewController{
    
    //MARK: Properties
    private var controller: MasterController = MasterController.shared
    private var listSubject: [Grupo]!
    private var slides:[Any]!
    private var slide2: MainSlide!
    private var slide1: DetailSlide!
    private var slide3: TimeSlide!
    private var actualGroup: Grupo!
    
    //MARK: GUI Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var courseTableView: UITableView!
    
    //MARK: Actions
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "QR Code", image: UIImage(named: "qr-icon"), tag: 2)
        
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if controller.getCreateGroup(){
            listSubject = controller.getListGroup()
            
            courseTableView.reloadData()
            
            controller.setCreateGroup(value: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavBar()
        
        scrollView.delegate = self
        
        slide1 = (Bundle.main.loadNibNamed("DetailSlide", owner: self, options: nil)?.first as! DetailSlide)
        slide2 = (Bundle.main.loadNibNamed("MainSlide", owner: self, options: nil)?.first as! MainSlide)
        slide3 = (Bundle.main.loadNibNamed("TimeSlide", owner: self, options: nil)?.first as! TimeSlide)
        
        createSubject()
        setupSlideScrollView(slideList: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    func getActualGroup() -> Grupo {
        return actualGroup
    }
    
    func createNavBar(){
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 44, width: 375, height: 85))
        view.addSubview(navBar)
        navBar.prefersLargeTitles = true
        navBar.barTintColor = .white
        
        let navItem = UINavigationItem(title: "Codigo QR")
        navItem.largeTitleDisplayMode = .always
        
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.exportar(_:)))
        rightBarButton.image = UIImage(named: "share-icon")
        rightBarButton.tintColor = #colorLiteral(red: 0, green: 0.9769522548, blue: 0.1877456605, alpha: 1)
        navItem.rightBarButtonItem = rightBarButton
        
        navBar.setItems([navItem], animated: true)
    }
    
    func createSubject(){
        var listCourses: Array<Curso>
        
        (_, listCourses) = self.controller.numberOfCourse()
        
        if controller.getListGroup()!.isEmpty{
            for course in listCourses{
                self.controller.setCurso(curso: course)
                _ = self.controller.groupsOf()
            }
        }
        listSubject = controller.getListGroup()
        
        setInfo(item: 0)
        
        controller.setGrupo(grupo: listSubject[0])
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
        
        slide3.startTimeLabel.text = dates.0
        slide3.endTimeLabel.text = dates.1
        
        slides = [slide1, slide2, slide3]
    }
    
    func setSchedule(group: Grupo, slide: DetailSlide){
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: Date())
        
        var date = group.getNearSchedule().horaInicio
        let hour1 = calendar.component(.hour, from: date)
        let minutes1 = calendar.component(.minute, from: date)
        
        if(minutes1 < 10){
            slide.schedule1Label.text = String(format: "%d:%@", hour1, "0\(minutes1)")
        }else{
            slide.schedule1Label.text = String(format: "%d:%d", hour1, minutes1)
        }
        
        date = group.getNearSchedule().horaFinal
        let hour2 = calendar.component(.hour, from: date)
        let minutes2 = calendar.component(.minute, from: date)
        
        if(minutes2 < 10){
            slide.schedule2Label.text = String(format: "%d:%@", hour2, "0\(minutes2)")
        }else{
            slide.schedule2Label.text = String(format: "%d:%d", hour2, minutes2)
        }
        print("T##items: Any...##Any")
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
        
        hour2 = calendar.component(.hour, from: Date().adding(minutes: controller.getProfesor().tiempoTardiaCodigo))
        minutes2 = calendar.component(.minute, from: Date().adding(minutes: controller.getProfesor().tiempoTardiaCodigo))
        
        if(minutes2 < 10){
            minutesString2 = "0"+String(minutes2)
        }else{
            minutesString2 = String(minutes2)
        }
        
        return ( String(format: "%d:"+minutesString, hour), String(format: "%d:"+minutesString2, hour2) )
    }
    
    //MARK: Obj-c Action
    @IBAction func exportar(_ sender: Any) {
        var image = controller.getGrupo().getCode()?.getCIImage()
        
        var data = image?.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        
        let activityViewController = UIActivityViewController(activityItems: [ UIImage(ciImage: data!)], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension CourseScreen: UIScrollViewDelegate{
    //MARK: Scroll View
    func setupSlideScrollView(slideList : [Any]) {
        scrollView.frame = CGRect(x: 67, y: 162, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        
        for i in 0 ..< slideList.count {
            (slideList[i] as! UIView).frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slideList[i] as! UIView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        pageControl.currentPage = Int(x/w)
    }
}

extension CourseScreen: UITableViewDelegate, UITableViewDataSource{
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
        if slide3.getHasStarted(){
            let alert = UIAlertController(title: "Cronometro", message: "No se puede crear otra Lista de Asistencia hasta que finalice el tiempo minimo para estar presente.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            setInfo(item: indexPath.section)
            controller.setGrupo(grupo: listSubject[indexPath.section])
        }
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
                    self.courseTableView.deleteSections(indexSetTable, with: .fade)
                    
                    self.controller.setCreateGroup(value: true)
                }
            }))
            alert.addAction(UIAlertAction(title: "NO", style: .cancel))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
