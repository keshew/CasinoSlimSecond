import SwiftUI

class SweetJoysViewModel: ObservableObject {
    let contact = SweetJoysModel()
    @Published var slots: [[String]] = []
    @Published var coin =   UserDefaultsManager.shared.coins
    @Published var bet = 5
    let allFruits = ["sweet1", "sweet2", "sweet3","sweet4", "sweet5", "sweet6"]
    @Published var winningPositions: [(row: Int, col: Int)] = []
    @Published var isSpinning = false
    @Published var isStopSpininng = false
    @Published var isWin = false
    @Published var win = 0
    var spinningTimer: Timer?
    @ObservedObject private var soundManager = SoundManager.shared
    
    init() {
        resetSlots()
    }
    
    @Published var betString: String = "5" {
        didSet {
            if let newBet = Int(betString), newBet > 0 {
                bet = newBet
            }
        }
    }
    let symbolArray = [
        Symbol(image: "sweet1", value: "100"),
        Symbol(image: "sweet2", value: "50"),
        Symbol(image: "sweet3", value: "20"),
        Symbol(image: "sweet4", value: "15"),
        Symbol(image: "sweet5", value: "5"),
        Symbol(image: "sweet6", value: "3")
    ]
    
    func resetSlots() {
        slots = (0..<3).map { _ in
            (0..<3).map { _ in
                allFruits.randomElement()!
            }
        }
    }
    
    func spin() {
        UserDefaultsManager.shared.removeCoins(bet)
        UserDefaultsManager.shared.addExperience()
        UserDefaultsManager.shared.recordBet(bet)
        UserDefaultsManager.shared.startGame()
        coin =  UserDefaultsManager.shared.coins
        isSpinning = true
        soundManager.playSlot1()
        spinningTimer?.invalidate()
        winningPositions.removeAll()
        win = 0
        let columns = 3
        for col in 0..<columns {
            let delay = Double(col) * 0.4
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                var spinCount = 0
                let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                    for row in 0..<3 {
                        withAnimation(.spring(response: 0.1, dampingFraction: 1.5, blendDuration: 0)) {
                            self.slots[row][col] = self.allFruits.randomElement()!
                        }
                    }
                    spinCount += 1
                    if spinCount > 12 + col * 4 {
                        timer.invalidate()
                        if col == columns - 1 {
                            self.isSpinning = false
                            self.soundManager.stopSlot()
                            self.checkWin()
                        }
                    }
                }
                RunLoop.current.add(timer, forMode: .common)
            }
        }
    }
    
    
    func checkWin() {
        winningPositions = []
        var totalWin = 0
        var maxMultiplier = 0
        let minCounts = [
            "sweet1": 3,
            "sweet2": 3,
            "sweet3": 3,
            "sweet4": 3,
            "sweet5": 3,
            "sweet6": 3
        ]
        let multipliers = [
            "sweet1": 100,
            "sweet2": 50,
            "sweet3": 25,
            "sweet4": 15,
            "sweet5": 5,
            "sweet6": 3
        ]
        
        checkRows(minCounts: minCounts, multipliers: multipliers, totalWin: &totalWin, maxMultiplier: &maxMultiplier)
        
        checkMainDiagonal(minCounts: minCounts, multipliers: multipliers, totalWin: &totalWin, maxMultiplier: &maxMultiplier)
        
        checkAntiDiagonal(minCounts: minCounts, multipliers: multipliers, totalWin: &totalWin, maxMultiplier: &maxMultiplier)
        
        if totalWin != 0 {
            win = totalWin
            isWin = true
            UserDefaultsManager.shared.addCoins(totalWin)
            UserDefaultsManager.shared.recordWin()
            UserDefaultsManager.shared.recordWinAmount(totalWin)
            coin = UserDefaultsManager.shared.coins
        }
        
        UserDefaultsManager.shared.recordLoss()
    }

    private func checkMainDiagonal(minCounts: [String: Int], multipliers: [String: Int], totalWin: inout Int, maxMultiplier: inout Int) {
        let diagonal = [slots[0][0], slots[1][1], slots[2][2]]
        checkLine(diagonal: diagonal, positions: [(0,0), (1,1), (2,2)], minCounts: minCounts, multipliers: multipliers, totalWin: &totalWin, maxMultiplier: &maxMultiplier)
    }

    private func checkAntiDiagonal(minCounts: [String: Int], multipliers: [String: Int], totalWin: inout Int, maxMultiplier: inout Int) {
        let diagonal = [slots[0][2], slots[1][1], slots[2][0]]
        checkLine(diagonal: diagonal, positions: [(0,2), (1,1), (2,0)], minCounts: minCounts, multipliers: multipliers, totalWin: &totalWin, maxMultiplier: &maxMultiplier)
    }

    private func checkLine(diagonal: [String], positions: [(row: Int, col: Int)], minCounts: [String: Int], multipliers: [String: Int], totalWin: inout Int, maxMultiplier: inout Int) {
        var currentSymbol = diagonal[0]
        var count = 1
        
        for i in 1..<diagonal.count {
            if diagonal[i] == currentSymbol {
                count += 1
            } else {
                if let minCount = minCounts[currentSymbol], count >= minCount {
                    let multiplierValue = multipliers[currentSymbol] ?? 0
                    totalWin += multiplierValue
                    if multiplierValue > maxMultiplier {
                        maxMultiplier = multiplierValue
                    }
                    let startIndex = i - count
                    for j in startIndex..<i {
                        winningPositions.append(positions[j])
                    }
                }
                currentSymbol = diagonal[i]
                count = 1
            }
        }
        
        if let minCount = minCounts[currentSymbol], count >= minCount {
            let multiplierValue = multipliers[currentSymbol] ?? 0
            totalWin += multiplierValue
            if multiplierValue > maxMultiplier {
                maxMultiplier = multiplierValue
            }
            let startIndex = diagonal.count - count
            for j in startIndex..<diagonal.count {
                winningPositions.append(positions[j])
            }
        }
    }

    private func checkRows(minCounts: [String: Int], multipliers: [String: Int], totalWin: inout Int, maxMultiplier: inout Int) {
        for row in 0..<3 {
            let rowContent = slots[row]
            var currentSymbol = rowContent[0]
            var count = 1
            
            for col in 1..<rowContent.count {
                if rowContent[col] == currentSymbol {
                    count += 1
                } else {
                    if let minCount = minCounts[currentSymbol], count >= minCount {
                        let multiplierValue = multipliers[currentSymbol] ?? 0
                        totalWin += multiplierValue
                        if multiplierValue > maxMultiplier {
                            maxMultiplier = multiplierValue
                        }
                        let startCol = col - count
                        for c in startCol..<col {
                            winningPositions.append((row: row, col: c))
                        }
                    }
                    currentSymbol = rowContent[col]
                    count = 1
                }
            }
            
            if let minCount = minCounts[currentSymbol], count >= minCount {
                let multiplierValue = multipliers[currentSymbol] ?? 0
                totalWin += multiplierValue
                if multiplierValue > maxMultiplier {
                    maxMultiplier = multiplierValue
                }
                let startCol = rowContent.count - count
                for c in startCol..<rowContent.count {
                    winningPositions.append((row: row, col: c))
                }
            }
        }
    }
}

