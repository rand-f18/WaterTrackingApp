import SwiftUI

struct WaterIntakeView: View {
    @State private var currentWaterIntake: Double = 0.0
    @EnvironmentObject var waterIntakeModel: WaterIntakeModel // Access the shared model

    var body: some View {
        VStack() {
            Text("Today's Water Intake")
                .foregroundColor(Color(hex: "636366"))
                .font(.system(size: 16))
                .padding(.trailing, 200)
                .padding(.bottom, 5)

            HStack(spacing: 10) {
                Text("\(currentWaterIntake, specifier: "%.1f") liter")
                    .foregroundColor(currentWaterIntake >= waterIntakeModel.targetWaterIntake ? .green : .black)
                Text("/")
                Text("\(waterIntakeModel.targetWaterIntake, specifier: "%.1f") liter")
                    .foregroundColor(.black)
            }
            .bold()
            .font(.system(size: 22))
            .padding(.trailing, 170)
            .padding(.bottom, 80)

            WaterIntakeProgressView(currentWaterIntake: $currentWaterIntake, targetWaterIntake: waterIntakeModel.targetWaterIntake)

            Text("\(currentWaterIntake, specifier: "%.1f") L")
                .font(.system(size: 22))
                .bold()
                .foregroundColor(.black)
                .padding(.top, 100)

            Stepper(value: $currentWaterIntake, in: 0...waterIntakeModel.targetWaterIntake, step: 0.1) {
                            
                        }
                        .disabled(currentWaterIntake >= waterIntakeModel.targetWaterIntake)
                        .padding(.trailing, 130)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

struct WaterIntakeProgressView: View {
    @Binding var currentWaterIntake: Double
    let targetWaterIntake: Double

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 300, height: 300) // Increased size

            Circle()
                .stroke(Color(hex: "F2F2F7"), lineWidth: 25) // Widened track
                .frame(width: 300, height: 300)

            Circle()
                .trim(from: 0, to: currentWaterIntake / targetWaterIntake)
                .stroke(style: StrokeStyle(lineWidth: 25, lineCap: .round, lineJoin: .round)) // Widened blue tracker
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "32ADE6"), Color(hex: "57B8FF")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 300, height: 300)
                .rotationEffect(.degrees(-90))


            if currentWaterIntake == 0 {
                Image(systemName: "zzz")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .foregroundColor(.yellow)
            } else if currentWaterIntake <= targetWaterIntake / 4 {
                Image(systemName: "zzz")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .foregroundColor(.yellow)
            } else if currentWaterIntake <= targetWaterIntake / 2 {
                Image(systemName: "tortoise.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.yellow)
            } else if currentWaterIntake <= (3 * targetWaterIntake / 4) {
                Image(systemName: "hare.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.yellow)
            } else {
                Image(systemName: "hands.clap.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct ContentView_Previews2: PreviewProvider {
    static var previews: some View {
        WaterIntakeView()
            .environmentObject(WaterIntakeModel()) // Provide a mock model for preview
    }
}
