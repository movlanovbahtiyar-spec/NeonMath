import Foundation

/// Defines the category of geometry, algebra, and trigonometry problems.
public enum QuestionType: String, CaseIterable, Codable {
    // Geometry
    case triangleAngle = "Geometry: Triangle Angle"
    case transversalParallel = "Geometry: Parallel Transversal"
    case supplementaryLines = "Geometry: Supplementary Angles"
    case inscribedCircleAngle = "Geometry: Inscribed Circle Angle"
    case circleTangent = "Geometry: Circle Tangent"
    case geometricIQPattern = "Geometry: IQ Pattern"
    
    // Trigonometry
    case unitCircle = "Trigonometry: Unit Circle"
    case triangleTrig = "Trigonometry: Right Triangle Ratio"
    case trigIdentity = "Trigonometry: Identities"
    
    // Algebra
    case vectorPuzzle = "Algebra: Vector Coordinate"
    case functionGraph = "Algebra: Function Graph"
    case matrixGrid = "Algebra: Matrix Grid"
}

/// Represents the active difficulty tier of the procedural question.
public enum AppDifficulty {
    case easy
    case medium
    case hard
    case expert
}

/// Represents a single procedurally generated math question.
public struct Question: Identifiable, Codable, Equatable {
    public let id: UUID
    public let type: QuestionType
    public let prompt: String
    public let options: [String]
    public let correctAnswer: String
    
    /// Dictionary of numerical parameters required by CanvasDrawView to render the geometry.
    public let numericValues: [String: Double]
    
    /// Dictionary of custom text labels to draw at specific positions on the canvas.
    public let stringValues: [String: String]
    
    public init(
        id: UUID = UUID(),
        type: QuestionType,
        prompt: String,
        options: [String],
        correctAnswer: String,
        numericValues: [String: Double],
        stringValues: [String: String] = [:]
    ) {
        self.id = id
        self.type = type
        self.prompt = prompt
        self.options = options
        self.correctAnswer = correctAnswer
        self.numericValues = numericValues
        self.stringValues = stringValues
    }
    
    // MARK: - Backward Compatible Codable Decoder
    
    private enum CodingKeys: String, CodingKey {
        case id, type, prompt, options, correctAnswer, numericValues, stringValues
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.type = try container.decode(QuestionType.self, forKey: .type)
        self.prompt = try container.decode(String.self, forKey: .prompt)
        self.options = try container.decode([String].self, forKey: .options)
        self.correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        self.numericValues = try container.decode([String: Double].self, forKey: .numericValues)
        self.stringValues = try container.decodeIfPresent([String: String].self, forKey: .stringValues) ?? [:]
    }
    
    /// Generates a question dynamically adjusted to the player's current score (Dynamic Difficulty Adjustment) and chosen language.
    /// Questions are chosen at random from all topics, but their difficulty scales based on score.
    public static func generate(forScore score: Int, language: AppLanguage) -> Question {
        // Resolve difficulty based on active score progression
        let difficulty: AppDifficulty
        if score <= 500 {
            difficulty = .easy
        } else if score <= 1200 {
            difficulty = .medium
        } else if score <= 2000 {
            difficulty = .hard
        } else {
            difficulty = .expert
        }
        
        // Pick any math topic randomly to mix subjects
        let tierType = QuestionType.allCases.randomElement() ?? .triangleAngle
        
        switch tierType {
        case .triangleAngle:
            return generateTriangleAngleQuestion(difficulty: difficulty, language: language)
        case .transversalParallel:
            return generateParallelTransversalQuestion(difficulty: difficulty, language: language)
        case .supplementaryLines:
            return generateSupplementaryLinesQuestion(difficulty: difficulty, language: language)
        case .inscribedCircleAngle:
            return generateInscribedCircleAngleQuestion(difficulty: difficulty, language: language)
        case .circleTangent:
            return generateCircleTangentQuestion(difficulty: difficulty, language: language)
        case .geometricIQPattern:
            return generateGeometricIQPatternQuestion(difficulty: difficulty, language: language)
        case .unitCircle:
            return generateUnitCircleQuestion(difficulty: difficulty, language: language)
        case .triangleTrig:
            return generateTriangleTrigQuestion(difficulty: difficulty, language: language)
        case .trigIdentity:
            return generateTrigIdentityQuestion(difficulty: difficulty, language: language)
        case .vectorPuzzle:
            return generateVectorPuzzleQuestion(difficulty: difficulty, language: language)
        case .functionGraph:
            return generateFunctionGraphQuestion(difficulty: difficulty, language: language)
        case .matrixGrid:
            return generateMatrixGridQuestion(difficulty: difficulty, language: language)
        }
    }
    
    public static func generateRandom(language: AppLanguage) -> Question {
        return generate(forScore: Int.random(in: 0...2500), language: language)
    }
    
    // MARK: - Procedural Generators (Geometry)
    
    private static func generateTriangleAngleQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let angleA: Double
        let angleB: Double
        let angleC: Double
        
        let prompt: String
        let correctString: String
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        var strings: [String: String] = [:]
        
