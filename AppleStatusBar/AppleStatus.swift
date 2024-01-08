//
//  AppleStatus.swift
//  AppleStatusBar
//
//  Created by Sean Hong on 1/8/24.
//

import Foundation

// MARK: - AppleStatus
struct AppleStatus: Decodable {
    let drMessage: String?
    let drpost: Bool
    let services: [Service]
}

// MARK: - Service
struct Service: Decodable {
    let events: [Event]
    let redirectURL: String?
    let serviceName: String
}

// MARK: - Event
struct Event: Decodable {
    let usersAffected: String
    let epochStartDate, epochEndDate: Int
    let messageId, statusType, datePosted, startDate: String
    let endDate: String
    let affectedServices: [String]?
    let eventStatus, message: String
}

enum StatusIndicator: String {
    case available, issue, outage
    
    var icon: String {
        switch self {
        case .available: "🟢"
        case .issue: "🟠"
        case .outage: "🔴"
        }
    }
}
