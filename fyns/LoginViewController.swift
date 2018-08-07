//
//  LoginViewController.swift
//  fyns
//
//  Created by Eric de La Varende on 31/07/2018.
//  Copyright © 2018 Eric de La Varende. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func navigate(_ sender: UIButton) {
        print("navigate")
        if let emailText = email.text, emailText.count > 4, let passwordText = password.text, passwordText.count > 4 {
            let urlPath = "http://localhost:3001/api/users"
            var json = [String:Any]()
            json["email"] = emailText
            json["password"] = passwordText
            
            HttpRequest.post(url: urlPath, data: json){ (output) in
                if let id = output["id"] {
                    print(output)
                    DispatchQueue.main.async{
                        print(id)
                        UserDefaults.standard.set(id, forKey: "id")
                        UserDefaults.standard.set(true, forKey: "status")
                        Switcher.updateRootVC()
                    }
                }
                
            }
        } else {
            print("error")
            //UserDefaults.standard.set(7, forKey: "id")
            //UserDefaults.standard.set(true, forKey: "status")
            //Switcher.updateRootVC()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
