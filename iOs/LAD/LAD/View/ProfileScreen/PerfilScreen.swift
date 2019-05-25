//
//  perfilScreen.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/7/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

class PerfilScreen: UIViewController {
    
    //MARK: Properties
    private let controller: MasterController = MasterController.shared
    private var number:Int = 0
    private var listConfig:Array<String> = ["Tiempo Maximo de Presente", "Tiempo de Vigencia del Codigo"]
    private var listOption:Array<(name:String,image:UIImage)> = [("Editar Perfil",UIImage(named: "profile-icon")!), ("Cambiar Contraseña",UIImage(named: "padlock-icon")!)]
    
    var cellSpacingHeight: CGFloat = 0
    
    //MARK: IBOutlet-Properties
    @IBOutlet weak var configTable: UITableView!
    @IBOutlet weak var optionTable: UITableView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    //MARK: Action
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Perfil"
        self.navigationItem.leftBarButtonItem?.title = "Done"
        
        self.image.image = UIImage(named: "Logo v1.0")
        self.image.layer.cornerRadius = image.frame.height/2
        self.image.clipsToBounds = true
        
        self.nameLabel.text = String(format: "%@ %@", controller.getUsuario().nombre, controller.getUsuario().apellidos)
        self.nameLabel.textAlignment = .center
        
        self.emailLabel.text = self.controller.getUsuario().correo
        self.emailLabel.textAlignment = .center
        self.emailLabel.textColor = UIColor.gray
        
        self.cellSpacingHeight = 0
        
        self.configTable.rowHeight = UITableView.automaticDimension
        
        self.optionTable.rowHeight = UITableView.automaticDimension
        
        self.configTable.isScrollEnabled = false
        self.optionTable.isScrollEnabled = false
        
        if controller.getUsuario().tipo == .Estudiante{
            configTable.isHidden = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == configTable){
            return self.listConfig.count
        }else{
            return self.listOption.count
        }
    }
    
    @objc func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let qrScreen: UIViewController = storyboard.instantiateViewController(withIdentifier: "qrScreen")
        self.navigationController!.pushViewController(qrScreen, animated: true)
    }

    @IBAction func deleteUser(_ sender: Any) {
        _ = controller.deleteUser()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginScreen: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
        self.navigationController!.pushViewController(loginScreen, animated: true)
    }
    
}

extension PerfilScreen: UITableViewDelegate, UITableViewDataSource {
    //MARK: Table View
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
        if tableView == configTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "configItem", for: indexPath)
            cell.textLabel?.text = self.listConfig[indexPath.section]
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            //cell.clipsToBounds = true
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionItem", for: indexPath)
            cell.textLabel?.text = self.listOption[indexPath.section].name
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.imageView?.image = self.listOption[indexPath.section].image
            //cell.clipsToBounds = true
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        if(tableView == configTable){
            switch self.listConfig[indexPath.section] {
            case "Tiempo Maximo de Presente":
                let alertController = UIAlertController(title: "Tiempo Maximo Para estar Presente", message: "Tiempo, en minutos, que corre desde que inicia la clase hasta dicho tiempo.", preferredStyle: .alert)
                
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Minutos"
                }
                let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                    let time1 = alertController.textFields![0] as UITextField
                    if(time1.text!.isInt){
                        self.controller.setTimeMaxPresence(time: Int(time1.text!)!)
                    }else{
                        alertController.textFields![0].backgroundColor = UIColor.red
                        alertController.textFields![0].textColor = UIColor.black
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
                
                alertController.addAction(saveAction)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
                break
            case "Tiempo de Vigencia del Codigo":
                let alertController = UIAlertController(title: "Tiempo de Vigencia del Codigo", message: "Tiempo, en minutos, que estara disponible para ser scaneado.", preferredStyle: .alert)
                
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Minutos"
                }
                let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                    let time2 = alertController.textFields![0] as UITextField
                    if(time2.text!.isInt){
                        self.controller.setTimeCodeAvailable(time: Int(time2.text!)!)
                    }else{
                        alertController.textFields![0].backgroundColor = UIColor.red
                        alertController.textFields![0].textColor = UIColor.black
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
                
                alertController.addAction(saveAction)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
                break
            default:
                break
            }
        }else if(tableView == optionTable){
            switch self.listOption[indexPath.section].name {
            case "Cambiar Contraseña":
                let alertController = UIAlertController(title: "Cambio de Contraseña", message: "", preferredStyle: .alert)
                
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Nueva Contraseña" }
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Repetir Nueva Contraseña" }
                let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                    let contraseña1 = alertController.textFields![0] as UITextField
                    let contraseña2 = alertController.textFields![1] as UITextField
                    
                    let contraseñaEncryoted1 = NativeEncryption.encrypt(message: contraseña1.text!)
                    let contraseñaEncryoted2 = NativeEncryption.encrypt(message: contraseña2.text!)
                    
                    if(contraseñaEncryoted1.isEqual(contraseñaEncryoted2)){
                        self.controller.setNewPassword(password: contraseña2.text!)
                    }else{
                        alertController.message = "Error: Las contraseñas no coinciden."
                        alertController.textFields![1].backgroundColor = UIColor.red
                        alertController.textFields![1].textColor = UIColor.black
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
                
                alertController.addAction(saveAction)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
                break
            default:
                break
            }
        }
    }
}
