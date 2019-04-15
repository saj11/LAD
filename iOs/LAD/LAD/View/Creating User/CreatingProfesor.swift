//
//  Selection.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 3/24/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

class CreatingUser: UIViewController{
    
    private var controller: MasterController = MasterController.shared
    
    //MARK: Properties
    @IBOutlet weak var userNameTF: DesignableTextField!
    @IBOutlet weak var lastNameTF: DesignableTextField!
    @IBOutlet weak var emailTF: DesignableTextField!
    @IBOutlet weak var passwordTF: DesignableTextField!
    @IBOutlet weak var passwordRepTF: DesignableTextField!
    
    //MARK: Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signUp(_ sender: DesignableButton) {
        /*let userName = userNameTF.text
        let lastName = lastNameTF.text
        let email = emailTF.text
        let password = passwordTF.text
        let confirmPass = passwordRepTF.text*/
        
        let userName = "prueba"
        let lastName = "prueba"
        let email = "pp@gmail.com"
        let password = "123456789"
        let confirmPass = "123456789"
        
        if((password.elementsEqual(confirmPass))){
            let encryptedPass = NativeEncryption.encrypt(message:password)
            let dataArray = [userName, lastName, email, encryptedPass]
            if(self.controller.validateNewUser(typeUser: "P", input: email)){
                if(self.controller.addNewUser(typeUser: "P", data: dataArray)){
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let cursoScreen = storyboard.instantiateViewController(withIdentifier: "NavController2") as! UINavigationController
                    self.present(cursoScreen, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController(title: "Usuario Profesor", message: "Error: No se pudo crear el nuevo usuario.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "Usuario Profesor", message: "Error: Ya se encuentra un usuario con dicho correo", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Usuario Profesor", message: "Error: La contraseña no coincide con la confirmación", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
