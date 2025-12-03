import SwiftUI

struct Achievments: Codable, Identifiable {
    var id = UUID()
    let image: String
    let title: String
    let subtitle: String
    var isDone: Bool = false
}

struct AchievView: View {
    @StateObject var achievModel =  AchievViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.black, Color(red: 46/255, green: 4/255, blue: 26/255), Color.black], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            let completedAchievs = achievModel.achievements.filter { $0.isDone }
            let uncompletedAchievs = achievModel.achievements.filter { !$0.isDone }
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
                                            
                                            Text("\(achievModel.energy)")
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
                                            
                                            Text("\(achievModel.coin)")
                                                .font(.custom("MPLUS1p-Bold", size: 16))
                                                .foregroundStyle(Color(red: 219/255, green: 187/255, blue: 165/255))
                                        }
                                        .offset(x: -2)
                                    }
                            }
                            .frame(width: 110, height: 35)
                            .cornerRadius(20)
                            .shadow(color: Color(red: 72/255, green: 8/255, blue: 8/255), radius: 5)
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        if !completedAchievs.isEmpty {
                            ZStack(alignment: .leading) {
                                Image("redShadow")
                                    .resizable()
                                    .frame(height: 60)
                                Text("Collected")
                                    .font(.custom("MPLUS1p-Bold", size: 18))
                                    .foregroundStyle(Color(red: 243/255, green: 175/255, blue: 175/255))
                                    .padding(.horizontal, 30)
                            }
                            
                            VStack {
                                ForEach(completedAchievs) { achiev in
                                    AchievementRow(achiev: achiev)
                                }
                            }
                        }
                    }
                    
                    VStack(spacing: 0) {
                        if !uncompletedAchievs.isEmpty {
                            ZStack(alignment: .leading) {
                                Image("redShadow")
                                    .resizable()
                                    .frame(height: 60)
                                Text("Uncollected")
                                    .font(.custom("MPLUS1p-Bold", size: 18))
                                    .foregroundStyle(Color(red: 243/255, green: 175/255, blue: 175/255))
                                    .padding(.horizontal, 30)
                            }
                            
                            VStack {
                                ForEach(uncompletedAchievs) { achiev in
                                    AchievementRow(achiev: achiev)
                                }
                            }
                        }
                    }
                    
                    Color.clear.frame(height: 70)
                }
                .padding(.top)
            }
        }
    }
}

#Preview {
    AchievView()
}

struct AchievementRow: View {
    let achiev: Achievments
    
    var body: some View {
        Rectangle()
            .fill(LinearGradient(colors: [Color(red: 55/255, green: 55/255, blue: 55/255),
                                        Color(red: 23/255, green: 23/255, blue: 23/255),
                                        Color(red: 47/255, green: 47/255, blue: 47/255)],
                                startPoint: .top, endPoint: .bottom))
            .overlay {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color(red: 41/255, green: 41/255, blue: 41/255))
                    .overlay {
                        HStack(spacing: 10) {
                            Image(achiev.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                            
                            VStack(alignment: .leading) {
                                Text(achiev.title)
                                    .font(.custom("MPLUS1p-Bold", size: 14))
                                    .foregroundStyle(Color(red: 176/255, green: 176/255, blue: 176/255))
                                
                                Text(achiev.subtitle)
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
