//
//  File.swift
//  WithoutEyesPuzzle
//
//  Created by 本田輝 on 2025/02/24.
//


import MediaPlayer

@MainActor func showVolumeControl() {
    let volumeView = MPVolumeView()
    volumeView.frame = CGRect(x: 1000, y: 1000, width: 0, height: 0) // 画面上に表示
    if let window = UIApplication.shared.windows.first {
        window.addSubview(volumeView)
    }
}
