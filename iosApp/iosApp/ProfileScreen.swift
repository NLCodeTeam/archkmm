//
//  ProfileScreen.swift
//  iosApp
//
//  Created by user on 16.10.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        Button(action: {
            router.path.append(DashboardScreenLink())
            router.path.append(ProfileScreenLink())
        } ){
            HStack {
                Spacer()
                Text("Login").foregroundColor(Color.white).bold()
                Spacer()
            }
        }
        .accentColor(Color.gray)
        .padding()
        .background(Color(UIColor.lightGray))
        .cornerRadius(4.0)
        .padding(Edge.Set.vertical, 20)
        .frame(width: 100.0, height: 40.0)
        
        .backport.navigationDestination(for: DashboardScreenLink.self) {
            _  in DashboardScreenDetails()
        }.backport.navigationDestination(for: ProfileScreenLink.self) {
            _  in ProfileScreenDetails()
        }
    }
    
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
