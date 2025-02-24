//
//  Difficulty.swift
//  WithoutEyesPuzzle
//
//  Created by 本田輝 on 2025/02/24.
//

import SwiftUI

enum Difficulty {
    case easy, normal, hard

    /// 🎯 難易度に応じた制限時間（秒数）を返す
    var timeLimit: Int {
        switch self {
        case .easy: return 180
        case .normal: return 120
        case .hard: return 60
        }
    }
}
