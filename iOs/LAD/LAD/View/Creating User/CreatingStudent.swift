//
//  CreatingStudent.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/14/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

class CreatingStudent: UIViewController{
    private var controller: MasterController = MasterController.shared
    private var initialPoint: CGPoint!
    // MARK: Properties
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var carnetTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var repeatPasswordTF: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        nameTF.delegate = self
        lastNameTF.delegate = self
        carnetTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        repeatPasswordTF.delegate = self
        
        scrollView.isDirectionalLockEnabled = true
        scrollView.delegate = self
        
        initialPoint = CGPoint(x: 0, y: 0)
    }
    
    @IBAction func signUp(_ sender: AnyObject) {
        let userName = nameTF.text
         let lastName = lastNameTF.text
         let id = carnetTF.text
         let email = emailTF.text
         let password = passwordTF.text
         let confirmPass = repeatPasswordTF.text
        
        /*let userName = "joseph"
        let lastName = "salazar"
        let id = 2015100516
        let email = "jossalazar@ic-itcr.ac.cr"
        let password = "123456789"
        let confirmPass = "123456789"*/
        
        if((password!.elementsEqual(confirmPass!))){
            let encryptedPass = NativeEncryption.encrypt(message: password!)
            let userData = [userName, lastName, id, email, encryptedPass] as [Any]
            
            if(self.controller.validateNewUser(typeUser: "S", input: email!)){
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

extension CreatingStudent: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            initialPoint.y += (nextField.frame.origin.y - textField.frame.origin.y)
            scrollView.setContentOffset(initialPoint, animated: true)
            view.endEditing(true)
            
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            view.endEditing(true)
            
            signUp(self)
            textField.resignFirstResponder()
        }
        
        return false
    }
}

extension CreatingStudent: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
