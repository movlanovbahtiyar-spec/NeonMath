import Foundation

/// Defines the available sub-categories.
public enum Math1SubCategory: String, Codable, CaseIterable {
    case basicNumbers = "Numbers & Basics"
    case equationsInequalities = "Equations & Inequalities"
    case problems = "Problems"
    case foundations = "Functions & Sets"
    case countingProbability = "Counting & Probability"
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawVal = try container.decode(String.self)
        switch rawVal {
        case "Basic Arithmetic", "basicArithmetic":
            self = .basicNumbers
        case "Sequences", "sequences":
            self = .basicNumbers
        case "Venn Diagrams", "vennDiagrams", "Logic", "logic":
            self = .foundations
        case "Ratios", "ratios":
            self = .equationsInequalities
        default:
            self = Math1SubCategory(rawValue: rawVal) ?? .basicNumbers
        }
    }
}

public enum Math2SubCategory: String, Codable, CaseIterable {
    case advancedFunctions = "Advanced Functions & Polynomials"
    case quadraticsComplex = "Quadratics & Complex Numbers"
    case trigonometry = "Advanced Trigonometry"
    case logarithms = "Logarithms"
    case sequencesSeries = "Sequences & Series"
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawVal = try container.decode(String.self)
        switch rawVal {
        case "Function Graphs", "functionGraphs", "Parabola Vertices", "parabolaVertices":
            self = .advancedFunctions
        case "2D Vectors", "vectors2D":
            self = .quadraticsComplex
        case "Unit Circle Trigonometry", "unitCircle":
            self = .trigonometry
        case "Logarithm Basics", "logarithmBasics":
            self = .logarithms
        default:
            self = Math2SubCategory(rawValue: rawVal) ?? .advancedFunctions
        }
    }
}

public enum GeometrySubCategory: String, Codable, CaseIterable {
    case linesAngles = "Lines & Angles"
    case triangleAngles = "Triangle Angles"
    case pythagoreanTriplets = "Pythagorean Triplets"
    case circleTheorems = "Circle Theorems"
    case transformations = "Transformations"
}

public enum QuestionSubCategory: Codable, Equatable {
    case math1(Math1SubCategory)
    case math2(Math2SubCategory)
    case geometry(GeometrySubCategory)
    
