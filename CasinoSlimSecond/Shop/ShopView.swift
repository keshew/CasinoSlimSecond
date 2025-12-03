import SwiftUI

struct ShopView: View {
    @StateObject var shopModel =  ShopViewModel()
    @State var isGameAlert = false
    @State var energyAlert = false
    @State var isSettings = false
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
                                            
                                            Text("\(shopModel.energy)")
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
                                            
                                            Text("\(shopModel.coin)")
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
                    
                    VStack(spacing: 0) {
                        ZStack(alignment: .leading) {
                            Image("redShadow")
                                .resizable()
                                .frame(height: 60)
                            
                            Text("Currency")
                                .font(.custom("MPLUS1p-Bold", size: 18))
                                .foregroundStyle(Color(red: 243/255, green: 175/255, blue: 175/255))
                                .padding(.horizontal, 30)
                        }
                        
                        Image("daily")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .overlay {
                                HStack {
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 5) {
                                        Spacer()
                                        
                                        Text("Free coins every day")
                                            .font(.custom("MPLUS1p-Bold", size: 14))
                                            .foregroundStyle(Color(red: 255/255, green: 235/255, blue: 167/255))
                                        
                                        HStack(spacing: 10) {
                                            Image("coin")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 16, height: 16)
                                            
                                            Text("5.000")
                                                .font(.custom("MPLUS1p-Bold", size: 12))
                                                .foregroundStyle(Color(red: 255/255, green: 235/255, blue: 167/255))
                                        }
                                        .offset(x: -2)
                                        
                                        VStack(spacing: -5) {
                                            Text(shopModel.formattedTime())
                                                .font(.custom("MPLUS1p-Bold", size: 12))
                                                .foregroundStyle(Color(red: 123/255, green: 10/255, blue: 25/255))
                                            
                                            Button(action: {
                                                shopModel.claimReward()
                                                shopModel.coin = UserDefaultsManager.shared.coins
                                            }) {
                                                Image("take")
                                                    .resizable()
                                                    .frame(width: 110, height: 50)
                                            }
                                            .disabled(!shopModel.canClaimReward)
                                            .opacity(shopModel.canClaimReward ? 1 : 0.5)
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .padding(.horizontal, 40)
                            }
                            .frame(width: 400, height: 185)
                        
                        Image("sparsk")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .overlay {
                                Button(action: {
                                    shopModel.buyEnergy()
                                }) {
                                    Image("buy")
                                        .resizable()
                                        .frame(width: 120, height: 45)
                                }
                                .offset(x: 88, y: 45)
                                .alert("You don't have enough coins", isPresented: $shopModel.showAlert) {
                                    Button("OK") {}
                                }
                            }
                            .frame(width: 400, height: 185)
                    }
                    
                    VStack(spacing: 0) {
                        ZStack(alignment: .leading) {
                            Image("redShadow")
                                .resizable()
                                .frame(height: 60)
                            
                            Text("Games")
                                .font(.custom("MPLUS1p-Bold", size: 18))
                                .foregroundStyle(Color(red: 243/255, green: 175/255, blue: 175/255))
                                .padding(.horizontal, 30)
                        }
                        
                        LazyVGrid(columns: [GridItem(.flexible(minimum: 100, maximum: 120)),
                                            GridItem(.flexible(minimum: 100, maximum: 120)),
                                            GridItem(.flexible(minimum: 100, maximum: 120))]) {
                            ForEach(0..<12, id: \.self) { index in
                                Button(action: {
                                    isGameAlert = true
                                }) {
                                    Image("game\(index + 1)")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 120)
                                }
                                .alert("Not enough energy", isPresented: $isGameAlert) {
                                    Button("OK") {}
                                }
                            }
                        }
                    }
                }
                
                VStack(spacing: 0) {
                    ZStack(alignment: .leading) {
                        Image("redShadow")
                            .resizable()
                            .frame(height: 60)
                        
                        Text("Avatars")
                            .font(.custom("MPLUS1p-Bold", size: 18))
                            .foregroundStyle(Color(red: 243/255, green: 175/255, blue: 175/255))
                            .padding(.horizontal, 30)
                    }
                    
                    LazyVGrid(columns: [GridItem(.flexible(minimum: 100, maximum: 120)),
                                        GridItem(.flexible(minimum: 100, maximum: 120)),
                                        GridItem(.flexible(minimum: 100, maximum: 120))]) {
                        ForEach(0..<6, id: \.self) { index in
                            Button(action: {
                                isGameAlert = true
                            }) {
                                Image("av\(index + 1)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 120)
                            }
                            .alert("Not enough energy", isPresented: $isGameAlert) {
                                Button("OK") {}
                            }
                        }
                    }
                }
                
                Color.clear.frame(height: 70)
            }
            .padding(.top)
        }
        .fullScreenCover(isPresented: $isSettings) {
            SettingsView()
        }
    }
}

#Preview {
    ShopView()
}

