//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Brian Wilson on 10/23/21.
//

import Foundation
import UIKit

class UdacityAPI {
    
    struct Auth {
        static var accountId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        case session
        case students
        case studentLocation
        case userData
        
        var stringValue: String {
            switch self {
            case .session: return Endpoints.base + "session"
            case .students: return Endpoints.base + "StudentLocation?limit=100&order=-updatedAt"
            case .studentLocation: return Endpoints.base + "StudentLocation"
            case .userData: return Endpoints.base + "users/" + Auth.accountId
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, response, error)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 200 {
                let newData = data.subdata(in: 5..<data.count)
                UserDefaults.standard.set(true, forKey: UserDefaults.Keys.isLoggedIn.rawValue)
                completion(true, httpResponse, nil)
                let decoder = JSONDecoder()
                do {
                    let userAccount = try decoder.decode(PostSessionResponse.self, from: newData)
                    Auth.accountId = userAccount.account.key
                } catch {
                    completion(false, httpResponse, error)
                }
            } else {
                //Not Authorized
                completion(false, httpResponse, nil)
            }
        }
        task.resume()
    }
    
    class func getStudentLocations(completion: @escaping ([StudentInformation]?, URLResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.students.url) { data, response, error in
            guard let data = data else {
                completion(nil, response, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let studentLocations = try decoder.decode(StudentLocationResponse.self, from: data)
                completion(studentLocations.results, response, nil)
            } catch  {
                completion(nil, response, error)
            }
        }
        task.resume()
    }
    
    class func getUserInformation(completion: @escaping (PublicUserDataResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.userData.url) { data, response, error in
            guard let data = data else {
                return
            }
            let newData = data.subdata(in: 5..<data.count)
            let decoder = JSONDecoder()
            do {
                let userInfo = try decoder.decode(PublicUserDataResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion(userInfo, nil)
                }
            } catch  {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func postStudentLocation(studentInfo: PostStudentLocation, completion: @escaping (PostStudentLocationResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.studentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(studentInfo)
       
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(PostStudentLocationResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(response, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func logout() {
        UserDefaults.standard.reset()
        UdacityAPI.deleteSession()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
    
    class func deleteSession() {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStoraage = HTTPCookieStorage.shared
        for cookie in sharedCookieStoraage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let _ = data else {
                //Error
                return
            }
        }
        task.resume()
    }
}



