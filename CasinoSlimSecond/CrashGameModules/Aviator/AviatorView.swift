import SwiftUI

struct AviatorView: View {
    @StateObject var viewModel =  AviatorViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var isSettings = false
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.black, Color(red: 46/255, green: 4/255, blue: 26/255), Color.black], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Button(action: {
                            NotificationCenter.default.post(name: Notification.Name("RefreshData"), object: nil)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("back")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                        
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
                                            
                                            Text("\(viewModel.coin)")
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
                            isSettings = true
                        }) {
                            Image("settings")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                    }
                    .padding(.horizontal)
                    
                    Rectangle()
                        .fill(LinearGradient(colors: [Color(red: 55/255, green: 55/255, blue: 55/255),
                                                      Color(red: 23/255, green: 23/255, blue: 23/255),
                                                      Color(red: 47/255, green: 47/255, blue: 47/255)], startPoint: .top, endPoint: .bottom))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white, lineWidth: 4)
                                .overlay {
                                    VStack(spacing: 15) {
                                        ZStack(alignment: .bottomLeading) {
                                            Image("rectPlane")
                                                .resizable()
                                                .frame(height: 250)
                                               
                                            
                                            Image("plane")
                                                .resizable()
                                                .frame(width: 60, height: 30)
                                                .offset(x: viewModel.planePositionX, y: viewModel.planePositionY)
                                                .rotationEffect(Angle(degrees: viewModel.planeRotation))
                                        }
                                        
                                        Rectangle()
                                            .fill(LinearGradient(colors: [Color(red: 55/255, green: 55/255, blue: 55/255),
                                                                          Color(red: 23/255, green: 23/255, blue: 23/255),
                                                                          Color(red: 47/255, green: 47/255, blue: 47/255)], startPoint: .top, endPoint: .bottom))
                                            .overlay {
                                                Text("BONUS: \(viewModel.multiplierString)")
                                                    .font(.custom("MPLUS1p-Bold", size: 18))
                                                    .foregroundStyle(Color(red: 181/255, green: 181/255, blue: 181/255))
                                            }
                                            .frame(height: 40)
                                            .cornerRadius(6)
                                        
                                        VStack(spacing: 5) {
                                            Text("BET COST")
                                                .font(.custom("MPLUS1p-Bold", size: 16))
                                                .foregroundStyle(Color(red: 236/255, green: 117/255, blue: 117/255))
                                            
                                            ZStack {
                                                Rectangle()
                                                    .fill(LinearGradient(colors: [Color(red: 55/255, green: 55/255, blue: 55/255),
                                                                                  Color(red: 23/255, green: 23/255, blue: 23/255),
                                                                                  Color(red: 47/255, green: 47/255, blue: 47/255)], startPoint: .top, endPoint: .bottom))
                                                    .overlay {
                                                        Text("\(viewModel.bet)")
                                                            .font(.custom("MPLUS1p-Bold", size: 16))
                                                            .foregroundStyle(Color(red: 181/255, green: 181/255, blue: 181/255))
                                                    }
                                                    .frame(height: 40)
                                                    .cornerRadius(6)
                                                
                                                HStack {
                                                    Button(action: {
                                                        if (viewModel.bet + 50) <= viewModel.coin {
                                                            viewModel.bet += 50
                                                        }
                                                    }) {
                                                        Rectangle()
                                                            .fill(LinearGradient(colors: [Color(red: 234/255, green: 221/255, blue: 146/255),
                                                                                          Color(red: 215/255, green: 133/255, blue: 26/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                            .overlay {
                                                                RoundedRectangle(cornerRadius: 8)
                                                                    .stroke(.white)
                                                                    .overlay {
                                                                        Text("+")
                                                                            .font(.custom("MPLUS1p-Bold", size: 26))
                                                                            .foregroundStyle(Color(red: 158/255, green: 56/255, blue: 15/255))
                                                                            .offset(y: -2)
                                                                    }
                                                            }
                                                            .frame(width: 40, height: 40)
                                                            .cornerRadius(8)
                                                            .shadow(color: .yellow.opacity(0.7), radius: 3, y: 2)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    Button(action: {
                                                        if viewModel.bet >= 100 {
                                                            viewModel.bet -= 50
                                                        }
                                                    }) {
                                                        Rectangle()
                                                            .fill(LinearGradient(colors: [Color(red: 234/255, green: 221/255, blue: 146/255),
                                                                                          Color(red: 215/255, green: 133/255, blue: 26/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                            .overlay {
                                                                RoundedRectangle(cornerRadius: 8)
                                                                    .stroke(.white)
                                                                    .overlay {
                                                                        Text("-")
                                                                            .font(.custom("MPLUS1p-Bold", size: 26))
                                                                            .foregroundStyle(Color(red: 158/255, green: 56/255, blue: 15/255))
                                                                            .offset(y: -2)
                                                                    }
                                                            }
                                                            .frame(width: 40, height: 40)
                                                            .cornerRadius(8)
                                                            .shadow(color: .yellow.opacity(0.7), radius: 3, y: 2)
                                                    }
                                                }
                                            }
                                        }
                                        
                                        HStack {
                                            Button(action: {
                                                withAnimation {
                                                    if !viewModel.isPlaying {
                                                        viewModel.startGame()
                                                    }
                                                }
                                            }) {
                                                Rectangle()
                                                    .fill(LinearGradient(colors: [Color(red: 234/255, green: 221/255, blue: 146/255),
                                                                                  Color(red: 215/255, green: 133/255, blue: 26/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(.white)
                                                            .overlay {
                                                                Text("BET")
                                                                    .font(.custom("MPLUS1p-Bold", size: 18))
                                                                    .foregroundStyle(Color(red: 158/255, green: 56/255, blue: 15/255))
                                                            }
                                                    }
                                                    .frame(height: 40)
                                                    .cornerRadius(8)
                                                    .shadow(color: .yellow.opacity(0.7), radius: 3, y: 2)
                                            }
                                        }
                                        
                                        VStack(spacing: 5) {
                                            Text("WALLET")
                                                .font(.custom("MPLUS1p-Bold", size: 16))
                                                .foregroundStyle(Color(red: 236/255, green: 117/255, blue: 117/255))
                                            
                                            Rectangle()
                                                .fill(LinearGradient(colors: [Color(red: 55/255, green: 55/255, blue: 55/255),
                                                                              Color(red: 23/255, green: 23/255, blue: 23/255),
                                                                              Color(red: 47/255, green: 47/255, blue: 47/255)], startPoint: .top, endPoint: .bottom))
                                                .overlay {
                                                    Text("\(viewModel.reward)")
                                                        .font(.custom("MPLUS1p-Bold", size: 16))
                                                        .foregroundStyle(Color(red: 181/255, green: 181/255, blue: 181/255))
                                                }
                                                .frame(height: 40)
                                                .cornerRadius(6)
                                        }
                                        
                                        Button(action: {
                                            withAnimation {
                                                if !viewModel.isPlaying {
                                                    
                                                } else {
                                                    viewModel.collectReward()
                                                }
                                            }
                                        }) {
                                            Rectangle()
                                                .fill(LinearGradient(colors: [Color(red: 234/255, green: 221/255, blue: 146/255),
                                                                              Color(red: 215/255, green: 133/255, blue: 26/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(.white)
                                                        .overlay {
                                                            Text("TAKE COINS")
                                                                .font(.custom("MPLUS1p-Bold", size: 18))
                                                                .foregroundStyle(Color(red: 158/255, green: 56/255, blue: 15/255))
                                                        }
                                                }
                                                .frame(height: 40)
                                                .cornerRadius(8)
                                                .shadow(color: .yellow.opacity(0.7), radius: 3, y: 2)
                                        }
                                        
                                        Image("tutorFly")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 160)
                                    }
                                    .padding(.horizontal)
                                }
                        }
                        .frame(height: 780)
                        .cornerRadius(16)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .fullScreenCover(isPresented: $isSettings) {
            SettingsView()
        }
    }
}

#Preview {
    AviatorView()
}

