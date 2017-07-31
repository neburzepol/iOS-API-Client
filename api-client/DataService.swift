//
//  DataService.swift
//  api-client
//
//  Created by Ali Lopez Galaviz on 29/07/17.
//  Copyright © 2017 Ali López Galaviz. All rights reserved.
//

import Foundation

protocol DataServiceDelegate:class {
    func trucksLoaded()
    func reviewsLoaded()
}

class DataService{
    
    static let instance = DataService()
    
    weak var delegate:DataServiceDelegate?
    
    var foodtrucks = [FoodTruck]()
    var reviews = [FoodTruckReview]()
    
    //Get all foodtrucks
    func getAllFoodtrucks(){
        let sessionConfig = URLSessionConfiguration.default
        
        //Create session, and optionally set a URLSessioDelegate
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        // Create request
        // Get all foodtrucks (GET /api/v1/foodtruck)
        guard let url = URL(string: GET_ALL_FT_URL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                //Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session task succeeded: HTTP \(statusCode)")
                if let data = data {
                    self.foodtrucks = FoodTruck.parseFoodTruckJSONData(data: data)
                    self.delegate?.trucksLoaded()
                }
            }else{
                //Failure
                print("URL Session task failed: \(error?.localizedDescription)")
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    // Get all reviews for a specific Food truck
    func getAllReviews(for truck:FoodTruck){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let url = URL(string: "\(GET_ALL_FT_REVIEWS)/\(truck.id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                //Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session task succeeded: HTTP \(statusCode)")
                if let data = data {
                    self.reviews = FoodTruckReview.parseReviewJSONData(data: data)
                    self.delegate?.reviewsLoaded()
                }
            }else{
                //Failure
                print("URL Session task failed: \(error?.localizedDescription)")
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    //POST add a new food truck
    func addNewFoodTruck(_ name:String, foodtype:String, avgcost:Double, latitude:Double, longitude:Double, completion: @escaping callback){
        //Construct our JSON
        let json: [String:Any] = [
            "name":name,
            "foodtype":foodtype,
            "avgcost":avgcost,
            "geometry": [
                "coordinates":[
                    "lat":latitude,
                    "long":longitude
                ],
                "type":"Point"
            ]
        ]
        
        do {
            //Serializer json
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            let sessionConfig = URLSessionConfiguration.default
            
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let url = URL(string: POST_ADD_NEW_TRUCK) else{ return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            guard let token = AuthService.instance.authToken else{
                completion(false)
                return
            }
            
            request.addValue("bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = jsonData
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if error == nil{
                    //Success
                    //Check for status code 200 here. If it's not 200, then
                    //Authotication was not successfull. If it is, we 're done
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session taks succeeded: HTTP \(statusCode)")
                    if statusCode != 200{
                        completion(false)
                        return
                    }else{
                        self.getAllFoodtrucks()
                        completion(true)
                    }
                }else{
                    //Failure
                    print("URL Session task failed: \(error?.localizedDescription)")
                    completion(false)
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
            
        } catch let err {
            print(err)
            completion(false)
        }
        
    }
    
    //POST add new food truck review
    func addNeeReview(_ foodtruckId: String, title:String, text:String, completion: @escaping callback){
        
        let json:[String:Any] = ["title":title,
                                 "text":text,
                                 "foodtruck":foodtruckId
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            guard let url = URL(string: "\(POST_ADD_NEW_REVIEW)/\(foodtruckId)") else{
                completion(false)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            guard let token = AuthService.instance.authToken else{
                completion(false)
                return
            }
            
            request.addValue("bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = jsonData
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if error == nil{
                    //Success
                    //Check for status code 200 here. If it's not 200, then
                    //Authotication was not successfull. If it is, we 're done
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session taks succeeded: HTTP \(statusCode)")
                    if statusCode != 200{
                        completion(false)
                        return
                    }else{
                        completion(true)
                    }
                }else{
                    //Failure
                    print("URL Session task failed: \(error?.localizedDescription)")
                    completion(false)
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()

            
        } catch let error {
            print(error)
            completion(false)
        }
        
    }
    
}
