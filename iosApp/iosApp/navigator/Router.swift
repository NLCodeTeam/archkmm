//
//  Router.swift
//  iosApp
//
//  Created by user on 17.10.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

enum Tab: Int {
    case dashboard, news, profile
}

struct DashboardScreenLink: Hashable {
    var id = UUID().uuidString
}

struct ProfileScreenLink: Hashable {
    var id = UUID().uuidString
}

struct NewsScreenLink: Hashable {
    var id = UUID().uuidString
}

enum ProfileScreenFlow {
    
}


final class Router: ObservableObject {
    @Published var path: NavigationPath = .init()
    @Published var selectedTab: Tab = .dashboard
}
