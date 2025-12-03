import SwiftUI

struct Loading: View {
    @State var isMenu = false
    @ObservedObject private var soundManager = SoundManager.shared
    
    var body: some View {
        ZStack {
            Image("splash")
                .resizable()
                .ignoresSafeArea()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isMenu = true
            }
        }
        .fullScreenCover(isPresented: $isMenu) {
            TabBarView()
        }
    }
}

#Preview {
    Loading()
}
