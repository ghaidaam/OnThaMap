//
//  UdacityAPI.swift
//  OnThaMap
//
//  Created by Ghaida Almahmoud on 13/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class UdacityAPI{
    
    static func postSession(with email: String, password: String, completion: @escaping ([String:Any]?, Error?) -> ()){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
                return
            }
            
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            let result = try! JSONSerialization.jsonObject(with:newData!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
            completion(result, nil)
            
        }
        task.resume()
    }
    
    
    static func deleteSession(completion: @escaping (Error?) -> ()) {
        var requst = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        requst.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {xsrfCookie = cookie}
        }
        if let xsrfCookie = xsrfCookie {
            requst.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: requst) {data, response, error in
            if error != nil{
                completion(error)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            completion(error)
            
        }
        task.resume()
}
    
    class parse{
     
        static func postStudentLocation(lihk: String, locationCoordinate: CLLocationCoordinate2D, locationName: String, completion: @escaping (Error?) ->()) {
            var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
            request.httpMethod = "POST"
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    completion(error)
                    return
                }
                print(String(data: data!, encoding: .utf8)!)
                completion(nil)
            }
            task.resume()
        }
        static func getStudentsLocations(completion: @escaping ([StudentLocation]?, Error?) -> ()){
            let BASE_URL = "https://onthemap-api.udacity.com/v1/StudentLocation"
            var request = URLRequest(url: URL(string: BASE_URL + "?limit=100&order=-updatedAt")!)
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAblr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuwThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Kay")
            let session = URLSession.shared
            let task = session.dataTask(with: request) {data, response, error in
                if error != nil {
                    completion(nil, error)
                    return
                }
                let dict = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String:Any]
                guard let results = dict["results"] as? [[String:Any]] else {return}
                let resultsData = try! JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
                let studentsLocations = try! JSONDecoder().decode([StudentLocation].self, from: resultsData)
                Global.shared.StudentsLocations = studentsLocations
                completion(studentsLocations, nil)
            }
            task.resume()
        }
    }
}
