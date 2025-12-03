import SwiftUI

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    var coins: Int {
        get { defaults.integer(forKey: "coins") }
        set { defaults.set(newValue, forKey: "coins") }
    }
    
    var energy: Int {
        get { defaults.integer(forKey: "energy") }
        set { defaults.set(newValue, forKey: "energy") }
    }
    
    var totalExperience: Int {
        get { defaults.integer(forKey: "totalExperience") }
        set { defaults.set(newValue, forKey: "totalExperience") }
    }
    
    var achievements: [Achievments] {
        get {
            if let data = defaults.data(forKey: "achievements") {
                return (try? JSONDecoder().decode([Achievments].self, from: data)) ?? defaultAchievements
            }
            return defaultAchievements
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: "achievements")
            }
        }
    }
    
    var totalCoinsEarned: Int {
        get { defaults.integer(forKey: "totalCoinsEarned") }
        set { defaults.set(newValue, forKey: "totalCoinsEarned") }
    }
    
    var totalCoinsSpent: Int {
        get { defaults.integer(forKey: "totalCoinsSpent") }
        set { defaults.set(newValue, forKey: "totalCoinsSpent") }
    }
    
    var totalSparks: Int {
        get { defaults.integer(forKey: "totalSparks") }
        set { defaults.set(newValue, forKey: "totalSparks") }
    }
    
    var dayStreak: Int {
        get { defaults.integer(forKey: "dayStreak") }
        set { defaults.set(newValue, forKey: "dayStreak") }
    }
    
    var lastLoginDate: Date {
        get { defaults.object(forKey: "lastLoginDate") as? Date ?? Date.distantPast }
        set { defaults.set(newValue, forKey: "lastLoginDate") }
    }
    
    var winStreak: Int {
        get { defaults.integer(forKey: "winStreak") }
        set { defaults.set(newValue, forKey: "winStreak") }
    }
    
    var loseStreak: Int {
        get { defaults.integer(forKey: "loseStreak") }
        set { defaults.set(newValue, forKey: "loseStreak") }
    }
    
    var maxSingleBet: Int {
        get { defaults.integer(forKey: "maxSingleBet") }
        set { defaults.set(newValue, forKey: "maxSingleBet") }
    }
    
    var maxSingleWin: Int {
        get { defaults.integer(forKey: "maxSingleWin") }
        set { defaults.set(newValue, forKey: "maxSingleWin") }
    }
    
    var hasPlayedFirstGame: Bool {
        get { defaults.bool(forKey: "hasPlayedFirstGame") }
        set { defaults.set(newValue, forKey: "hasPlayedFirstGame") }
    }
    
    private var defaultAchievements: [Achievments] {
        [
            Achievments(image: "achiev1", title: "First Game", subtitle: "Play the game for the first time"),
            Achievments(image: "achiev2", title: "First Victory", subtitle: "For the first time during the game, come out ahead"),
            Achievments(image: "achiev3", title: "First 1.000 coins", subtitle: "Earn your first thousand coins for the first time"),
            Achievments(image: "achiev1", title: "First 100 sparks", subtitle: "Earn your first hundred sparks for the first time"),
            Achievments(image: "achiev2", title: "Coin Collector", subtitle: "Earn a total of 10.000 coins across all games."),
            Achievments(image: "achiev3", title: "Spark Hunter", subtitle: "Earn a total of 500 sparks."),
            Achievments(image: "achiev1", title: "High Roller", subtitle: "Place a single bet of at least 10.000 coins."),
            Achievments(image: "achiev2", title: "Big Win", subtitle: "Win 10.000 coins or more in a single round."),
            Achievments(image: "achiev3", title: "Lucky Streak", subtitle: "Win 3 rounds in a row."),
            Achievments(image: "achiev1", title: "Cold Streak", subtitle: "Lose 5 rounds in a row.")
        ]
    }
    
    func addCoins(_ amount: Int) {
        coins += amount
        totalCoinsEarned += amount
        checkAchievement(.first1000Coins)
        checkAchievement(.coinCollector)
    }
    
    func removeCoins(_ amount: Int) {
        coins = max(coins - amount, 0)
        totalCoinsSpent += amount
    }
    
    func addEnergy(_ amount: Int) {
        energy += amount
    }
    
    func removeEnergy(_ amount: Int) {
        energy = max(energy - amount, 0)
    }
    
    func addExperience() {
        totalExperience += 50
    }
    
    func startGame() {
        hasPlayedFirstGame = true
        checkAchievement(.firstGame)
        updateDayStreak()
    }
    
    func recordWin() {
        winStreak += 1
        loseStreak = 0
        checkAchievement(.luckyStreak)
        checkAchievement(.firstVictory)
    }
    
    func recordLoss() {
        loseStreak += 1
        winStreak = 0
        checkAchievement(.coldStreak)
    }
    
    func recordBet(_ amount: Int) {
        maxSingleBet = max(maxSingleBet, amount)
        checkAchievement(.highRoller)
    }
    
    func recordWinAmount(_ amount: Int) {
        maxSingleWin = max(maxSingleWin, amount)
        checkAchievement(.bigWin)
    }
    
    func addSparks(_ amount: Int) {
        totalSparks += amount
        checkAchievement(.first100Sparks)
        checkAchievement(.sparkHunter)
    }
    
    private func checkAchievement(_ type: AchievementType) {
        for i in 0..<achievements.count {
            if matchesAchievementType(achievements[i], type) {
                achievements[i].isDone = true
                break
            }
        }
    }
    
    private enum AchievementType {
        case firstGame, firstVictory, first1000Coins, first100Sparks
        case coinCollector, sparkHunter, highRoller, bigWin, luckyStreak, coldStreak
    }
    
    private func matchesAchievementType(_ achievement: Achievments, _ type: AchievementType) -> Bool {
        switch type {
        case .firstGame: return achievement.title == "First Game" && hasPlayedFirstGame
        case .firstVictory: return achievement.title == "First Victory" && winStreak > 0
        case .first1000Coins: return achievement.title == "First 1.000 coins" && totalCoinsEarned >= 1000
        case .first100Sparks: return achievement.title == "First 100 sparks" && totalSparks >= 100
        case .coinCollector: return achievement.title == "Coin Collector" && totalCoinsEarned >= 10000
        case .sparkHunter: return achievement.title == "Spark Hunter" && totalSparks >= 500
        case .highRoller: return achievement.title == "High Roller" && maxSingleBet >= 10000
        case .bigWin: return achievement.title == "Big Win" && maxSingleWin >= 10000
        case .luckyStreak: return achievement.title == "Lucky Streak" && winStreak >= 3
        case .coldStreak: return achievement.title == "Cold Streak" && loseStreak >= 5
        default: return false
        }
    }
    
    private func updateDayStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        let lastLogin = Calendar.current.startOfDay(for: lastLoginDate)
        
        if Calendar.current.isDate(today, inSameDayAs: lastLogin) {
        } else if Calendar.current.isDate(today, equalTo: lastLogin, toGranularity: .day) {
            dayStreak += 1
        } else {
            dayStreak = 1
        }
        
        lastLoginDate = Date()
    }
}