        switch difficulty {
        case .easy:
            // Find x: two simple integer angles given
            angleA = Double(Int.random(in: 40...80))
            angleB = Double(Int.random(in: 35...75))
            angleC = 180.0 - angleA - angleB
            
            let unknownSelector = Int.random(in: 0...2)
            let correctAnswerVal = unknownSelector == 0 ? angleA : (unknownSelector == 1 ? angleB : angleC)
            correctString = "\(Int(correctAnswerVal))°"
            distractors = [Int(correctAnswerVal) + 10, Int(correctAnswerVal) - 10, 180 - Int(angleA)]
                .filter { $0 != Int(correctAnswerVal) && $0 > 10 }
                .map { "\($0)°" }
            
            let label = unknownSelector == 0 ? "A" : (unknownSelector == 1 ? "B" : "C")
            let format = Localizer.string(forKey: "find_unknown_x", lang: language)
            prompt = String(format: format, label)
            
            numeric = ["angleA": angleA, "angleB": angleB, "angleC": angleC, "unknownIndex": Double(unknownSelector)]
            
        case .medium:
            // One angle is expressed as algebra: angle C is 2x. A = 50, B = 70. Solve for x.
            angleA = 50.0
            angleB = 70.0
            angleC = 60.0
            
            correctString = "30"
            distractors = ["25", "35", "40"]
            prompt = Localizer.string(forKey: "solve_for_x", lang: language)
            
            numeric = ["angleA": angleA, "angleB": angleB, "angleC": angleC, "unknownIndex": 2.0]
            strings = ["label0": "50°", "label1": "70°", "label2": "2x"]
            
        case .hard, .expert:
            // Two angles are algebraic: A = x + 15, B = 2x, C = 75°. Solve for x (x = 30).
            angleA = 45.0
            angleB = 60.0
            angleC = 75.0
            
            correctString = "30"
            distractors = ["20", "25", "35"]
            prompt = Localizer.string(forKey: "solve_for_x", lang: language)
            
            numeric = ["angleA": angleA, "angleB": angleB, "angleC": angleC, "unknownIndex": 0.0]
            strings = ["label0": "x + 15", "label1": "2x", "label2": "75°"]
        }
        
