//
//  ExplanationView.swift
//  WithoutEyesPuzzle
//
//  Created by 本田輝 on 2025/02/23.
//


import SwiftUI

struct ExplanationView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("遊び方")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("このゲームでは、目を閉じてプレイします。")
                .foregroundColor(.white)
            Text("画面の端を長押しするとピースが出現し、指を離すと固定されます。")
                .foregroundColor(.white)
            Text("まずは、以下のチュートリアルで操作を体験してください。")
                .foregroundColor(.white)
            
//            NavigationLink(destination: TutorialView()) {
//                Text("チュートリアル開始")
//                    .font(.title2)
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(width: 220)
//                    .background(Color.green)
//                    .cornerRadius(10)
//            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
    }
}
