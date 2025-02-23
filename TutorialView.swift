
import SwiftUI

struct TutorialView: View {
    @Binding var showTutorial: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("📖 チュートリアル")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
                
                Text("1. 指でドラッグして絵文字を配置\n2. 音の高さが変わる\n3. すべての場所に配置できたらクリア！")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                
                // 🔹 戻るボタン
                Button(action: {
                    showTutorial = false  // 🔹 `fullScreenCover` を閉じる
                }) {
                    Text("スタート画面へ戻る")
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}
