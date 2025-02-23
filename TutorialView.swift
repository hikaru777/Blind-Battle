//import SwiftUI
//import AVFoundation
//import ARKit
//
//struct TutorialView: View {
//    @State private var fingerPosition: CGPoint? = CGPoint(x: UIScreen.main.bounds.width - 100, y: UIScreen.main.bounds.height / 2) // 画面右側中央に初期配置
//    @State private var squarePosition: CGPoint? = nil   // 出現する四角の位置
//    @State private var isDragging: Bool = false         // ドラッグ中かどうか
//    @State private var offset: CGSize = .zero           // ドラッグによるオフセット
//    @State private var snapped: Bool = false            // 中央にスナップ済みかどうか
//    @State private var isFingerPlaced: Bool = false     // 指を置いたかどうか
//    @State private var isEyesClosed: Bool = false       // 目を閉じたかどうか
//    @State private var audioPlayer: AVAudioPlayer?
//    
//    @StateObject private var faceTracking = FaceTrackingManager()  // 目の検知用
//    
//    var body: some View {
//        GeometryReader { geometry in
//            let center = CGPoint(x: geometry.size.width / 2,
//                                 y: geometry.size.height / 2)
//            
//            ZStack {
//                Color.black.ignoresSafeArea()
//                
//                // プロンプトテキスト
//                VStack {
//                    Spacer()
//                    if !isFingerPlaced {
//                        Text("指を置いてください")
//                            .foregroundColor(.white)
//                            .font(.title2)
//                            .padding()
//                    } else if !isEyesClosed {
//                        Text("目を閉じてください")
//                            .foregroundColor(.white)
//                            .font(.title2)
//                            .padding()
//                    } else if squarePosition == nil {
//                        Text("指を置いていた位置に四角を出しました")
//                            .foregroundColor(.white)
//                            .font(.title2)
//                            .padding()
//                    } else if !snapped {
//                        Text("ドラッグして中央に持って行ってください")
//                            .foregroundColor(.white)
//                            .font(.title2)
//                            .padding()
//                    }
//                    Spacer()
//                }
//                
//                // 中央ターゲット（緑の円）
//                Circle()
//                    .stroke(Color.green, lineWidth: 2)
//                    .frame(width: 100, height: 100)
//                    .position(center)
//                
//                // 最初から画面右側にホワホワする円を表示
//                if let pos = fingerPosition {
//                    PulsatingCircle()
//                        .frame(width: 100, height: 100)
//                        .position(pos)
//                }
//                
//                // 四角（存在する場合のみ）
//                if let pos = squarePosition {
//                    Rectangle()
//                        .fill(Color.blue)
//                        .frame(width: 80, height: 80)
//                        .position(x: pos.x + offset.width, y: pos.y + offset.height)
//                        .animation(.easeInOut(duration: 0.3), value: isDragging)
//                }
//                
//                // 指を置くタップジェスチャー
//                Color.clear
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .contentShape(Rectangle())
//                    .gesture(
//                        DragGesture(minimumDistance: 0)
//                            .onChanged { value in
//                                if !isFingerPlaced {
//                                    fingerPosition = value.location
//                                    squarePosition = value.location
//                                    isFingerPlaced = true
//                                }
//                                offset = value.translation
//                            }
//                            .onEnded { _ in
//                                if let pos = squarePosition {
//                                    let newPosition = CGPoint(
//                                        x: pos.x + offset.width,
//                                        y: pos.y + offset.height
//                                    )
//                                    let dx = newPosition.x - center.x
//                                    let dy = newPosition.y - center.y
//                                    let distance = sqrt(dx * dx + dy * dy)
//                                    
//                                    if distance < 30 {
//                                        withAnimation {
//                                            squarePosition = center
//                                            snapped = true
//                                            offset = .zero
//                                        }
//                                        playUnlockSound()
//                                    } else {
//                                        squarePosition = newPosition
//                                        offset = .zero
//                                    }
//                                }
//                            }
//                    )
//            }
//            .onChange(of: faceTracking.areEyesClosed) { newValue in
//                if newValue && isFingerPlaced && !isEyesClosed {
//                    // 目を閉じたことを検知
//                    isEyesClosed = true
//                    playUnlockSound()
//
//                    // 目を閉じたら四角を出す
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        withAnimation {
//                            squarePosition = fingerPosition
//                        }
//                    }
//                } else if !newValue && isEyesClosed {
//                    // 目を開いたことを検知
//                    isEyesClosed = false
//                    print("目を開きました！") // ここに目を開いたときの処理を追加
//                }
//            }
//        }
//    }
//    
//    // アンロック音を鳴らす関数
//    func playUnlockSound() {
//        guard let soundURL = Bundle.main.url(forResource: "unlock", withExtension: "mp3") else { return }
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
//            audioPlayer?.play()
//        } catch {
//            print("Failed to play sound: \(error)")
//        }
//    }
//}
//
//// ホワホワする円のビュー
//struct PulsatingCircle: View {
//    @State private var animate = false
//
//    var body: some View {
//        ZStack {
//            Circle()
//                .stroke(Color.white.opacity(0.4), lineWidth: 2)
//                .frame(width: 80, height: 80)
//                .scaleEffect(animate ? 1.3 : 1.0)
//                .opacity(animate ? 0.2 : 1)
//                .animation(Animation.easeOut(duration: 1.2).repeatForever(autoreverses: true), value: animate)
//            
//            Circle()
//                .stroke(Color.white.opacity(0.6), lineWidth: 2)
//                .frame(width: 60, height: 60)
//                .scaleEffect(animate ? 1.2 : 1.0)
//                .opacity(animate ? 0.3 : 1)
//                .animation(Animation.easeOut(duration: 1.0).repeatForever(autoreverses: true), value: animate)
//            
//            Circle()
//                .stroke(Color.white.opacity(0.8), lineWidth: 2)
//                .frame(width: 40, height: 40)
//                .scaleEffect(animate ? 1.1 : 1.0)
//                .opacity(animate ? 0.5 : 1)
//                .animation(Animation.easeOut(duration: 0.8).repeatForever(autoreverses: true), value: animate)
//        }
//        .onAppear {
//            animate = true
//        }
//    }
//}
