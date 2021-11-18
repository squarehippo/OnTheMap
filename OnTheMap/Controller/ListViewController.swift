//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Brian Wilson on 11/2/21.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var students = [StudentInformation]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UdacityAPI.getStudentLocations { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    self.students = data
                    self.tableView.reloadData()
                } else {
                    self.createAlert(title: "Data Not Available", message: "Please try again later")
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        cell.textLabel?.text = students[indexPath.row].firstName + " " + students[indexPath.row].lastName
        cell.detailTextLabel?.text = students[indexPath.row].mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: students[indexPath.row].mediaURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        UdacityAPI.getStudentLocations { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    self.students = data
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        UdacityAPI.logout()
    }
    
    
}
