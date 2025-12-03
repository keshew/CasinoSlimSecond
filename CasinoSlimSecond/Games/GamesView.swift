import SwiftUI

struct GamesView: View {
    @StateObject var gamesModel =  GamesViewModel()
    @State var isGameAlert = false
    @State var slot1 = false
    @State var slot2 = false
    @State var slot3 = false
    @State var crash1 = false
    @State var crash2 = false
    @State var crash3 = false
    @State var settings = false
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
                                            
                                            Text("\(gamesModel.energy)")
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
                                            
                                            Text("\(gamesModel.coin)")
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
                            settings = true
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
                            
                            Text("Crash Games")
                                .font(.custom("MPLUS1p-Bold", size: 18))
                                .foregroundStyle(Color(red: 243/255, green: 175/255, blue: 175/255))
                                .padding(.horizontal, 30)
                        }
                        
                        HStack {
                            Button(action: {
                                crash1 = true
                            }) {
                                Image("crash1")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                            }
                            
                            Button(action: {
                                crash2 = true
                            }) {
                                Image("crash2")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                            }
                            
                            Button(action: {
                                crash3 = true
                            }) {
                                Image("crash3")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                            }
                        }
                    }
                    
                    VStack(spacing: 0) {
                        ZStack(alignment: .leading) {
                            Image("redShadow")
                                .resizable()
                                .frame(height: 60)
                            
                            Text("Slot Games")
                                .font(.custom("MPLUS1p-Bold", size: 18))
                                .foregroundStyle(Color(red: 243/255, green: 175/255, blue: 175/255))
                                .padding(.horizontal, 30)
                        }
                        
                        HStack {
                            Button(action: {
                                slot1 = true
                            }) {
                                Image("slot1")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                            }
                            
                            Button(action: {
                                slot2 = true
                            }) {
                                Image("slot2")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                            }
                            
                            Button(action: {
                                slot3 = true
                            }) {
                                Image("slot3")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                            }
                        }
                    }
                    
                    Image("moreGames")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 185)
                    
                    LazyVGrid(columns: [GridItem(.flexible(minimum: 100, maximum: 120)),
                                        GridItem(.flexible(minimum: 100, maximum: 120)),
                                        GridItem(.flexible(minimum: 100, maximum: 120))]) {
                        ForEach(0..<9, id: \.self) { index in
                            Button(action: {
                                isGameAlert = true
                            }) {
                                Image("gamelocked\(index + 1)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 120)
                            }
                            .alert("You can unlock this game in shop", isPresented: $isGameAlert) {
                                Button("OK") {}
                            }
                        }
                    }
                    
                    Color.clear.frame(height: 70)
                }
            }
            .padding(.top)
        }
        .fullScreenCover(isPresented: $settings) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $slot1) {
            HappyCardsView()
        }
        .fullScreenCover(isPresented: $slot2) {
            SweetJoysView()
        }
        .fullScreenCover(isPresented: $slot3) {
            GreenLuckyView()
        }
        .fullScreenCover(isPresented: $crash1) {
            AviatorView()
        }
        .fullScreenCover(isPresented: $crash2) {
            FlightView()
        }
        .fullScreenCover(isPresented: $crash3) {
            BallView()
        }
    }
}

#Preview {
    GamesView()
}