    private enum CodingKeys: String, CodingKey {
        case type, value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeStr = try container.decode(String.self, forKey: .type)
        switch typeStr {
        case "math1":
            let val = try container.decode(Math1SubCategory.self, forKey: .value)
            self = .math1(val)
        case "math2":
            let val = try container.decode(Math2SubCategory.self, forKey: .value)
            self = .math2(val)
        case "geometry":
            let val = try container.decode(GeometrySubCategory.self, forKey: .value)
            self = .geometry(val)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown sub-category type")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .math1(let val):
            try container.encode("math1", forKey: .type)
            try container.encode(val, forKey: .value)
        case .math2(let val):
            try container.encode("math2", forKey: .type)
            try container.encode(val, forKey: .value)
        case .geometry(let val):
            try container.encode("geometry", forKey: .type)
            try container.encode(val, forKey: .value)
        }
    }
}

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
    
    // Math 1 New Categories
    case vennDiagrams = "Math1: Venn Diagrams"
    case logic = "Math1: Propositional Logic"
    case ratios = "Math1: Ratios & Proportions"
    
    case tytNumbers = "Math1: Numbers & Basics"
    case tytEquations = "Math1: Equations & Inequalities"
    case tytProblems = "Math1: Word Problems"
    case tytFoundations = "Math1: Functions & Stats"
    case tytProbability = "Math1: Counting & Probability"
    
    // Math 2 New Categories
    case parabolaVertices = "Math2: Parabola Vertices"
    case logarithmBasics = "Math2: Logarithm Basics"
    
    case aytFunctions = "Math2: Advanced Functions"
    case aytQuadratics = "Math2: Quadratics & Complex"
    case aytTrig = "Math2: AYT Trigonometry"
    case aytLog = "Math2: Logarithms"
    case aytSequences = "Math2: Sequences & Series"
    
    // Geometry New Categories
    case transformations = "Geometry: Coordinate Transformations"
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
    public let subCategory: QuestionSubCategory
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
        subCategory: QuestionSubCategory,
        prompt: String,
        options: [String],
        correctAnswer: String,
        numericValues: [String: Double],
        stringValues: [String: String] = [:]
    ) {
        self.id = id
        self.type = type
        self.subCategory = subCategory
        self.prompt = prompt
        self.options = options
        self.correctAnswer = correctAnswer
        self.numericValues = numericValues
        self.stringValues = stringValues
    }
    
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
        self.subCategory = Question.defaultSubCategory(for: type)
        self.prompt = prompt
        self.options = options
        self.correctAnswer = correctAnswer
        self.numericValues = numericValues
        self.stringValues = stringValues
    }
    
    // MARK: - Backward Compatible Codable Decoder
    
    private enum CodingKeys: String, CodingKey {
        case id, type, subCategory, prompt, options, correctAnswer, numericValues, stringValues
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
        
        // Backward compatible decoding for subCategory
        if let sub = try container.decodeIfPresent(QuestionSubCategory.self, forKey: .subCategory) {
            self.subCategory = sub
        } else {
            self.subCategory = Question.defaultSubCategory(for: self.type)
        }
    }
    
    public static func defaultSubCategory(for type: QuestionType) -> QuestionSubCategory {
        switch type {
        case .triangleAngle:
            return .geometry(.triangleAngles)
        case .transversalParallel, .supplementaryLines:
            return .geometry(.linesAngles)
        case .inscribedCircleAngle, .circleTangent:
            return .geometry(.circleTheorems)
        case .geometricIQPattern:
            return .geometry(.transformations)
        case .unitCircle, .trigIdentity:
            return .math2(.trigonometry)
        case .triangleTrig:
            return .geometry(.pythagoreanTriplets)
        case .vectorPuzzle:
            return .math2(.quadraticsComplex)
        case .functionGraph:
            return .math2(.advancedFunctions)
        case .matrixGrid:
            return .math1(.basicNumbers)
        case .vennDiagrams:
            return .math1(.foundations)
        case .logic:
            return .math1(.foundations)
        case .ratios:
            return .math1(.equationsInequalities)
        case .tytNumbers:
            return .math1(.basicNumbers)
        case .tytEquations:
            return .math1(.equationsInequalities)
        case .tytProblems:
            return .math1(.problems)
        case .tytFoundations:
            return .math1(.foundations)
        case .tytProbability:
            return .math1(.countingProbability)
        case .parabolaVertices:
            return .math2(.advancedFunctions)
        case .logarithmBasics:
            return .math2(.logarithms)
        case .aytFunctions:
            return .math2(.advancedFunctions)
        case .aytQuadratics:
            return .math2(.quadraticsComplex)
        case .aytTrig:
            return .math2(.trigonometry)
        case .aytLog:
            return .math2(.logarithms)
        case .aytSequences:
            return .math2(.sequencesSeries)
        case .transformations:
            return .geometry(.transformations)
        }
    }
    
    /// Generates a question dynamically adjusted to the player's current question index (difficulty progression), chosen language, and chosen curriculum track.
    public static func generate(forQuestionIndex index: Int, language: AppLanguage, track: CurriculumTrack) -> Question {
        // Resolve difficulty based on question index (0-19: easy, 20-39: medium, 40+: hard/expert)
        let difficulty: AppDifficulty
        if index < 20 {
            difficulty = .easy
        } else if index < 40 {
            difficulty = .medium
        } else {
            difficulty = index % 2 == 0 ? .hard : .expert
        }
        
        let selectedType: QuestionType
        let chosenSubCategory: QuestionSubCategory
        
        switch track {
        case .mat1:
            let sub = Math1SubCategory.allCases.randomElement() ?? .basicNumbers
            chosenSubCategory = .math1(sub)
            switch sub {
            case .basicNumbers:
                selectedType = [.matrixGrid, .tytNumbers].randomElement() ?? .tytNumbers
            case .equationsInequalities:
                selectedType = [.ratios, .tytEquations].randomElement() ?? .tytEquations
            case .problems:
                selectedType = .tytProblems
            case .foundations:
                selectedType = [.logic, .vennDiagrams, .tytFoundations].randomElement() ?? .tytFoundations
            case .countingProbability:
                selectedType = .tytProbability
            }
        case .mat2:
            let sub = Math2SubCategory.allCases.randomElement() ?? .advancedFunctions
            chosenSubCategory = .math2(sub)
            switch sub {
            case .advancedFunctions:
                selectedType = [.functionGraph, .parabolaVertices, .aytFunctions].randomElement() ?? .aytFunctions
            case .quadraticsComplex:
                selectedType = .aytQuadratics
            case .trigonometry:
                selectedType = [.unitCircle, .trigIdentity, .aytTrig].randomElement() ?? .aytTrig
            case .logarithms:
                selectedType = [.logarithmBasics, .aytLog].randomElement() ?? .aytLog
            case .sequencesSeries:
                selectedType = .aytSequences
            }
        case .geometry:
            let sub = GeometrySubCategory.allCases.randomElement() ?? .linesAngles
            chosenSubCategory = .geometry(sub)
            switch sub {
            case .linesAngles:
                selectedType = [.transversalParallel, .supplementaryLines].randomElement() ?? .transversalParallel
            case .triangleAngles:
                selectedType = .triangleAngle
            case .pythagoreanTriplets:
                selectedType = .triangleTrig
            case .circleTheorems:
                selectedType = [.inscribedCircleAngle, .circleTangent].randomElement() ?? .inscribedCircleAngle
            case .transformations:
                selectedType = .transformations
            }
        case .mix:
            // Weighted selection: 35% Math 1, 35% Math 2, 30% Geometry
            let rand = Double.random(in: 0...100)
            if rand < 35.0 {
                let sub = Math1SubCategory.allCases.randomElement() ?? .basicNumbers
                chosenSubCategory = .math1(sub)
                switch sub {
                case .basicNumbers:
                    selectedType = [.matrixGrid, .tytNumbers].randomElement() ?? .tytNumbers
                case .equationsInequalities:
                    selectedType = [.ratios, .tytEquations].randomElement() ?? .tytEquations
                case .problems:
                    selectedType = .tytProblems
                case .foundations:
                    selectedType = [.logic, .vennDiagrams, .tytFoundations].randomElement() ?? .tytFoundations
                case .countingProbability:
                    selectedType = .tytProbability
                }
            } else if rand < 70.0 {
                let sub = Math2SubCategory.allCases.randomElement() ?? .advancedFunctions
                chosenSubCategory = .math2(sub)
                switch sub {
                case .advancedFunctions:
                    selectedType = [.functionGraph, .parabolaVertices, .aytFunctions].randomElement() ?? .aytFunctions
                case .quadraticsComplex:
                    selectedType = .aytQuadratics
                case .trigonometry:
                    selectedType = [.unitCircle, .trigIdentity, .aytTrig].randomElement() ?? .aytTrig
                case .logarithms:
                    selectedType = [.logarithmBasics, .aytLog].randomElement() ?? .aytLog
                case .sequencesSeries:
                    selectedType = .aytSequences
                }
            } else {
                let sub = GeometrySubCategory.allCases.randomElement() ?? .linesAngles
                chosenSubCategory = .geometry(sub)
                switch sub {
                case .linesAngles: selectedType = [.transversalParallel, .supplementaryLines].randomElement() ?? .transversalParallel
                case .triangleAngles: selectedType = .triangleAngle
                case .pythagoreanTriplets: selectedType = .triangleTrig
                case .circleTheorems: selectedType = [.inscribedCircleAngle, .circleTangent].randomElement() ?? .inscribedCircleAngle
                case .transformations: selectedType = .transformations
                }
            }
        }
        
        var generatedQuestion: Question
        switch selectedType {
        case .triangleAngle:
            generatedQuestion = generateTriangleAngleQuestion(difficulty: difficulty, language: language)
        case .transversalParallel:
            generatedQuestion = generateParallelTransversalQuestion(difficulty: difficulty, language: language)
        case .supplementaryLines:
            generatedQuestion = generateSupplementaryLinesQuestion(difficulty: difficulty, language: language)
        case .inscribedCircleAngle:
            generatedQuestion = generateInscribedCircleAngleQuestion(difficulty: difficulty, language: language)
        case .circleTangent:
            generatedQuestion = generateCircleTangentQuestion(difficulty: difficulty, language: language)
        case .geometricIQPattern:
            generatedQuestion = generateGeometricIQPatternQuestion(difficulty: difficulty, language: language)
        case .unitCircle:
            generatedQuestion = generateUnitCircleQuestion(difficulty: difficulty, language: language)
        case .triangleTrig:
            generatedQuestion = generateTriangleTrigQuestion(difficulty: difficulty, language: language)
        case .trigIdentity:
            generatedQuestion = generateTrigIdentityQuestion(difficulty: difficulty, language: language)
        case .vectorPuzzle:
            generatedQuestion = generateVectorPuzzleQuestion(difficulty: difficulty, language: language)
        case .functionGraph:
            generatedQuestion = generateFunctionGraphQuestion(difficulty: difficulty, language: language)
        case .matrixGrid:
            generatedQuestion = generateMatrixGridQuestion(difficulty: difficulty, language: language)
        case .vennDiagrams:
            generatedQuestion = generateVennDiagramsQuestion(difficulty: difficulty, language: language)
        case .logic:
            generatedQuestion = generateLogicQuestion(difficulty: difficulty, language: language)
        case .ratios:
            generatedQuestion = generateRatiosQuestion(difficulty: difficulty, language: language)
        case .parabolaVertices:
            generatedQuestion = generateParabolaVerticesQuestion(difficulty: difficulty, language: language)
        case .logarithmBasics:
            generatedQuestion = generateLogarithmBasicsQuestion(difficulty: difficulty, language: language)
        case .transformations:
            generatedQuestion = generateTransformationsQuestion(difficulty: difficulty, language: language)
        case .tytNumbers:
            generatedQuestion = generateTytNumbersQuestion(difficulty: difficulty, language: language)
        case .tytEquations:
            generatedQuestion = generateTytEquationsQuestion(difficulty: difficulty, language: language)
        case .tytProblems:
            generatedQuestion = generateTytProblemsQuestion(difficulty: difficulty, language: language)
        case .tytFoundations:
            generatedQuestion = generateTytFoundationsQuestion(difficulty: difficulty, language: language)
        case .tytProbability:
            generatedQuestion = generateTytProbabilityQuestion(difficulty: difficulty, language: language)
        case .aytFunctions:
            generatedQuestion = generateAytFunctionsQuestion(difficulty: difficulty, language: language)
        case .aytQuadratics:
            generatedQuestion = generateAytQuadraticsQuestion(difficulty: difficulty, language: language)
        case .aytTrig:
            generatedQuestion = generateAytTrigQuestion(difficulty: difficulty, language: language)
        case .aytLog:
            generatedQuestion = generateAytLogQuestion(difficulty: difficulty, language: language)
        case .aytSequences:
            generatedQuestion = generateAytSequencesQuestion(difficulty: difficulty, language: language)
        }
        
        // Return question with the exactly chosen subCategory to ensure weighting/tracking fits 100%
        return Question(
            id: generatedQuestion.id,
            type: generatedQuestion.type,
            subCategory: chosenSubCategory,
            prompt: generatedQuestion.prompt,
            options: generatedQuestion.options,
            correctAnswer: generatedQuestion.correctAnswer,
            numericValues: generatedQuestion.numericValues,
            stringValues: generatedQuestion.stringValues
        )
    }
    
    public static func generateRandom(language: AppLanguage, track: CurriculumTrack = .mat1) -> Question {
        return generate(forQuestionIndex: Int.random(in: 0...50), language: language, track: track)
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
        let sides: Int
        var vertexValues: [Int]
        
        switch difficulty {
        case .easy:
            sides = 3
            let v0 = Int.random(in: 2...6)
            let v1 = Int.random(in: 1...5)
            let v2 = Int.random(in: 2...6)
            vertexValues = [v0, v1, v2, 0]
        case .medium:
            sides = 3
            let v0 = Int.random(in: 4...9)
            let v1 = Int.random(in: 3...8)
            let v2 = Int.random(in: 4...9)
            vertexValues = [v0, v1, v2, 0]
        case .hard, .expert:
            sides = 4
            let v0 = Int.random(in: 3...8)
            let v1 = Int.random(in: 2...7)
            let v2 = Int.random(in: 3...8)
            let v3 = Int.random(in: 2...7)
            vertexValues = [v0, v1, v2, v3]
        }
        
        let sum = vertexValues.reduce(0, +)
        let centerValue = sum * sides
        
        let correctString = "\(centerValue)"
        let distractors = ["\(centerValue - sides)", "\(centerValue + sum)", "\(sum)"].filter { $0 != correctString }
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
                "vertex3": sides > 3 ? Double(vertexValues[3]) : 0.0,
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
    
    // MARK: - Procedural Generators (New Sub-categories)
    
    private static func generateVennDiagramsQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let a = Int.random(in: 10...30)
        let b = Int.random(in: 12...35)
        let intersection = Int.random(in: 3...min(a, b) - 2)
        let union = a + b - intersection
        
        let correctString = "\(union)"
        let distractors = ["\(union + 4)", "\(union - 3)", "\(a + b)"].filter { $0 != correctString }
        let options = shuffleOptions(correct: correctString, distractors: distractors)
        
        let prompt = language == .tr ? 
            "|A| = \(a), |B| = \(b) ve |A ∩ B| = \(intersection) ise, |A ∪ B| birleşim kümesinin eleman sayısını bulun." :
            "If |A| = \(a), |B| = \(b), and |A ∩ B| = \(intersection), find the cardinality of the union |A ∪ B|."
        
        return Question(
            type: .vennDiagrams,
            prompt: prompt,
            options: options,
            correctAnswer: correctString,
            numericValues: [
                "a": Double(a),
                "b": Double(b),
                "intersection": Double(intersection),
                "union": Double(union)
            ]
        )
    }
    
    private static func generateLogicQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let p = Int.random(in: 0...1)
        let q = Int.random(in: 0...1)
        let format = Int.random(in: 0...2)
        
        let correctVal: Int
        let expressionStr: String
        
        switch format {
        case 0:
            correctVal = ((p == 1 || q == 1) && p == 0) ? 1 : 0
            expressionStr = "(p ∨ q) ∧ ¬p"
        case 1:
            correctVal = ((p == 1 && q == 1) || q == 0) ? 1 : 0
            expressionStr = "(p ∧ q) ∨ ¬q"
        default:
            correctVal = (p == 1 && q == 0) ? 0 : 1
            expressionStr = "p ⟹ q"
        }
        
        let correctString = "\(correctVal)"
        let undefinedStr = language == .tr ? "Tanımsız" : "Undefined"
        let finalOptions = [correctString, correctVal == 1 ? "0" : "1", undefinedStr].shuffled()
        
        let prompt = language == .tr ?
            "p = \(p) ve q = \(q) için verilen mantıksal ifadenin doğruluk değerini bulun: \(expressionStr)" :
            "Find the truth value of the logical expression: \(expressionStr), given p = \(p) and q = \(q)."
        
        return Question(
            type: .logic,
            prompt: prompt,
            options: finalOptions,
            correctAnswer: correctString,
            numericValues: [
                "p": Double(p),
                "q": Double(q),
                "format": Double(format),
                "correct": Double(correctVal)
            ]
        )
    }
    
    private static func generateRatiosQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let r1 = Int.random(in: 2...4)
        let r2 = Int.random(in: 5...7)
        let factor = Int.random(in: 5...12)
        let total = (r1 + r2) * factor
        
        let findLarger = Bool.random()
        let correctVal = findLarger ? (r2 * factor) : (r1 * factor)
        
        let correctString = "\(correctVal)"
        let distractors = ["\(correctVal + factor)", "\(correctVal - factor)", "\(total - correctVal)"].filter { $0 != correctString }
        let options = shuffleOptions(correct: correctString, distractors: distractors)
        
        let prompt: String
        if language == .tr {
            let partText = findLarger ? "büyük" : "küçük"
            prompt = "\(total) birim uzunluğundaki bir çizgi \(r1):\(r2) oranında ikiye bölünmüştür. \(partText) parçanın uzunluğunu bulun."
        } else {
            let partText = findLarger ? "larger" : "smaller"
            prompt = "A line of length \(total) units is divided in the ratio \(r1):\(r2). Find the length of the \(partText) segment."
        }
        
        return Question(
            type: .ratios,
            prompt: prompt,
            options: options,
            correctAnswer: correctString,
            numericValues: [
                "r1": Double(r1),
                "r2": Double(r2),
                "total": Double(total),
                "findLarger": findLarger ? 1.0 : 0.0,
                "correct": Double(correctVal)
            ]
        )
    }
    
    private static func generateParabolaVerticesQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let h = Int.random(in: -4...4)
        let k = Int.random(in: -3...5)
        
        let b = -2 * h
        let c = h * h + k
        
        let findY = Bool.random()
        let correctVal = findY ? k : h
        
        let correctString = "\(correctVal)"
        let distractors = ["\(correctVal + 2)", "\(correctVal - 3)", "\(correctVal == h ? k : h)"].filter { $0 != correctString }
        let options = shuffleOptions(correct: correctString, distractors: distractors)
        
        var bStr = ""
        if b > 0 {
            bStr = " + \(b)x"
        } else if b < 0 {
            bStr = " - \(-b)x"
        }
        
        var cStr = ""
        if c > 0 {
            cStr = " + \(c)"
        } else if c < 0 {
            cStr = " - \(-c)"
        } else if bStr.isEmpty {
            cStr = " + 0"
        }
        
        let equationStr = "y = x²" + bStr + cStr
        let prompt: String
        if language == .tr {
            let coordName = findY ? "y-koordinatını (k)" : "x-koordinatını (h)"
            prompt = "\(equationStr) parabolünün tepe noktasının (T) \(coordName) bulun."
        } else {
            let coordName = findY ? "y-coordinate (k)" : "x-coordinate (h)"
            prompt = "Find the \(coordName) of the vertex of the parabola \(equationStr)."
        }
        
        return Question(
            type: .parabolaVertices,
            prompt: prompt,
            options: options,
            correctAnswer: correctString,
            numericValues: [
                "h": Double(h),
                "k": Double(k),
                "b": Double(b),
                "c": Double(c),
                "findY": findY ? 1.0 : 0.0
            ]
        )
    }
    
    private static func generateLogarithmBasicsQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let base = [2, 3, 5].randomElement() ?? 2
        let c = Int.random(in: 2...3)
        
        let powerVal = Int(pow(Double(base), Double(c)))
        let a = [1, 2].randomElement() ?? 1
        
        let x = Int.random(in: 3...15)
        let b = a * x - powerVal
        
        let correctString = "\(x)"
        let distractors = ["\(x + 2)", "\(x - 1)", "\(base + c)"].filter { $0 != correctString }
        let options = shuffleOptions(correct: correctString, distractors: distractors)
        
        let argStr = (a == 1 ? "x" : "\(a)x") + (b >= 0 ? " - \(b)" : " + \(-b)")
        let equationStr = "log_\(base)(\(argStr)) = \(c)"
        
        let prompt = language == .tr ?
            "Logaritmik denklemdeki bilinmeyen x değerini çözün: \(equationStr)" :
            "Solve for x in the logarithmic equation: \(equationStr)"
        
        return Question(
            type: .logarithmBasics,
            prompt: prompt,
            options: options,
            correctAnswer: correctString,
            numericValues: [
                "base": Double(base),
                "c": Double(c),
                "a": Double(a),
                "b": Double(b),
                "x": Double(x)
            ]
        )
    }
    
    private static func generateTransformationsQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let px = Int.random(in: -5...5)
        let py = Int.random(in: -5...5)
        
        let reflectionType = Int.random(in: 0...2)
        let dx = Int.random(in: -3...3)
        let dy = Int.random(in: -3...3)
        
        let rx: Int
        let ry: Int
        let reflectStr: String
        let reflectStrTr: String
        
        switch reflectionType {
        case 0:
            rx = px
            ry = -py
            reflectStr = "reflected across the x-axis"
            reflectStrTr = "x-eksenine göre yansıtılıyor"
        case 1:
            rx = -px
            ry = py
            reflectStr = "reflected across the y-axis"
            reflectStrTr = "y-eksenine göre yansıtılıyor"
        default:
            rx = -px
            ry = -py
            reflectStr = "reflected across the origin"
            reflectStrTr = "orijine göre yansıtılıyor"
        }
        
        let fx = rx + dx
        let fy = ry + dy
        
        let correctString = "(\(fx), \(fy))"
        let distractors = ["(\(-fx), \(fy))", "(\(fx), \(-fy))", "(\(px + dx), \(py + dy))"].filter { $0 != correctString }
        let options = shuffleOptions(correct: correctString, distractors: distractors)
        
        let translateStr = "translated by (\(dx >= 0 ? "+\(dx)" : "\(dx)"), \(dy >= 0 ? "+\(dy)" : "\(dy)")"
        let translateStrTr = "(\(dx >= 0 ? "+\(dx)" : "\(dx)"), \(dy >= 0 ? "+\(dy)" : "\(dy)") öteleniyor"
        
        let prompt = language == .tr ?
            "P(\(px), \(py)) noktası \(reflectStrTr) ve ardından \(translateStrTr). Son koordinatları bulun." :
            "Point P(\(px), \(py)) is \(reflectStr) and then \(translateStr). Find its final coordinates."
        
        return Question(
            type: .transformations,
            prompt: prompt,
            options: options,
            correctAnswer: correctString,
            numericValues: [
                "px": Double(px),
                "py": Double(py),
                "reflectionType": Double(reflectionType),
                "dx": Double(dx),
                "dy": Double(dy),
                "fx": Double(fx),
                "fy": Double(fy)
            ]
        )
    }
    
    
    // MARK: - TYT Math 1 Curriculum Generators
    
    private static func generateTytNumbersQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let subTopic = Int.random(in: 0...5)
        var prompt = ""
        var correctAnswerVal = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        
        switch subTopic {
        case 0:
            // Temel Kavramlar: max product of x + y = A
            let sumVal = Int.random(in: 5...12) * 2 // Always even
            let correct = (sumVal / 2) * (sumVal / 2)
            correctAnswerVal = "\(correct)"
            distractors = ["\(correct - 4)", "\(correct + 5)", "\(sumVal * 2)"]
            prompt = language == .tr ?
                "x ve y pozitif tam sayılardır. x + y = \(sumVal) olduğuna göre, x · y çarpımının alabileceği en büyük değeri bulun." :
                "x and y are positive integers. If x + y = \(sumVal), find the maximum value of x · y."
            numeric = ["sum": Double(sumVal), "correct": Double(correct), "sub": 0.0]
        case 1:
            // Sayı Basamakları: AB - BA = D -> A - B
            let diff = Int.random(in: 2...7)
            let diffVal = diff * 9
            correctAnswerVal = "\(diff)"
            distractors = ["\(diff + 1)", "\(diff - 1)", "9"]
            prompt = language == .tr ?
                "AB ve BA iki basamaklı sayılardır. AB - BA = \(diffVal) olduğuna göre, A - B farkını bulun." :
                "AB and BA are two-digit numbers. If AB - BA = \(diffVal), find the difference A - B."
            numeric = ["diffVal": Double(diffVal), "correct": Double(diff), "sub": 1.0]
        case 2:
            // Bölünebilme: 5A3 divisible by 9
            let d1 = Int.random(in: 2...7)
            let d2 = Int.random(in: 1...5)
            let sumDigits = d1 + d2
            let correctDigit = sumDigits <= 9 ? (9 - sumDigits) : (18 - sumDigits)
            correctAnswerVal = "\(correctDigit)"
            distractors = ["\((correctDigit + 3) % 9)", "\((correctDigit + 7) % 9)", "9"].filter { $0 != correctAnswerVal }
            let numStr = "\(d1)A\(d2)"
            prompt = language == .tr ?
                "\(numStr) sayısı 9 ile tam bölünebildiğine göre, A rakamını bulun." :
                "If the number \(numStr) is divisible by 9, find the digit A."
            numeric = ["d1": Double(d1), "d2": Double(d2), "correct": Double(correctDigit), "sub": 2.0]
        case 3:
            // Asal Sayılar / Faktöriyel: N! / (N-1)!
            let n = Int.random(in: 5...12)
            correctAnswerVal = "\(n)"
            distractors = ["\(n - 1)", "\(n + 1)", "1"]
            prompt = language == .tr ?
                "\(n)! / \((n - 1))! işleminin sonucunu bulun." :
                "Find the result of the expression: \(n)! / \((n - 1))!"
            numeric = ["n": Double(n), "correct": Double(n), "sub": 3.0]
        case 4:
            // EBOB-EKOK: a = A, b = B. EBOB(a,b)=G, EKOK(a,b)=L
            let g = [4, 6, 8].randomElement() ?? 6
            let k1 = 2
            let k2 = 3
            let a = g * k1
            let b = g * k2
            let ekok = g * k1 * k2
            correctAnswerVal = "\(b)"
            distractors = ["\(b + g)", "\(b - g)", "\(g)"]
            prompt = language == .tr ?
                "EBOB(a, b) = \(g) ve EKOK(a, b) = \(ekok) olarak verilmiştir. a = \(a) olduğuna göre, b değerini bulun." :
                "Given EBOB(a, b) = \(g) and EKOK(a, b) = \(ekok). If a = \(a), find the value of b."
            numeric = ["g": Double(g), "ekok": Double(ekok), "a": Double(a), "correct": Double(b), "sub": 4.0]
        default:
            // Rasyonel: (1/A + 1/B) * (A*B) = B + A
            let a = Int.random(in: 2...4)
            let b = Int.random(in: 3...5)
            let correct = b + a
            correctAnswerVal = "\(correct)"
            distractors = ["\(correct + 2)", "\(correct - 1)", "\(a * b)"]
            prompt = language == .tr ?
                "(1/\(a) + 1/\(b)) · \(a * b) işleminin sonucunu bulun." :
                "Find the result of the expression: (1/\(a) + 1/\(b)) · \(a * b)"
            numeric = ["a": Double(a), "b": Double(b), "correct": Double(correct), "sub": 5.0]
        }
        
        return Question(
            type: .tytNumbers,
            prompt: prompt,
            options: shuffleOptions(correct: correctAnswerVal, distractors: distractors),
            correctAnswer: correctAnswerVal,
            numericValues: numeric
        )
    }
    
    private static func generateTytEquationsQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let subTopic = Int.random(in: 0...4)
        var prompt = ""
        var correctAnswerVal = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        
        switch subTopic {
        case 0:
            // Birinci Dereceden Denklemler: Ax - B = Cx + D
            let x = Int.random(in: 2...6)
            let c = Int.random(in: 1...4)
            let k = Int.random(in: 1...3)
            let a = c + k
            let b = Int.random(in: 1...5)
            let d = k * x - b
            correctAnswerVal = "\(x)"
            distractors = ["\(x + 1)", "\(x - 2)", "\(a + c)"]
            prompt = language == .tr ?
                "Bilinmeyen x değerini çözün: \(a)x - \(b) = \(c)x + \(d)" :
                "Solve for x: \(a)x - \(b) = \(c)x + \(d)"
            numeric = ["a": Double(a), "b": Double(b), "c": Double(c), "d": Double(d), "correct": Double(x), "sub": 0.0]
        case 1:
            // Basit Eşitsizlikler: A < 2x - 1 <= B
            let xMin = Int.random(in: 1...4)
            let xMax = xMin + Int.random(in: 2...4)
            let a = 2 * xMin - 1
            let b = 2 * xMax - 1
            let correctRange = language == .tr ? "\(xMin) < x ≤ \(xMax)" : "\(xMin) < x <= \(xMax)"
            correctAnswerVal = correctRange
            distractors = [
                language == .tr ? "\(xMin-1) < x ≤ \(xMax)" : "\(xMin-1) < x <= \(xMax)",
                language == .tr ? "\(xMin) < x ≤ \(xMax+1)" : "\(xMin) < x <= \(xMax+1)",
                language == .tr ? "\(xMin) ≤ x < \(xMax)" : "\(xMin) <= x < \(xMax)"
            ]
            prompt = language == .tr ?
                "\(a) < 2x - 1 ≤ \(b) eşitsizliğini sağlayan x aralığını bulun." :
                "Find the range of x that satisfies the inequality: \(a) < 2x - 1 <= \(b)."
            numeric = ["a": Double(a), "b": Double(b), "xMin": Double(xMin), "xMax": Double(xMax), "sub": 1.0]
        case 2:
            // Mutlak Değer: |x - A| = B -> Find max x
            let a = Int.random(in: 2...8)
            let b = Int.random(in: 3...7)
            let correct = a + b
            correctAnswerVal = "\(correct)"
            distractors = ["\(a - b)", "\(correct + 2)", "\(a * b)"]
            prompt = language == .tr ?
                "|x - \(a)| = \(b) denklemini sağlayan en büyük x değerini bulun." :
                "Find the largest value of x that satisfies the equation: |x - \(a)| = \(b)."
            numeric = ["a": Double(a), "b": Double(b), "correct": Double(correct), "sub": 2.0]
        case 3:
            // Üslü Sayılar: B^x = P
            let b = [2, 3].randomElement() ?? 2
            let x = Int.random(in: 3...5)
            let p = Int(pow(Double(b), Double(x)))
            correctAnswerVal = "\(x)"
            distractors = ["\(x - 1)", "\(x + 1)", "\(b)"]
            prompt = language == .tr ?
                "Denklemdeki x değerini bulun: \(b)^x = \(p)" :
                "Solve for x in the equation: \(b)^x = \(p)"
            numeric = ["b": Double(b), "p": Double(p), "correct": Double(x), "sub": 3.0]
        default:
            // Köklü Sayılar: sqrt(a1^2 * C) + sqrt(a2^2 * C) = K * sqrt(C)
            let c = [2, 3, 5].randomElement() ?? 3
            let a1 = Int.random(in: 2...4)
            let a2 = Int.random(in: 2...3)
            let t1 = a1 * a1 * c
            let t2 = a2 * a2 * c
            let correctK = a1 + a2
            correctAnswerVal = "\(correctK)"
            distractors = ["\(correctK - 1)", "\(correctK + 2)", "\(c)"]
            prompt = language == .tr ?
                "K değerini bulun: √\(t1) + √\(t2) = K√\(c)" :
                "Find the value of K: √\(t1) + √\(t2) = K√\(c)"
            numeric = ["t1": Double(t1), "t2": Double(t2), "c": Double(c), "correct": Double(correctK), "sub": 4.0]
        }
        
        return Question(
            type: .tytEquations,
            prompt: prompt,
            options: shuffleOptions(correct: correctAnswerVal, distractors: distractors),
            correctAnswer: correctAnswerVal,
            numericValues: numeric
        )
    }
    
    private static func generateTytProblemsQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let subTopic = Int.random(in: 0...4)
        var prompt = ""
        var correctAnswerVal = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        
        switch subTopic {
        case 0:
            // Sayı/Kesir: x/2 + 3x = T -> x
            let x = Int.random(in: 2...8) * 2 // Always even
            let t = x / 2 + 3 * x
            correctAnswerVal = "\(x)"
            distractors = ["\(x + 2)", "\(x - 2)", "\(t)"]
            prompt = language == .tr ?
                "Bir sayının yarısı ile 3 katının toplamı \(t) olduğuna göre, bu sayıyı bulun." :
                "If the sum of half a number and 3 times the number is \(t), find the number."
            numeric = ["t": Double(t), "correct": Double(x), "sub": 0.0]
        case 1:
            // Yaş: Father A, Son B. x years later father is 2x son.
            let sonAge = Int.random(in: 10...18)
            let years = Int.random(in: 4...12)
            let fatherAge = 2 * (sonAge + years) - years
            correctAnswerVal = "\(years)"
            distractors = ["\(years - 2)", "\(years + 3)", "\(sonAge)"]
            prompt = language == .tr ?
                "Bir baba \(fatherAge) yaşında, oğlu ise \(sonAge) yaşındadır. Kaç yıl sonra babanın yaşı oğlunun yaşının 2 katı olur?" :
                "A father is \(fatherAge) years old and his son is \(sonAge) years old. In how many years will the father's age be 2 times the son's age?"
            numeric = ["fatherAge": Double(fatherAge), "sonAge": Double(sonAge), "correct": Double(years), "sub": 1.0]
        case 2:
            // İşçi: Ali A days, Veli B days. Together.
            let pairs = [(6, 12, 4), (10, 15, 6), (12, 24, 8), (8, 24, 6)]
            let pair = pairs.randomElement() ?? pairs[0]
            correctAnswerVal = "\(pair.2)"
            distractors = ["\(pair.2 + 2)", "\(pair.2 - 1)", "\(pair.0)"]
            prompt = language == .tr ?
                "Ali bir işi tek başına \(pair.0) günde, Veli ise \(pair.1) günde bitiriyor. İkisi birlikte bu işi kaç günde bitirir?" :
                "Ali can complete a job alone in \(pair.0) days, and Veli in \(pair.1) days. How many days will it take if they work together?"
            numeric = ["a": Double(pair.0), "b": Double(pair.1), "correct": Double(pair.2), "sub": 2.0]
        case 3:
            // Hız: Two cars, distance D, speed V1, V2. Time to meet t.
            let v1 = 60
            let v2 = 80
            let t = Int.random(in: 2...4)
            let d = (v1 + v2) * t
            correctAnswerVal = "\(t)"
            distractors = ["\(t + 1)", "\(t - 1)", "5"]
            prompt = language == .tr ?
                "Aralarında \(d) km olan iki araç, sırasıyla \(v1) km/sa ve \(v2) km/sa hızlarla birbirine doğru hareket ediyor. Kaç saat sonra karşılaşırlar?" :
                "Two cars, \(d) km apart, move towards each other at \(v1) km/h and \(v2) km/h respectively. In how many hours will they meet?"
            numeric = ["d": Double(d), "v1": Double(v1), "v2": Double(v2), "correct": Double(t), "sub": 3.0]
        default:
            // Yüzde/Kar-Zarar: Cost C, profit P -> Selling price S
            let c = [100, 200, 300].randomElement() ?? 200
            let p = [10, 20, 25, 30].randomElement() ?? 20
            let correctS = c + (c * p) / 100
            correctAnswerVal = "\(correctS)"
            distractors = ["\(correctS - 15)", "\(correctS + 20)", "\(c)"]
            prompt = language == .tr ?
                "Maliyet fiyatı \(c) TL olan bir ürün %\(p) kârla satılırsa satış fiyatı kaç TL olur?" :
                "If a product costing \(c) TL is sold at a \(p)% profit, what is the selling price in TL?"
            numeric = ["c": Double(c), "p": Double(p), "correct": Double(correctS), "sub": 4.0]
        }
        
        return Question(
            type: .tytProblems,
            prompt: prompt,
            options: shuffleOptions(correct: correctAnswerVal, distractors: distractors),
            correctAnswer: correctAnswerVal,
            numericValues: numeric
        )
    }
    
    private static func generateTytFoundationsQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let subTopic = Int.random(in: 0...2)
        var prompt = ""
        var correctAnswerVal = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        
        switch subTopic {
        case 0:
            // Fonksiyonlar: f(x) = Ax + B, find f(C)
            let a = Int.random(in: 2...5)
            let b = Int.random(in: 1...6)
            let c = Int.random(in: 2...4)
            let correct = a * c + b
            correctAnswerVal = "\(correct)"
            distractors = ["\(correct + 3)", "\(correct - 2)", "\(a * c)"]
            prompt = language == .tr ?
                "f(x) = \(a)x + \(b) olduğuna göre, f(\(c)) değerini bulun." :
                "Given f(x) = \(a)x + \(b), find the value of f(\(c))."
            numeric = ["a": Double(a), "b": Double(b), "c": Double(c), "correct": Double(correct), "sub": 0.0]
        case 1:
            // Kartezyen: s(A) = N, s(B) = M -> s(A x B)
            let n = Int.random(in: 3...7)
            let m = Int.random(in: 3...6)
            let correct = n * m
            correctAnswerVal = "\(correct)"
            distractors = ["\(correct + 4)", "\(correct - 3)", "\(n + m)"]
            prompt = language == .tr ?
                "A ve B kümeleri için s(A) = \(n) ve s(B) = \(m) olduğuna göre, s(A × B) kartezyen çarpım kümesinin eleman sayısını bulun." :
                "For sets A and B, if s(A) = \(n) and s(B) = \(m), find the number of elements in s(A × B)."
            numeric = ["n": Double(n), "m": Double(m), "correct": Double(correct), "sub": 1.0]
        default:
            // İstatistik: Median of 5 sorted numbers
            let base = Int.random(in: 5...15)
            let num1 = base
            let num2 = base + Int.random(in: 1...3)
            let num3 = num2 + Int.random(in: 1...3)
            let num4 = num3 + Int.random(in: 2...4)
            let num5 = num4 + Int.random(in: 1...3)
            
            let list = [num1, num2, num3, num4, num5].shuffled()
            let listStr = list.map { String($0) }.joined(separator: ", ")
            
            correctAnswerVal = "\(num3)"
            distractors = ["\(num2)", "\(num4)", "\(num3 + 1)"]
            prompt = language == .tr ?
                "Verilen sayı grubunun medyan (ortanca) değerini bulun: [\(listStr)]" :
                "Find the median value of the following numbers: [\(listStr)]"
            numeric = ["n1": Double(num1), "n2": Double(num2), "n3": Double(num3), "n4": Double(num4), "n5": Double(num5), "sub": 2.0]
        }
        
        return Question(
            type: .tytFoundations,
            prompt: prompt,
            options: shuffleOptions(correct: correctAnswerVal, distractors: distractors),
            correctAnswer: correctAnswerVal,
            numericValues: numeric
        )
    }
    
    private static func generateTytProbabilityQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let subTopic = Int.random(in: 0...3)
        var prompt = ""
        var correctAnswerVal = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        
        switch subTopic {
        case 0:
            // Permütasyon: 4 people, N chairs -> P(N, 4)
            let n = [5, 6].randomElement() ?? 5
            let correct = n == 5 ? 120 : 360
            correctAnswerVal = "\(correct)"
            distractors = [n == 5 ? "24" : "720", n == 5 ? "60" : "120", "240"]
            prompt = language == .tr ?
                "4 kişi, yan yana duran \(n) koltuğa kaç farklı şekilde oturabilir?" :
                "In how many different ways can 4 people sit on \(n) adjacent chairs?"
            numeric = ["n": Double(n), "correct": Double(correct), "sub": 0.0]
        case 1:
            // Kombinasyon: committee of M from N -> C(N, M)
            let configs = [(6, 3, 20), (6, 2, 15), (5, 2, 10)]
            let config = configs.randomElement() ?? configs[0]
            correctAnswerVal = "\(config.2)"
            distractors = ["\(config.2 + 5)", "\(config.2 - 2)", "\(config.0 * config.1)"]
            prompt = language == .tr ?
                "\(config.0) kişi arasından \(config.1) kişilik bir komite kaç farklı şekilde seçilebilir?" :
                "How many different ways can a committee of \(config.1) people be chosen from \(config.0) people?"
            numeric = ["n": Double(config.0), "m": Double(config.1), "correct": Double(config.2), "sub": 1.0]
        case 2:
            // Binom: (x + A)^3 -> coefficient of x^2 is 3A
            let a = Int.random(in: 2...5)
            let correct = 3 * a
            correctAnswerVal = "\(correct)"
            distractors = ["\(a * a)", "\(3 * a * a)", "\(a)"]
            prompt = language == .tr ?
                "(x + \(a))³ ifadesinin açılımındaki x² teriminin katsayısını bulun." :
                "Find the coefficient of the x² term in the expansion of (x + \(a))³."
            numeric = ["a": Double(a), "correct": Double(correct), "sub": 2.0]
        default:
            // Olasılık: two dice rolled, sum is S -> prob
            let sums = [3, 4, 11]
            let s = sums.randomElement() ?? 3
            let correctProb = s == 4 ? "1/12" : "1/18"
            correctAnswerVal = correctProb
            distractors = [s == 4 ? "1/18" : "1/12", "1/6", "1/9"]
            prompt = language == .tr ?
                "İki zar aynı anda atılıyor. Üst yüze gelen sayıların toplamının \(s) olma olasılığı kaçtır?" :
                "Two dice are rolled simultaneously. What is the probability that the sum of the numbers is \(s)?"
            numeric = ["s": Double(s), "sub": 3.0]
        }
        
        return Question(
            type: .tytProbability,
            prompt: prompt,
            options: shuffleOptions(correct: correctAnswerVal, distractors: distractors),
            correctAnswer: correctAnswerVal,
            numericValues: numeric
        )
    }
    
    
    // MARK: - AYT Math 2 Curriculum Generators
    
    private static func generateAytFunctionsQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let subTopic: Int
        switch difficulty {
        case .easy:
            subTopic = Int.random(in: 0...1)
        case .medium:
            subTopic = Int.random(in: 0...1)
        case .hard, .expert:
            subTopic = Int.random(in: 0...2)
        }
        
        var prompt = ""
        var correctAnswerVal = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        
        if subTopic == 0 {
            let a: Int
            let b: Int
            let c: Int
            switch difficulty {
            case .easy:
                a = 0
                b = Int.random(in: 1...5)
                c = Int.random(in: 1...3)
            case .medium:
                a = Int.random(in: 1...3)
                b = Int.random(in: -3...3)
                c = Int.random(in: 2...4)
            case .hard, .expert:
                a = Int.random(in: -5...5)
                b = Int.random(in: -8...8)
                let cVal = Int.random(in: -3...4)
                c = cVal == 0 ? 2 : cVal
            }
            let correct = c * c + a * c + b
            correctAnswerVal = "\(correct)"
            distractors = ["\(correct + 4)", "\(correct - 3)", "\(c * c + b)", "\(correct + (c == 0 ? 2 : c))"]
            
            let aSign = a > 0 ? "+ \(a)x " : (a < 0 ? "- \(-a)x " : "")
            let bSign = b >= 0 ? "+ \(b)" : "- \(-b)"
            let polyStr = "P(x) = x² \(aSign)\(bSign)"
            
            prompt = language == .tr ?
                "\(polyStr) polinomunun x - \(c) ile bölümünden kalanı bulun." :
                "Find the remainder when the polynomial \(polyStr) is divided by x - \(c)."
            numeric = ["a": Double(a), "b": Double(b), "c": Double(c), "correct": Double(correct), "sub": 0.0]
        } else if subTopic == 1 {
            let dx: Int
            let dy: Int
            switch difficulty {
            case .easy:
                dx = Int.random(in: 2...4)
                dy = 0
            case .medium:
                dx = Int.random(in: 2...4)
                dy = Int.random(in: 1...3)
            case .hard, .expert:
                let dxVal = Int.random(in: -4...4)
                dx = dxVal == 0 ? 2 : dxVal
                let dyVal = Int.random(in: -3...3)
                dy = dyVal == 0 ? -2 : dyVal
            }
            
            let dxStr = dx > 0 ? "- \(dx)" : "+ \(-dx)"
            let dyStr = dy > 0 ? " + \(dy)" : (dy < 0 ? " - \(-dy)" : "")
            let correctStr = "f(x \(dxStr))\(dyStr)"
            correctAnswerVal = correctStr
            
            let alt1 = "f(x \(dxStr))\(dy != 0 ? " - \(abs(dy))" : " + 2")"
            let alt2 = "f(x \(dx > 0 ? "+ \(dx)" : "- \(-dx)"))\(dyStr)"
            let alt3 = "f(x \(dx > 0 ? "+ \(dx)" : "- \(-dx)"))\(dy != 0 ? " - \(abs(dy))" : " + 2")"
            distractors = [alt1, alt2, alt3]
            
            let directionX = dx > 0 ? (language == .tr ? "sağa" : "right") : (language == .tr ? "sola" : "left")
            let directionY = dy > 0 ? (language == .tr ? "yukarı" : "up") : (language == .tr ? "aşağı" : "down")
            
            if dy == 0 {
                prompt = language == .tr ?
                    "f(x) fonksiyonu \(abs(dx)) birim \(directionX) ötelenirse oluşan yeni fonksiyonu bulun." :
                    "If the function f(x) is shifted \(abs(dx)) units to the \(directionX), find the new function."
            } else {
                prompt = language == .tr ?
                    "f(x) fonksiyonu \(abs(dx)) birim \(directionX) ve \(abs(dy)) birim \(directionY) ötelenirse oluşan yeni fonksiyonu bulun." :
                    "If the function f(x) is shifted \(abs(dx)) units to the \(directionX) and \(abs(dy)) units \(directionY), find the new function."
            }
            numeric = ["dx": Double(dx), "dy": Double(dy), "sub": 1.0]
        } else {
            let a = Int.random(in: 2...4)
            let b = Int.random(in: 1...5)
            let c = a * Int.random(in: 1...3) + b
            let correct = (c - b) / a
            correctAnswerVal = "\(correct)"
            distractors = ["\(correct + 1)", "\(correct - 2)", "\(c * a + b)"]
            
            let funcStr = "f(x) = \(a)x + \(b)"
            prompt = language == .tr ?
                "\(funcStr) olduğuna göre, f⁻¹(\(c)) değerini bulun." :
                "Given \(funcStr), find the value of f⁻¹(\(c))."
            numeric = ["dx": 0.0, "dy": 0.0, "sub": 1.0]
        }
        
        return Question(
            type: .aytFunctions,
            prompt: prompt,
            options: shuffleOptions(correct: correctAnswerVal, distractors: distractors),
            correctAnswer: correctAnswerVal,
            numericValues: numeric
        )
    }
    
    private static func generateAytQuadraticsQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let subTopic: Int
        switch difficulty {
        case .easy:
            subTopic = Int.random(in: 0...1)
        case .medium:
            subTopic = Int.random(in: 0...2)
        case .hard, .expert:
            subTopic = Int.random(in: 0...2)
        }
        
        var prompt = ""
        var correctAnswerVal = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        
        switch subTopic {
        case 0:
            if difficulty == .easy {
                let a = Int.random(in: 3...9)
                let b = Int.random(in: 2...12)
                correctAnswerVal = "\(a)"
                distractors = ["\(-a)", "\(b)", "\(b / 2)"]
                prompt = language == .tr ?
                    "x² - \(a)x + \(b) = 0 denkleminin kökleri x₁ ve x₂'dir. x₁ + x₂ toplamını bulun." :
                    "The roots of the equation x² - \(a)x + \(b) = 0 are x₁ and x₂. Find the sum x₁ + x₂."
                numeric = ["a": Double(a), "b": Double(b), "correct": Double(a), "sub": 0.0]
            } else if difficulty == .medium {
                let a = Int.random(in: 2...6)
                let bVal = Int.random(in: -10...10)
                let b = bVal == 0 ? 5 : bVal
                correctAnswerVal = "\(b)"
                distractors = ["\(a)", "\(-b)", "\(b + 2)"]
                prompt = language == .tr ?
                    "x² - \(a)x + \(b) = 0 denkleminin kökleri x₁ ve x₂'dir. x₁ • x₂ çarpımını bulun." :
                    "The roots of the equation x² - \(a)x + \(b) = 0 are x₁ and x₂. Find the product x₁ • x₂."
                numeric = ["a": Double(a), "b": Double(b), "correct": Double(b), "sub": 0.0]
            } else {
                let sumVal = Int.random(in: 3...5)
                let prodVal = Int.random(in: 1...3)
                let correct = sumVal * sumVal - 2 * prodVal
                correctAnswerVal = "\(correct)"
                distractors = ["\(sumVal * sumVal)", "\(correct - 4)", "\(correct + 2)"]
                
                let bSign = -sumVal >= 0 ? "+ \(-sumVal)" : "- \(sumVal)"
                let polyStr = "x² \(bSign)x + \(prodVal) = 0"
                prompt = language == .tr ?
                    "\(polyStr) denkleminin kökleri x₁ ve x₂'dir. x₁² + x₂² ifadesinin değerini bulun." :
                    "The roots of the equation \(polyStr) are x₁ and x₂. Find the value of x₁² + x₂²."
                numeric = ["a": Double(sumVal), "b": Double(prodVal), "correct": Double(correct), "sub": 0.0]
            }
        case 1:
            if difficulty == .easy {
                let a = Int.random(in: 2...6)
                let b = Int.random(in: 1...5)
                let c = Int.random(in: 1...4)
                let d = Int.random(in: 2...5)
                let real = a + c
                let imag = b + d
                correctAnswerVal = "\(real) + \(imag)i"
                distractors = ["\(real) - \(imag)i", "\(real - 2) + \(imag + 1)i", "\(real + imag)"]
                prompt = language == .tr ?
                    "(\(a) + \(b)i) + (\(c) + \(d)i) işleminin sonucunu bulun." :
                    "Find the result of (\(a) + \(b)i) + (\(c) + \(d)i)."
                numeric = ["a": Double(a), "b": Double(b), "c": Double(c), "d": Double(d), "sub": 1.0]
            } else if difficulty == .medium {
                let a = Int.random(in: 1...3)
                let b = Int.random(in: 1...2)
                let c = Int.random(in: 2...4)
                let d = Int.random(in: 1...2)
                let real = a * c - b * d
                let imag = a * d + b * c
                correctAnswerVal = "\(real) + \(imag)i"
                distractors = ["\(real) - \(imag)i", "\(real + 2) + \(imag - 1)i", "\(a*c) + \(b*d)i"]
                prompt = language == .tr ?
                    "(\(a) + \(b)i) • (\(c) + \(d)i) işleminin sonucunu bulun." :
                    "Find the result of (\(a) + \(b)i) • (\(c) + \(d)i)."
                numeric = ["a": Double(a), "b": Double(b), "c": Double(c), "d": Double(d), "sub": 1.0]
            } else {
                let choice = Int.random(in: 0...1)
                if choice == 0 {
                    let power = Int.random(in: 45...103)
                    let rem = power % 4
                    switch rem {
                    case 0: correctAnswerVal = "1"
                    case 1: correctAnswerVal = "i"
                    case 2: correctAnswerVal = "-1"
                    default: correctAnswerVal = "-i"
                    }
                    distractors = ["1", "i", "-1", "-i"].filter { $0 != correctAnswerVal }
                    prompt = language == .tr ?
                        "i² = -1 olduğuna göre, i^{\(power)} ifadesinin değerini bulun." :
                        "Given i² = -1, find the value of i^{\(power)}."
                } else {
                    let isPower8 = Bool.random()
                    let power = isPower8 ? 8 : 6
                    correctAnswerVal = isPower8 ? "16" : "-8i"
                    distractors = isPower8 ? ["16i", "-16", "8"] : ["8i", "-8", "64i"]
                    prompt = language == .tr ?
                        "(1 + i)^{\(power)} ifadesinin sonucunu bulun." :
                        "Find the result of the expression (1 + i)^{\(power)}."
                }
                numeric = ["a": 1, "b": 1, "c": 0, "d": 0, "sub": 1.0]
            }
        default:
            let m = [9, 16, 25].randomElement() ?? 9
            let sqrtM = Int(sqrt(Double(m)))
            let minK = 2 * sqrtM + 1
            correctAnswerVal = "\(minK)"
            distractors = ["\(minK - 1)", "\(minK + 2)", "\(sqrtM)"]
            
            prompt = language == .tr ?
                "x² - Kx + \(m) = 0 denkleminin iki farklı reel kökü olması için K'nın alabileceği en küçük pozitif tam sayı değerini bulun." :
                "Find the smallest positive integer K such that the equation x² - Kx + \(m) = 0 has two distinct real roots."
            numeric = ["m": Double(m), "correct": Double(minK), "sub": 2.0]
        }
        
        return Question(
            type: .aytQuadratics,
            prompt: prompt,
            options: shuffleOptions(correct: correctAnswerVal, distractors: distractors),
            correctAnswer: correctAnswerVal,
            numericValues: numeric
        )
    }
    
    private static func generateAytTrigQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let subTopic: Int
        switch difficulty {
        case .easy:
            subTopic = 0
        case .medium:
            subTopic = Int.random(in: 0...1)
        case .hard, .expert:
            subTopic = Int.random(in: 0...1)
        }
        
        var prompt = ""
        var correctAnswerVal = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        
        if subTopic == 0 {
            if difficulty == .easy {
                correctAnswerVal = "24/25"
                distractors = ["12/25", "7/25", "4/5"]
                prompt = language == .tr ?
                    "sin(θ) = 3/5 ve cos(θ) = 4/5 olduğuna göre, sin(2θ) yarım açı değerini bulun." :
                    "Given sin(θ) = 3/5 and cos(θ) = 4/5, find the double-angle value of sin(2θ)."
                numeric = ["sub": 0.0]
            } else if difficulty == .medium {
                correctAnswerVal = "7/9"
                distractors = ["8/9", "5/9", "1/9"]
                prompt = language == .tr ?
                    "sin(θ) = 1/3 olduğuna göre, cos(2θ) değerini bulun." :
                    "Given sin(θ) = 1/3, find the value of cos(2θ)."
                numeric = ["sub": 0.0]
            } else {
                correctAnswerVal = "56/65"
                distractors = ["16/65", "48/65", "63/65"]
                prompt = language == .tr ?
                    "sin(a) = 3/5 ve cos(b) = 12/13 (a, b dar açılar) ise sin(a + b) değerini bulun." :
                    "If sin(a) = 3/5 and cos(b) = 12/13 (a, b acute), find sin(a + b)."
                numeric = ["sub": 0.0]
            }
        } else {
            if difficulty == .easy {
                let choice = Int.random(in: 0...2)
                let angle: Int
                let valStr: String
                switch choice {
                case 0: angle = 60; valStr = "1/2"
                case 1: angle = 30; valStr = "√3/2"
                default: angle = 45; valStr = "√2/2"
                }
                correctAnswerVal = "\(angle)°"
                distractors = ["\((angle + 15) % 90)°", "\((angle + 30) % 90)°", "90°"].filter { $0 != correctAnswerVal }
                prompt = language == .tr ?
                    "cos(x) = \(valStr) denkleminin [0°, 90°] aralığındaki kökünü (x) derece cinsinden bulun." :
                    "Find the root (x) of the equation cos(x) = \(valStr) in the interval [0°, 90°] in degrees."
                numeric = ["correct": Double(angle), "sub": 1.0]
            } else if difficulty == .medium {
                correctAnswerVal = "15°"
                distractors = ["30°", "45°", "60°"]
                prompt = language == .tr ?
                    "sin(2x) = 1/2 denkleminin [0°, 90°] aralığındaki en küçük kökünü derece cinsinden bulun." :
                    "Find the smallest root of the equation sin(2x) = 1/2 in the interval [0°, 90°] in degrees."
                numeric = ["correct": 30.0, "sub": 1.0]
            } else {
                correctAnswerVal = "45°"
                distractors = ["30°", "60°", "90°"]
                prompt = language == .tr ?
                    "2cos²(x) - 1 = 0 denkleminin [0°, 90°] aralığındaki kökünü bulun." :
                    "Find the root of the equation 2cos²(x) - 1 = 0 in the interval [0°, 90°]."
                numeric = ["correct": 45.0, "sub": 1.0]
            }
        }
        
        return Question(
            type: .aytTrig,
            prompt: prompt,
            options: shuffleOptions(correct: correctAnswerVal, distractors: distractors),
            correctAnswer: correctAnswerVal,
            numericValues: numeric
        )
    }
    
    private static func generateAytLogQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let subTopic: Int
        switch difficulty {
        case .easy:
            subTopic = Int.random(in: 0...1)
        case .medium:
            subTopic = Int.random(in: 0...1)
        case .hard, .expert:
            subTopic = Int.random(in: 0...2)
        }
        
        var prompt = ""
        var correctAnswerVal = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        
        if subTopic == 0 {
            if difficulty == .easy {
                let correct = Int.random(in: 3...4)
                let totalVal = Int(pow(2.0, Double(correct)))
                let a = 2
                let c = totalVal / a
                correctAnswerVal = "\(correct)"
                distractors = ["\(correct + 1)", "\(correct - 1)", "\(totalVal)"]
                prompt = language == .tr ?
                    "log_2(\(a)) + log_2(\(c)) ifadesinin değerini bulun." :
                    "Find the value of the expression: log_2(\(a)) + log_2(\(c))"
                numeric = ["a": Double(a), "c": Double(c), "correct": Double(correct), "sub": 0.0]
            } else if difficulty == .medium {
                let correct = 5
                let a = 27
                let c = 9
                correctAnswerVal = "\(correct)"
                distractors = ["4", "6", "12"]
                prompt = language == .tr ?
                    "log_3(\(a)) + log_3(\(c)) ifadesinin değerini bulun." :
                    "Find the value of the expression: log_3(\(a)) + log_3(\(c))"
                numeric = ["a": 3.0, "c": 9.0, "correct": 5.0, "sub": 0.0]
            } else {
                correctAnswerVal = "2"
                distractors = ["1", "3", "5"]
                prompt = language == .tr ?
                    "log_5(125) - log_5(5) ifadesinin değerini bulun." :
                    "Find the value of the expression: log_5(125) - log_5(5)"
                numeric = ["a": 5.0, "c": 2.0, "correct": 2.0, "sub": 0.0]
            }
        } else if subTopic == 1 {
            if difficulty == .easy {
                let base = 2
                let power = Int.random(in: 3...5)
                let resultVal = Int(pow(Double(base), Double(power)))
                let correctX = power + 1
                correctAnswerVal = "\(correctX)"
                distractors = ["\(correctX - 1)", "\(correctX + 1)", "\(power)"]
                prompt = language == .tr ?
                    "Denklemdeki x değerini çözün: 2^(x-1) = \(resultVal)" :
                    "Solve for x in the equation: 2^(x-1) = \(resultVal)"
                numeric = ["resultVal": Double(resultVal), "correct": Double(correctX), "sub": 1.0]
            } else if difficulty == .medium {
                correctAnswerVal = "2"
                distractors = ["1", "3", "4"]
                prompt = language == .tr ?
                    "3^(2x - 1) = 27 denklemini sağlayan x değerini bulun." :
                    "Solve for x in the equation: 3^(2x - 1) = 27"
                numeric = ["resultVal": 27.0, "correct": 2.0, "sub": 1.0]
            } else {
                correctAnswerVal = "2"
                distractors = ["1", "0", "4"]
                prompt = language == .tr ?
                    "4^x - 3•2^x - 4 = 0 denklemini sağlayan reel x değerini bulun." :
                    "Solve for x in the equation: 4^x - 3•2^x - 4 = 0"
                numeric = ["resultVal": 4.0, "correct": 2.0, "sub": 1.0]
            }
        } else {
            correctAnswerVal = "8"
            distractors = ["6", "4", "16"]
            prompt = language == .tr ?
                "(log₂ x)² - 3 log₂ x + 2 = 0 denkleminin köklerinin çarpımını bulun." :
                "Find the product of the roots of the equation: (log₂ x)² - 3 log₂ x + 2 = 0"
            numeric = ["a": 2.0, "c": 4.0, "correct": 2.0, "sub": 0.0]
        }
        
        return Question(
            type: .aytLog,
            prompt: prompt,
            options: shuffleOptions(correct: correctAnswerVal, distractors: distractors),
            correctAnswer: correctAnswerVal,
            numericValues: numeric
        )
    }
    
    private static func generateAytSequencesQuestion(difficulty: AppDifficulty, language: AppLanguage) -> Question {
        let subTopic: Int
        switch difficulty {
        case .easy:
            subTopic = Int.random(in: 0...1)
        case .medium:
            subTopic = Int.random(in: 0...1)
        case .hard, .expert:
            subTopic = Int.random(in: 0...2)
        }
        
        var prompt = ""
        var correctAnswerVal = ""
        var distractors: [String] = []
        var numeric: [String: Double] = [:]
        
        switch subTopic {
        case 0:
            if difficulty == .easy {
                let a1 = Int.random(in: 2...8)
                let d = Int.random(in: 2...5)
                let n = Int.random(in: 4...8)
                let correct = a1 + (n - 1) * d
                correctAnswerVal = "\(correct)"
                distractors = ["\(correct + d)", "\(correct - d)", "\(a1 + n * d)"]
                prompt = language == .tr ?
                    "İlk terimi a₁ = \(a1), ortak farkı d = \(d) olan bir aritmetik dizinin \(n). terimini (a_\(n)) bulun." :
                    "Find the \(n)th term (a_\(n)) of an arithmetic sequence with first term a₁ = \(a1) and common difference d = \(d)."
                numeric = ["a1": Double(a1), "d": Double(d), "n": Double(n), "correct": Double(correct), "sub": 0.0]
            } else if difficulty == .medium {
                let d = Int.random(in: 2...4)
                let a3 = Int.random(in: 4...10)
                let a7 = a3 + 4 * d
                correctAnswerVal = "\(d)"
                distractors = ["\(d + 1)", "\(d - 1)", "\(d + 2)"]
                prompt = language == .tr ?
                    "Bir aritmetik dizide a₃ = \(a3) ve a₇ = \(a7) olduğuna göre, bu dizinin ortak farkını (d) bulun." :
                    "In an arithmetic sequence a₃ = \(a3) and a₇ = \(a7). Find the common difference (d)."
                numeric = ["a1": Double(a3 - 2 * d), "d": Double(d), "n": 3, "correct": Double(d), "sub": 0.0]
            } else {
                let a1 = 3
                let d = 2
                let correct = 120
                correctAnswerVal = "\(correct)"
                distractors = ["110", "130", "240"]
                prompt = language == .tr ?
                    "İlk terimi a₁ = \(a1), ortak farkı d = \(d) olan bir aritmetik dizinin ilk 10 teriminin toplamını (S₁₀) bulun." :
                    "Find the sum of the first 10 terms (S₁₀) of an arithmetic sequence with first term a₁ = \(a1) and common difference d = \(d)."
                numeric = ["a1": Double(a1), "d": Double(d), "n": 5, "correct": Double(correct), "sub": 0.0]
            }
        case 1:
            if difficulty == .easy {
                let a1 = Int.random(in: 2...3)
                let r = [2, 3].randomElement() ?? 2
                let n = 3
                let correct = a1 * Int(pow(Double(r), Double(n - 1)))
                correctAnswerVal = "\(correct)"
                distractors = ["\(correct + r)", "\(correct * r)", "\(a1 + r * n)"]
                prompt = language == .tr ?
                    "İlk terimi a₁ = \(a1), ortak çarpanı r = \(r) olan bir geometrik dizinin 3. terimini (a₃) bulun." :
                    "Find the 3rd term (a₃) of a geometric sequence with first term a₁ = \(a1) and common ratio r = \(r)."
                numeric = ["a1": Double(a1), "r": Double(r), "n": Double(n), "correct": Double(correct), "sub": 1.0]
            } else if difficulty == .medium {
                let r = [2, 3].randomElement() ?? 2
                let a2 = Int.random(in: 2...4)
                let a5 = a2 * r * r * r
                correctAnswerVal = "\(r)"
                distractors = ["\(r + 1)", "\(r - 1)", "\(r * 2)"]
                prompt = language == .tr ?
                    "Bir geometrik dizide a₂ = \(a2) ve a₅ = \(a5) olduğuna göre, bu dizinin ortak çarpanını (r) bulun." :
                    "In a geometric sequence a₂ = \(a2) and a₅ = \(a5). Find the common ratio (r)."
                numeric = ["a1": Double(a2) / Double(r), "r": Double(r), "n": 2, "correct": Double(r), "sub": 1.0]
            } else {
                let is8 = Bool.random()
                let a1 = is8 ? 8 : 6
                let correct = is8 ? 16 : 12
                correctAnswerVal = "\(correct)"
                distractors = is8 ? ["8", "24", "32"] : ["6", "18", "24"]
                prompt = language == .tr ?
                    "İlk terimi a₁ = \(a1), ortak çarpanı r = 1/2 olan sonsuz azalan geometrik serinin toplamını bulun." :
                    "Find the sum of an infinite geometric series with first term a₁ = \(a1) and common ratio r = 1/2."
                numeric = ["a1": Double(a1), "r": 0.5, "n": 4, "correct": Double(correct), "sub": 1.0]
            }
        default:
            let correct = 21
            correctAnswerVal = "\(correct)"
            distractors = ["13", "34", "18"]
            prompt = language == .tr ?
                "Fibonacci dizisinin 8. terimini (F₈) bulun (Dizi 1, 1, 2, 3, 5, ... şeklinde başlar)." :
                "Find the 8th term (F₈) of the Fibonacci sequence (sequence starts 1, 1, 2, 3, 5, ...)."
            numeric = ["a1": 1.0, "r": 1.618, "n": 5, "correct": 21.0, "sub": 1.0]
        }
        
        return Question(
            type: .aytSequences,
            prompt: prompt,
            options: shuffleOptions(correct: correctAnswerVal, distractors: distractors),
            correctAnswer: correctAnswerVal,
            numericValues: numeric
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
