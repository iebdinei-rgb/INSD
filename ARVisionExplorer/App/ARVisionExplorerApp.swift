import SwiftUI

@main
struct ARVisionExplorerApp: App {
    @StateObject private var arViewModel = ARViewModel()
    @StateObject private var avatarViewModel = AvatarViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(arViewModel)
                .environmentObject(avatarViewModel)
                .preferredColorScheme(.dark)
                .statusBarHidden(true)
        }
    }
}
