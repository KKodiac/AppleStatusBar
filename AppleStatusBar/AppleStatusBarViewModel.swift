//
//  AppleStatusBarViewModel.swift
//  AppleStatusBar
//
//  Created by Sean Hong on 1/8/24.
//

import Foundation
import os

class AppleStatusBarViewModel: ObservableObject {
    @Published var status: AppleStatus? = nil
    @Published var indicator: StatusIndicator = .available
    
    private let appleStatusUrl: String = "https://www.apple.com/support/systemstatus/data/developer/system_status_en_US.js"
    private let logger: Logger = Logger(
        subsystem: AppleStatusBarApp.subsystem,
        category: "ViewModel"
    )
    
    func scheduleAppleStatus() {
        let url = URL(string: appleStatusUrl)!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                self.logger.error("Error during status request: \(error)")
                return
            }
            guard let data = data else {
                self.logger.error("Error during status data: Unable to read response data")
                return
            }
            let parsedContent = String(data: data, encoding: .utf8)!
                .replacingOccurrences(of: "jsonCallback(", with: "")
                .replacingOccurrences(of: ");", with: "")
            
            let decoder = JSONDecoder()
            
            do {
                let appleStatus = try decoder.decode(AppleStatus.self, from: parsedContent.data(using: .utf8)!)
                self.updateStatus(appleStatus)
                self.logger.log("Status: \(self.status.debugDescription)")
            } catch {
                self.logger.error("Error during data decoding: \(error)")
                return
            }
        }.resume()
    }
    
    func showEventStatus(_ events: [Event]) -> StatusIndicator {
        if events.contains(where: {
            event in event.eventStatus == StatusIndicator.issue.rawValue
        }) { return .issue }
        
        if events.contains(where: {
            event in event.eventStatus == StatusIndicator.outage.rawValue
        }) { return .outage }
        
        return .available
    }
    
    private func updateStatus(_ newStatus: AppleStatus) {
        DispatchQueue.main.async {
            self.status = newStatus
        }
    }
}
