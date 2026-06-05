import SwiftUI

/// Landing screen displayed when `viewModel.gameState == .lobby`.
/// Simplified menu following premium Apple guidelines: a clean centerpiece,
/// prominent High Score, and a focused start action.
/// All customization, stats, rules, and links are moved to a modal Settings View.
public struct MainLobbyView: View {
    @Bindable var viewModel: GameViewModel
    
    @State private var startButtonScale: CGFloat = 1.0
    @State private var showSettings = false
    
    public init(viewModel: GameViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Rank/Level Resolver
    private var pilotRank: (title: String, subtitle: String, color: Color) {
        let correct = viewModel.userProfile.totalCorrectAnswers
        let lang = viewModel.userProfile.language
        if correct < 15 {
            let subtitleText = lang == .tr ? "Seviye 1 • Temel Öğrenme" : "Level 1 • Learning Basics"
            return (Localizer.string(forKey: "axiom_initiate", lang: lang), subtitleText, Color(hex: "#00F0FF"))
        } else if correct < 35 {
            let subtitleText = lang == .tr ? "Seviye 2 • Orta Kapsam" : "Level 2 • Medium Scope"
            return (Localizer.string(forKey: "vector_pilot", lang: lang), subtitleText, Color(hex: "#39FF14"))
        } else if correct < 70 {
            let subtitleText = lang == .tr ? "Seviye 3 • Çember Teoremleri" : "Level 3 • Circle Theorems"
            return (Localizer.string(forKey: "tangent_commander", lang: lang), subtitleText, Color(hex: "#FF9F0A"))
        } else if correct < 120 {
            let subtitleText = lang == .tr ? "Seviye 4 • Dizi Uzmanı" : "Level 4 • Array Master"
            return (Localizer.string(forKey: "matrix_overlord", lang: lang), subtitleText, Color(hex: "#BD00FF"))
        } else {
            let subtitleText = lang == .tr ? "Seviye 5 • Tümünün Hakimi" : "Level 5 • Master of All"
            return (Localizer.string(forKey: "quantum_architect", lang: lang), subtitleText, Color(hex: "#FF007F"))
        }
    }
    
    public var body: some View {
        let lang = viewModel.userProfile.language
        
        ZStack {
            // Obsidian dark background
            Color(hex: "#0A0A0C").ignoresSafeArea()
            
            // Soft ambient circular glow matching the rank level color
            VStack {
                Circle()
                    .fill(pilotRank.color.opacity(0.05))
                    .frame(width: 320, height: 320)
                    .blur(radius: 80)
                    .offset(y: -80)
                Spacer()
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Top Utility Bar
                HStack {
                    Spacer()
                    
                    // Settings Gear Button
                    Button(action: {
                        HapticFeedbackManager.shared.playSoftImpact()
                        showSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white.opacity(0.55))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 20)
                
                Spacer()
                
                // MARK: - Pi Icon Centerpiece (Evoking math cleanly)
                ZStack {
                    // Soft outer glow ring
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [pilotRank.color.opacity(0.45), pilotRank.color.opacity(0.02)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 140, height: 140)
                        .shadow(color: pilotRank.color.opacity(0.2), radius: 10)
                    
                    // Pi symbol
                    Text("π")
                        .font(.system(size: 72, weight: .bold))
                        .foregroundColor(pilotRank.color)
                        .shadow(color: pilotRank.color.opacity(0.4), radius: 12)
                }
                .padding(.bottom, 24)
                
                // MARK: - App Title Header
                VStack(spacing: 6) {
                    Text(Localizer.string(forKey: "app_title", lang: lang))
                        .font(.system(size: 34, weight: .black))
                        .foregroundColor(.white)
                        .tracking(5.0)
                    
                    Text(Localizer.string(forKey: "subtitle", lang: lang).uppercased())
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white.opacity(0.35))
                        .tracking(3.5)
                }
                .padding(.bottom, 32)
                
                // MARK: - High Score Display
                VStack(spacing: 4) {
                    Text(Localizer.string(forKey: "high_score", lang: lang).uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.4))
                        .tracking(1.5)
                    
                    Text("\(viewModel.userProfile.highScore)")
                        .font(.system(size: 56, weight: .black))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // MARK: - Curriculum Selector Capsule (4 segments)
                HStack(spacing: 0) {
                    ForEach(CurriculumTrack.allCases, id: \.self) { track in
                        Button(action: {
                            HapticFeedbackManager.shared.playSoftImpact()
                            viewModel.updateCurriculumTrack(track)
                        }) {
                            Text(trackTitle(track, lang: lang))
                                .font(.system(size: 10, weight: .black))
                                .tracking(0.5)
                                .foregroundColor(viewModel.userProfile.selectedTrack == track ? .black : .white.opacity(0.6))
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(viewModel.userProfile.selectedTrack == track ? Color.white : Color.clear)
                                )
                        }
                    }
                }
                .padding(3)
                .background(Color.white.opacity(0.06))
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                
                // Active Curriculum Badge Details
                HStack(spacing: 6) {
                    Circle()
                        .fill(pilotRank.color)
                        .frame(width: 6, height: 6)
                        .shadow(color: pilotRank.color, radius: 3)
                    
                    let track = viewModel.userProfile.selectedTrack
                    Text(trackDescription(track, lang: lang))
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white.opacity(0.3))
                        .tracking(1.5)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                }
                .padding(.bottom, 24)
                .padding(.horizontal, 24)
                
                // MARK: - Premium Play Button (Nike Athletics Bold CTA Style)
                VStack(spacing: 12) {
                    Button(action: {
                        HapticFeedbackManager.shared.playHeavyImpact()
                        viewModel.startGame()
                    }) {
                        Text(Localizer.string(forKey: "launch_blitz", lang: lang).uppercased())
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.black)
                            .tracking(2.0)
                            .padding(.vertical, 18)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(28)
                            .shadow(color: Color.white.opacity(0.15), radius: 10, x: 0, y: 6)
                    }
                    .scaleEffect(startButtonScale)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                        ) {
                            startButtonScale = 1.02
                        }
                    }
                    
