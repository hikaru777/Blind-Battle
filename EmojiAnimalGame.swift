import SwiftUI
import AVFoundation

struct PlacedEmoji: Identifiable {
    let id = UUID()
    let emoji: String
    let position: CGPoint
}

@available(iOS 17.0, *)
struct HiddenEmojiGame: View {
    @StateObject private var audioManager = AudioManager()
    @State private var targetPoints: [CGPoint] = []  // 配置すべきポイント
    @State private var placedEmojis: [PlacedEmoji] = []  // 配置済みの絵文字（使用済み targetPoint は削除）
    @State private var currentDragPosition: CGPoint = .zero
    @State private var isDragging: Bool = false
    @State private var pitchValue: Float = 440  // 初期値: 440Hz (A4)
    @State private var startTime: Date? = nil  // ゲーム開始時間
    @Binding var remainingTime: Int
    @State private var touchPoints: [CGPoint] = []  // 軌跡を記録する配列
    @State private var timer: Timer?
    @State private var isEnded: Bool = false
    var difficulty: Difficulty
    @Environment(\.presentationMode) var presentationMode
    
    let emojis = ["🐶", "🐱", "🐸", "🐵"]
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            ZStack {
                
                Path { path in
                    guard !touchPoints.isEmpty else { return }
                    path.move(to: touchPoints.first!)
                    for point in touchPoints.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(Color.black.opacity(0.5), lineWidth: 3)
                
                ForEach(placedEmojis) { placed in
                    Text(placed.emoji)
                        .font(.system(size: 50))
                        .position(placed.position)
                }
                
                if !targetPoints.isEmpty {
                    
                    Color.black.ignoresSafeArea()
                        .opacity(isEnded ? 0 : 1)
                    
                    // 🟢 残りの置くべき場所の個数を表示
                    Text("Remaining: \(targetPoints.count)")
                        .foregroundColor(targetPoints.isEmpty ? .black : .white)
                        .font(.title2)
                        .bold()
                        .padding()
                        .position(x: screenWidth / 2, y: 90)
                        .opacity(isEnded ? 0 : 1)
                    // ⏳ 経過時間の表示
                    Text("⏳ \(remainingTime) sec")
                        .foregroundColor(targetPoints.isEmpty ? .black : .white)
                        .font(.title2)
                        .bold()
                        .padding()
                        .position(x: screenWidth / 2, y: 50)
                        .opacity(isEnded ? 0 : 1)
                }
                
                if targetPoints.isEmpty {
                    VStack(spacing: 30) {
                        Text("🎉 Game Cleared! 🎉")
                            .foregroundColor(.green)
                            .font(.largeTitle)
                            .transition(.opacity)
                        Text("⏳ \(remainingTime) sec")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 30))
                }

                // 🔹 タイムアップ時の表示
                if remainingTime <= 0 && !targetPoints.isEmpty {
                    VStack(spacing: 30) {
                        Text("⏳ Time's up! Better luck next time!")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                            .transition(.opacity)
                        Text("Found: \(placedEmojis.count)")
                            .foregroundColor(.black)
                            .font(.title2)
                            .bold()
                            .onAppear {
                                isEnded = true
                                audioManager.stopSound()
                            }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 30))
                }
                
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                currentDragPosition = value.location
                                isDragging = true
                                
                                // 軌跡を記録
                                touchPoints.append(value.location)
                                
                                let frequency = calculateFrequency(for: value.location)
                                pitchValue = frequency
                                audioManager.updatePitch(frequency: frequency)
                                
                            }
                            .onEnded { _ in
                                if let snappedPosition = closestTargetPoint(to: currentDragPosition) {
                                    let randomEmoji = emojis.randomElement() ?? "🐶"
                                    
                                    let adjustedPosition = CGPoint(
                                        x: snappedPosition.x + CGFloat.random(in: -5...5),
                                        y: snappedPosition.y + CGFloat.random(in: -5...5)
                                    )
                                    let newPlaced = PlacedEmoji(emoji: randomEmoji, position: adjustedPosition)
                                    placedEmojis.append(newPlaced)
                                    
                                    if let index = targetPoints.firstIndex(where: { distance(from: $0, to: snappedPosition) < 10 }) {
                                        targetPoints.remove(at: index)
                                        audioManager.updatePitch(frequency: 880)
                                    }
                                }
                                isDragging = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    audioManager.stopSound()
                                }
                            }
                    )
                    .onAppear {
                        generateTargetPoints(screenWidth: screenWidth, screenHeight: screenHeight)
                        generateTargetPoints(screenWidth: screenWidth, screenHeight: screenHeight)
                        
                        if startTime == nil {
                            startTime = Date()
                            
                            // 🔹 `timer` をセット
                            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                DispatchQueue.main.async {
                                    if remainingTime > 0 {
                                        remainingTime -= 1
                                    } else {
                                        timer?.invalidate()
                                        timer = nil
                                    }
                                }
                            }
                            RunLoop.main.add(timer!, forMode: .common) // 🔹 メインスレッドで動作させる
                        }
                    }
                    .onChange(of: targetPoints) { newValue in
                        if newValue.isEmpty {
                            timer?.invalidate()  // 🔹 すべてのターゲットが配置されたらタイマーを止める
                            timer = nil
                        }
                    }
                    .disabled(targetPoints.isEmpty)
                    .disabled(remainingTime <= 0)
            }
            .overlay {
                // 🔹 戻るボタン（ゲームクリア時・タイムアップ時共通）
                if targetPoints.isEmpty || remainingTime <= 0 {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()  // 🎯 画面を閉じる
                            }) {
                                Text("Return to Start")
                                    .frame(width: 200, height: 50)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                    }
                }
            }
        }
    }
    
    func generateTargetPoints(screenWidth: CGFloat, screenHeight: CGFloat) {
        let count = 15
        let minDistance: CGFloat = 50
        var points: [CGPoint] = []
        let maxAttempts = 1000
        var attempts = 0
        
        while points.count < count && attempts < maxAttempts {
            let candidate = CGPoint(
                x: CGFloat.random(in: 50...(screenWidth - 50)),
                y: CGFloat.random(in: 100...(screenHeight - 100))
            )
            if points.allSatisfy({ distance(from: candidate, to: $0) >= minDistance }) {
                points.append(candidate)
            }
            attempts += 1
        }
        targetPoints = points
    }
    
    func closestTargetPoint(to position: CGPoint) -> CGPoint? {
        return targetPoints.first { candidate in
            distance(from: position, to: candidate) < 10
        }
    }
    
    func calculateFrequency(for position: CGPoint) -> Float {
        let closestPoint = targetPoints.min { distance(from: position, to: $0) < distance(from: position, to: $1) }
        let dist = closestPoint.map { distance(from: position, to: $0) } ?? 100
        
        let minFrequency: Float = 220
        let maxFrequency: Float = 660
        let normalizedDist = min(dist / 100, 1)
        
        let frequencyRange = maxFrequency - minFrequency
        let frequencyScale = 1 - normalizedDist
        let frequency = minFrequency + frequencyRange * Float(frequencyScale)
        
        return frequency
    }
    
    func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        let dx = p1.x - p2.x
        let dy = p1.y - p2.y
        return sqrt(dx * dx + dy * dy)
    }
}
