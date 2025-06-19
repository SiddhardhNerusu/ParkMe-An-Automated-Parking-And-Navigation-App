import SwiftUI



struct LoginView: View {
    @EnvironmentObject var accountManager: AccountManager
    @Binding var isLoggedIn: Bool

    
    @State private var email = ""
    @State private var password = ""
    @State private var userID = ""
    @State private var licensePlate = ""
    @State private var carMake = ""
    @State private var carType = ""
    @State private var profileImage: UIImage?
    @State private var showImagePicker = false
    @State private var isSignUp = false
    @State private var errorMessage = ""
    @State private var showPassword = false
    @State private var passwordStrength: PasswordStrength = .weak

    var body: some View {
        ZStack {
            Color(red: 230/255, green: 242/255, blue: 255/255)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Text(isSignUp ? "Create Account" : "Welcome Back")
                        .font(.largeTitle.bold())
                        .foregroundColor(.black)

                    if isSignUp {
                        CustomTextField(placeholder: "User ID", text: $userID)
                        CustomLicensePlateField(licensePlate: $licensePlate)
                        CustomTextField(placeholder: "Car Make", text: $carMake)
                        CustomTextField(placeholder: "Car Type", text: $carType)

                        Button(action: { showImagePicker = true }) {
                            if let image = profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .strokeBorder(Color.blue, lineWidth: 2)
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Text("Add\nPhoto")
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.blue)
                                    )
                            }
                        }
                    }

                    CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)

                    CustomSecureField(
                        placeholder: "Password",
                        text: $password,
                        showPassword: $showPassword
                    )

                    if isSignUp {
                        HStack {
                            PasswordStrengthBar(strength: passwordStrength)
                            Text(passwordStrength.rawValue)
                                .font(.caption)
                                .foregroundColor(passwordStrength.color)
                        }
                    }

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    Button(action: handlePrimaryAction) {
                        Text(isSignUp ? "Sign Up" : "Log In")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#FF2E84"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    Button {
                        isSignUp.toggle()
                        errorMessage = ""
                    } label: {
                        Text(isSignUp ? "Already have an account? Log In" : "No account? Sign Up")
                            .font(.footnote)
                            .foregroundColor(Color(hex: "#FF2E84"))
                    }

                    Button("Skip Login") {
                        isLoggedIn = true
                    }
                    .foregroundColor(.gray)
                    .padding(.top, 6)
                }
                .padding()
                .padding(.top, 40)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $profileImage)
        }
        .onChange(of: password) { newValue in
            passwordStrength = calculatePasswordStrength(newValue)
        }
    }

    private func handlePrimaryAction() {
        if isSignUp {
            guard !email.isEmpty, !password.isEmpty, !userID.isEmpty, !licensePlate.isEmpty else {
                errorMessage = "Fill all fields"
                return
            }

            let newAccount = UserAccount(
                email: email,
                password: password,
                userID: userID,
                licensePlate: licensePlate,
                carMake: carMake,
                carType: carType,
                profileImage: profileImage
            )

            if accountManager.register(newAccount) {
                errorMessage = ""
                isSignUp = false
            } else {
                errorMessage = "Account already exists"
            }
        } else {
            if accountManager.login(email: email, password: password) {
                errorMessage = ""
                isLoggedIn = true
            } else {
                errorMessage = "Incorrect credentials"
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

