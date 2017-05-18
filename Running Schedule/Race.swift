//
//  Race.swift
//  RunningSchedule
//
//  Created by Luís Machado on 21/03/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

enum raceType: String {
    case estrada = "Road"
    case trail = "Trail"
    case other = "Other"
}

class Race: NSObject {
    var id: String?
    var name: String?
    var date: String?
    var posterUrl: String?
    var locationName: String?
    var locationCoordinates: String?
    var type: raceType?
    var typeName: String?
    var distances: String?
    var webpage: String?
}
