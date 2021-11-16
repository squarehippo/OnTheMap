//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Brian Wilson on 11/3/21.
//

import UIKit
import CoreLocation

class FindLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func findLocationPressed(_ sender: UIButton) {
        getLocation(from: locationTextField.text ?? "") { location in
            if !(self.linkTextField.text?.isEmpty ?? false) {
                if let location = location {
                    self.performSegue(withIdentifier: "showLocationSegue", sender: location)
                } else {
                    let alert = UIAlertController(title: "No Location Found", message: "Please try a different location.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: self.locationHandler))
                    self.present(alert, animated: true)
                }
            } else {
                let alert = UIAlertController(title: "Missing Link", message: "Please provide a url.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: self.linkHandler))
                self.present(alert, animated: true)
            }
        }
    }
    
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location?.coordinate else {
                      completion(nil)
                      return
                  }
            completion(location)
        }
    }
    
    func locationHandler(alert: UIAlertAction!) {
        locationTextField.text = ""
        locationTextField.becomeFirstResponder()
    }
    
    func linkHandler(alert: UIAlertAction!) {
        linkTextField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let location = sender as? CLLocationCoordinate2D {
            let destinationVC = segue.destination as! AddLocationViewController
            destinationVC.location = location
            destinationVC.mediaLink = linkTextField.text
            destinationVC.mapString = locationTextField.text
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
