//
//  Login.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 3/24/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit


class Login: UIViewController{
    var controller: MasterController = MasterController.shared
    // MARK: Properties
    
    @IBOutlet weak var userNameTF: DesignableTextField!
    @IBOutlet weak var passwordTF: DesignableTextField!
    
    // MARK: Actions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the Navigation Bar
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signIn(_ sender: DesignableButton) {
        //let userN = userNameTF.text
        //let pass = passwordTF.text
        
        //let userN = "cbenavides@itcr.ac.cr"
        //let userN = "mestrada@itcr.ac.cr"
        //let userN = "p@gmail.com"
        //let pass = "hola1234"
        //let pass = "123456789"
        
        let userN = "2015100516"
        let pass = "123456789"
        
        var typeUser: String
        
        if userN.isInt{
            typeUser = "Estudiante"
        }else{
            typeUser = "Profesor"
        }
        
        if(self.controller.validateUser(typeUser: typeUser, email: userN, password: pass)){
            if typeUser.elementsEqual("Profesor"){
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let cursoScreen = storyboard.instantiateViewController(withIdentifier: "NavController2") as! UINavigationController
                self.present(cursoScreen, animated: true, completion: nil)
            }else{
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let cursoScreen = storyboard.instantiateViewController(withIdentifier: "StudentTabBarController") as! UITabBarController
                self.present(cursoScreen, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Lista de Asistencia Digital", message: "Error: No concide el usuario con la contraseña proporcionada", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
