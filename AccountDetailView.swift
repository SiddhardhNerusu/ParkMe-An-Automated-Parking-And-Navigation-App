import SwiftUI

struct AccountDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var accountManager: AccountManager

    @State private var updatedUser: UserAccount
    @State private var showImagePicker = false
    @State private var showPassword = false
    @State private var newPassword = ""
    @State private var oldPassword = ""
    @State private var passwordStrength: PasswordStrength = .weak
    @State private var showConfirmationAlert = false

    init() {
        if let user = AccountManager().currentUser {
            _updatedUser = State(initialValue: user)
        } else {
            _updatedUser = State(initialValue: UserAccount(
                email: "", password: "", userID: "", licensePlate: "",
                carMake: "", carType: "", profileImage: nil
            ))
        }
    }

    var body: some View {
        NavigationView {
            Form {
               
                Section(header: Text("PROFILE PICTURE")) {
                    Button(action: { showImagePicker = true }) {
                        if let image = updatedUser.profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .strokeBorder(style: StrokeStyle(lineWidth: 2))
                                .frame(width: 100, height: 100)
                                .overlay(Text("Add\nPhoto").multilineTextAlignment(.center))
                        }
                    }
                }

 
                Section(header: Text("LOGIN DETAILS")) {
                    TextField("Email", text: $updatedUser.email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)

                    SecureField("Current Password", text: $oldPassword)
                        .textContentType(.password)

                    HStack {
                        if showPassword {
                            TextField("New Password", text: $newPassword)
                        } else {
                            SecureField("New Password", text: $newPassword)
                        }
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .onChange(of: newPassword) { newValue in
                        passwordStrength = calculatePasswordStrength(newValue)
                    }

                    HStack {
                        PasswordStrengthBar(strength: passwordStrength)
                        Text(passwordStrength.rawValue)
                            .font(.caption)
                            .foregroundColor(passwordStrength.color)
                    }
                }


                Section(header: Text("ACCOUNT DETAILS")) {
                    TextField("User ID", text: $updatedUser.userID)

                    ZStack {
                        if updatedUser.licensePlate.isEmpty {
                            Text("LICENSE PLATE")
                                .font(.system(size: 28, weight: .bold, design: .monospaced))
                                .foregroundColor(.black)
                        }
                        TextField("", text: $updatedUser.licensePlate)
                            .keyboardType(.asciiCapable)
                            .textCase(.uppercase)
                            .onChange(of: updatedUser.licensePlate) { newValue in
                                updatedUser.licensePlate = String(newValue.prefix(7))
                            }
                            .font(.system(size: 28, weight: .bold, design: .monospaced))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 12)
                    }
                    .frame(height: 55)
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    .foregroundColor(.black)

                    TextField("Car Make", text: $updatedUser.carMake)
                    TextField("Car Type", text: $updatedUser.carType)
                }
            }
            .navigationTitle("Your Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        showConfirmationAlert = true
                    }
                }
            }
            .alert("Edit Details?", isPresented: $showConfirmationAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Sure", role: .destructive) {
                    if oldPassword == accountManager.currentUser?.password {
                        if !newPassword.isEmpty {
                            updatedUser.password = newPassword
                        }
                        accountManager.updateCurrentUser(updatedUser)
                        dismiss()
                    }
                }
            } message: {
                Text("Are you sure you want to save changes to your account?")
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: Binding(
                    get: { updatedUser.profileImage },
                    set: { newImage in
                        updatedUser.profileImageData = newImage?.jpegData(compressionQuality: 0.8)
                    }
                ))
            }
        }
    }

    private func calculatePasswordStrength(_ password: String) -> PasswordStrength {
        let length = password.count
        let hasNumbers = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasSymbols = password.rangeOfCharacter(from: CharacterSet.punctuationCharacters) != nil
        if length >= 8 && hasNumbers && hasSymbols {
            return .strong
        } else if length >= 6 && hasNumbers {
            return .medium
        } else {
            return .weak
        }
    }
}
