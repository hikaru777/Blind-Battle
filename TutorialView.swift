import SwiftUI

struct TutorialView: View {
    @Binding var showTutorial: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("📖 How to Play")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("🎯 **Objective**")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                        
                        Text("Your goal is to place all emojis correctly by using only sound cues. The pitch of the sound will help you determine the right position.")
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .font(.body)
                        
                        Divider().background(Color.white)
                        
                        Text("🖐 **Controls**")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                        
                        Text("""
                        - **Tap and Drag:** Touch anywhere on the screen and drag to move your finger around.
                        - **Listen to the Sound:** The pitch changes based on your proximity to the correct placement.
                        - **Release to Place:** When you think you are close, release your finger to drop the emoji.
                        """)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .font(.body)
                        
                        Divider().background(Color.white)
                        
                        Text("🔊 **How Sound Works**")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                        
                        Text("""
                        - A **higher pitch** means you are close to the correct spot.
                        - A **lower pitch** means you are far away.
                        - The goal is to move until you hear the highest pitch before releasing.
                        """)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .font(.body)
                        
                        Divider().background(Color.white)
                        
                        Text("⏳ **Game Rules**")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                        
                        Text("""
                        - You have a **limited time** to place all emojis.
                        - If you run out of time before placing them all, the game ends.
                        - The game is completed when all emojis are placed in their correct positions.
                        """)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .font(.body)
                    }
                    .padding(.horizontal)
                    
                    // 🔹 Return button
                    Button(action: {
                        showTutorial = false  // 🔹 Close `fullScreenCover`
                    }) {
                        Text("Return to Start")
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding(.vertical, 30)
            }
        }
    }
}
