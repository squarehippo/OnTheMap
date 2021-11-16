//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Brian Wilson on 10/23/21.
//

import UIKit
import MapKit
//import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var students = [StudentInformation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        //self.title = "On The Map"
        
        UdacityAPI.getStudentInformation { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    self.students = data
                    for student in self.students {
                        let studentLatitude = Double(student.latitude)
                        let studentLongitude = Double(student.longitude)
                        let currentStudent = MKPointAnnotation()
                        currentStudent.title = student.firstName
                        currentStudent.subtitle = student.mediaURL
                        currentStudent.coordinate = CLLocationCoordinate2D(latitude: studentLatitude, longitude: studentLongitude)
                        self.mapView.addAnnotation(currentStudent)
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "custom"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "user")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view:MKAnnotationView) {
        let tapGesture = UITapGestureRecognizer(target:self,  action:#selector(calloutTapped(sender:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.removeGestureRecognizer(view.gestureRecognizers!.first!)
    }
    
    @objc func calloutTapped(sender:UITapGestureRecognizer) {
        let view = sender.view as! MKAnnotationView
        if let annotation = view.annotation as? MKPointAnnotation {
            if let url = URL(string: annotation.subtitle ?? "") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        UdacityAPI.getStudentInformation { data, response, error in
            DispatchQueue.main.async {
                for annotation in self.mapView.annotations {
                    self.mapView.removeAnnotation(annotation)
                }
                if let data = data {
                    self.students = data
                    for student in self.students {
                        let studentLatitude = Double(student.latitude)
                        let studentLongitude = Double(student.longitude)
                        let currentStudent = MKPointAnnotation()
                        currentStudent.title = student.firstName
                        currentStudent.subtitle = student.mediaURL
                        currentStudent.coordinate = CLLocationCoordinate2D(latitude: studentLatitude, longitude: studentLongitude)
                        self.mapView.addAnnotation(currentStudent)
                    }
                }
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        UdacityAPI.logout()
    }
    
    
}
