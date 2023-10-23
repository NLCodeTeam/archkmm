import SwiftUI

@main
struct iOSApp: App {
    
    @StateObject private var router = Router()
    
	var body: some Scene {
		WindowGroup {
            NavigationStack(path: $router.path) {
                ContentView().navigationBarTitleDisplayMode(.inline)
            }.environmentObject(router)
		}
	}
}
