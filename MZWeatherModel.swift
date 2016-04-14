//
//  MZWeatherModel.swift
//  MZWeatherSplash
//
//  Created by 张逸 on 16/4/14.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit

class MZWeatherModel: AnyObject {
    let minDegree: Int
    let maxDegree: Int
    let status1: String
    let status2: String
    init(withXML xml: XMLIndexer) {
        minDegree = Int(xml["Profiles"]["Weather"]["temperature2"].element?.text ?? "0") ?? 0
        maxDegree = Int(xml["Profiles"]["Weather"]["temperature1"].element?.text ?? "0") ?? 0
        status1 = xml["Profiles"]["Weather"]["status1"].element?.text ?? "null"
        status2 = xml["Profiles"]["Weather"]["status2"].element?.text ?? "null"
    }
}
