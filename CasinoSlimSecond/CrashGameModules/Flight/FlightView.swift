import SpriteKit
import SwiftUI

class FlightSpriteScene: SKScene, SKPhysicsContactDelegate {
    private var rocket: SKSpriteNode!
    var isGameOver = false
    var isPlaying = false
    
    private let rocketCategory: UInt32 = 0x1 << 0
    private let obstacleCategory: UInt32 = 0x1 << 1
    var gameStartTime: TimeInterval = 0
    var reward: Int = 0 { 
        didSet {
            print("Reward updated: \(reward)")
        }
    }
    
    var onRewardUpdate: ((Int) -> Void)?
    private var obstacleSpawnTimer: Timer?
    var onGameOver: (() -> Void)?
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        scaleMode = .resizeFill
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        
        setupBackground()
        setupRocket()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pauseGameNotification),
                                               name: .pauseGameNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startGameNotification), name: .startGameNotification, object: nil)
        
        pauseGame() // Изначально игра на паузе
    }
    
    @objc func startGameNotification() {
        startGame()
    }
    
    private func setupBackground() {
        let bgTexture = SKTexture(imageNamed: "bgRocket")
        guard bgTexture.size() != .zero else { fatalError("bgRocket texture not found!") }
        let bg = SKSpriteNode(texture: bgTexture)
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.size = size
        bg.zPosition = -1
        addChild(bg)
    }
    
    private func setupRocket() {
        let rocketTexture = SKTexture(imageNamed: "rocket")
        guard rocketTexture.size() != .zero else { fatalError("rocket texture not found!") }
        rocket = SKSpriteNode(texture: rocketTexture)
        rocket.size = CGSize(width: 80, height: 70)
        rocket.position = CGPoint(x: size.width/2, y: rocket.size.height/2 + 10)
        rocket.zPosition = 10
        rocket.physicsBody = SKPhysicsBody(rectangleOf: rocket.size)
        rocket.physicsBody?.isDynamic = false
        rocket.physicsBody?.categoryBitMask = rocketCategory
        rocket.physicsBody?.contactTestBitMask = obstacleCategory
        rocket.physicsBody?.collisionBitMask = 0
        addChild(rocket)
    }
    
    func startGame() {
        pauseGame()
        enumerateChildNodes(withName: "obstacle") { node, _ in
            node.removeFromParent()
        }
        rocket.position.x = size.width / 2
        
        isGameOver = false
        isPlaying = true
        reward = 0  
        gameStartTime = 0
        
        self.view?.isPaused = false
        startSpawningObstacles()
    }
    
    func pauseGame() {
        isPlaying = false
        obstacleSpawnTimer?.invalidate()
        self.view?.isPaused = true
    }
    
    func startSpawningObstacles() {
        gameStartTime = CACurrentMediaTime()
        obstacleSpawnTimer?.invalidate()
        obstacleSpawnTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.spawnObstacle()
            self?.updateReward()
        }
    }
    
    func spawnObstacle() {
        guard isPlaying && !isGameOver else { return }
        
        let obstacleTexture = SKTexture(imageNamed: "obstacle")
        guard obstacleTexture.size() != .zero else { return }
        
        let obstacle = SKSpriteNode(texture: obstacleTexture)
        obstacle.size = CGSize(width: 50, height: 50)
        obstacle.name = "obstacle"
        let minX = obstacle.size.width * 0.6
        let maxX = size.width - obstacle.size.width * 0.6
        let randomX = CGFloat.random(in: minX...maxX)
        
        obstacle.position = CGPoint(x: randomX, y: size.height + obstacle.size.height/2)
        obstacle.zPosition = 5
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: obstacle.size.width / 4, height: obstacle.size.height / 4))
        obstacle.physicsBody?.isDynamic = true
        obstacle.physicsBody?.categoryBitMask = obstacleCategory
        obstacle.physicsBody?.contactTestBitMask = rocketCategory
        obstacle.physicsBody?.collisionBitMask = 0
        addChild(obstacle)
        
        let moveDown = SKAction.moveTo(y: -obstacle.size.height, duration: 4.0)
        let remove = SKAction.removeFromParent()
        obstacle.run(SKAction.sequence([moveDown, remove]))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isPlaying && !isGameOver else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let clampedX = min(max(location.x, rocket.size.width / 2), size.width - rocket.size.width / 2)
        rocket.position.x = clampedX
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == (rocketCategory | obstacleCategory) {
            gameOver()
        }
    }
    
    func updateReward() {
        guard isPlaying else { return }
        let survivalTime = CACurrentMediaTime() - gameStartTime
        let multiplier = max(1.0, survivalTime / 2.0)
        let newReward = Int(multiplier * 50)
        if newReward != reward {
            reward = newReward
            onRewardUpdate?(reward)
        }
    }

    func gameOver() {
        isGameOver = true
        pauseGame()
        UserDefaultsManager.shared.recordLoss()
        onGameOver?()
        onRewardUpdate?(reward)
    }

    @objc func pauseGameNotification() {
        let survivalTime = CACurrentMediaTime() - gameStartTime
        let multiplier = max(1.0, survivalTime / 2.0)
        reward = Int(multiplier * 50)
        UserDefaultsManager.shared.addCoins(reward)
        NotificationCenter.default.post(name: .rewardUpdatedNotification, object: nil, userInfo: ["reward": reward])
        pauseGame()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        obstacleSpawnTimer?.invalidate()
    }
}

