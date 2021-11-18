//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Brian Wilson on 11/3/21.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentURLLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocationCoordinate2D!
    var mediaLink: String!
    var mapString: String!
    var userFirstName: String?
    var userLastName: String?
    var uniqueKey: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentLatitude = location.latitude
        let currentLongitude = location.longitude
        let currentLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        mapView.centerToLocation(currentLocation)
        
        UdacityAPI.getUserInformation { [self] user, error in
            if let user = user {
                userFirstName = user.firstName
                userLastName = user.lastName
                uniqueKey = user.uniqueKey
                
                let newPin = MKPointAnnotation()
                newPin.title = user.firstName
                newPin.coordinate = self.location
                self.mapView.addAnnotation(newPin)
                
                self.studentNameLabel.text = userFirstName! + " " + userLastName!
                self.studentURLLabel.text = mediaLink
                self.latitudeLabel.text = "\(currentLatitude)"
                self.longitudeLabel.text = "\(currentLongitude)"
            }
        }
    }
    
    
    @IBAction func addLocationPressed(_ sender: UIButton) {
        let newPinInformation = PostStudentLocation(
            uniqueKey: uniqueKey ?? "",
            firstName: userFirstName ?? "",
            lastName: userLastName ?? "",
            mapString: mapString,
            mediaURL: mediaLink,
            latitude: location.latitude,
            longitude: location.longitude
            )
        UdacityAPI.postStudentLocation(studentInfo: newPinInformation) { data, error in
            if data != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            } else {
                self.createAlert(title: "Operation Failed", message: "Please try again later")
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

private extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
      
    setRegion(coordinateRegion, animated: true)
  }
}
