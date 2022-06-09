//
//  Log.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import Foundation

import Foundation
import os.log

public struct Log {
    public static var general = OSLog(subsystem: "com.iremtosun.newsApp.Mobilium", category: "general")
    public static var network = OSLog(subsystem: "com.iremtosun.newsApp.Mobilium", category: "network")
    public static var data = OSLog(subsystem: "com.iremtosun.newsApp.Mobilium", category: "data")
}
