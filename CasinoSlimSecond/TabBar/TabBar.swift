import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: CustomTabBar.TabType = .Home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                if selectedTab == .Home {
                    MainView(selectedTab: $selectedTab)
                } else if selectedTab == .Games {
                    GamesView()
                } else if selectedTab == .Shop {
                    ShopView()
                } else if selectedTab == .Achiev {
                    AchievView()
                }
            }
            .frame(maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
            }
            
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TabBarView()
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabType
    
    enum TabType: Int {
        case Home
        case Games
        case Shop
        case Achiev
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                Rectangle()
                    .fill(LinearGradient(colors: [Color(red: 55/255, green: 55/255, blue: 55/255),
                                                  Color(red: 23/255, green: 23/255, blue: 23/255),
                                                  Color(red: 47/255, green: 47/255, blue: 47/255)], startPoint: .top, endPoint: .bottom))
                    .frame(height: 110)
                    .edgesIgnoringSafeArea(.bottom)
                    .offset(y: 35)
            }
            
            HStack(spacing: 0) {
                TabBarItem(imageName: "tab1", tab: .Home, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab2", tab: .Games, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab3", tab: .Shop, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab4", tab: .Achiev, selectedTab: $selectedTab)
            }
            .padding(.top, 10)
            .frame(height: 60)
        }
    }
}

struct TabBarItem: View {
    let imageName: String
    let tab: CustomTabBar.TabType
    @Binding var selectedTab: CustomTabBar.TabType
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 12) {
                Image(selectedTab == tab ? imageName + "Picked" : imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                
                Text("\(tab)")
                    .font(.custom("MPLUS1p-Bold", size: 12))
                    .foregroundStyle(LinearGradient(colors: selectedTab == tab ? [Color(red: 255/255, green: 243/255, blue: 196/255),
                                                                                  Color(red: 241/255, green: 220/255, blue: 138/255),
                                                                                  Color(red: 216/255, green: 119/255, blue: 41/255),
                                                                                  Color(red: 245/255, green: 143/255, blue: 121/255)] : [Color(red: 76/255, green: 76/255, blue: 76/255)], startPoint: .top, endPoint: .bottom))
            }
            .frame(maxWidth: .infinity)
        }
    }
}
