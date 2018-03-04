//
//  LoginOrRegisterViewController.swift
//  Fastalk
//
//  Created by Dan Xu on 3/3/18.
//  Copyright © 2018 IOSGroup7. All rights reserved.
//

import UIKit
import Firebase

class LoginOrRegisterViewController: UIViewController {
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var segControl: UISegmentedControl!

    var currentOption = 0
    var alertController:UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldPassword.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segControlAction(_ sender: Any) {
        self.currentOption = self.segControl.selectedSegmentIndex
    }
    
    @IBAction func goButtonClicked(_ sender: Any) {
        let email = textFieldEmail.text!
        let password = textFieldPassword.text!
        if (email == "" || password == "") {
            self.alertController = UIAlertController(title: "Empty Fields", message: "Please provide both email and password!", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            alertController!.addAction(OKAction)
            
            present(self.alertController!, animated: true, completion:nil)
        } else if (password.count < 6) {
            self.alertController = UIAlertController(title: "Password error", message: "Password should be at least 6 characters", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            alertController!.addAction(OKAction)
            
            present(self.alertController!, animated: true, completion:nil)
        }
        if (currentOption == 0) {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let err = error {
                    //print("error: " + err.localizedDescription)
                    self.alertController = UIAlertController(title: "Login error", message: "\(err.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let OKAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default)
                    self.alertController!.addAction(OKAction)
                    
                    self.present(self.alertController!, animated: true, completion:nil)
                    return
                }
                if let user = user {
                    let uid = user.uid
                    let email = user.email
                    let photoURL = user.photoURL
                    // ...
                }
                self.performSegue(withIdentifier: "LoginOrRegisterToChat", sender: nil)
            }
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let err = error {
                    //print("error: " + err.localizedDescription)
                    self.alertController = UIAlertController(title: "Register error", message: "\(err.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let OKAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default)
                    self.alertController!.addAction(OKAction)
                    
                    self.present(self.alertController!, animated: true, completion:nil)
                    return
                }
                if let user = user {
                    let uid = user.uid
                    let email = user.email
                    let photoURL = user.photoURL
                    // ...
                }
                self.performSegue(withIdentifier: "LoginOrRegisterToChat", sender: nil)
            }
        }
        // TODO: - add email format check here
        // TODO: - add a logout somewhere
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let navVc = segue.destination as! UINavigationController
        let channelVc = navVc.viewControllers.first as! ChannelListTableViewController
        
        channelVc.senderDisplayName = textFieldEmail?.text
    }
    
}