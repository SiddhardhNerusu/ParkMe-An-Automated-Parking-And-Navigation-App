import SwiftUI

struct SideMenuView: View {
    var onSettingsTap: () -> Void
    var onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Menu")
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                }
            }
            .padding()

            Button("Settings", action: onSettingsTap)
                .padding(.horizontal)
                .padding(.top)

            Spacer()
        }
        .frame(maxWidth: 280)
        .background(.ultraThinMaterial)
        .edgesIgnoringSafeArea(.all)
    }
}
