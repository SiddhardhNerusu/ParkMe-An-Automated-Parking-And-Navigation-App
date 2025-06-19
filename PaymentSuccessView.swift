import SwiftUI

struct PaymentSuccessView: View {
    @AppStorage("isNightMode") private var isNightMode = false
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            (isNightMode ? Color.black : Color.white).ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image("parkme_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
                    .shadow(radius: 10)

                Text("Payment Successful")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText(isNightMode: isNightMode))
                Text("Thanks for parking with us!")
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding()
        }
        
        .overlay(
            ConfettiView()
                .allowsHitTesting(false)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        )
        
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isPresented = false
            }
        }
    }
}
