import SwiftUI

struct MainView: View {
    @StateObject var mainModel =  MainViewModel()
    @Binding var selectedTab: CustomTabBar.TabType
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
                                            
                                            Text("\(mainModel.energy)")
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
                                            
                                            Text("\(mainModel.coin)")
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
                        .fill(LinearGradient(colors: [Color(red: 63/255, green: 5/255, blue: 5/255),
                                                      Color(red: 73/255, green: 23/255, blue: 8/255),
                                                      Color(red: 22/255, green: 2/255, blue: 2/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 41/255, green: 41/255, blue: 41/255))
                                .overlay {
                                    HStack {
                                        if let avatar = mainModel.avatarImage {
                                            Image(uiImage: avatar)
                                                .resizable()
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                                .padding(.horizontal)
                                                .padding(.vertical, 15)
                                                .frame(width: 100, height: 100)
                                        } else {
                                            Image("playerCircle")
                                                .resizable()
                                                .overlay {
                                                    Text("P")
                                                        .font(.custom("MPLUS1p-Bold", size: 56))
                                                        .foregroundStyle(Color(red: 171/255, green: 84/255, blue: 11/255))
                                                }
                                                .frame(width: 130, height: 130)
                                        }
                                        
                                        VStack(spacing: 15) {
                                            HStack {
                                                ZStack(alignment: .leading) {
                                                    Image("nameRect")
                                                        .resizable()
                                                        .frame(height: 35)
                                                        .aspectRatio(contentMode: .fit)
                                                    
                                                    Text(mainModel.playerName)
                                                        .font(.custom("MPLUS1p-Bold", size: 18))
                                                        .foregroundStyle(LinearGradient(colors: [Color(red: 255/255, green: 243/255, blue: 196/255),
                                                                                                 Color(red: 241/255, green: 220/255, blue: 138/255),
                                                                                                 Color(red: 216/255, green: 119/255, blue: 41/255),
                                                                                                 Color(red: 245/255, green: 143/255, blue: 121/255)], startPoint: .top, endPoint: .bottom))
                                                        .padding(.horizontal)
                                                }
                                                
                                                Image("premium")
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                            }
                                            
                                            VStack {
                                                HStack {
                                                    Text("Lvl. \(mainModel.xp / 1000 + 1)")
                                                        .font(.custom("MPLUS1p-Bold", size: 16))
                                                        .foregroundStyle(LinearGradient(colors: [Color(red: 237/255, green: 183/255, blue: 183/255),
                                                                                                 Color(red: 193/255, green: 22/255, blue: 21/255)], startPoint: .top, endPoint: .bottom))
                                                    
                                                    Spacer()
                                                    
                                                    Text("\(mainModel.xp % 1000)/\(mainModel.xp / 1000 + 1)000 XP")
                                                        .font(.custom("MPLUS1p-Bold", size: 10))
                                                        .foregroundStyle(Color(red: 149/255, green: 67/255, blue: 67/255))
                                                }
                                                
                                                GeometryReader { geometry in
                                                    ZStack(alignment: .leading) {
                                                        Rectangle()
                                                            .fill(LinearGradient(colors: [Color(red: 55/255, green: 55/255, blue: 55/255),
                                                                                          Color(red: 23/255, green: 23/255, blue: 23/255),
                                                                                          Color(red: 47/255, green: 47/255, blue: 47/255)], startPoint: .top, endPoint: .bottom))
                                                            .frame(width: geometry.size.width)
                                                            .cornerRadius(10)
                                                        
                                                        Rectangle()
                                                            .fill(LinearGradient(colors: [Color(red: 255/255, green: 243/255, blue: 196/255),
                                                                                          Color(red: 241/255, green: 220/255, blue: 138/255),
                                                                                          Color(red: 216/255, green: 119/255, blue: 41/255),
                                                                                          Color(red: 245/255, green: 143/255, blue: 121/255)], startPoint: .top, endPoint: .bottom))
                                                            .frame(width: geometry.size.width - 100)
                                                            .cornerRadius(10)
                                                    }
                                                }
                                                .frame(height: 15)
                                            }
                                            .padding(.horizontal, 10)
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                }
                        }
                        .frame(height: 155)
                        .cornerRadius(12)
                        .shadow(color: Color(red: 232/255, green: 133/255, blue: 33/255).opacity(0.4), radius: 15)
                        .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        ZStack(alignment: .leading) {
                            Image("redShadow")
                                .resizable()
                                .frame(height: 60)
                            
                            Text("Our favorite games")
                                .font(.custom("MPLUS1p-Bold", size: 18))
                                .foregroundStyle(Color(red: 243/255, green: 175/255, blue: 175/255))
                                .padding(.horizontal, 30)
                        }
                        
                        HStack {
                            Button(action: {
                                selectedTab = .Games
                            }) {
                                Image("crash1")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                            }
                            
                            Button(action: {
                                selectedTab = .Games
                            }) {
                                Image("crash2")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                            }
                            
                            Button(action: {
                                selectedTab = .Games
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
                            
                            Text("Recent Achievements")
                                .font(.custom("MPLUS1p-Bold", size: 18))
                                .foregroundStyle(Color(red: 243/255, green: 175/255, blue: 175/255))
                                .padding(.horizontal, 30)
                        }
                        
                        VStack {
                            let completedAchievs = mainModel.achievements.filter { $0.isDone }
                            
                            ForEach(completedAchievs.prefix(3), id: \.id) { achiv in
                                Rectangle()
                                    .fill(LinearGradient(colors: [Color(red: 55/255, green: 55/255, blue: 55/255),
                                                                  Color(red: 23/255, green: 23/255, blue: 23/255),
                                                                  Color(red: 47/255, green: 47/255, blue: 47/255)], startPoint: .top, endPoint: .bottom))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 3)
                                            .stroke(Color(red: 41/255, green: 41/255, blue: 41/255))
                                            .overlay {
                                                HStack(spacing: 10) {
                                                    Image(achiv.image)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 32, height: 32)
                                                    
                                                    VStack(alignment: .leading) {
                                                        Text(achiv.title)
                                                            .font(.custom("MPLUS1p-Bold", size: 14))
                                                            .foregroundStyle(Color(red: 176/255, green: 176/255, blue: 176/255))
                                                        
                                                        Text(achiv.subtitle)
                                                            .font(.custom("MPLUS1p-Bold", size: 10))
                                                            .foregroundStyle(Color(red: 121/255, green: 121/255, blue: 121/255))
                                                    }
                                                    
                                                    Spacer()
                                                }
                                                .padding(.leading)
                                                .offset(x: -5)
                                            }
                                    }
                                    .frame(height: 45)
                                    .cornerRadius(3)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                    VStack(spacing: 0) {
                        ZStack(alignment: .leading) {
                            Image("redShadow")
                                .resizable()
                                .frame(height: 60)
                            
                            Text("Statistics")
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
                                            VStack(spacing: 15) {
                                                HStack(spacing: 20) {
                                                    HStack {
                                                        let profit = UserDefaultsManager.shared.totalCoinsEarned - UserDefaultsManager.shared.totalCoinsSpent
                                                        
                                                        Image("stat1")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                        
                                                        Text("Profit")
                                                            .font(.custom("MPLUS1p-Bold", size: 18))
                                                            .foregroundStyle(Color(red: 176/255, green: 176/255, blue: 176/255))
                                                        
                                                        Spacer()
                                                        
                                                        Text("+\(profit)%")
                                                            .font(.custom("MPLUS1p-Bold", size: 16))
                                                            .foregroundStyle(LinearGradient(colors: [Color(red: 148/255, green: 174/255, blue: 95/255),
                                                                                                     Color(red: 95/255, green: 128/255, blue: 24/255)], startPoint: .top, endPoint: .bottom))
                                                    }
                                                    
                                                    HStack {
                                                        Image("stat2")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                        
                                                        Text("Earned")
                                                            .font(.custom("MPLUS1p-Bold", size: 18))
                                                            .foregroundStyle(Color(red: 176/255, green: 176/255, blue: 176/255))
                                                        
                                                        Spacer()
                                                        
                                                        Text("\(UserDefaultsManager.shared.totalCoinsEarned)")
                                                            .font(.custom("MPLUS1p-Bold", size: 16))
                                                            .foregroundStyle(LinearGradient(colors: [Color(red: 148/255, green: 174/255, blue: 95/255),
                                                                                                     Color(red: 95/255, green: 128/255, blue: 24/255)], startPoint: .top, endPoint: .bottom))
                                                    }
                                                }
                                                
                                                HStack(spacing: 20) {
                                                    HStack {
                                                        Image("stat3")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                        
                                                        Text("Day Streak")
                                                            .font(.custom("MPLUS1p-Bold", size: 16))
                                                            .foregroundStyle(Color(red: 176/255, green: 176/255, blue: 176/255))
                                                        
                                                        Spacer()
                                                        
                                                        Text("\(UserDefaultsManager.shared.dayStreak)")
                                                            .font(.custom("MPLUS1p-Bold", size: 16))
                                                            .foregroundStyle(LinearGradient(colors: [Color(red: 179/255, green: 179/255, blue: 179/255),
                                                                                                     Color(red: 116/255, green: 116/255, blue: 116/255)], startPoint: .top, endPoint: .bottom))
                                                    }
                                                    
                                                    HStack {
                                                        Image("stat4")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 20, height: 20)
                                                        
                                                        Text("Spent")
                                                            .font(.custom("MPLUS1p-Bold", size: 18))
                                                            .foregroundStyle(Color(red: 176/255, green: 176/255, blue: 176/255))
                                                        
                                                        Spacer()
                                                        
                                                        Text("\(UserDefaultsManager.shared.totalCoinsSpent)")
                                                            .font(.custom("MPLUS1p-Bold", size: 16))
                                                            .foregroundStyle(LinearGradient(colors: [Color(red: 179/255, green: 93/255, blue: 93/255),
                                                                                                     Color(red: 121/255, green: 47/255, blue: 47/255)], startPoint: .top, endPoint: .bottom))
                                                    }
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                }
                                .frame(height: 105)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                    }
                    
                    Color.clear.frame(height: 70)
                }
                .padding(.top)
            }
        }
        .fullScreenCover(isPresented: $isSettings) {
            SettingsView()
        }
    }
}

#Preview {
    MainView(selectedTab: .constant(CustomTabBar.TabType.Home))
}

