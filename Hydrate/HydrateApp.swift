//
//  HydrateApp.swift
//  Hydrate
//
//  Created by Rand Soliman Alobaid on 17/04/1446 AH.
//

import SwiftUI

@main
struct HydrateApp: App {
    @StateObject private var waterIntakeModel = WaterIntakeModel() // Create the model instance

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(waterIntakeModel) // Pass the model to the environment
        }
    }
}
