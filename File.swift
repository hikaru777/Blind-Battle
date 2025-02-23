//
//  File.swift
//  WithoutEyesPuzzle
//
//  Created by 本田輝 on 2025/02/24.
//

import Foundation
import SwiftUI

extension CGPoint: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
