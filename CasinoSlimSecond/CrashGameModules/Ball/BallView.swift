import SpriteKit
import Combine
import SwiftUI

class GameData: ObservableObject {
    @Published var reward: Double = 0.0
    @Published var bet: Int = 50
    @Published var rewardStay = 0.0
    @Published var balance: Int = UserDefaultsManager.shared.coins
    @Published var isPlayTapped: Bool = false
    @Published var labels: [String] = ["1x", "1.5x", "2x", "5x", "10x", "5x", "2x", "1.5x", "1x"]
    
    var createBallPublisher = PassthroughSubject<Void, Never>()
    
    var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: balance)) ?? "\(balance)"
    }
    
    
    func decreaseBet() {
        if bet - 5 >= 5 {
            bet -= 5
        }
    }
    func increaseBet() {
        let newBet = bet + 5
        if newBet <= balance {
            bet = newBet
        }
    }
    
    func dropBalls() {
        guard bet <= balance else {
            return
        }
        let _ = UserDefaultsManager.shared.removeCoins(bet)
        balance = UserDefaultsManager.shared.coins
        UserDefaultsManager.shared.recordBet(bet)
        UserDefaultsManager.shared.startGame()
        UserDefaultsManager.shared.addExperience()
        reward = 0.0
        rewardStay = 0.0
        isPlayTapped = true
        createBallPublisher.send(())
    }
    
    func resetGame() {
        bet = 50
        reward = 0
        isPlayTapped = false
    }
    
    func addWin(_ amount: Double) {
        reward += amount
        rewardStay += amount
    }
    
    func finishGame() {
        UserDefaultsManager.shared.addCoins(Int(reward))
        balance = UserDefaultsManager.shared.coins
        reward = 0
        isPlayTapped = false
    }
}

class GameSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: GameData? {
        didSet {
        }
    }
    
    let ballCategory: UInt32 = 0x1 << 0
    let obstacleCategory: UInt32 = 0x1 << 1
    let ticketCategory: UInt32 = 0x1 << 2
    
    var ballsInPlay: Int = 0
    var ballNodes: [SKSpriteNode] = []
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        size = UIScreen.main.bounds.size
        backgroundColor = .clear
        
        let bgTexture = SKTexture(imageNamed: "bgPlinko")
        guard bgTexture.size() != .zero else { fatalError("bgRocket texture not found!") }
        let bg = SKSpriteNode(texture: bgTexture)
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.size = size
        bg.zPosition = -1
        addChild(bg)
        
        createObstacles()
        createTickets()
        createInitialBalls()
        
        game?.createBallPublisher.sink { [weak self] in
            self?.launchBalls()
        }.store(in: &cancellables)
    }
    
    var cancellables = Set<AnyCancellable>()
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        for (index, ball) in ballNodes.enumerated().reversed() {
            if ball.position.y < 0 || ball.position.x < 0 || ball.position.x > size.width {
                ball.removeFromParent()
                ballNodes.remove(at: index)
                ballsInPlay -= 1
                createBall(atIndex: index)
            }
        }
    }
    
    func createObstacles() {
        let startRowCount = 2
        let numberOfRows = UIScreen.main.bounds.width > 700 ? 6 : 6
        let obstacleSize = CGSize(width: 15, height: UIScreen.main.bounds.width > 700 ? 60 : 42)
        let horizontalSpacing: CGFloat = UIScreen.main.bounds.width > 700 ? 35 : 25
        
        for row in 0..<numberOfRows {
            let countInRow = startRowCount + row
            let totalWidth = CGFloat(countInRow) * (obstacleSize.width + horizontalSpacing) - horizontalSpacing
            let xOffset = (size.width - totalWidth) / 2 + obstacleSize.width / 2
            let yPosition = (size.height / 1.32) - CGFloat(row) * (obstacleSize.height + UIScreen.main.bounds.width > 700 ? 160 : 100)
            
            for col in 0..<countInRow {
                let obstacle = SKSpriteNode(imageNamed: "obstacle2")
                obstacle.size = obstacleSize
                let xPosition = xOffset + CGFloat(col) * (obstacleSize.width + horizontalSpacing)
                obstacle.position = CGPoint(x: xPosition, y: yPosition)
                
                obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacleSize.width / 2.0)
                obstacle.physicsBody?.isDynamic = false
                obstacle.physicsBody?.categoryBitMask = obstacleCategory
                obstacle.physicsBody?.contactTestBitMask = ballCategory
                
                addChild(obstacle)
            }
        }
    }
    
    func createTickets() {
        let barWidth = size.width * 0.97
           let barHeight: CGFloat = 55
           let yPosition = size.height / 22

           let gradientLayer = CAGradientLayer()
           gradientLayer.frame = CGRect(x: 0, y: 0, width: barWidth, height: barHeight)
           gradientLayer.colors = [
               UIColor.red.cgColor,
               UIColor.green.cgColor,
               UIColor.red.cgColor
           ]
           gradientLayer.locations = [0, 0.5, 1]
           gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
           gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

           let renderer = UIGraphicsImageRenderer(size: gradientLayer.frame.size)
           let gradientImage = renderer.image { ctx in
               gradientLayer.render(in: ctx.cgContext)
           }

           let texture = SKTexture(image: gradientImage)

           let gradientBar = SKSpriteNode(texture: texture)
           gradientBar.size = CGSize(width: barWidth, height: barHeight)
           gradientBar.position = CGPoint(x: size.width/2, y: yPosition)
           gradientBar.zPosition = 5

           gradientBar.physicsBody = SKPhysicsBody(rectangleOf: gradientBar.size)
           gradientBar.physicsBody?.isDynamic = false
           gradientBar.physicsBody?.categoryBitMask = ticketCategory
           gradientBar.physicsBody?.contactTestBitMask = ballCategory

           addChild(gradientBar)
    }
    
    func createInitialBalls() {
        ballNodes.forEach { $0.removeFromParent() }
        ballNodes.removeAll()
        ballsInPlay = 0
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: 15, height: UIScreen.main.bounds.width > 700 ? 70 : 42)
        ball.position = CGPoint(x: size.width / 2,
                                y: size.height / 1.15)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 3)
        ball.physicsBody?.restitution = 0.0
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.collisionBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.isDynamic = true
        
        addChild(ball)
        ballNodes.append(ball)
        ballsInPlay += 1
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let game = game else { return }

        let ballCategory = self.ballCategory
        let ticketCategory = self.ticketCategory

        var ballNode: SKNode?
        var gradientBarNode: SKNode?

        if contact.bodyA.categoryBitMask == ballCategory {
            ballNode = contact.bodyA.node
        } else if contact.bodyB.categoryBitMask == ballCategory {
            ballNode = contact.bodyB.node
        }

        if contact.bodyA.categoryBitMask == ticketCategory {
            gradientBarNode = contact.bodyA.node
        } else if contact.bodyB.categoryBitMask == ticketCategory {
            gradientBarNode = contact.bodyB.node
        }

        guard let ball = ballNode as? SKSpriteNode,
              let gradientBar = gradientBarNode as? SKSpriteNode else {
            return
        }

        let ballPositionInBar = gradientBar.convert(ball.position, from: ball.parent!)

        let width = gradientBar.size.width

        let normalizedX = max(0, min(1, (ballPositionInBar.x + width/2) / width))

        let distanceToCenter = abs(normalizedX - 0.5)
        let multiplier = 2.0 - distanceToCenter * 2

        let win = Double(game.bet) * multiplier
        game.addWin(win)
        UserDefaultsManager.shared.recordWin()
        UserDefaultsManager.shared.recordWinAmount(Int(win))

        ball.removeFromParent()
        if let index = ballNodes.firstIndex(of: ball) {
            ballNodes.remove(at: index)
        }

        ballsInPlay -= 1
        createBall(atIndex: 0)
        checkBallsStopped()
    }

    func createBall(atIndex index: Int) {
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: 15, height: UIScreen.main.bounds.width > 700 ? 70 : 42)
        ball.position = CGPoint(x: size.width / 2,
                                y: size.height / 1.15)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 3)
        ball.physicsBody?.restitution = 0.0
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.collisionBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.isDynamic = true
        
        addChild(ball)
        ballNodes.append(ball)
        ballsInPlay += 1
    }
    
    func launchBalls() {
        for (_, ball) in ballNodes.enumerated() {
            ball.physicsBody?.affectedByGravity = true
            
            let randomXImpulse = CGFloat.random(in: -0.01...0.01)
            
            ball.physicsBody?.applyImpulse(CGVector(dx: randomXImpulse, dy: 0))
        }
    }
    
    private func parseMultiplier(from text: String?) -> Double? {
        guard let text = text?.lowercased().replacingOccurrences(of: "x", with: "") else { return nil }
        return Double(text)
    }
    
    private func checkBallsStopped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self, let game = self.game else { return }
            let movingBalls = self.ballNodes.filter {
                guard let body = $0.physicsBody else { return false }
                return body.velocity.dx > 5 || body.velocity.dy > 5
            }
            if movingBalls.isEmpty && game.isPlayTapped {
                game.finishGame()
            }
        }
    }
}

