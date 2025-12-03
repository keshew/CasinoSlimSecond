import SwiftUI

struct GreenLuckyView: View {
    @StateObject var viewModel =  GreenLuckyViewModel()
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
                                            Image("bgGreen")
                                                .resizable()
                                                .overlay {
                                                    ZStack {
                                                        HStack(spacing: 110) {
                                                            Image("lineGreen")
                                                                .resizable()
                                                                .frame(width: 2, height: 200)
                                                            
                                                            Image("lineGreen")
                                                                .resizable()
                                                                .frame(width: 2, height: 200)
                                                        }
                                                        
                                                        VStack(spacing: 15) {
                                                            ForEach(0..<3, id: \.self) { row in
                                                                HStack(spacing: 40) {
                                                                    ForEach(0..<3, id: \.self) { col in
                                                                        Image(viewModel.slots[row][col])
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fit)
                                                                            .frame(width: 60, height: 60)
                                                                            .padding(.horizontal, 5)
                                                                            .shadow(
                                                                                color: viewModel.winningPositions.contains(where: { $0.row == row && $0.col == col }) ? Color.yellow : .clear,
                                                                                radius: viewModel.isSpinning ? 0 : 25
                                                                            )
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                .frame(height: 250)
                                        }
                                        
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
                                                if viewModel.coin >= viewModel.bet {
                                                    viewModel.spin()
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
                                            .disabled(viewModel.isSpinning)
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
                                                    Text("\(viewModel.win)")
                                                        .font(.custom("MPLUS1p-Bold", size: 16))
                                                        .foregroundStyle(Color(red: 181/255, green: 181/255, blue: 181/255))
                                                }
                                                .frame(height: 40)
                                                .cornerRadius(6)
                                        }
                                        
                                        Image("tutorGreen")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 210)
                                    }
                                    .padding(.horizontal)
                                }
                        }
                        .frame(height: 730)
                        .cornerRadius(16)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
            
            if viewModel.win > 0 {
                ZStack {
                    VStack {
                        Image("bleek")
                            .resizable()
                            .ignoresSafeArea()
                        Image("bleek")
                            .resizable()
                            .ignoresSafeArea()
                    }
                    
                    Image("winGreen")
                        .resizable()
                }
                .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Image("greenWinlabel")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 260)
                    
                    Spacer()
                    
                    VStack(spacing: 30) {
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
                                            
                                            Text("9.999")
                                                .font(.custom("MPLUS1p-Bold", size: 16))
                                                .foregroundStyle(Color(red: 195/255, green: 165/255, blue: 219/255))
                                        }
                                        .offset(x: -5)
                                    }
                            }
                            .frame(width: 110, height: 35)
                            .cornerRadius(20)
                            .shadow(color: Color(red: 51/255, green: 13/255, blue: 132/255), radius: 5)
                        
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
                                            
                                            Text("\(viewModel.win)")
                                                .font(.custom("MPLUS1p-Bold", size: 16))
                                                .foregroundStyle(Color(red: 219/255, green: 187/255, blue: 165/255))
                                        }
                                        .offset(x: -2)
                                    }
                            }
                            .frame(width: 160, height: 45)
                            .cornerRadius(20)
                            .shadow(color: Color(red: 72/255, green: 8/255, blue: 8/255), radius: 5)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.win = 0
                    }) {
                        Image("take")
                            .resizable()
                            .frame(width: 210, height: 80)
                    }
                    
                    Spacer()
                }
            }
        }
        .fullScreenCover(isPresented: $isSettings) {
            SettingsView()
        }
    }
}

#Preview {
    GreenLuckyView()
}

