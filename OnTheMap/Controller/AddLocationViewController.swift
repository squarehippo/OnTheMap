//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Brian Wilson on 11/3/21.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var location: CLLocationCoordinate2D!
    var mediaLink: String!
    var mapString: String!
    var uniqueKey = UserDefaults.standard.string(forKey: UserDefaults.Keys.uniqueKey.rawValue)!
    var userFirstName = UserDefaults.standard.string(forKey: UserDefaults.Keys.firstName.rawValue) ?? ""
    var userLastName = UserDefaults.standard.string(forKey: UserDefaults.Keys.lastName.rawValue) ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("This key is: ", uniqueKey)
        UdacityAPI.getUserInformation(userId: uniqueKey) { data, error in
            //print("UserData from Add Location = ", data)
        }

        let currentLatitude = location.latitude
        let currentLongitude = location.longitude
        let currentLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        mapView.centerToLocation(currentLocation)
        
        let newPin = MKPointAnnotation()
        newPin.title = userFirstName
        //newPin.subtitle = student.mediaURL
        newPin.coordinate = location
        self.mapView.addAnnotation(newPin)
    }
    
    
    
    @IBAction func addLocationPressed(_ sender: UIButton) {
        let newPinInformation = PublicUserData(
            uniqueKey: uniqueKey,
            firstName: userFirstName,
            lastName: userLastName,
            mapString: mapString,
            mediaURL: mediaLink,
            latitude: location.latitude,
            longitude: location.longitude
            )
        //UdacityAPI.postStudentInformation(completion: )
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
