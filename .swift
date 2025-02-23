//
//  StartView.swift
//  WithoutEyesPuzzle
//
//  Created by 本田輝 on 2025/02/23.
//


import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Text("触覚パズル")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                NavigationLink(destination: ExplanationView()) {
                    Text("スタート")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .ignoresSafeArea()
        }
    }
}