extension Notification.Name {
    static let startGameNotification = Notification.Name("startGameNotification")
    static let pauseGameNotification = Notification.Name("pauseGameNotification")
    static let rewardUpdatedNotification = Notification.Name("rewardUpdatedNotification")
}

struct FlightSpriteView: UIViewRepresentable {
    @Binding var gameOver: Bool
    @Binding var isPlaying: Bool
    @State private var scene: FlightSpriteScene?
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.allowsTransparency = true
        skView.backgroundColor = .clear
        
        let sceneSize = CGSize(width: UIScreen.main.bounds.width - 60, height: 250)
        let newScene = FlightSpriteScene(size: sceneSize)
        newScene.onGameOver = {
            DispatchQueue.main.async {
                self.gameOver = true
                self.isPlaying = false
            }
        }
        skView.presentScene(newScene)
        scene = newScene
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
    }
}


struct FlightView: View {
    @StateObject var viewModel =  FlightViewModel()
    @State private var isGameOver = false
    @State private var hasCollectedReward = false
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
                                        FlightSpriteView(
                                              gameOver: $isGameOver,
                                              isPlaying: $viewModel.isPlaying
                                          )
                                        .frame(height: 250)
                                        
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
                                                guard viewModel.coin > viewModel.bet else { return }
                                                NotificationCenter.default.post(name: .startGameNotification, object: nil)
                                                UserDefaultsManager.shared.removeCoins(viewModel.bet)
                                                viewModel.coin = UserDefaultsManager.shared.coins
                                                UserDefaultsManager.shared.addExperience()
                                                UserDefaultsManager.shared.removeCoins(viewModel.bet)
                                                UserDefaultsManager.shared.recordBet(viewModel.bet)
                                                UserDefaultsManager.shared.startGame()
                                                isGameOver = false
                                                hasCollectedReward = false
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
                                            guard !hasCollectedReward else { return }
                                            
                                            let totalReward = Int(Double(viewModel.reward) * (Double(viewModel.reward) / Double(viewModel.bet)))
                                            
                                            UserDefaultsManager.shared.addCoins(totalReward)
                                            
                                            NotificationCenter.default.post(name: .pauseGameNotification, object: nil)
                                            hasCollectedReward = true
                                            viewModel.isPlaying = false
                                            viewModel.reward = 0
                                            isGameOver = false
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
                                        
                                        Image("tutorRocket")
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
    FlightView()
}

