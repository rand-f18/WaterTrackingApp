//
//  Calculation.swift
//  Hydrate
//
//  Created by Rand Soliman Alobaid on 19/04/1446 AH.
//

import SwiftUI
import Combine

class WaterIntakeModel: ObservableObject {
    @Published var weight: String = "" {
        didSet {
            // Update targetWaterIntake whenever weight changes
            if let weightValue = Double(weight), weightValue > 0 {
                targetWaterIntake = weightValue * 0.03
            } else {
                targetWaterIntake = 2.7 // Default value if invalid
            }
        }
    }
    
    @Published var targetWaterIntake: Double = 2.7
}
