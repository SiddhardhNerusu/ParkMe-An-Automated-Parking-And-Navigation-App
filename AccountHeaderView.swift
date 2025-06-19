
import SwiftUI

struct AccountHeaderView: View {
    @EnvironmentObject var accountManager: AccountManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                if let image = accountManager.currentUser?.profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .overlay(Text("👤").font(.largeTitle))
                }

                VStack(alignment: .leading) {
                    Text(accountManager.currentUser?.userID ?? "Guest")
                        .font(.title2.bold())
                    
                    NavigationLink(destination: AccountDetailView()) {
                        Text("View profile")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
            }
        }
        .padding(.vertical)
    }
}
