import SwiftUI

struct ContentView: View {
    @EnvironmentObject var waterIntakeModel: WaterIntakeModel // Access the shared model
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Image(systemName: "drop.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(hex: "32ADE6"))
                    .frame(height: 56)
                    .padding(.bottom, 15)
                    .padding(.trailing, 300)
                
                Text("Hydrate")
                    .bold()
                    .font(.system(size: 22))
                    .padding(.trailing, 255)
                    .padding(.bottom, 15)
                
                Text("Start with Hydrate to record and track your water intake daily based on your needs and stay hydrated")
                    .foregroundColor(Color(hex: "636366"))
                    .font(.system(size: 17))
                    .padding(.leading, 15)
                    .padding(.trailing, 14)
                    .padding(.bottom, 35)
                
                HStack {
                    ZStack(alignment: .trailing) {
                        TextField("Value", text: $waterIntakeModel.weight)
                            .padding(10)
                            .padding(.leading, 130)
                            .background(Color(hex: "F2F2F7"))
                            .frame(width: 340)
                            .keyboardType(.decimalPad)
                        
                        Text("Body weight")
                            .padding(.trailing, 225)
                        
                        Button(action: {
                            waterIntakeModel.weight = "" // Clear the weight
                        }) {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(Color(hex: "85858B"))
                                .padding(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                    .padding(.bottom, 50)
                }
                
                Spacer()
                
                NavigationLink(destination: Notification()) {
                    Text("Next")
                        .foregroundColor(.white) // White text
                        .frame(width: 355, height: 55)
                        .background(Color(hex: "32ADE6")) // Blue background
                        .cornerRadius(10) // Rounded corners
                }
                .padding(.top, 100)
            }
        }
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

#Preview {
    ContentView()
        .environmentObject(WaterIntakeModel())
}
