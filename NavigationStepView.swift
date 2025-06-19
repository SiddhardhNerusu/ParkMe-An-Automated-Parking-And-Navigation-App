import SwiftUI

struct NavigationStepView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 16) {
                Text("Navigation In Progress")
                    .font(.headline)
                Text(navigationManager.currentInstruction)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                ProgressView()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
    }
}
