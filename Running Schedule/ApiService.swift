//
//  ApiService.swift
//  RunningSchedule
//
//  Created by Luís Machado on 01/04/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    enum ApiError : Error {
        case JsonError(String)
    }
    
    static let sharedInstance = ApiService()
    
    func fetchRaces(completion: @escaping ([Race]?, _ error:Error?) -> ()) {
        
        let url = URL(string: "https://s3.eu-west-2.amazonaws.com/running-app/running_json.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async(execute: {
                    completion(nil, error)
                })
                print(error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                var races = [Race]()
                
                guard let dictionary = json as? [String:AnyObject] else { completion(nil, ApiError.JsonError("Json Error")); return }
                guard let racesList = dictionary["nodes"] as? NSArray else { completion(nil, ApiError.JsonError("Json Error")); return }
                
                for raceNode in racesList {
                    if let race = raceNode as? [String:AnyObject], let raceInfo = race["node"] {
                        let race = Race()
                        
                        if let moreInfoHref = raceInfo["+ info"] as? NSString {
                            race.webpage = moreInfoHref as String
                        }
                        
                        if let title = raceInfo["title"] as? NSString {
                            race.name = title as String
                        }
                        
                        if let location = raceInfo["Localidade"] as? String {
                            race.locationName = location
                        }
                        
                        if let distances = raceInfo["Distância"] as? String {
                            race.distances = distances
                        }
                        
                        if let imageInfo = raceInfo["field_image"] as? [String:AnyObject] {
                            if let imageUrl = imageInfo["src"] as? String {
                                race.posterUrl = imageUrl
                            }
                        }
                        
                        if let date = raceInfo["Data"] as? String {
                            race.date = date
                        }
                        
                        if let type = raceInfo["Tipo"] as? String {
                            race.typeName = type
                            
                            if type == "Estrada" {
                                race.type = raceType.estrada
                            } else if type == "Trail" {
                                race.type = raceType.trail
                            } else {
                                race.type = raceType.other
                            }
                        }
                        
                        races.append(race)
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    completion(races, nil)
                })
                
            } catch let jsonError {
                print(jsonError)
                DispatchQueue.main.async(execute: {
                    completion(nil, jsonError)
                })
                
            }
        }.resume()
        
    }
}
