//
//  StartView.swift
//  WithoutEyesPuzzle
//
//  Created by 本田輝 on 2025/02/24.
//

import SwiftUI
import MediaPlayer  // 🔹 追加

struct StartView: View {
    @Binding var showGame: Bool
    @Binding var showTutorial: Bool
    @Binding var difficulty: Difficulty
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("🎮 Without Eyes Puzzle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
                
                // 🎯 難易度選択
                Button(action: {
                    setVolume(for: .easy)
                    difficulty = .easy
                    showGame = true
                }) {
                    Text("簡単")
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    setVolume(for: .normal)
                    difficulty = .normal
                    showGame = true
                }) {
                    Text("普通")
                        .frame(width: 200, height: 50)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    setVolume(for: .hard)
                    difficulty = .hard
                    showGame = true
                }) {
                    Text("難しい")
                        .frame(width: 200, height: 50)
                        .background(Color.red)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
            
            // 🎯 右上の「？」ボタン（チュートリアル画面へ遷移）
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showTutorial = true
                    }) {
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
    }
    
    // 🎯 難易度に応じて音量を変更
    func setVolume(for difficulty: Difficulty) {
        let volume: Float
        switch difficulty {
        case .easy: volume = 0.8
        case .normal: volume = 0.5
        case .hard: volume = 0.3
        }

        DispatchQueue.main.async {
            // 一時的に MPVolumeView を表示（隠しておく）
            let volumeView = MPVolumeView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            if let window = UIApplication.shared.windows.first {
                window.addSubview(volumeView) // UI に追加（隠れている）
            }

            if let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
                slider.value = volume // 音量を変更
                slider.sendActions(for: .touchUpInside) // 変更を適用
            }

            // 0.5秒後に MPVolumeView を削除（UI を邪魔しないように）
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                volumeView.removeFromSuperview()
            }
        }
    }
}