        let options = shuffleOptions(correct: correctString, distractors: distractors)
        return Question(type: .triangleAngle, prompt: prompt, options: options, correctAnswer: correctString, numericValues: numeric, stringValues: strings)
    }
    
    private static func generateParallelTransversalQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let angleTheta = Double(Int.random(in: 45...75))
        let angleBeta = 180.0 - angleTheta
        var prompt = Localizer.string(forKey: "parallel_lines_x", lang: language)
        
        var correctString = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        var strings: [String: String] = [:]
        
        switch difficulty {
        case .easy:
            // Given 110° corresponding to x
            let thetaIndices = [0, 3, 4, 7]
            let givenIndex = 3
            let unknownIndex = 0 // equal corresponding angle
            
            correctString = "\(Int(angleTheta))°"
            distractors = ["\(Int(angleBeta))°", "\(Int(angleTheta + 10))°", "\(Int(angleTheta - 10))°"]
            
            numeric = ["angleTheta": angleTheta, "givenIndex": Double(givenIndex), "unknownIndex": Double(unknownIndex), "givenAngleValue": angleTheta]
            
        case .medium:
            // Given 115° at index 3, unknown 5x at index 0. 5x = 65 -> x = 13.
            let angleThetaVal = 65.0
            let angleBetaVal = 115.0
            
            correctString = "13"
            distractors = ["11", "15", "12"]
            
            numeric = ["angleTheta": angleThetaVal, "givenIndex": 3.0, "unknownIndex": 0.0, "givenAngleValue": angleBetaVal]
            strings = ["label3": "115°", "label0": "5x"]
            
        case .hard, .expert:
            // Given 3x - 10 at index 0, unknown 2x + 15 at index 4 (equal angles). 3x - 10 = 2x + 15 -> x = 25.
            let angleThetaVal = 65.0
            let angleBetaVal = 115.0
            
            correctString = "25"
            distractors = ["20", "30", "15"]
            prompt = Localizer.string(forKey: "solve_for_x", lang: language)
            
            numeric = ["angleTheta": angleThetaVal, "givenIndex": 0.0, "unknownIndex": 4.0, "givenAngleValue": angleThetaVal]
            strings = ["label0": "3x - 10", "label4": "2x + 15"]
        }
        
        let options = shuffleOptions(correct: correctString, distractors: distractors)
        return Question(type: .transversalParallel, prompt: prompt, options: options, correctAnswer: correctString, numericValues: numeric, stringValues: strings)
    }
    
    private static func generateSupplementaryLinesQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        var prompt = Localizer.string(forKey: "angles_straight_line", lang: language)
        var correctString = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        var strings: [String: String] = [:]
        
        switch difficulty {
        case .easy:
            // Left is x, right is 115°
            let angleA = 65.0 // left
            let angleB = 115.0 // right
            correctString = "65°"
            distractors = ["115°", "55°", "75°"]
            
            numeric = ["angleA": angleA, "angleB": angleB, "isALeft": 1.0, "isAUnknown": 1.0]
            
        case .medium:
            // Left is 5x, right is 55°. 5x + 55 = 180 -> 5x = 125 -> x = 25.
            let angleA = 125.0
            let angleB = 55.0
            correctString = "25"
            distractors = ["20", "30", "15"]
            
            numeric = ["angleA": angleA, "angleB": angleB, "isALeft": 1.0, "isAUnknown": 1.0]
            strings = ["labelLeft": "5x", "labelRight": "55°"]
            
        case .hard, .expert:
            // Left is 2x + 10, right is 3x - 5. 5x + 5 = 180 -> 5x = 175 -> x = 35.
            let angleA = 80.0 // 2 * 35 + 10
            let angleB = 100.0 // 3 * 35 - 5
            correctString = "35"
            distractors = ["30", "40", "25"]
            prompt = Localizer.string(forKey: "solve_for_x", lang: language)
            
            numeric = ["angleA": angleA, "angleB": angleB, "isALeft": 1.0, "isAUnknown": 1.0]
            strings = ["labelLeft": "2x + 10", "labelRight": "3x - 5"]
        }
        
        let options = shuffleOptions(correct: correctString, distractors: distractors)
        return Question(type: .supplementaryLines, prompt: prompt, options: options, correctAnswer: correctString, numericValues: numeric, stringValues: strings)
    }
    
    private static func generateInscribedCircleAngleQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        var prompt = ""
        var correctString = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        var strings: [String: String] = [:]
        
        switch difficulty {
        case .easy:
            // Simple inscribed (45) -> find central (90)
            let inscribedAngle = 45.0
            let centralAngle = 90.0
            correctString = "90°"
            distractors = ["45°", "180°", "60°"]
            prompt = Localizer.string(forKey: "find_central_angle", lang: language)
            
            numeric = ["inscribedAngle": inscribedAngle, "centralAngle": centralAngle, "askForCentral": 1.0]
            
        case .medium:
            // Central is 2x + 10, Inscribed is 45. 2x + 10 = 90 -> 2x = 80 -> x = 40.
            let inscribedAngle = 45.0
            let centralAngle = 90.0
            correctString = "40"
            distractors = ["35", "45", "50"]
            prompt = Localizer.string(forKey: "solve_for_x", lang: language)
            
            numeric = ["inscribedAngle": inscribedAngle, "centralAngle": centralAngle, "askForCentral": 1.0]
            strings = ["labelCentral": "2x + 10", "labelInscribed": "45°"]
            
        case .hard, .expert:
            // Central is 4x, Inscribed is x + 25. 4x = 2x + 50 -> 2x = 50 -> x = 25.
            let inscribedAngle = 50.0
            let centralAngle = 100.0
            correctString = "25"
            distractors = ["20", "30", "15"]
            prompt = Localizer.string(forKey: "solve_for_x", lang: language)
            
            numeric = ["inscribedAngle": inscribedAngle, "centralAngle": centralAngle, "askForCentral": 1.0]
            strings = ["labelCentral": "4x", "labelInscribed": "x + 25"]
        }
        
        let options = shuffleOptions(correct: correctString, distractors: distractors)
        return Question(type: .inscribedCircleAngle, prompt: prompt, options: options, correctAnswer: correctString, numericValues: numeric, stringValues: strings)
    }
    
    private static func generateCircleTangentQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        var prompt = Localizer.string(forKey: "radius_meets_tangent", lang: language)
        var correctString = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        var strings: [String: String] = [:]
        
        switch difficulty {
        case .easy:
            // Center is 50 -> find tangent (40)
            let centerAngle = 50.0
            let unknownAngle = 40.0
            correctString = "40°"
            distractors = ["50°", "90°", "30°"]
            
            numeric = ["centerAngle": centerAngle, "unknownAngle": unknownAngle]
            
        case .medium:
            // Center is 2x, outer is x. 3x = 90 -> x = 30.
            let centerAngle = 60.0
            let unknownAngle = 30.0
            correctString = "30"
            distractors = ["25", "35", "45"]
            prompt = Localizer.string(forKey: "solve_for_x", lang: language)
            
            numeric = ["centerAngle": centerAngle, "unknownAngle": unknownAngle]
            strings = ["labelCenter": "2x", "labelTangent": "x"]
            
        case .hard, .expert:
            // Center is x + 10, outer is 2x - 10. 3x = 90 -> x = 30.
            let centerAngle = 40.0 // 30 + 10
            let unknownAngle = 50.0 // 60 - 10
            correctString = "30"
            distractors = ["25", "35", "20"]
            prompt = Localizer.string(forKey: "solve_for_x", lang: language)
            
            numeric = ["centerAngle": centerAngle, "unknownAngle": unknownAngle]
            strings = ["labelCenter": "x + 10", "labelTangent": "2x - 10"]
        }
        
        let options = shuffleOptions(correct: correctString, distractors: distractors)
        return Question(type: .circleTangent, prompt: prompt, options: options, correctAnswer: correctString, numericValues: numeric, stringValues: strings)
    }
    
    private static func generateGeometricIQPatternQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let sides = 3
        var vertexValues = [5, 4, 3, 0]
        var centerValue = 36 // (5+4+3) * 3
        
        switch difficulty {
        case .easy:
            vertexValues = [3, 2, 4, 0]
            centerValue = 27
        case .medium:
            vertexValues = [6, 4, 5, 0]
            centerValue = 45
        case .hard, .expert:
            vertexValues = [8, 7, 5, 0]
            centerValue = 60
        }
        
        let correctString = "\(centerValue)"
        let distractors = ["\(centerValue - 5)", "\(centerValue + 10)", "\(vertexValues.reduce(0, +))"]
        let prompt = Localizer.string(forKey: "decode_vertex_pattern", lang: language)
        let options = shuffleOptions(correct: correctString, distractors: distractors)
        
        return Question(
            type: .geometricIQPattern,
            prompt: prompt,
            options: options,
            correctAnswer: correctString,
            numericValues: [
                "sides": Double(sides),
                "vertex0": Double(vertexValues[0]),
                "vertex1": Double(vertexValues[1]),
                "vertex2": Double(vertexValues[2]),
                "vertex3": 0.0,
                "centerValue": Double(centerValue)
            ]
        )
    }
    
    // MARK: - Procedural Generators (Trigonometry)
    
    private static func generateUnitCircleQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        var selectedAngle = 45.0
        var trigFuncIndex = 0 // 0: sin, 1: cos, 2: tan
        
        switch difficulty {
        case .easy:
            // Quadrant 1 simple angles
            selectedAngle = [30.0, 45.0, 60.0].randomElement() ?? 45.0
            trigFuncIndex = Int.random(in: 0...1) // sin/cos
        case .medium:
            // Quadrant 2 angles
            selectedAngle = [120.0, 135.0, 150.0].randomElement() ?? 135.0
            trigFuncIndex = Int.random(in: 0...2) // sin/cos/tan
        case .hard, .expert:
            // Quadrant 3/4 angles
            selectedAngle = [210.0, 240.0, 315.0].randomElement() ?? 240.0
            trigFuncIndex = Int.random(in: 0...2)
        }
        
        let funcLabel = trigFuncIndex == 0 ? "sin" : (trigFuncIndex == 1 ? "cos" : "tan")
        let promptFormat = Localizer.string(forKey: "evaluate_trig", lang: language)
        let promptText = String(format: promptFormat, funcLabel, Int(selectedAngle))
        
        let correctAnswerVal: String
        let distractors: [String]
        
        switch (selectedAngle, trigFuncIndex) {
        case (30.0, 0): correctAnswerVal = "1/2"; distractors = ["√3/2", "√2/2", "-1/2"]
        case (30.0, 1): correctAnswerVal = "√3/2"; distractors = ["1/2", "√2/2", "-√3/2"]
        case (30.0, 2): correctAnswerVal = "√3/3"; distractors = ["√3", "1", "1/2"]
            
        case (45.0, 0): correctAnswerVal = "√2/2"; distractors = ["1/2", "√3/2", "1"]
        case (45.0, 1): correctAnswerVal = "√2/2"; distractors = ["1/2", "√3/2", "0"]
        case (45.0, 2): correctAnswerVal = "1"; distractors = ["√3", "√3/3", "0"]
            
        case (60.0, 0): correctAnswerVal = "√3/2"; distractors = ["1/2", "√2/2", "-1/2"]
        case (60.0, 1): correctAnswerVal = "1/2"; distractors = ["√3/2", "√2/2", "-√3/2"]
        case (60.0, 2): correctAnswerVal = "√3"; distractors = ["√3/3", "1", "2"]
            
        case (120.0, 0): correctAnswerVal = "√3/2"; distractors = ["-1/2", "1/2", "-√3/2"]
        case (120.0, 1): correctAnswerVal = "-1/2"; distractors = ["-√3/2", "1/2", "√3/2"]
        case (120.0, 2): correctAnswerVal = "-√3"; distractors = ["-√3/3", "√3", "1"]
            
        case (135.0, 0): correctAnswerVal = "√2/2"; distractors = ["-√2/2", "1/2", "-1"]
        case (135.0, 1): correctAnswerVal = "-√2/2"; distractors = ["√2/2", "-1/2", "0"]
        case (135.0, 2): correctAnswerVal = "-1"; distractors = ["1", "-√3", "0"]
            
        case (150.0, 0): correctAnswerVal = "1/2"; distractors = ["-√3/2", "-1/2", "√3/2"]
        case (150.0, 1): correctAnswerVal = "-√3/2"; distractors = ["-1/2", "1/2", "√3/2"]
        case (150.0, 2): correctAnswerVal = "-√3/3"; distractors = ["-√3", "√3/3", "-1"]
            
        case (210.0, 0): correctAnswerVal = "-1/2"; distractors = ["1/2", "-√3/2", "√3/2"]
        case (210.0, 1): correctAnswerVal = "-√3/2"; distractors = ["-1/2", "1/2", "√2/2"]
        case (210.0, 2): correctAnswerVal = "√3/3"; distractors = ["-√3/3", "√3", "-1"]
            
        case (240.0, 0): correctAnswerVal = "-√3/2"; distractors = ["-1/2", "1/2", "-√2/2"]
        case (240.0, 1): correctAnswerVal = "-1/2"; distractors = ["-√3/2", "1/2", "√3/2"]
        case (240.0, 2): correctAnswerVal = "√3"; distractors = ["√3/3", "-√3", "1"]
            
        case (315.0, 0): correctAnswerVal = "-√2/2"; distractors = ["√2/2", "-1/2", "-1"]
        case (315.0, 1): correctAnswerVal = "√2/2"; distractors = ["-√2/2", "1/2", "0"]
        case (315.0, 2): correctAnswerVal = "-1"; distractors = ["1", "-√3", "0"]
            
        default:
            correctAnswerVal = "1/2"; distractors = ["√3/2", "-1/2"]
        }
        
        let options = shuffleOptions(correct: correctAnswerVal, distractors: distractors)
        
        return Question(
            type: .unitCircle,
            prompt: promptText,
            options: options,
            correctAnswer: correctAnswerVal,
            numericValues: [
                "angle": selectedAngle,
                "trigFunc": Double(trigFuncIndex)
            ]
        )
    }
    
    private static func generateTriangleTrigQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let trigFuncIndex = Int.random(in: 0...2) // 0: sin, 1: cos, 2: tan
        let funcLabel = trigFuncIndex == 0 ? "sin" : (trigFuncIndex == 1 ? "cos" : "tan")
        
        var prompt = ""
        var correctAnswerVal = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        var strings: [String: String] = [:]
        
        switch difficulty {
        case .easy:
            // Pythagorean triple 3, 4, 5. Find ratio directly
            correctAnswerVal = trigFuncIndex == 0 ? "3/5" : (trigFuncIndex == 1 ? "4/5" : "3/4")
            distractors = ["4/5", "3/5", "3/4", "4/3", "5/4"].filter { $0 != correctAnswerVal }
            
            prompt = String(format: Localizer.string(forKey: "triangle_ratio", lang: language), funcLabel)
            numeric = ["opposite": 3.0, "adjacent": 4.0, "hypotenuse": 5.0, "trigFunc": Double(trigFuncIndex), "askSideA": 1.0]
            
        case .medium:
            // Pythagorean triple 5, 12, 13
            correctAnswerVal = trigFuncIndex == 0 ? "5/13" : (trigFuncIndex == 1 ? "12/13" : "5/12")
            distractors = ["12/13", "5/13", "5/12", "12/5", "13/12"].filter { $0 != correctAnswerVal }
            
            prompt = String(format: Localizer.string(forKey: "triangle_ratio", lang: language), funcLabel)
            numeric = ["opposite": 5.0, "adjacent": 12.0, "hypotenuse": 13.0, "trigFunc": Double(trigFuncIndex), "askSideA": 1.0]
            
        case .hard, .expert:
            // Solve for side x. Given sin(θ) = 3/5, Hyp = 10, find opposite side x (x = 6).
            correctAnswerVal = "6"
            distractors = ["8", "5", "7"]
            
            let format = Localizer.string(forKey: "find_side_x", lang: language)
            prompt = String(format: format, "sin", "3/5")
            
            numeric = ["opposite": 6.0, "adjacent": 8.0, "hypotenuse": 10.0, "trigFunc": 0.0, "askSideA": 1.0]
            strings = ["labelAdj": "8", "labelOpp": "x", "labelHyp": "10"]
        }
        
        let options = shuffleOptions(correct: correctAnswerVal, distractors: distractors)
        return Question(type: .triangleTrig, prompt: prompt, options: options, correctAnswer: correctAnswerVal, numericValues: numeric, stringValues: strings)
    }
    
    private static func generateTrigIdentityQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let identities: [(String, String, [String])]
        
        switch difficulty {
        case .easy:
            identities = [
                ("sin²(θ) + cos²(θ)", "1", ["0", "-1", "sin(θ)"])
            ]
        case .medium:
            identities = [
                ("1 - cos²(θ)", "sin²(θ)", ["cos²(θ)", "1", "-sin²(θ)"]),
                ("tan(θ) · cos(θ)", "sin(θ)", ["cos(θ)", "tan(θ)", "1"])
            ]
        case .hard, .expert:
            identities = [
                ("sin(2θ) / 2sin(θ)", "cos(θ)", ["sin(θ)", "2cos(θ)", "1/2"]),
                ("cos(2θ) + 2sin²(θ)", "1", ["0", "-1", "cos²(θ)"])
            ]
        }
        
        let selected = identities.randomElement() ?? identities[0]
        let promptFormat = Localizer.string(forKey: "simplify_expression", lang: language)
        let promptText = String(format: promptFormat, selected.0)
        
        let options = shuffleOptions(correct: selected.1, distractors: selected.2)
        
        return Question(
            type: .trigIdentity,
            prompt: promptText,
            options: options,
            correctAnswer: selected.1,
            numericValues: [
                "identityIndex": 0.0
            ]
        )
    }
    
    // MARK: - Procedural Generators (Algebra)
    
    private static func generateVectorPuzzleQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        var prompt = ""
        var correctAnswerVal = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        
        switch difficulty {
        case .easy:
            // Identify coordinate (x, y)
            let xVal = Double([2, 3, 4, -2, -3, -4].randomElement() ?? 3)
            let yVal = Double([1, 2, 3, -1, -2, -3].randomElement() ?? 2)
            
            correctAnswerVal = "(\(Int(xVal)), \(Int(yVal)))"
            distractors = ["(\(Int(yVal)), \(Int(xVal)))", "(-\(Int(xVal)), -\(Int(yVal)))", "(\(Int(xVal)), -\(Int(yVal)))"]
            prompt = Localizer.string(forKey: "identify_coords", lang: language)
            
            numeric = ["vectorX": xVal, "vectorY": yVal, "askCoordinates": 1.0]
            
        case .medium:
            // Calculate magnitude of simple Pythagorean vector (3, 4) or (4, 3)
            let isVertical = Bool.random()
            let xVal = isVertical ? 3.0 : 4.0
            let yVal = isVertical ? 4.0 : 3.0
            
            correctAnswerVal = "5"
            distractors = ["7", "4", "6"]
            prompt = Localizer.string(forKey: "calculate_magnitude", lang: language)
            
            numeric = ["vectorX": xVal, "vectorY": yVal, "askCoordinates": 0.0]
            
        case .hard, .expert:
            // Two vectors: u = (3, 2), v = (1, 4). Calculate dot product (3*1 + 2*4 = 11).
            let uX = Double(Int.random(in: 1...3))
            let uY = Double(Int.random(in: 1...3))
            let vX = Double(Int.random(in: 1...3))
            let vY = Double(Int.random(in: 1...3))
            
            let dotProduct = Int(uX * vX + uY * vY)
            correctAnswerVal = "\(dotProduct)"
            distractors = ["\(dotProduct + 3)", "\(dotProduct - 2)", "\(Int(uX+uY+vX+vY))"]
            prompt = Localizer.string(forKey: "solve_vector_dot", lang: language)
            
            numeric = ["vectorX": uX, "vectorY": uY, "vectorX2": vX, "vectorY2": vY, "askCoordinates": 0.0]
        }
        
        let options = shuffleOptions(correct: correctAnswerVal, distractors: distractors)
        return Question(type: .vectorPuzzle, prompt: prompt, options: options, correctAnswer: correctAnswerVal, numericValues: numeric)
    }
    
    private static func generateFunctionGraphQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let prompt = Localizer.string(forKey: "identify_equation", lang: language)
        var correctAnswerVal = ""
        var distractors: [String] = []
        var paramA = 1.0
        var paramB = 0.0
        var graphTypeIndex = 0.0
        
        switch difficulty {
        case .easy:
            // simple y = x or y = -x
            let isPositive = Bool.random()
            correctAnswerVal = isPositive ? "y = x" : "y = -x"
            distractors = isPositive ? ["y = -x", "y = 2x", "y = x + 1"] : ["y = x", "y = -2x", "y = x - 1"]
            paramA = isPositive ? 1.0 : -1.0
            paramB = 0.0
            graphTypeIndex = 0.0
            
        case .medium:
            // linear y = x + 2 or y = 2x - 1
            let choice = [
                (1.0, 2.0, "y = x + 2", ["y = x - 2", "y = -x + 2", "y = 2x"]),
                (2.0, -1.0, "y = 2x - 1", ["y = x - 1", "y = 2x + 1", "y = -2x - 1"])
            ].randomElement()!
            
            paramA = choice.0
            paramB = choice.1
            correctAnswerVal = choice.2
            distractors = choice.3
            graphTypeIndex = 0.0
            
        case .hard, .expert:
            // quadratic parabola y = x² - 2 or y = -x² + 1
            let choice = [
                (1.0, -2.0, "y = x² - 2", ["y = x² + 2", "y = -x² - 2", "y = 2x²"]),
                (-1.0, 1.0, "y = -x² + 1", ["y = x² + 1", "y = -x²", "y = -2x² + 1"])
            ].randomElement()!
            
            paramA = choice.0
            paramB = choice.1
            correctAnswerVal = choice.2
            distractors = choice.3
            graphTypeIndex = 1.0
        }
        
        let options = shuffleOptions(correct: correctAnswerVal, distractors: distractors)
        return Question(
            type: .functionGraph,
            prompt: prompt,
            options: options,
            correctAnswer: correctAnswerVal,
            numericValues: [
                "graphType": graphTypeIndex,
                "paramA": paramA,
                "paramB": paramB
            ]
        )
    }
    
    private static func generateMatrixGridQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let valA = Double(Int.random(in: 2...6))
        var valB = 0.0
        var valC = 0.0
        var valX = 0.0
        
        switch difficulty {
        case .easy:
            // simple additions A+k
            let k = Double(Int.random(in: 2...4))
            valB = valA + k
            valC = valA + 3
            valX = valC + k
            
        case .medium:
            // multiplications A*k
            let k = 2.0
            valB = valA * k
            valC = valA + 3
            valX = valC * k
            
        case .hard, .expert:
            // complex double actions: X = A * B - C
            valB = Double(Int.random(in: 2...4))
            valC = Double(Int.random(in: 1...3))
            valX = valA * valB - valC
        }
        
        let correctString = "\(Int(valX))"
        let distractors = ["\(Int(valX + 3))", "\(Int(valX - 2))", "\(Int(valB + valC))"].filter { $0 != correctString }
        let prompt = Localizer.string(forKey: "matrix_pattern", lang: language)
        let options = shuffleOptions(correct: correctString, distractors: distractors)
        
        return Question(
            type: .matrixGrid,
            prompt: prompt,
            options: options,
            correctAnswer: correctString,
            numericValues: [
                "valA": valA,
                "valB": valB,
                "valC": valC,
                "valX": valX
            ]
        )
    }
    
    // MARK: - Helper Utilities
    
    private static func shuffleOptions(correct: String, distractors: [String]) -> [String] {
        var uniqueDistractors = Array(Set(distractors)).filter { $0 != correct }
        
        while uniqueDistractors.count < 2 {
            let correctClean = correct.replacingOccurrences(of: "°", with: "")
            let correctVal = Int(correctClean) ?? 5
            let fallbackVal = correctVal + (uniqueDistractors.count == 0 ? 3 : -3)
            let fallbackString = correct.contains("°") ? "\(fallbackVal)°" : "\(fallbackVal)"
            if fallbackString != correct && !uniqueDistractors.contains(fallbackString) {
                uniqueDistractors.append(fallbackString)
            }
        }
        
        var finalOptions = [correct, uniqueDistractors[0], uniqueDistractors[1]]
        finalOptions.shuffle()
        return finalOptions
    }
}

