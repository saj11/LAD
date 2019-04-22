//
//  CreatingStudent.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/14/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

class CreatingStudent: UIViewController {
    var controller: MasterController = MasterController.shared
    // MARK: Properties
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var lastNameTF: DesignableTextField!
    @IBOutlet weak var carnetTF: DesignableTextField!
    @IBOutlet weak var emailTF: DesignableTextField!
    @IBOutlet weak var passwordTF: DesignableTextField!
    @IBOutlet weak var repeatPasswordTF: DesignableTextField!
    
    //MARK: Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        /*let userName = userNameTF.text
         let lastName = lastNameTF.text
         let id = carnetTF.text
         let email = emailTF.text
         let password = passwordTF.text
         let confirmPass = passwordRepTF.text*/
        
        let userName = "joseph"
        let lastName = "salazar"
        let id = 2015100516
        let email = "jossalazar@ic-itcr.ac.cr"
        let password = "123456789"
        let confirmPass = "123456789"
        
        if((password.elementsEqual(confirmPass))){
            let encryptedPass = NativeEncryption.encrypt(message: password)
            let userData = [userName, lastName, id, email, encryptedPass] as [Any]
            
            if(self.controller.validateNewUser(typeUser: "S", input: email)){
                if(self.controller.addNewUser(typeUser: "S", data: userData)){
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let cursoScreen = storyboard.instantiateViewController(withIdentifier: "StudentTabBarController") as! UITabBarController
                    self.present(cursoScreen, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController(title: "Usuario Estudiante", message: "Error: No se pudo crear el nuevo usuario.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "Usuario Estudiante", message: "Error: Ya se encuentra un usuario con dicho correo", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Usuario Estudiante", message: "Error: La contraseña no coincide con la confirmación", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
