import SwiftUI

struct SettingsView: View {
    @StateObject var settingsModel =  SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingImagePicker = false
    @State private var showNameAlert = false
    @State private var inputName = ""
    @State var showAlert = false
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.black, Color(red: 46/255, green: 4/255, blue: 26/255), Color.black], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Rectangle()
                            .fill(LinearGradient(colors: [Color(red: 55/255, green: 55/255, blue: 55/255),
                                                          Color(red: 23/255, green: 23/255, blue: 23/255),
                                                          Color(red: 47/255, green: 47/255, blue: 47/255)], startPoint: .top, endPoint: .bottom))
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(red: 41/255, green: 41/255, blue: 41/255))
                                    .overlay {
                                        HStack(spacing: 10) {
                                            Image("energy")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 18, height: 26)
                                            
                                            Text("\(settingsModel.energy)")
                                                .font(.custom("MPLUS1p-Bold", size: 16))
                                                .foregroundStyle(Color(red: 195/255, green: 165/255, blue: 219/255))
                                        }
                                        .offset(x: -5)
                                    }
                            }
                            .frame(width: 110, height: 35)
                            .cornerRadius(20)
                            .shadow(color: Color(red: 51/255, green: 13/255, blue: 132/255), radius: 5)
                        
                        Spacer()
                        
                        Rectangle()
                            .fill(LinearGradient(colors: [Color(red: 55/255, green: 55/255, blue: 55/255),
                                                          Color(red: 23/255, green: 23/255, blue: 23/255),
                                                          Color(red: 47/255, green: 47/255, blue: 47/255)], startPoint: .top, endPoint: .bottom))
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(red: 41/255, green: 41/255, blue: 41/255))
                                    .overlay {
                                        HStack(spacing: 10) {
                                            Image("coin")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 16, height: 16)
                                            
                                            Text("\(settingsModel.coin)")
                                                .font(.custom("MPLUS1p-Bold", size: 16))
                                                .foregroundStyle(Color(red: 219/255, green: 187/255, blue: 165/255))
                                        }
                                        .offset(x: -2)
                                    }
                            }
                            .frame(width: 110, height: 35)
                            .cornerRadius(20)
                            .shadow(color: Color(red: 72/255, green: 8/255, blue: 8/255), radius: 5)
                        
                        Spacer()
                        
                        Button(action: {
                            NotificationCenter.default.post(name: Notification.Name("RefreshData"), object: nil)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("back")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                    }
                    .padding(.horizontal)
                    
                    Rectangle()
                        .fill(LinearGradient(colors: [Color(red: 63/255, green: 5/255, blue: 5/255),
                                                      Color(red: 73/255, green: 23/255, blue: 8/255),
                                                      Color(red: 22/255, green: 2/255, blue: 2/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 41/255, green: 41/255, blue: 41/255))
                                .overlay {
                                    VStack(spacing: 5) {
                                        HStack {
                                            ZStack(alignment: .leading) {
                                                Image("nameRect")
                                                    .resizable()
                                                    .frame(height: 45)
                                                    .aspectRatio(contentMode: .fit)
                                                
                                                Text(settingsModel.playerName)
                                                    .font(.custom("MPLUS1p-Bold", size: 18))
                                                    .foregroundStyle(LinearGradient(colors: [Color(red: 255/255, green: 243/255, blue: 196/255),
                                                                                             Color(red: 241/255, green: 220/255, blue: 138/255),
                                                                                             Color(red: 216/255, green: 119/255, blue: 41/255),
                                                                                             Color(red: 245/255, green: 143/255, blue: 121/255)], startPoint: .top, endPoint: .bottom))
                                                    .padding(.horizontal)
                                            }
                                            
                                            Button(action: {
                                                inputName = settingsModel.playerName
                                                        showNameAlert = true
                                            }) {
                                                Image("edit")
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                            }
                                            .alert("Enter your nickname", isPresented: $showNameAlert, actions: {
                                                     TextField("Nickname", text: $inputName)
                                                         .textInputAutocapitalization(.words)
                                                     Button("OK") {
                                                         settingsModel.savePlayerName(inputName)
                                                     }
                                                     Button("Cancel", role: .cancel) {}
                                                 }, message: {
                                                     Text("Please, enter nickname")
                                                 })
                                        }
                                        .padding(.horizontal)
                                        
                                        HStack(spacing: 20) {
                                            if let avatar = settingsModel.avatarImage {
                                                Image(uiImage: avatar)
                                                    .resizable()
                                                    .frame(width: 100, height: 100)
                                                    .clipShape(Circle())
                                                    .padding(.horizontal)
                                                    .padding(.vertical, 15)
                                                    .overlay(
                                                        Button(action: {
                                                            isShowingImagePicker = true
                                                        }) {
                                                            ZStack(alignment: .bottom) {
                                                                Path { path in
                                                                    let center = CGPoint(x: 50, y: 50)
                                                                    let radius: CGFloat = 51
                                                                    path.addArc(center: center, radius: radius,
                                                                                startAngle: .degrees(180), endAngle: .degrees(360),
                                                                                clockwise: true)
                                                                    path.addLine(to: center)
                                                                }
                                                                .fill(Color.black.opacity(0.5))
                                                                .offset(x: 16, y: 15)
                                                                
                                                                Image("camera")
                                                                    .resizable()
                                                                    .frame(width: 32, height: 32)
                                                                    .offset(y: -25)
                                                            }
                                                        }
                                                            .sheet(isPresented: $isShowingImagePicker) {
                                                                ImagePicker(image: $settingsModel.avatarImage)
                                                                    .onDisappear {
                                                                        if let img = settingsModel.avatarImage {
                                                                            settingsModel.saveAvatar(img)
                                                                        }
                                                                    }
                                                            }
                                                    )
                                                    .frame(width: 100, height: 100)
                                            } else {
                                                Image("playerCircle")
                                                    .resizable()
                                                    .overlay {
                                                        Text("P")
                                                            .font(.custom("MPLUS1p-Bold", size: 56))
                                                            .foregroundStyle(Color(red: 171/255, green: 84/255, blue: 11/255))
                                                    }
                                                    .overlay(
                                                        Button(action: {
                                                            isShowingImagePicker = true
                                                        }) {
                                                            ZStack(alignment: .bottom) {
                                                                Path { path in
                                                                    let center = CGPoint(x: 50, y: 50)
                                                                    let radius: CGFloat = 44
                                                                    path.addArc(center: center, radius: radius,
                                                                                startAngle: .degrees(180), endAngle: .degrees(360),
                                                                                clockwise: true)
                                                                    path.addLine(to: center)
                                                                }
                                                                .fill(Color.black.opacity(0.5))
                                                                
                                                                Image("camera")
                                                                    .resizable()
                                                                    .frame(width: 32, height: 32)
                                                                    .offset(y: -12)
                                                            }
                                                        }
                                                            .sheet(isPresented: $isShowingImagePicker) {
                                                                ImagePicker(image: $settingsModel.avatarImage)
                                                                    .onDisappear {
                                                                        if let img = settingsModel.avatarImage {
                                                                            settingsModel.saveAvatar(img)
                                                                        }
                                                                    }
                                                            }
                                                    )
                                                    .frame(width: 100, height: 100)
                                            }
                                            
                                            LazyVGrid(columns: [GridItem(.flexible(minimum: 50, maximum: 50)),
                                                                GridItem(.flexible(minimum: 50, maximum: 50)),
                                                                GridItem(.flexible(minimum: 50, maximum: 50)),
                                                                GridItem(.flexible(minimum: 50, maximum: 50))]) {
                                                ForEach(2..<8, id: \.self) { index in
                                                    if index >= 2 {
                                                        Button(action: {
                                                            showAlert = true
                                                        }) {
                                                            ZStack {
                                                                Image("pers\(index+1)")
                                                                    .resizable()
                                                                    .frame(width: 55, height: 55)
                                                                
                                                                Image("locked")
                                                                    .resizable()
                                                                    .frame(width: 24, height: 24)
                                                            }
                                                        }
                                                        .alert("You can unlock avatars in shop", isPresented: $showAlert) {
                                                            Button("OK") {}
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }
                        }
                        .frame(height: 185)
                        .cornerRadius(12)
                        .shadow(color: Color(red: 232/255, green: 133/255, blue: 33/255).opacity(0.4), radius: 15)
                        .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        ZStack(alignment: .leading) {
                            Image("redShadow")
                                .resizable()
                                .frame(height: 60)
                            
                            Text("Settings")
                                .font(.custom("MPLUS1p-Bold", size: 18))
                                .foregroundStyle(Color(red: 243/255, green: 175/255, blue: 175/255))
                                .padding(.horizontal, 30)
                        }
                        
                        VStack {
                            Rectangle()
                                .fill(LinearGradient(colors: [Color(red: 55/255, green: 55/255, blue: 55/255),
                                                              Color(red: 23/255, green: 23/255, blue: 23/255),
                                                              Color(red: 47/255, green: 47/255, blue: 47/255)], startPoint: .top, endPoint: .bottom))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 41/255, green: 41/255, blue: 41/255))
                                        .overlay {
                                            VStack(spacing: 20) {
                                                HStack {
                                                    Image("sound")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 24, height: 24)
                                                    
                                                    Text("Sound")
                                                        .font(.custom("MPLUS1p-Bold", size: 14))
                                                        .foregroundStyle(Color(red: 176/255, green: 176/255, blue: 176/255))
                                                    
                                                    Toggle("", isOn: $settingsModel.isSoundOn)
                                                        .toggleStyle(CustomToggleStyle())
                                                }
                                                
                                                HStack {
                                                    Image("music")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 24, height: 24)
                                                    
                                                    Text("Music")
                                                        .font(.custom("MPLUS1p-Bold", size: 14))
                                                        .foregroundStyle(Color(red: 176/255, green: 176/255, blue: 176/255))
                                                    
                                                    Toggle("", isOn: $settingsModel.isMusicOn)
                                                        .toggleStyle(CustomToggleStyle())
                                                }
                                                
                                                HStack {
                                                    Image("vibration")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 24, height: 24)
                                                    
                                                    Text("Vibration")
                                                        .font(.custom("MPLUS1p-Bold", size: 14))
                                                        .foregroundStyle(Color(red: 176/255, green: 176/255, blue: 176/255))
                                                    
                                                    Toggle("", isOn: $settingsModel.isVib)
                                                        .toggleStyle(CustomToggleStyle())
                                                }
                                                
                                                HStack {
                                                    Image("notif")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 24, height: 24)
                                                    
                                                    Text("Notifications")
                                                        .font(.custom("MPLUS1p-Bold", size: 14))
                                                        .foregroundStyle(Color(red: 176/255, green: 176/255, blue: 176/255))
                                                    
                                                    Toggle("", isOn: $settingsModel.isNotifOn)
                                                        .toggleStyle(CustomToggleStyle())
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                }
                                .frame(width: 260, height: 205)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
        }
    }
}

#Preview {
    SettingsView()
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? Color(red: 239/255, green: 24/255, blue: 17/255) : Color(red: 121/255, green: 121/255, blue: 121/255))
                .frame(width: 48, height: 24)
                .overlay(
                    Circle()
                        .fill(configuration.isOn ? Color(red: 250/255, green: 198/255, blue: 198/255) : Color(red: 176/255, green: 176/255, blue: 176/255))
                        .frame(width: 20, height: 20)
                        .offset(x: configuration.isOn ? 12 : -12)
                        .animation(.easeInOut, value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selected = info[.originalImage] as? UIImage {
                parent.image = selected
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