                    Text(Localizer.string(forKey: "dynamic_run", lang: lang).uppercased())
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white.opacity(0.35))
                        .tracking(2.0)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(viewModel: viewModel, pilotColor: pilotRank.color)
        }
    }
    
    private func trackTitle(_ track: CurriculumTrack, lang: AppLanguage) -> String {
        switch track {
        case .mat1:
            return "MAT-1"
        case .mat2:
            return "MAT-2"
        case .geometry:
            return lang == .tr ? "GEOMETRİ" : "GEOMETRY"
        case .mix:
            return lang == .tr ? "MİX" : "MIX"
        }
    }
    
    private func trackDescription(_ track: CurriculumTrack, lang: AppLanguage) -> String {
        if lang == .tr {
            switch track {
            case .mat1:
                return "MAT-1 MÜFREDATI AKTİF • GEOMETRİ & TEMEL CEBİR"
            case .mat2:
                return "MAT-2 MÜFREDATI AKTİF • TRİGONOMETRİ & İLERİ CEBİR"
            case .geometry:
                return "GEOMETRİ MÜFREDATI AKTİF • TÜM GEOMETRİ KONULARI"
            case .mix:
                return "KARIŞIK MÜFREDAT AKTİF • TÜM KONULAR"
            }
        } else {
            switch track {
            case .mat1:
                return "MAT-1 CURRICULUM ACTIVE • GEOMETRY & ALGEBRA"
            case .mat2:
                return "MAT-2 CURRICULUM ACTIVE • TRIGONOMETRY & VECTORS"
            case .geometry:
                return "GEOMETRY CURRICULUM ACTIVE • ALL GEOMETRIC TOPICS"
            case .mix:
                return "MIXED CURRICULUM ACTIVE • ALL TOPICS"
            }
        }
    }
}