struct BallView: View {
    @StateObject var viewModel =  BallViewModel()
    @StateObject var gameModel = GameData()
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
                                            
                                            Text("\(gameModel.balance)")
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
                                        SpriteView(scene: viewModel.createGameScene(gameData: gameModel), options: [.allowsTransparency])
                                            .frame(height: 250)
                                        
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
                                                        Text("\(gameModel.bet)")
                                                            .font(.custom("MPLUS1p-Bold", size: 16))
                                                            .foregroundStyle(Color(red: 181/255, green: 181/255, blue: 181/255))
                                                    }
                                                    .frame(height: 40)
                                                    .cornerRadius(6)
                                                
                                                HStack {
                                                    Button(action: {
                                                        gameModel.increaseBet()
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
                                                        gameModel.decreaseBet()
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
                                            
                                            VStack(spacing: 5) {
                                                Text("WIN")
                                                    .font(.custom("MPLUS1p-Bold", size: 16))
                                                    .foregroundStyle(Color(red: 236/255, green: 117/255, blue: 117/255))
                                                
                                                Rectangle()
                                                    .fill(LinearGradient(colors: [Color(red: 55/255, green: 55/255, blue: 55/255),
                                                                                  Color(red: 23/255, green: 23/255, blue: 23/255),
                                                                                  Color(red: 47/255, green: 47/255, blue: 47/255)], startPoint: .top, endPoint: .bottom))
                                                    .overlay {
                                                        Text("\(Int(gameModel.rewardStay))")
                                                            .font(.custom("MPLUS1p-Bold", size: 16))
                                                            .foregroundStyle(Color(red: 181/255, green: 181/255, blue: 181/255))
                                                    }
                                                    .frame(height: 40)
                                                    .cornerRadius(6)
                                            }
                                        }
                                        
                                        HStack {
                                            Button(action: {
                                                gameModel.dropBalls()
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
                                        
                                        Image("tutorPlinko")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 160)
                                    }
                                    .padding(.horizontal)
                                }
                        }
                        .frame(height: 670)
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
    BallView()
}

