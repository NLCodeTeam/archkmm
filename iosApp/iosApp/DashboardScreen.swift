//
//  DashboardScreen.swift
//  iosApp
//
//  Created by user on 16.10.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct DashboardScreen: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        
        Text("Dashboard Screen Details").font(.largeTitle)
            .backport
            .navigationDestination(for: DashboardScreenLink.self) { _ in DashboardScreenDetails() }
    }
}
            
struct DashboardScreen_Previews: PreviewProvider {
    static var previews: some View {
        DashboardScreen()
    }
}