// MARK: - Settings View Modal Sheet
struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: GameViewModel
    let pilotColor: Color
    
    @State private var usernameInput = ""
    @State private var showResetConfirmation = false
    
    var body: some View {
        let lang = viewModel.userProfile.language
        let accuracy = viewModel.userProfile.totalQuestionsAttempted > 0 ?
            Int((Double(viewModel.userProfile.totalCorrectAnswers) / Double(viewModel.userProfile.totalQuestionsAttempted)) * 100) : 0
        
        NavigationStack {
            ZStack {
                Color(hex: "#0A0A0C").ignoresSafeArea()
                
                List {
                    // Profile Section
                    Section(header: Text(lang == .tr ? "PROFİL AYARLARI" : "PROFILE SETTINGS")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white.opacity(0.4))
                        .tracking(1.0)
                    ) {
                        HStack {
                            Text(lang == .tr ? "Kullanıcı Adı" : "Username")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                            TextField(lang == .tr ? "Ad Girin" : "Enter Name", text: $usernameInput)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.plain)
                                .onSubmit {
                                    viewModel.updateUsername(usernameInput)
                                }
                        }
                        .listRowBackground(Color.white.opacity(0.03))
                        
                        // Language Selection
                        HStack {
                            Text(lang == .tr ? "Dil" : "Language")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                            Picker("", selection: Binding(
                                get: { viewModel.userProfile.language },
                                set: { viewModel.updateLanguage($0) }
                            )) {
                                ForEach(AppLanguage.allCases, id: \.self) { item in
                                    Text(item.rawValue).tag(item)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 110)
                        }
                        .listRowBackground(Color.white.opacity(0.03))
                    }
                    
                    // Lifetime Stats Section
                    Section(header: Text(lang == .tr ? "UÇUŞ İSTATİSTİKLERİ" : "FLIGHT STATISTICS")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white.opacity(0.4))
                        .tracking(1.0)
                    ) {
                        StatRow(label: lang == .tr ? "En Yüksek Skor" : "High Score", value: "\(viewModel.userProfile.highScore)")
                        StatRow(label: lang == .tr ? "Toplam Çözüm" : "Total Solves", value: "\(viewModel.userProfile.totalCorrectAnswers)")
                        StatRow(label: lang == .tr ? "Doğruluk Oranı" : "Accuracy Rate", value: "\(accuracy)%")
                        StatRow(label: lang == .tr ? "En İyi Seri" : "Best Streak", value: "\(viewModel.userProfile.streakRecord)")
                        StatRow(label: lang == .tr ? "Toplam Oyun" : "Total Games", value: "\(viewModel.userProfile.totalGamesPlayed)")
                    }
                    .listRowBackground(Color.white.opacity(0.03))
                    
                    // Rules / Active Curriculum Details
                    Section(header: Text(lang == .tr ? "OYUN KURALLARI & MÜFREDAT" : "RULES & CURRICULUM")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white.opacity(0.4))
                        .tracking(1.0)
                    ) {
                        NavigationLink(destination: SettingsRulesDetailView(language: lang)) {
                            Text(lang == .tr ? "Kurallar ve Soru Türleri" : "Rules & Question Types")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .listRowBackground(Color.white.opacity(0.03))
                    }
                    
                    // Legal Section
                    Section(header: Text(lang == .tr ? "YASAL VE SÖZLEŞMELER" : "LEGAL & AGREEMENTS")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white.opacity(0.4))
                        .tracking(1.0)
                    ) {
                        Link(destination: URL(string: "https://movlanovbahtiyar-spec.github.io/NeonMath/terms.html")!) {
                            HStack {
                                Text(lang == .tr ? "Kullanım Koşulları" : "Terms of Service")
                                    .font(.system(size: 15, weight: .semibold))
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 12))
                            }
                            .foregroundColor(.white)
                        }
                        .listRowBackground(Color.white.opacity(0.03))
                        
                        Link(destination: URL(string: "https://movlanovbahtiyar-spec.github.io/NeonMath/privacy.html")!) {
                            HStack {
                                Text(lang == .tr ? "Gizlilik Sözleşmesi" : "Privacy Policy")
                                    .font(.system(size: 15, weight: .semibold))
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 12))
                            }
                            .foregroundColor(.white)
                        }
                        .listRowBackground(Color.white.opacity(0.03))
                    }
                    
                    // Danger Zone Reset Section
                    Section {
                        Button(role: .destructive, action: {
                            HapticFeedbackManager.shared.playWarning()
                            showResetConfirmation = true
                        }) {
                            HStack {
                                Spacer()
                                Text(lang == .tr ? "Profil Verilerini Sıfırla" : "Reset Profile Data")
                                    .font(.system(size: 15, weight: .bold))
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.red.opacity(0.1))
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle(lang == .tr ? "Ayarlar" : "Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(lang == .tr ? "Kapat" : "Close") {
                            viewModel.updateUsername(usernameInput)
                            dismiss()
                        }
                        .foregroundColor(pilotColor)
                    }
                }
            }
        }
        .onAppear {
            usernameInput = viewModel.userProfile.username
        }
        .confirmationDialog(
            Localizer.string(forKey: "reset_confirm", lang: lang),
            isPresented: $showResetConfirmation,
            titleVisibility: .visible
        ) {
            Button(Localizer.string(forKey: "reset_action", lang: lang), role: .destructive) {
                viewModel.resetStats()
                usernameInput = viewModel.userProfile.username
                HapticFeedbackManager.shared.playHeavyImpact()
            }
            Button(Localizer.string(forKey: "cancel", lang: lang), role: .cancel) {}
        } message: {
            Text(Localizer.string(forKey: "reset_body", lang: lang))
        }
    }
}

