import SwiftUI
import AVFoundation

struct HiddenEmojiGame: View {
    @StateObject private var audioManager = AudioManager()
    @State private var targetPoints: [CGPoint] = []  // 配置すべきポイント
    @State private var placedEmojis: [PlacedEmoji] = []  // 配置済みの絵文字（使用済みのtargetPointは除外）
    @State private var currentDragPosition: CGPoint = .zero
    @State private var isDragging: Bool = false
    @State private var pitchValue: Float = 440  // 初期値: 440Hz (A4)
    @State private var totalScore: Int = 0

    // 使用する絵文字を限定
    let emojis = ["🐶", "🐱", "🐸", "🐵"]

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height

            ZStack {
                Color.black.ignoresSafeArea()

                // 配置数表示
                Text("\(placedEmojis.count) / \(targetPoints.count + placedEmojis.count)")
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
                    .padding()
                    .position(x: screenWidth / 2, y: 50)

                // ドラッグ中の音の高さ表示
                if isDragging {
                    Text("🎶 \(Int(pitchValue)) Hz")
                        .foregroundColor(.white)
                        .font(.title2)
                        .position(x: screenWidth / 2, y: 80)
                }

                // タップ＆ドラッグで絵文字を配置する透明レイヤー
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                currentDragPosition = value.location
                                isDragging = true

                                let frequency = calculateFrequency(for: value.location)
                                pitchValue = frequency
                                audioManager.updatePitch(frequency: frequency)
                            }
                            .onEnded { _ in
                                if let snappedPosition = closestTargetPoint(to: currentDragPosition) {
                                    let randomEmoji = emojis.randomElement() ?? "🐶"

                                    // 座標を微調整して配置（ランダム性を追加）
                                    let adjustedPosition = CGPoint(
                                        x: snappedPosition.x + CGFloat.random(in: -5...5),
                                        y: snappedPosition.y + CGFloat.random(in: -5...5)
                                    )

                                    let newPlaced = PlacedEmoji(emoji: randomEmoji, position: adjustedPosition)
                                    placedEmojis.append(newPlaced)

                                    // 使用済みのtargetPointは削除する
                                    if let index = targetPoints.firstIndex(where: { distance(from: $0, to: snappedPosition) < 10 }) {
                                        targetPoints.remove(at: index)
                                    }
                                }
                                isDragging = false
                            }
                    )

                // 配置された絵文字の表示
                ForEach(placedEmojis) { placed in
                    Text(placed.emoji)
                        .font(.system(size: 50))
                        .position(placed.position)
                }
            }
            .onAppear {
                generateTargetPoints(screenWidth: geometry.size.width, screenHeight: geometry.size.height)
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

        // ✅ Break the calculation into smaller steps
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

struct PlacedEmoji: Identifiable {
    let id = UUID()
    let emoji: String
    let position: CGPoint
}

struct HiddenEmojiGame_Previews: PreviewProvider {
    static var previews: some View {
        HiddenEmojiGame()
    }
}