// MARK: - Localizer Central Utility Struct

/// Dedicated translation provider enabling dynamic localization toggling without app restarts.
public struct Localizer {
    public static func string(forKey key: String, lang: AppLanguage) -> String {
        let trDict: [String: String] = [
            // Lobby & Navigation
            "app_title": "NEON MATH",
            "subtitle": "HIZLI BULMACA SİSTEMİ",
            "launch_blitz": "HIZLI BLITZ BAŞLAT",
            "dynamic_run": "60 Saniyelik Dinamik Adaptif Yarış",
            "score": "SKOR",
            "time_remaining": "KALAN SÜRE",
            "high_score": "En Yüksek Skor",
            "high_subtitle": "⚡️ Zirve Blitz Skoru",
            "accuracy": "Doğruluk",
            "acc_subtitle": "🎯 Çözme Oranı",
            "streak": "En İyi Seri",
            "streak_subtitle": "🔥 Kesintisiz İsabete",
            "total_games": "Toplam Oyun",
            "games_subtitle": "🎮 Uçuş Sayısı",
            "active_curriculums": "AKTİF MÜFREDATLAR",
            "rules": "Kurallar",
            "reset": "Sıfırla",
            "reset_confirm": "İstatistikleri Sıfırla?",
            "reset_body": "Bu işlem skorunuzu, doğru cevap sayınızı ve seri rekorunuzu kalıcı olarak silecektir.",
            "reset_action": "Profil Verilerini Sıfırla",
            "cancel": "İptal",
            "solves": "Çözüm",
            "pilot_dossier": "PİLOT DOSYASI",
            "axiom_initiate": "LEVEL 1 • TEMEL SEVİYE",
            "vector_pilot": "LEVEL 2 • ORTA SEVİYE",
            "tangent_commander": "LEVEL 3 • ÇEMBER TEOREMLERİ",
            "matrix_overlord": "LEVEL 4 • DİZİ UZMANI",
            "quantum_architect": "LEVEL 5 • TÜMÜNÜN HAKİMİ",
            "geometry_row": "Geometri (Geometry)",
            "algebra_row": "Cebir (Algebra)",
            "trig_row": "Trigonometri (Trigonometry)",
            "dda_level": "DDA Aşamaları 1-4",
            "score_unlocked": "Skor > 500",
            "trig_unlocked": "Skor > 1200",
            "active_status": "Aktif",
            "system_curriculums": "SİSTEM MÜFREDATI",
            "rules_blitz_time": "BLITZ SÜRE MEKANİKLERİ",
            "rules_points": "• Oyun 60 saniyelik bir süreyle başlar.\n• Doğru cevaplar, aktif Ateş Serisi çarpanınıza göre skor kazandırır.\n• Her doğru cevap sürenize +3 saniye ekler.\n• Her yanlış cevap sürenizden -5 saniye düşer ve ekran sarsıntısını tetikler.",
            
            // Subject Details
            "geom_title": "GEOMETRİ (GEOMETRY)",
            "geom_desc": "Temel özelliklerden çember teoremlerine uzanan işlemsel geometride uzmanlaşın.",
            "geom_t1": "Üçgen İç Açıları (180° iç hesaplamalar)",
            "geom_t2": "Bitişik Doğru Açı Bölmeleri (180° komşu hesaplamalar)",
            "geom_t3": "İç Ters Açı & Kesen paralellik mantığı",
            "geom_t4": "Çevre ve Merkez Açı özellikleri",
            "geom_t5": "Teğet-Yarıçap dikliği (90° özellikleri)",
            "geom_t6": "Köşe değer dizisi IQ bulmacaları",
            
            "alge_title": "CEBİR & ÖRÜNTÜLER (ALGEBRA)",
            "alge_desc": "Standart neon düzlem modellerini kullanarak vektör ve grafik arayüzlerini öğrenin.",
            "alge_t1": "Vektör projeksiyonu ve büyüklük hesabı",
            "alge_t2": "Doğrusal denklem koordinat kesişim noktaları",
            "alge_t3": "İkinci dereceden parabol grafiği formül doğrulama",
            "alge_t4": "Satır/Sütun matris dizisi bulmacaları",
            
            "trig_title": "TRİGONOMETRİ (TRIGONOMETRY)",
            "trig_desc": "Hızlı trigonometrik oranları, birim çember eşleşmelerini ve özdeşlik sadeleştirmelerini test edin.",
            "trig_t1": "Birim çember koordinatları (sin/cos/tan değerlendirmeleri)",
            "trig_t2": "Dik üçgen hipotenüs trigonometrik oranları",
            "trig_t3": "Trigonometrik cebirsel özdeşliklerin sadeleştirilmesi",
            
            // GameOver
            "game_over": "BLITZ BİTTİ",
            "dossier_summary": "PİLOT UÇUŞ RAPORU",
            "final_score": "Final Skoru",
            "correct_answers": "Doğru Sayısı",
            "accuracy_rate": "Doğruluk Oranı",
            "new_high_score": "YENİ REKOR!",
            "return_lobby": "LOBİYE DÖN",
            "play_again": "YENİDEN OYNA",
            
            // Prompts & Questions
            "find_unknown_x": "Vertex %@'deki bilinmeyen x açısını bulun.",
            "parallel_lines_x": "Paralel doğrular kesişti. x açısını bulun.",
            "angles_straight_line": "Doğru üzerindeki açılar verilmiştir. x açısını hesaplayın.",
            "find_central_angle": "Aynı yayı gören merkez açıyı (x) bulun.",
            "find_inscribed_angle": "Aynı yayı gören çevre açıyı (x) bulun.",
            "radius_meets_tangent": "Yarıçap teğet doğruyla kesişiyor. Bilinmeyen x açısını bulun.",
            "decode_vertex_pattern": "Bilinmeyen x merkez değerini bulmak için köşe örüntüsünü çözün.",
            "evaluate_trig": "Birim çember üzerindeki işaretli açı için %@(θ) değerini bulun (θ = %d°).",
            "triangle_ratio": "Dik üçgende, işaretli açı için %@(θ) oranını bulun.",
            "simplify_expression": "İfadeyi sadeleştirin: %@",
            "identify_coords": "Neon u vektörünün (x, y) koordinatlarını bulun.",
            "calculate_magnitude": "u vektörünün ||u|| büyüklüğünü hesaplayın.",
            "identify_equation": "Çizilen neon grafiğe karşılık gelen matematiksel denklemi bulun.",
            "matrix_pattern": "Bilinmeyen x değişkenini bulmak için sayı örüntü matrisini analiz edin.",
            
            "solve_for_x": "Şekilde verilen denklemi çözerek bilinmeyen x değerini hesaplayın.",
            "solve_vector_dot": "Neon u ve v vektörlerinin iç (nokta) çarpımını (u · v) hesaplayın.",
            "find_side_x": "Eğer %@(θ) = %@ ise, dik üçgendeki bilinmeyen x kenar uzunluğunu bulun."
        ]
        
        let enDict: [String: String] = [
            // Lobby & Navigation
            "app_title": "NEON MATH",
            "subtitle": "SPEED PUZZLING SYSTEM",
            "launch_blitz": "LAUNCH SPEED BLITZ",
            "dynamic_run": "60-Second Dynamic Adaptive Run",
            "score": "SCORE",
            "time_remaining": "TIME REMAINING",
            "high_score": "High Score",
            "high_subtitle": "⚡️ Peak Blitz Run",
            "accuracy": "Accuracy",
            "acc_subtitle": "🎯 Solved Rate",
            "streak": "Best Streak",
            "streak_subtitle": "🔥 Unbroken Hits",
            "total_games": "Total Games",
            "games_subtitle": "🎮 Flight Count",
            "active_curriculums": "ACTIVE CURRICULUMS",
            "rules": "Rules",
            "reset": "Reset",
            "reset_confirm": "Reset Statistics?",
            "reset_body": "This will permanently clear your score, solve count, and streak record.",
            "reset_action": "Reset Profile Data",
            "cancel": "Cancel",
            "solves": "Solves",
            "pilot_dossier": "PILOT DOSSIER",
            "axiom_initiate": "LEVEL 1 • INITIATE",
            "vector_pilot": "LEVEL 2 • VECTOR PILOT",
            "tangent_commander": "LEVEL 3 • COMMANDER",
            "matrix_overlord": "LEVEL 4 • OVERLORD",
            "quantum_architect": "LEVEL 5 • ARCHITECT",
            "geometry_row": "Geometry (Geometri)",
            "algebra_row": "Algebra (Cebir)",
            "trig_row": "Trigonometry (Trigonometri)",
            "dda_level": "DDA Tiers 1-4",
            "score_unlocked": "Score > 500",
            "trig_unlocked": "Score > 1200",
            "active_status": "Active",
            "system_curriculums": "SYSTEM CURRICULUMS",
            "rules_blitz_time": "BLITZ TIME MECHANICS",
            "rules_points": "• Game starts with a 60-second limit.\n• Correct answers award score points based on your active Hot Streak multiplier.\n• Correct answers inject +3 seconds back to the countdown.\n• Incorrect answers deduct -5 seconds and activate a camera shake.",
            
            // Subject Details
            "geom_title": "GEOMETRY (GEOMETRİ)",
            "geom_desc": "Master procedural spatial math ranging from basic properties to circle theorems.",
            "geom_t1": "Triangle Sum (180° interior calculations)",
            "geom_t2": "Supplementary Line Splits (Adjacent 180° calculations)",
            "geom_t3": "Alternate Interior & Transversal intersection logic",
            "geom_t4": "Inscribed and Central Arc theorems",
            "geom_t5": "Tangent-radius perpendicularity (90° properties)",
            "geom_t6": "Vertex IQ arithmetic sequence challenges",
            
            "alge_title": "ALGEBRA & PATTERNS (CEBİR)",
            "alge_desc": "Understand vectors and graphing interfaces using standard neon plane models.",
            "alge_t1": "Vector projection and magnitude calculations",
            "alge_t2": "Linear equation coordinate intersection points",
            "alge_t3": "Quadratic parabola graphing formula validation",
            "alge_t4": "Row/Column matrix sequence deductions",
            
            "trig_title": "TRIGONOMETRY (TRİGONOMETRİ)",
            "trig_desc": "Test quick trigonometric ratios, unit circle mappings, and identity simplification.",
            "trig_t1": "Unit circle coordinates (sin/cos/tan evaluations)",
            "trig_t2": "Right angle hypotenuse trigonometric ratios",
            "trig_t3": "Simplifying trigonometric algebraic identities",
            
            // GameOver
            "game_over": "BLITZ OVER",
            "dossier_summary": "PILOT FLIGHT SUMMARY",
            "final_score": "Final Score",
            "correct_answers": "Correct Answers",
            "accuracy_rate": "Accuracy Rate",
            "new_high_score": "NEW HIGH SCORE!",
            "return_lobby": "RETURN TO LOBBY",
            "play_again": "PLAY AGAIN",
            
            // Prompts & Questions
            "find_unknown_x": "Find the unknown angle x at vertex %@.",
            "parallel_lines_x": "Parallel lines are intersected. Find the angle marked x.",
            "angles_straight_line": "Angles lie on a straight line. Calculate angle x.",
            "find_central_angle": "Find the central angle x subtended by the same arc.",
            "find_inscribed_angle": "Find the inscribed angle x subtended by the same arc.",
            "radius_meets_tangent": "The radius meets the tangent line. Find the unknown angle x.",
            "decode_vertex_pattern": "Decode the geometric vertex pattern to find the center value x.",
            "evaluate_trig": "Evaluate %@(θ) for the angle θ = %d° marked on the unit circle.",
            "triangle_ratio": "In the right triangle, find the ratio of %@(θ) at the marked angle.",
            "simplify_expression": "Simplify the expression: %@",
            "identify_coords": "Identify the coordinate pair (x, y) of the neon vector u.",
            "calculate_magnitude": "Calculate the magnitude ||u|| of the neon vector u.",
            "identify_equation": "Identify the mathematical equation matching the plotted neon graph.",
            "matrix_pattern": "Analyze the number pattern grid to deduce the missing variable x.",
            
            "solve_for_x": "Solve the algebraic equation in the diagram to find value x.",
            "solve_vector_dot": "Calculate the dot product (u · v) of neon vectors u and v.",
            "find_side_x": "If %@(θ) = %@, find the length of the unknown side x in the right triangle."
        ]
        
        if lang == .tr {
            return trDict[key] ?? key
        } else {
            return enDict[key] ?? key
        }
    }
}
