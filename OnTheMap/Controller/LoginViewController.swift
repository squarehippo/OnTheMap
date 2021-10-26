//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Brian Wilson on 10/23/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        print("Logged in pressed...waiting to commence.")
        UdacityClient.login(username: username.text ?? "", password: password.text ?? "") { loggedIn, error in
            DispatchQueue.main.async {
                if loggedIn {
                    self.performSegue(withIdentifier: "loggedIn", sender: nil)
                    print("Success!")
                } else {
                    print("No dice!")
                }
            }
        }
    }
}
