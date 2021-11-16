//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Brian Wilson on 10/23/21.
//

import Foundation
import UIKit

class UdacityAPI {
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        case session
        case students
        case studentLocation
        case userData(String)
        
        var stringValue: String {
            switch self {
            case .session: return Endpoints.base + "session"
            case .students: return Endpoints.base + "StudentLocation?limit=100&order=-updatedAt"
            case .studentLocation: return Endpoints.base + "StudentLocation"
            case .userData(let userId): return Endpoints.base + "users/" + userId
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
                completion(true, httpResponse, nil)
                UserDefaults.standard.set(true, forKey: UserDefaults.Keys.isLoggedIn.rawValue)
                                
                let decoder = JSONDecoder()
                do {
                    let userAccount = try decoder.decode(PostSessionResponse.self, from: newData)
                    let userKey = userAccount.account.key
                    UserDefaults.standard.set(userKey, forKey: UserDefaults.Keys.uniqueKey.rawValue)
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
    
    class func getStudentInformation(completion: @escaping ([StudentInformation]?, URLResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.students.url) { data, response, error in
            guard let data = data else {
                completion(nil, response, error)
                return
            }
            //let newData = data.subdata(in: 5..<data.count)
            let decoder = JSONDecoder()
            do {
                let studentInfo = try decoder.decode(PostStudentLocation.self, from: data)
                completion(studentInfo.results, nil, nil)
            } catch  {
                print("Error", error)
            }
        }
        task.resume()
    }
    
    class func getUserInformation(userId: String, completion: @escaping (PublicUserData?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.userData(userId).url) { data, response, error in
            guard let data = data else {
                return
            }
            //print("GetUserInformation = ", String(data: data, encoding: .utf8))
            let newData = data.subdata(in: 5..<data.count)
            let decoder = JSONDecoder()
            do {
                let userInfo = try decoder.decode(PublicUserData.self, from: data)
                completion(userInfo, nil)
            } catch  {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func postStudentInformation(studentInfo: StudentInformation, completion: @escaping (Bool, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.studentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.httpBody = Data(studentInfo
       
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
              // Handle error…
              return
          }
          print(String(data: data!, encoding: .utf8)!)
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



