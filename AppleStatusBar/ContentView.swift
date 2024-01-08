//
//  ContentView.swift
//  AppleStatusBar
//
//  Created by Sean Hong on 1/8/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AppleStatusBarViewModel
    
    var body: some View {
        VStack {
            Text("Apple Developer Status").font(.title)
            ScrollView {
                LazyVStack(alignment: .leading) {
                    if let status = viewModel.status {
                        ForEach(status.services, id: \.self.serviceName) { service in
                            HStack {
                                Label(
                                    title: {
                                        if let redirectUrl = service.redirectURL {
                                            Text("Link")
                                            Link(service.serviceName, destination: URL(string: redirectUrl)!)
                                                .environment(\.openURL, OpenURLAction { url in
                                                    print("Open \(url)")
                                                    return .handled
                                                })
                                        } else {
                                            Text(service.serviceName)
                                        }
                                    }, icon: {
                                        Text(viewModel.showEventStatus(service.events).icon)
                                    }
                                )
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .frame(width: 300, height: 250)
        .onAppear {
            viewModel.scheduleAppleStatus()
        }
    }
}
