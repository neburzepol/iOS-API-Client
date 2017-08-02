//
//  AuthService.swift
//  api-client
//
//  Created by Ali Lopez Galaviz on 01/08/17.
//  Copyright © 2017 Ali López Galaviz. All rights reserved.
//

import Foundation

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isRegistered:Bool? {
        get{
            return defaults.bool(forKey: DEFAULTS_REGISTERED) == true
        }
        set{
            defaults.set(newValue, forKey: DEFAULTS_REGISTERED)
        }
    }
    
    var isAuthenticated: Bool? {
        get{
            return defaults.bool(forKey: DEFAULTS_AUTHENTICATED) == true
        }
        set{
            defaults.set(newValue, forKey: DEFAULTS_AUTHENTICATED)
        }
    }
    
    var email: String?{
        get{
            return defaults.string(forKey: DEFAULTS_EMAIL)
        }
        set{
            defaults.set(newValue, forKey: DEFAULTS_EMAIL)
        }
    }
    
    var authToken: String?{
        get{
            return defaults.string(forKey: DEFAULTS_TOKEN)
        }
        set{
            defaults.set(newValue, forKey: DEFAULTS_TOKEN)
        }
    }
    
    func registerUser(email username:String, password:String, completion:@escaping callback){
        let json:[String:Any] = ["email":username,
                                 "password":password]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            guard let url = URL(string: "\(POST_REGISTER_ACCOUNT)") else{
                isRegistered = false
                completion(false)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = jsonData
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if error == nil{
                    //Success
                    //Check for status code 200 here. If it's not 200, then
                    //Authotication was not successfull. If it is, we 're done
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session taks succeeded: HTTP \(statusCode)")
                    if statusCode != 200 && statusCode != 409{
                        self.isRegistered = false
                        completion(false)
                        return
                    }else{
                        self.isRegistered = true
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
            isRegistered = false
            completion(false)
        }
    }
    
    func logIn(email username:String, password:String, completion:@escaping callback){
        let json:[String:Any] = ["email":username,
                                 "password":password]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            guard let url = URL(string: POST_LOGIN_ACCOUNT) else{
                isAuthenticated = false
                completion(false)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
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
                        guard let data = data else{
                            completion(false)
                            return
                        }
                        
                        do{
                            let result = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? Dictionary<String, Any>
                            if result != nil {
                                if let email = result?["user"] as? String{
                                    if let token = result?["token"] as? String{
                                        //Successfully authenticated and have a token
                                        self.email = email
                                        self.authToken = token
                                        self.isRegistered = true
                                        self.isAuthenticated = true
                                        completion(true)
                                    }else{
                                        completion(false)
                                    }
                                }
                            }else{
                                completion(false)
                            }
                        }catch let err{
                            print(err)
                            completion(false)
                        }
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
