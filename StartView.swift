//
//  StartView.swift
//  WithoutEyesPuzzle
//
//  Created by 本田輝 on 2025/02/24.
//

import SwiftUI

struct StartView: View {
    @Binding var showGame: Bool
    @Binding var showTutorial: Bool
    @Binding var difficulty: Difficulty
    @Binding var remainingTime: Int

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("🎮 Without Eyes Puzzle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
                
                // 🎯 Difficulty Selection
                Text("Select Difficulty")
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()

                // 🔊 注意書きを追加
                Text("🔊 Please play with sound enabled for the best experience.")
                    .foregroundColor(.red)
                    .font(.body)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button(action: {
                    difficulty = .easy
                    remainingTime = Difficulty.easy.timeLimit  // 🎯 Easy → 180 sec
                    showGame = true
                }) {
                    Text("Easy")
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    difficulty = .normal
                    remainingTime = Difficulty.normal.timeLimit  // 🎯 Normal → 120 sec
                    showGame = true
                }) {
                    Text("Normal")
                        .frame(width: 200, height: 50)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    difficulty = .hard
                    remainingTime = Difficulty.hard.timeLimit  // 🎯 Hard → 60 sec
                    showGame = true
                }) {
                    Text("Hard")
                        .frame(width: 200, height: 50)
                        .background(Color.red)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
            
            // 🎯 Help button (Navigate to tutorial screen)
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
}
