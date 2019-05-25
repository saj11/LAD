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
    private var initialPoint: CGPoint!
    
    //MARK: Properties
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordRepTF: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        userNameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        passwordRepTF.delegate = self
        
        scrollView.isDirectionalLockEnabled = true
        scrollView.delegate = self
    }
    
    @IBAction func signUp(_ sender: AnyObject) {
        let userName = userNameTF.text
        let lastName = lastNameTF.text
        let email = emailTF.text
        let password = passwordTF.text
        let confirmPass = passwordRepTF.text
        
        /*let userName = "prueba"
        let lastName = "prueba"
        let email = "pp@gmail.com"
        let password = "123456789"
        let confirmPass = "123456789"*/
        
        if((password!.elementsEqual(confirmPass!))){
            let encryptedPass = NativeEncryption.encrypt(message:password!)
            let dataArray = [userName, lastName, email, encryptedPass]
            if(self.controller.validateNewUser(typeUser: "P", input: email!)){
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

extension CreatingUser: UITextFieldDelegate{
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

extension CreatingUser: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