// MARK: - Settings Rules Detail View
struct SettingsRulesDetailView: View {
    let language: AppLanguage
    
    var body: some View {
        ZStack {
            Color(hex: "#0A0A0C").ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 1. MAT-1 Section
                    SubjectCardView(
                        title: language == .tr ? "MAT-1 MÜFREDATI" : "MAT-1 CURRICULUM",
                        color: Color(hex: "#00F0FF"),
                        icon: "1.circle.fill",
                        description: language == .tr ? "Sayı kümelerinden denklemlere, TYT problemleri ve olasılığa kadar Temel Matematik." : "Comprehensive Basic Mathematics from numbers, equations, word problems to counting & probability.",
                        topics: language == .tr ? [
                            "Sayılar ve Temel Kavramlar (Sayı Kümeleri, Basamaklar, Bölünebilme, Asal Sayılar, EBOB-EKOK)",
                            "Denklem ve Eşitsizlikler (Birinci Dereceden Denklemler, Mutlak Değer, Üslü & Köklü Sayılar)",
                            "Problemler (Sayı, Kesir, Yaş, İşçi, Hız/Hareket, Yüzde, Kâr-Zarar, Karışım Problemleri)",
                            "Mantık, Küme ve Fonksiyon Temelleri (Sembolik Mantık, Kümeler, Kartezyen Çarpım, İstatistik)",
                            "Sayma ve Olasılık (Permütasyon, Kombinasyon, Binom Açılımı, Olasılık Teorisi)"
                        ] : [
                            "Numbers & Basic Concepts (Digit Analysis, Divisibility Rules, Prime Factorization, EBOB-EKOK)",
                            "Equations & Inequalities (Linear Equations, Absolute Values, Exponential & Radical Numbers)",
                            "Word Problems (Number, Fraction, Age, Work, Speed/Motion, Percentages, Profit & Loss)",
                            "Functions, Logic & Sets (Propositional Logic, Set Unions/Intersections, Cartesian Products, Stats)",
                            "Counting & Probability (Permutations, Combinations, Binomial Expansion, Probability)"
                        ]
                    )
                    
                    // 2. MAT-2 Section
                    SubjectCardView(
                        title: language == .tr ? "MAT-2 MÜFREDATI" : "MAT-2 CURRICULUM",
                        color: Color(hex: "#39FF14"),
                        icon: "2.circle.fill",
                        description: language == .tr ? "11 ve 12. sınıf AYT müfredatını kapsayan ileri düzey cebir, trigonometri, logaritma ve dizi sorularını çözün." : "Solve advanced algebra, trigonometry, logarithms, and sequence questions covering the 11th & 12th grade AYT curriculum.",
                        topics: language == .tr ? [
                            "Fonksiyonlar (İleri Düzey) & Polinomlar (Grafik Ötelemeleri, Polinomda Bölme/Kalan Bulma)",
                            "İkinci Dereceden Denklemler, Eşitsizlikler & Karmaşık Sayılar (Kökler, Diskriminant, İşaret Tablosu, Sanal Birim i)",
                            "Trigonometri (Esas Ölçü, Teoremler, Toplam-Fark & Yarım Açı Formülleri, Trigonometrik Denklemler)",
                            "Logaritma (Üstel Fonksiyonlar, Logaritma Özellikleri ve Denklemleri)",
                            "Diziler (Aritmetik ve Geometrik Diziler, Seriler)"
                        ] : [
                            "Advanced Functions & Polynomials (Graph Shifts, Polynomial Division/Remainders)",
                            "Quadratics, Inequalities & Complex Numbers (Roots, Discriminant, Sign Tables, Imaginary Unit i)",
                            "Trigonometry (Reference Angles, Sum-Difference & Half-Angle Formulas, Trig Equations)",
                            "Logarithms (Exponential Functions, Logarithmic Properties & Equations)",
                            "Sequences & Series (Arithmetic & Geometric Progressions)"
                        ]
                    )
                    
                    // 3. GEOMETRİ Section
                    SubjectCardView(
                        title: language == .tr ? "GEOMETRİ MÜFREDATI" : "GEOMETRY CURRICULUM",
                        color: Color(hex: "#BD00FF"),
                        icon: "triangle.fill",
                        description: language == .tr ? "Doğru ve üçgen açılarından, çember teorem ve koordinat yansımalarına uzanın." : "Study angles, right triangle rules, circle theorems, and transformations.",
                        topics: language == .tr ? [
                            "Doğruda Açılar (Kesen & Paralel Doğrular)",
                            "Üçgende Açılar (İç Açı Toplam Hesapları)",
                            "Pisagor Üçlüleri (Dik Üçgen Kenar Bulma)",
                            "Çember Teoremleri (Teğet & Çevre Açı)",
                            "Koordinat Dönüşümleri (Yansıma & Öteleme)"
                        ] : [
                            "Lines & Angles (Parallel Transversals)",
                            "Triangle Angles (180° Interior Calculations)",
                            "Pythagorean Triplets (Right Triangle Sides)",
                            "Circle Theorems (Inscribed & Tangent angles)",
                            "Coordinate Transformations (Reflection & Translation)"
                        ]
                    )
                    
                    // 4. Time Controls Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text(Localizer.string(forKey: "rules_blitz_time", lang: language))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .tracking(1.5)
                        
                        Text(Localizer.string(forKey: "rules_points", lang: language))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                            .lineSpacing(4)
                    }
                    .padding(16)
                    .background(Color.white.opacity(0.04))
                    .cornerRadius(14)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .navigationTitle(language == .tr ? "Kurallar" : "Rules")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Row Helpers
struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

struct SubjectCardView: View {
    let title: String
    let color: Color
    let icon: String
    let description: String
    let topics: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.body)
                
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(color)
                    .tracking(1.0)
            }
            
            Text(description)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(topics, id: \.self) { topic in
                    HStack(alignment: .top, spacing: 6) {
                        Text("•")
                            .foregroundColor(color)
                        Text(topic)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.04))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(color.opacity(0.25), lineWidth: 1)
        )
    }
}
