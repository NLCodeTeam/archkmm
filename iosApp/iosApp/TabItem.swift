//
//  TabItem.swift
//  iosApp
//
//  Created by user on 18.10.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct TabItem: View {
    @EnvironmentObject var router: Router
    
    var tab: Tab
    
    init(tab: Tab) {
        self.tab = tab
    }
    
    var body: some View {
        switch tab {
        case .dashboard:
            DashboardScreen().environmentObject(router)
        case .news:
            NewsScreen()
        case .profile:
            ProfileScreen().environmentObject(router)
        }
    }
}
