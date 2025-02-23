import SwiftUI

@available(iOS 17.0, *)
@main
struct MyApp: App {
    @State private var showGame = false
    @State private var showTutorial = false
    @State private var difficulty: Difficulty = .normal  // 初期値: 普通

    var body: some Scene {
        WindowGroup {
            StartView(showGame: $showGame, showTutorial: $showTutorial, difficulty: $difficulty)
                .fullScreenCover(isPresented: $showGame) {
                    HiddenEmojiGame(difficulty: difficulty)
                }
                .fullScreenCover(isPresented: $showTutorial) {
                    TutorialView(showTutorial: $showTutorial)
                }
        }
    }
}
