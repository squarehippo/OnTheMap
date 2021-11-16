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
        activityIndicator.startAnimating()
        guard let username = username.text, let password = password.text else {
            self.createAlert(title: "Missing Information", message: "Please provide a username and password")
            activityIndicator.stopAnimating()
            return
        }
        UdacityAPI.login(username: username, password: password, completion: handleLoginResponse(success: response: error:))
    }
    
    private func handleLoginResponse(success: Bool, response: URLResponse?, error: Error?) -> Void {
        DispatchQueue.main.async {
            if error != nil {
                self.createAlert(title: "Network Error", message: "Please try again")
                return
            } else if success {
                //If login succeeds define location of new root controller and go.
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                
            } else {
                self.createAlert(title: "Login Not Successful", message: "Invalid username or password")
                self.activityIndicator.stopAnimating()
                return
            }
        }
    }
    
    private func createAlert(title: String, message: String) {
        let alertMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertMessage.addAction(ok)
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        if let url = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com") {
            UIApplication.shared.open(url)
        }
    }
    
}

