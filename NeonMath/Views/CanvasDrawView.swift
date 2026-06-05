import SwiftUI

/// A programmatic rendering canvas that draws geometric shapes, algebra graphs, vectors, unit circles,
/// and matrix grids based on the active Question.
/// Uses a layered line rendering technique to produce a premium neon glow effect.
public struct CanvasDrawView: View {
    public let question: Question
    public let glowColor: Color
    
    public init(question: Question, glowColor: Color = Color(hex: "#00F0FF")) {
        self.question = question
        self.glowColor = glowColor
    }
    
    public var body: some View {
        Canvas { context, size in
            let strokeStyle = StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round)
            
            // Draw matching question geometries
            switch question.type {
            // Geometry
            case .triangleAngle:
                drawTriangle(context: context, size: size, strokeStyle: strokeStyle)
            case .transversalParallel:
                drawParallelTransversal(context: context, size: size, strokeStyle: strokeStyle)
            case .supplementaryLines:
                drawSupplementaryLines(context: context, size: size, strokeStyle: strokeStyle)
            case .inscribedCircleAngle:
                drawInscribedCircleAngle(context: context, size: size, strokeStyle: strokeStyle)
            case .circleTangent:
                drawCircleTangent(context: context, size: size, strokeStyle: strokeStyle)
            case .geometricIQPattern:
                drawGeometricIQPattern(context: context, size: size, strokeStyle: strokeStyle)
                
            // Trigonometry
            case .unitCircle:
                drawUnitCircle(context: context, size: size, strokeStyle: strokeStyle)
            case .triangleTrig:
                drawTriangleTrig(context: context, size: size, strokeStyle: strokeStyle)
            case .trigIdentity:
                drawTrigIdentity(context: context, size: size, strokeStyle: strokeStyle)
                
            // Algebra
            case .vectorPuzzle:
                drawVectorPuzzle(context: context, size: size, strokeStyle: strokeStyle)
            case .functionGraph:
                drawFunctionGraph(context: context, size: size, strokeStyle: strokeStyle)
            case .matrixGrid:
                drawMatrixGrid(context: context, size: size, strokeStyle: strokeStyle)
                
            // New Categories
            case .vennDiagrams:
                drawVennDiagrams(context: context, size: size, strokeStyle: strokeStyle)
            case .logic:
                drawLogic(context: context, size: size, strokeStyle: strokeStyle)
            case .ratios:
                drawRatios(context: context, size: size, strokeStyle: strokeStyle)
            case .parabolaVertices:
                drawParabolaVertices(context: context, size: size, strokeStyle: strokeStyle)
            case .logarithmBasics:
                drawLogarithmBasics(context: context, size: size, strokeStyle: strokeStyle)
            case .transformations:
                drawTransformations(context: context, size: size, strokeStyle: strokeStyle)
            case .tytNumbers:
                drawTytNumbers(context: context, size: size, strokeStyle: strokeStyle)
            case .tytEquations:
                drawTytEquations(context: context, size: size, strokeStyle: strokeStyle)
            case .tytProblems:
                drawTytProblems(context: context, size: size, strokeStyle: strokeStyle)
            case .tytFoundations:
                drawTytFoundations(context: context, size: size, strokeStyle: strokeStyle)
            case .tytProbability:
                drawTytProbability(context: context, size: size, strokeStyle: strokeStyle)
            }
        }
        .frame(height: 280)
        .background(Color.black.opacity(0.9))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(glowColor.opacity(0.2), lineWidth: 1.5)
        )
        .shadow(color: glowColor.opacity(0.25), radius: 10, x: 0, y: 0)
    }
    
    // MARK: - Layered Neon Stroke Helper
    
    /// Renders a path multiple times with increasing thickness and opacity to create a high-fidelity glowing line.
    private func strokeGlowPath(_ path: Path, in context: GraphicsContext, style: StrokeStyle, color: Color? = nil) {
        let actualColor = color ?? glowColor
        // Deep background glow
        context.stroke(path, with: .color(actualColor.opacity(0.15)), lineWidth: style.lineWidth + 6)
        // Mid-intensity glow
        context.stroke(path, with: .color(actualColor.opacity(0.4)), lineWidth: style.lineWidth + 2.5)
        // Solid core
        context.stroke(path, with: .color(.white), lineWidth: style.lineWidth)
    }
    
    // MARK: - Geometry Renderers
    
    private func drawTriangle(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let angleA = question.numericValues["angleA"] ?? 60.0
        let angleB = question.numericValues["angleB"] ?? 60.0
        let angleC = question.numericValues["angleC"] ?? 60.0
        let unknownIndex = Int(question.numericValues["unknownIndex"] ?? 0.0)
        
        let rB = angleB * .pi / 180.0
        let rC = angleC * .pi / 180.0
        
        let tanB = tan(rB)
        let tanC = tan(rC)
        let xA = tanC / (tanB + tanC)
        let yA = tanB * tanC / (tanB + tanC)
        
        let padding: CGFloat = 45
        let availW = size.width - (padding * 2)
        let availH = size.height - (padding * 2)
        
        let scale = min(availW, availH / yA)
        let offsetX = (size.width - scale) / 2
        let offsetY = (size.height - scale * yA) / 2
        
        let ptA = CGPoint(x: offsetX + xA * scale, y: offsetY)
        let ptB = CGPoint(x: offsetX, y: offsetY + yA * scale)
        let ptC = CGPoint(x: offsetX + scale, y: offsetY + yA * scale)
        
        var path = Path()
        path.move(to: ptA)
        path.addLine(to: ptB)
        path.addLine(to: ptC)
        path.closeSubpath()
        
        strokeGlowPath(path, in: context, style: strokeStyle)
        
        let vertices = [ptA, ptB, ptC]
        let angles = [angleA, angleB, angleC]
        
        for i in 0..<3 {
            let v = vertices[i]
            let v1 = vertices[(i + 1) % 3]
            let v2 = vertices[(i + 2) % 3]
            
            let labelText = question.stringValues["label\(i)"] ?? ((i == unknownIndex) ? "x" : "\(Int(angles[i]))°")
            let labelPos = drawAngleArcAndGetLabelPos(
                context: context,
                center: v,
                to: v1,
                to: v2,
                arcRadius: 18,
                labelOffset: 34
            )
            drawLabel(context: context, text: labelText, at: labelPos)
        }
    }
    
    private func drawParallelTransversal(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let angleTheta = question.numericValues["angleTheta"] ?? 60.0
        let givenIndex = Int(question.numericValues["givenIndex"] ?? 0)
        let unknownIndex = Int(question.numericValues["unknownIndex"] ?? 1)
        
        let y1 = size.height * 0.35
        let y2 = size.height * 0.65
        let mid = CGPoint(x: size.width / 2, y: size.height / 2)
        
        let rTheta = angleTheta * .pi / 180.0
        let tanTheta = tan(rTheta)
        
        let x1 = mid.x - (mid.y - y1) / tanTheta
        let x2 = mid.x + (y2 - mid.y) / tanTheta
        
        let ptP1 = CGPoint(x: x1, y: y1)
        let ptP2 = CGPoint(x: x2, y: y2)
        
        var linesPath = Path()
        linesPath.move(to: CGPoint(x: 35, y: y1))
        linesPath.addLine(to: CGPoint(x: size.width - 35, y: y1))
        
        linesPath.move(to: CGPoint(x: 35, y: y2))
        linesPath.addLine(to: CGPoint(x: size.width - 35, y: y2))
        
        strokeGlowPath(linesPath, in: context, style: strokeStyle)
        
        let vecX = ptP1.x - ptP2.x
        let vecY = ptP1.y - ptP2.y
        let len = sqrt(vecX*vecX + vecY*vecY)
        let extend: CGFloat = 35
        let dx = (vecX / len) * extend
        let dy = (vecY / len) * extend
        
        var transversalPath = Path()
        transversalPath.move(to: CGPoint(x: ptP2.x - dx, y: ptP2.y - dy))
        transversalPath.addLine(to: CGPoint(x: ptP1.x + dx, y: ptP1.y + dy))
        
        strokeGlowPath(transversalPath, in: context, style: strokeStyle)
        
        let betaVal = 180.0 - angleTheta
        
        // Render arc indicator & label for the given and unknown angles using transversal helper
        let isTopGiven = givenIndex < 4
        let centerGiven = isTopGiven ? ptP1 : ptP2
        
        let isThetaGiven = [0, 3, 4, 7].contains(givenIndex)
        let givenAngleVal = isThetaGiven ? angleTheta : betaVal
        let givenText = question.stringValues["label\(givenIndex)"] ?? "\(Int(givenAngleVal))°"
        drawTransversalQuadrant(context: context, center: centerGiven, idx: givenIndex, dx: dx, dy: dy, text: givenText)
        
        let isTopUnknown = unknownIndex < 4
        let centerUnknown = isTopUnknown ? ptP1 : ptP2
        let unknownText = question.stringValues["label\(unknownIndex)"] ?? "x"
        drawTransversalQuadrant(context: context, center: centerUnknown, idx: unknownIndex, dx: dx, dy: dy, text: unknownText)
    }
    
    private func drawSupplementaryLines(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let angleA = question.numericValues["angleA"] ?? 60.0
        let angleB = question.numericValues["angleB"] ?? 120.0
        let isALeft = question.numericValues["isALeft"] ?? 1.0
        let isAUnknown = question.numericValues["isAUnknown"] ?? 1.0
        
        let yBase = size.height * 0.65
        let centerPt = CGPoint(x: size.width / 2, y: yBase)
        
        var basePath = Path()
        basePath.move(to: CGPoint(x: 35, y: yBase))
        basePath.addLine(to: CGPoint(x: size.width - 35, y: yBase))
        strokeGlowPath(basePath, in: context, style: strokeStyle)
        
        let rA = angleA * .pi / 180.0
        let rayLength: CGFloat = 115
        
        let rayAngle = (isALeft == 1.0) ? -(.pi - rA) : -rA
        let rayEnd = CGPoint(
            x: centerPt.x + rayLength * cos(rayAngle),
            y: centerPt.y + rayLength * sin(rayAngle)
        )
        
        var rayPath = Path()
        rayPath.move(to: centerPt)
        rayPath.addLine(to: rayEnd)
        strokeGlowPath(rayPath, in: context, style: strokeStyle)
        
        let leftVal = (isALeft == 1.0) ? angleA : angleB
        let rightVal = (isALeft == 1.0) ? angleB : angleA
        let isLeftUnknown = (isALeft == 1.0) ? (isAUnknown == 1.0) : (isAUnknown == 0.0)
        
        let leftText = question.stringValues["labelLeft"] ?? (isLeftUnknown ? "x" : "\(Int(leftVal))°")
        let rightText = question.stringValues["labelRight"] ?? (isLeftUnknown ? "\(Int(rightVal))°" : "x")
        
        let ptLeft = CGPoint(x: centerPt.x - 50, y: centerPt.y)
        let ptRight = CGPoint(x: centerPt.x + 50, y: centerPt.y)
        
        let leftLabelPos = drawAngleArcAndGetLabelPos(context: context, center: centerPt, to: ptLeft, to: rayEnd, arcRadius: 20, labelOffset: 36)
        let rightLabelPos = drawAngleArcAndGetLabelPos(context: context, center: centerPt, to: rayEnd, to: ptRight, arcRadius: 20, labelOffset: 36)
        
        drawLabel(context: context, text: leftText, at: leftLabelPos)
        drawLabel(context: context, text: rightText, at: rightLabelPos)
    }
    
    private func drawInscribedCircleAngle(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let centralAngle = question.numericValues["centralAngle"] ?? 100.0
        let inscribedAngle = question.numericValues["inscribedAngle"] ?? 50.0
        let askForCentral = question.numericValues["askForCentral"] ?? 1.0
        
        let centerPt = CGPoint(x: size.width / 2, y: size.height * 0.52)
        let radius = size.height * 0.35
        
        var circlePath = Path()
        circlePath.addEllipse(in: CGRect(
            x: centerPt.x - radius,
            y: centerPt.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
        context.stroke(circlePath, with: .color(glowColor.opacity(0.18)), lineWidth: 2.0)
        
        let rCentral = centralAngle * .pi / 180.0
        let angleA = .pi/2.0 - rCentral/2.0
        let angleB = .pi/2.0 + rCentral/2.0
        
        let ptA = CGPoint(x: centerPt.x + radius * cos(angleA), y: centerPt.y + radius * sin(angleA))
        let ptB = CGPoint(x: centerPt.x + radius * cos(angleB), y: centerPt.y + radius * sin(angleB))
        let ptP = CGPoint(x: centerPt.x, y: centerPt.y - radius)
        
        var centralPath = Path()
        centralPath.move(to: ptA)
        centralPath.addLine(to: centerPt)
        centralPath.addLine(to: ptB)
        strokeGlowPath(centralPath, in: context, style: strokeStyle)
        
        var inscribedPath = Path()
        inscribedPath.move(to: ptA)
        inscribedPath.addLine(to: ptP)
        inscribedPath.addLine(to: ptB)
        strokeGlowPath(inscribedPath, in: context, style: strokeStyle)
        
        let centralText = question.stringValues["labelCentral"] ?? ((askForCentral == 1.0) ? "x" : "\(Int(centralAngle))°")
        let inscribedText = question.stringValues["labelInscribed"] ?? ((askForCentral == 1.0) ? "\(Int(inscribedAngle))°" : "x")
        
        let centralLabelPos = drawAngleArcAndGetLabelPos(context: context, center: centerPt, to: ptA, to: ptB, arcRadius: 22, labelOffset: 38)
        let inscribedLabelPos = drawAngleArcAndGetLabelPos(context: context, center: ptP, to: ptA, to: ptB, arcRadius: 22, labelOffset: 38)
        
        drawLabel(context: context, text: centralText, at: centralLabelPos)
        drawLabel(context: context, text: inscribedText, at: inscribedLabelPos)
    }
    
    private func drawCircleTangent(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let centerAngle = question.numericValues["centerAngle"] ?? 45.0
        let thetaRad = centerAngle * .pi / 180.0
        
        let unitW: CGFloat = 1.0
        let unitH = CGFloat(tan(thetaRad))
        
        let padding: CGFloat = 45
        let availW = size.width - padding * 2
        let availH = size.height - padding * 2
        
        let scale = min(availW * 0.7 / unitW, availH * 0.85 / unitH)
        let rScaled = scale
        let hScaled = scale * unitH
        
        let offsetX = (size.width - rScaled) / 2.0 - 25
        let offsetY = (size.height + hScaled) / 2.0
        
        let centerPt = CGPoint(x: offsetX, y: offsetY)
        let ptR = CGPoint(x: offsetX + rScaled, y: offsetY)
        let ptP = CGPoint(x: offsetX + rScaled, y: offsetY - hScaled)
        
        var circlePath = Path()
        circlePath.addEllipse(in: CGRect(
            x: centerPt.x - rScaled,
            y: centerPt.y - rScaled,
            width: rScaled * 2,
            height: rScaled * 2
        ))
        context.stroke(circlePath, with: .color(glowColor.opacity(0.18)), lineWidth: 2.0)
        
        var radPath = Path()
        radPath.move(to: centerPt)
        radPath.addLine(to: ptR)
        strokeGlowPath(radPath, in: context, style: strokeStyle)
        
        var tangentPath = Path()
        tangentPath.move(to: ptR)
        tangentPath.addLine(to: ptP)
        strokeGlowPath(tangentPath, in: context, style: strokeStyle)
        
        var hypPath = Path()
        hypPath.move(to: centerPt)
        hypPath.addLine(to: ptP)
        strokeGlowPath(hypPath, in: context, style: strokeStyle)
        
        let boxSize: CGFloat = 12
        var boxPath = Path()
        boxPath.move(to: CGPoint(x: ptR.x - boxSize, y: ptR.y))
        boxPath.addLine(to: CGPoint(x: ptR.x - boxSize, y: ptR.y - boxSize))
        boxPath.addLine(to: CGPoint(x: ptR.x, y: ptR.y - boxSize))
        context.stroke(boxPath, with: .color(glowColor.opacity(0.55)), lineWidth: 1.5)
        
        let labelPosO = drawAngleArcAndGetLabelPos(context: context, center: centerPt, to: ptR, to: ptP, arcRadius: 22, labelOffset: 38)
        let labelPosP = drawAngleArcAndGetLabelPos(context: context, center: ptP, to: centerPt, to: ptR, arcRadius: 20, labelOffset: 36)
        
        let centerText = question.stringValues["labelCenter"] ?? "\(Int(centerAngle))°"
        let tangentText = question.stringValues["labelTangent"] ?? "x"
        drawLabel(context: context, text: centerText, at: labelPosO)
        drawLabel(context: context, text: tangentText, at: labelPosP)
    }
    
    private func drawGeometricIQPattern(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let sides = Int(question.numericValues["sides"] ?? 3.0)
        let v0 = Int(question.numericValues["vertex0"] ?? 0)
        let v1 = Int(question.numericValues["vertex1"] ?? 0)
        let v2 = Int(question.numericValues["vertex2"] ?? 0)
        let v3 = Int(question.numericValues["vertex3"] ?? 0)
        
        let centerPt = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let radius = size.height * 0.28
        
        let vertices = GeometryUtils.regularPolygonVertices(sides: sides, center: centerPt, radius: radius)
        
        var polyPath = Path()
        if let first = vertices.first {
            polyPath.move(to: first)
            for i in 1..<vertices.count {
                polyPath.addLine(to: vertices[i])
            }
            polyPath.closeSubpath()
        }
        strokeGlowPath(polyPath, in: context, style: strokeStyle)
        
        let values = [v0, v1, v2, v3]
        for i in 0..<vertices.count {
            let vertex = vertices[i]
            let dx = vertex.x - centerPt.x
            let dy = vertex.y - centerPt.y
            let len = sqrt(dx*dx + dy*dy)
            
            let offsetDist: CGFloat = 20
            let labelPos = CGPoint(
                x: vertex.x + (dx / len) * offsetDist,
                y: vertex.y + (dy / len) * offsetDist
            )
            drawLabel(context: context, text: "\(values[i])", at: labelPos)
        }
        
        let hubRadius: CGFloat = 24
        var hubPath = Path()
        hubPath.addEllipse(in: CGRect(
            x: centerPt.x - hubRadius,
            y: centerPt.y - hubRadius,
            width: hubRadius * 2,
            height: hubRadius * 2
        ))
        context.fill(hubPath, with: .color(.black.opacity(0.85)))
        context.stroke(hubPath, with: .color(glowColor.opacity(0.4)), lineWidth: 2.0)
        
        drawLabel(context: context, text: "x", at: centerPt)
    }
    
    private func drawTriangleTrig(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let opp = question.numericValues["opposite"] ?? 3.0
        let adj = question.numericValues["adjacent"] ?? 4.0
        let hyp = question.numericValues["hypotenuse"] ?? 5.0
        
        let padding: CGFloat = 50
        let availW = size.width - padding * 2
        let availH = size.height - padding * 2
        
        let scale = min(availW / adj, availH / opp)
        let w = adj * scale
        let h = opp * scale
        
        let offsetX = (size.width - w) / 2.0
        let offsetY = (size.height + h) / 2.0
        
        let ptA = CGPoint(x: offsetX, y: offsetY)
        let ptC = CGPoint(x: offsetX + w, y: offsetY)
        let ptB = CGPoint(x: offsetX + w, y: offsetY - h)
        
        var path = Path()
        path.move(to: ptA)
        path.addLine(to: ptC)
        path.addLine(to: ptB)
        path.closeSubpath()
        strokeGlowPath(path, in: context, style: strokeStyle)
        
        let boxSize: CGFloat = 12
        var boxPath = Path()
        boxPath.move(to: CGPoint(x: ptC.x - boxSize, y: ptC.y))
        boxPath.addLine(to: CGPoint(x: ptC.x - boxSize, y: ptC.y - boxSize))
        boxPath.addLine(to: CGPoint(x: ptC.x, y: ptC.y - boxSize))
        context.stroke(boxPath, with: .color(glowColor.opacity(0.65)), lineWidth: 1.5)
        
        let labelPosA = drawAngleArcAndGetLabelPos(context: context, center: ptA, to: ptC, to: ptB, arcRadius: 22, labelOffset: 38)
        
        let adjText = question.stringValues["labelAdj"] ?? "\(Int(adj))"
        let oppText = question.stringValues["labelOpp"] ?? "\(Int(opp))"
        let hypText = question.stringValues["labelHyp"] ?? "\(Int(hyp))"
        let thetaText = question.stringValues["labelTheta"] ?? "θ"
        
        drawLabel(context: context, text: adjText, at: CGPoint(x: ptA.x + w/2.0, y: ptA.y + 16))
        drawLabel(context: context, text: oppText, at: CGPoint(x: ptC.x + 16, y: ptC.y - h/2.0))
        drawLabel(context: context, text: hypText, at: CGPoint(x: ptA.x + w/2.0 - 15, y: ptA.y - h/2.0 - 10))
        drawLabel(context: context, text: thetaText, at: labelPosA)
    }

    
    // MARK: - Trigonometry Renderers
    
    private func drawUnitCircle(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let centerPt = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let radius = size.height * 0.32
        
        // 1. Draw Grid Axes
        var gridPath = Path()
        // X axis
        gridPath.move(to: CGPoint(x: 35, y: centerPt.y))
        gridPath.addLine(to: CGPoint(x: size.width - 35, y: centerPt.y))
        // Y axis
        gridPath.move(to: CGPoint(x: centerPt.x, y: 25))
        gridPath.addLine(to: CGPoint(x: centerPt.x, y: size.height - 25))
        context.stroke(gridPath, with: .color(Color.white.opacity(0.2)), lineWidth: 1.5)
        
        // 2. Draw Unit Circle
        var circlePath = Path()
        circlePath.addEllipse(in: CGRect(
            x: centerPt.x - radius,
            y: centerPt.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
        context.stroke(circlePath, with: .color(glowColor.opacity(0.25)), lineWidth: 1.5)
        
        // 3. Draw Angle Ray
        let angle = question.numericValues["angle"] ?? 45.0
        let angleRad = angle * .pi / 180.0
        // Screen Y is negative upwards
        let ptOnCircle = CGPoint(
            x: centerPt.x + radius * cos(-angleRad),
            y: centerPt.y + radius * sin(-angleRad)
        )
        
        var rayPath = Path()
        rayPath.move(to: centerPt)
        rayPath.addLine(to: ptOnCircle)
        strokeGlowPath(rayPath, in: context, style: strokeStyle)
        
        // 4. Draw Angle Arc indicator
        let arcRadius = radius * 0.28
        var arcPath = Path()
        arcPath.addArc(
            center: centerPt,
            radius: arcRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(-angle),
            clockwise: true
        )
        context.stroke(arcPath, with: .color(glowColor.opacity(0.75)), lineWidth: 2.0)
        
        // 5. Draw dotted projections to axes
        var dottedPath = Path()
        dottedPath.move(to: ptOnCircle)
        dottedPath.addLine(to: CGPoint(x: ptOnCircle.x, y: centerPt.y)) // down to X
        dottedPath.move(to: ptOnCircle)
        dottedPath.addLine(to: CGPoint(x: centerPt.x, y: ptOnCircle.y)) // left to Y
        context.stroke(dottedPath, with: .color(Color.white.opacity(0.45)), style: StrokeStyle(lineWidth: 1.0, dash: [4, 4]))
        
        // 6. Highlight point on circle
        var dotPath = Path()
        dotPath.addEllipse(in: CGRect(
            x: ptOnCircle.x - 5,
            y: ptOnCircle.y - 5,
            width: 10,
            height: 10
        ))
        context.fill(dotPath, with: .color(.white))
        context.stroke(dotPath, with: .color(glowColor), lineWidth: 2.0)
        
        // Labels
        let labelPos = CGPoint(
            x: centerPt.x + (arcRadius + 16) * cos(-angleRad / 2.0),
            y: centerPt.y + (arcRadius + 16) * sin(-angleRad / 2.0)
        )
        drawLabel(context: context, text: "θ", at: labelPos)
        drawLabel(context: context, text: "X(1,0)", at: CGPoint(x: centerPt.x + radius + 15, y: centerPt.y + 12))
    }

    
    private func drawTrigIdentity(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        // Draw coordinate axes
        let midY = size.height / 2.0
        var axesPath = Path()
        axesPath.move(to: CGPoint(x: 25, y: midY))
        axesPath.addLine(to: CGPoint(x: size.width - 25, y: midY))
        context.stroke(axesPath, with: .color(Color.white.opacity(0.15)), lineWidth: 1.5)
        
        // Draw decorative Sine and Cosine waves representing math identity curves
        var sinPath = Path()
        var cosPath = Path()
        
        let rangeX = size.width - 60
        
        for i in 0...100 {
            let pct = CGFloat(i) / 100.0
            let x = 30 + pct * rangeX
            let theta = pct * 4.0 * .pi // 2 complete waves
            
            let ySin = midY - sin(theta) * 55.0
            let yCos = midY - cos(theta) * 55.0
            
            if i == 0 {
                sinPath.move(to: CGPoint(x: x, y: ySin))
                cosPath.move(to: CGPoint(x: x, y: yCos))
            } else {
                sinPath.addLine(to: CGPoint(x: x, y: ySin))
                cosPath.addLine(to: CGPoint(x: x, y: yCos))
            }
        }
        
        // Sine wave (dimmed blue)
        context.stroke(sinPath, with: .color(Color(hex: "#00F0FF").opacity(0.16)), lineWidth: 2.5)
        // Cosine wave (dimmed purple)
        context.stroke(cosPath, with: .color(Color(hex: "#BD00FF").opacity(0.16)), lineWidth: 2.5)
        
        // Draw a central floating neon information panel
        let panelW: CGFloat = size.width * 0.72
        let panelH: CGFloat = 85
        let rect = CGRect(
            x: (size.width - panelW) / 2.0,
            y: (size.height - panelH) / 2.0,
            width: panelW,
            height: panelH
        )
        
        let rRect = Path(roundedRect: rect, cornerRadius: 16)
        context.fill(rRect, with: .color(.black.opacity(0.85)))
        context.stroke(rRect, with: .color(glowColor.opacity(0.55)), lineWidth: 2.0)
        
        // Add decorative formulas inside card
        drawLabel(context: context, text: "TRIGONOMETRIC IDENTITY", at: CGPoint(x: size.width / 2.0, y: midY - 20))
        drawLabel(context: context, text: "f(θ) = ?", at: CGPoint(x: size.width / 2.0, y: midY + 12))
    }
    
    // MARK: - Algebra Renderers
    
    private func drawVectorPuzzle(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let centerPt = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let gridSpacing: CGFloat = 20
        
        // 1. Draw 2D coordinates grid
        var gridPath = Path()
        // Draw vertical/horizontal grids (-5 to +5)
        for i in -5...5 {
            let offset = CGFloat(i) * gridSpacing
            // vertical grid lines
            gridPath.move(to: CGPoint(x: centerPt.x + offset, y: 15))
            gridPath.addLine(to: CGPoint(x: centerPt.x + offset, y: size.height - 15))
            // horizontal grid lines
            gridPath.move(to: CGPoint(x: 25, y: centerPt.y + offset))
            gridPath.addLine(to: CGPoint(x: size.width - 25, y: centerPt.y + offset))
        }
        context.stroke(gridPath, with: .color(Color.white.opacity(0.08)), lineWidth: 1.0)
        
        // 2. Draw Strong Axes
        var axesPath = Path()
        axesPath.move(to: CGPoint(x: 20, y: centerPt.y))
        axesPath.addLine(to: CGPoint(x: size.width - 20, y: centerPt.y))
        axesPath.move(to: CGPoint(x: centerPt.x, y: 10))
        axesPath.addLine(to: CGPoint(x: centerPt.x, y: size.height - 10))
        context.stroke(axesPath, with: .color(Color.white.opacity(0.25)), lineWidth: 1.5)
        
        // 3. Draw Vector Arrow
        let vX = question.numericValues["vectorX"] ?? 3.0
        let vY = question.numericValues["vectorY"] ?? 2.0
        
        // Y math coordinate goes up (screen goes down)
        let vectorEnd = CGPoint(
            x: centerPt.x + CGFloat(vX) * gridSpacing,
            y: centerPt.y - CGFloat(vY) * gridSpacing
        )
        
        var vectorPath = Path()
        vectorPath.move(to: centerPt)
        vectorPath.addLine(to: vectorEnd)
        strokeGlowPath(vectorPath, in: context, style: strokeStyle)
        
        // 4. Draw Arrowhead
        let angle = atan2(vectorEnd.y - centerPt.y, vectorEnd.x - centerPt.x)
        let arrowLen: CGFloat = 12
        let arrowAngle: CGFloat = .pi / 6.0 // 30 degrees wings
        
        let ptLeft = CGPoint(
            x: vectorEnd.x - arrowLen * cos(angle - arrowAngle),
            y: vectorEnd.y - arrowLen * sin(angle - arrowAngle)
        )
        let ptRight = CGPoint(
            x: vectorEnd.x - arrowLen * cos(angle + arrowAngle),
            y: vectorEnd.y - arrowLen * sin(angle + arrowAngle)
        )
        
        var headPath = Path()
        headPath.move(to: vectorEnd)
        headPath.addLine(to: ptLeft)
        headPath.addLine(to: ptRight)
        headPath.closeSubpath()
        context.fill(headPath, with: .color(.white))
        context.stroke(headPath, with: .color(glowColor), lineWidth: 1.5)
        
        // Highlight grid coordinate endpoints
        var endCircle = Path()
        endCircle.addEllipse(in: CGRect(x: vectorEnd.x - 3.5, y: vectorEnd.y - 3.5, width: 7, height: 7))
        context.fill(endCircle, with: .color(.white))
        
        // 5. Draw Vector Label
        let labelPos = CGPoint(x: (centerPt.x + vectorEnd.x)/2.0 - 15, y: (centerPt.y + vectorEnd.y)/2.0 - 15)
        drawLabel(context: context, text: "u", at: labelPos)
        
        // 6. Draw Second Vector (for dot product in hard/expert tiers)
        if let vX2 = question.numericValues["vectorX2"],
           let vY2 = question.numericValues["vectorY2"] {
            let purpleColor = Color(hex: "#BD00FF")
            let vectorEnd2 = CGPoint(
                x: centerPt.x + CGFloat(vX2) * gridSpacing,
                y: centerPt.y - CGFloat(vY2) * gridSpacing
            )
            
            var vectorPath2 = Path()
            vectorPath2.move(to: centerPt)
            vectorPath2.addLine(to: vectorEnd2)
            strokeGlowPath(vectorPath2, in: context, style: strokeStyle, color: purpleColor)
            
            let angle2 = atan2(vectorEnd2.y - centerPt.y, vectorEnd2.x - centerPt.x)
            let ptLeft2 = CGPoint(
                x: vectorEnd2.x - arrowLen * cos(angle2 - arrowAngle),
                y: vectorEnd2.y - arrowLen * sin(angle2 - arrowAngle)
            )
            let ptRight2 = CGPoint(
                x: vectorEnd2.x - arrowLen * cos(angle2 + arrowAngle),
                y: vectorEnd2.y - arrowLen * sin(angle2 + arrowAngle)
            )
            
            var headPath2 = Path()
            headPath2.move(to: vectorEnd2)
            headPath2.addLine(to: ptLeft2)
            headPath2.addLine(to: ptRight2)
            headPath2.closeSubpath()
            context.fill(headPath2, with: .color(.white))
            context.stroke(headPath2, with: .color(purpleColor), lineWidth: 1.5)
            
            var endCircle2 = Path()
            endCircle2.addEllipse(in: CGRect(x: vectorEnd2.x - 3.5, y: vectorEnd2.y - 3.5, width: 7, height: 7))
            context.fill(endCircle2, with: .color(.white))
            
            let labelPos2 = CGPoint(x: (centerPt.x + vectorEnd2.x)/2.0 + 15, y: (centerPt.y + vectorEnd2.y)/2.0 + 15)
            drawLabel(context: context, text: "v", at: labelPos2)
        }
    }
    
    private func drawFunctionGraph(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let centerPt = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let gridSpacing: CGFloat = 20
        
        // 1. Draw Grid
        var gridPath = Path()
        for i in -5...5 {
            let offset = CGFloat(i) * gridSpacing
            gridPath.move(to: CGPoint(x: centerPt.x + offset, y: 15))
            gridPath.addLine(to: CGPoint(x: centerPt.x + offset, y: size.height - 15))
            gridPath.move(to: CGPoint(x: 25, y: centerPt.y + offset))
            gridPath.addLine(to: CGPoint(x: size.width - 25, y: centerPt.y + offset))
        }
        context.stroke(gridPath, with: .color(Color.white.opacity(0.08)), lineWidth: 1.0)
        
        // 2. Draw axes
        var axesPath = Path()
        axesPath.move(to: CGPoint(x: 20, y: centerPt.y))
        axesPath.addLine(to: CGPoint(x: size.width - 20, y: centerPt.y))
        axesPath.move(to: CGPoint(x: centerPt.x, y: 10))
        axesPath.addLine(to: CGPoint(x: centerPt.x, y: size.height - 10))
        context.stroke(axesPath, with: .color(Color.white.opacity(0.25)), lineWidth: 1.5)
        
        // 3. Graph function: y = ax + b or y = ax² + b
        let isParabola = (question.numericValues["graphType"] ?? 0.0) == 1.0
        let a = question.numericValues["paramA"] ?? 1.0
        let b = question.numericValues["paramB"] ?? 0.0
        
        var graphPath = Path()
        let steps = 60
        var firstPoint = true
        
        for i in 0...steps {
            let pct = CGFloat(i) / CGFloat(steps)
            // Math X limits: -5 to +5
            let xMath = -5.0 + Double(pct) * 10.0
            let yMath: Double
            
            if isParabola {
                yMath = a * (xMath * xMath) + b
            } else {
                yMath = a * xMath + b
            }
            
            // Convert to screen pixels
            let screenX = centerPt.x + CGFloat(xMath) * gridSpacing
            let screenY = centerPt.y - CGFloat(yMath) * gridSpacing
            
            // Only draw if point lies within coordinate safe boundaries
            guard screenY >= 10 && screenY <= size.height - 10 else {
                firstPoint = true // break continuity
                continue
            }
            
            if firstPoint {
                graphPath.move(to: CGPoint(x: screenX, y: screenY))
                firstPoint = false
            } else {
                graphPath.addLine(to: CGPoint(x: screenX, y: screenY))
            }
        }
        
        strokeGlowPath(graphPath, in: context, style: strokeStyle)
        
        // Label the origin (0,0) as a reference point
        drawLabel(context: context, text: "0", at: CGPoint(x: centerPt.x - 10, y: centerPt.y + 10))
    }
    
    private func drawMatrixGrid(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let valA = Int(question.numericValues["valA"] ?? 2.0)
        let valB = Int(question.numericValues["valB"] ?? 4.0)
        let valC = Int(question.numericValues["valC"] ?? 5.0)
        
        let centerPt = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        
        let gridW: CGFloat = 160
        let gridH: CGFloat = 130
        
        let rect = CGRect(
            x: centerPt.x - gridW / 2.0,
            y: centerPt.y - gridH / 2.0,
            width: gridW,
            height: gridH
        )
        
        // 1. Draw Outer Matrix Card Border
        let mRect = Path(roundedRect: rect, cornerRadius: 18)
        context.fill(mRect, with: .color(.black.opacity(0.85)))
        context.stroke(mRect, with: .color(glowColor.opacity(0.4)), lineWidth: 2.0)
        
        // 2. Draw Row and Column Dividers
        var dividers = Path()
        // Horizontal line
        dividers.move(to: CGPoint(x: rect.minX, y: centerPt.y))
        dividers.addLine(to: CGPoint(x: rect.maxX, y: centerPt.y))
        // Vertical line
        dividers.move(to: CGPoint(x: centerPt.x, y: rect.minY))
        dividers.addLine(to: CGPoint(x: centerPt.x, y: rect.maxY))
        context.stroke(dividers, with: .color(glowColor.opacity(0.25)), lineWidth: 1.5)
        
        // 3. Print numbers centered inside their respective cells
        let cellW = gridW / 2.0
        let cellH = gridH / 2.0
        
        let cellCenters: [CGPoint] = [
            CGPoint(x: rect.minX + cellW/2.0, y: rect.minY + cellH/2.0), // Top Left (A)
            CGPoint(x: rect.minX + cellW*1.5, y: rect.minY + cellH/2.0), // Top Right (B)
            CGPoint(x: rect.minX + cellW/2.0, y: rect.minY + cellH*1.5), // Bottom Left (C)
            CGPoint(x: rect.minX + cellW*1.5, y: rect.minY + cellH*1.5)  // Bottom Right (X)
        ]
        
        drawCellLabel(context: context, text: "\(valA)", at: cellCenters[0])
        drawCellLabel(context: context, text: "\(valB)", at: cellCenters[1])
        drawCellLabel(context: context, text: "\(valC)", at: cellCenters[2])
        drawCellLabel(context: context, text: "x", at: cellCenters[3], isUnknown: true)
    }
    
    // MARK: - Label Rendering Helpers
    
    private func drawLabel(context: GraphicsContext, text: String, at point: CGPoint) {
        let labelText = Text(text)
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            
        context.draw(
            Text(text)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(.black),
            at: CGPoint(x: point.x + 1, y: point.y + 1)
        )
        context.draw(labelText, at: point)
    }
    
    /// Specially sized rendering for Matrix cells
    private func drawCellLabel(context: GraphicsContext, text: String, at point: CGPoint, isUnknown: Bool = false) {
        let labelText = Text(text)
            .font(.system(size: 26, weight: .black, design: .rounded))
            .foregroundColor(isUnknown ? glowColor : .white)
            
        context.draw(
            Text(text)
                .font(.system(size: 26, weight: .black, design: .rounded))
                .foregroundColor(.black),
            at: CGPoint(x: point.x + 1.5, y: point.y + 1.5)
        )
        context.draw(labelText, at: point)
    }
    
    /// Programmatically sweeps an arc between two vectors, strokes it with a neon glow, and computes
    /// a perfectly centered position inside the angle sector for text labels (preventing floating label ambiguities).
    private func drawAngleArcAndGetLabelPos(
        context: GraphicsContext,
        center: CGPoint,
        to pt1: CGPoint,
        to pt2: CGPoint,
        arcRadius: CGFloat,
        labelOffset: CGFloat
    ) -> CGPoint {
        let angle1 = atan2(pt1.y - center.y, pt1.x - center.x)
        let angle2 = atan2(pt2.y - center.y, pt2.x - center.x)
        
        var a1 = angle1
        var a2 = angle2
        if a1 < 0 { a1 += 2 * .pi }
        if a2 < 0 { a2 += 2 * .pi }
        
        var sweep = a2 - a1
        if sweep < -.pi { sweep += 2 * .pi }
        if sweep > .pi { sweep -= 2 * .pi }
        
        let midAngle = a1 + sweep / 2.0
        
        var path = Path()
        path.addArc(
            center: center,
            radius: arcRadius,
            startAngle: .radians(a1),
            endAngle: .radians(a1 + sweep),
            clockwise: sweep < 0
        )
        context.stroke(path, with: .color(glowColor.opacity(0.65)), lineWidth: 1.5)
        
        return CGPoint(
            x: center.x + labelOffset * cos(midAngle),
            y: center.y + labelOffset * sin(midAngle)
        )
    }
    
    /// Renders a specific quadrant arc and label positioning for intersecting transversal lines.
    private func drawTransversalQuadrant(
        context: GraphicsContext,
        center: CGPoint,
        idx: Int,
        dx: CGFloat,
        dy: CGFloat,
        text: String
    ) {
        let leftPt = CGPoint(x: center.x - 50, y: center.y)
        let rightPt = CGPoint(x: center.x + 50, y: center.y)
        let upPt = CGPoint(x: center.x + dx, y: center.y + dy)
        let downPt = CGPoint(x: center.x - dx, y: center.y - dy)
        
        let pt1: CGPoint
        let pt2: CGPoint
        
        switch idx % 4 {
        case 0: // top-left
            pt1 = leftPt
            pt2 = upPt
        case 1: // top-right
            pt1 = rightPt
            pt2 = upPt
        case 2: // bottom-left
            pt1 = leftPt
            pt2 = downPt
        case 3: // bottom-right
            pt1 = rightPt
            pt2 = downPt
        default:
            return
        }
        
        let labelPos = drawAngleArcAndGetLabelPos(
            context: context,
            center: center,
            to: pt1,
            to: pt2,
            arcRadius: 20,
            labelOffset: 36
        )
        drawLabel(context: context, text: text, at: labelPos)
    }
    
    // MARK: - New Sub-category Drawing Renderers
    
    private func drawVennDiagrams(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let a = Int(question.numericValues["a"] ?? 15.0)
        let b = Int(question.numericValues["b"] ?? 18.0)
        let inter = Int(question.numericValues["intersection"] ?? 5.0)
        
        let cx = size.width / 2.0
        let cy = size.height / 2.0
        
        let r: CGFloat = 50.0
        let leftCenter = CGPoint(x: cx - 30, y: cy)
        let rightCenter = CGPoint(x: cx + 30, y: cy)
        
        // Draw circles
        var leftPath = Path()
        leftPath.addEllipse(in: CGRect(x: leftCenter.x - r, y: leftCenter.y - r, width: r*2, height: r*2))
        strokeGlowPath(leftPath, in: context, style: strokeStyle, color: glowColor)
        
        var rightPath = Path()
        rightPath.addEllipse(in: CGRect(x: rightCenter.x - r, y: rightCenter.y - r, width: r*2, height: r*2))
        strokeGlowPath(rightPath, in: context, style: strokeStyle, color: Color(hex: "#BD00FF"))
        
        // Draw labels A and B
        drawLabel(context: context, text: "A", at: CGPoint(x: leftCenter.x - r, y: leftCenter.y - r - 10))
        drawLabel(context: context, text: "B", at: CGPoint(x: rightCenter.x + r - 10, y: rightCenter.y - r - 10))
        
        // Draw cardinalities
        drawLabel(context: context, text: "\(a - inter)", at: CGPoint(x: leftCenter.x - 20, y: leftCenter.y))
        drawLabel(context: context, text: "\(inter)", at: CGPoint(x: cx, y: cy))
        drawLabel(context: context, text: "\(b - inter)", at: CGPoint(x: rightCenter.x + 20, y: rightCenter.y))
    }
    
    private func drawLogic(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let p = Int(question.numericValues["p"] ?? 0.0)
        let q = Int(question.numericValues["q"] ?? 1.0)
        let format = Int(question.numericValues["format"] ?? 0.0)
        
        let cx = size.width / 2.0
        let cy = size.height / 2.0
        
        let hudRect = CGRect(x: cx - 110, y: cy - 65, width: 220, height: 130)
        let hudPath = Path(roundedRect: hudRect, cornerRadius: 16)
        context.stroke(hudPath, with: .color(glowColor.opacity(0.3)), lineWidth: 1.5)
        
        drawLabel(context: context, text: "INPUTS:", at: CGPoint(x: cx - 75, y: cy - 45))
        drawLabel(context: context, text: "p = \(p)", at: CGPoint(x: cx - 75, y: cy - 15))
        drawLabel(context: context, text: "q = \(q)", at: CGPoint(x: cx - 75, y: cy + 15))
        
        // Draw logic gate block
        let bx = cx + 35
        let by = cy
        let blockRect = CGRect(x: bx - 35, y: by - 30, width: 70, height: 60)
        let blockPath = Path(roundedRect: blockRect, cornerRadius: 8)
        strokeGlowPath(blockPath, in: context, style: strokeStyle, color: Color(hex: "#BD00FF"))
        
        // Logical expression text inside the block
        let exprStr: String
        switch format {
        case 0: exprStr = "(p∨q)∧¬p"
        case 1: exprStr = "(p∧q)∨¬q"
        default: exprStr = "p⟹q"
        }
        drawLabel(context: context, text: exprStr, at: CGPoint(x: bx, y: by))
        
        // Connecting lines from inputs to block
        var lines = Path()
        lines.move(to: CGPoint(x: cx - 25, y: cy - 15))
        lines.addLine(to: CGPoint(x: bx - 35, y: cy - 15))
        
        lines.move(to: CGPoint(x: cx - 25, y: cy + 15))
        lines.addLine(to: CGPoint(x: bx - 35, y: cy + 15))
        
        // Output line
        lines.move(to: CGPoint(x: bx + 35, y: cy))
        lines.addLine(to: CGPoint(x: bx + 55, y: cy))
        context.stroke(lines, with: .color(.white.opacity(0.4)), lineWidth: 1.5)
        
        drawLabel(context: context, text: "?", at: CGPoint(x: bx + 65, y: cy))
    }
    
    private func drawRatios(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let r1 = question.numericValues["r1"] ?? 3.0
        let r2 = question.numericValues["r2"] ?? 5.0
        let total = question.numericValues["total"] ?? 80.0
        let findLarger = question.numericValues["findLarger"] ?? 1.0
        
        let cx = size.width / 2.0
        let cy = size.height / 2.0
        
        let w: CGFloat = 180.0
        let h: CGFloat = 16.0
        let startX = cx - w / 2.0
        
        let ratioSplit = CGFloat(r1 / (r1 + r2))
        let splitX = startX + w * ratioSplit
        
        let leftRect = CGRect(x: startX, y: cy - h/2.0, width: w * ratioSplit, height: h)
        let leftPath = Path(roundedRect: leftRect, cornerRadius: 4)
        context.fill(leftPath, with: .color(glowColor.opacity(0.15)))
        context.stroke(leftPath, with: .color(glowColor), lineWidth: 2.0)
        
        let rightRect = CGRect(x: splitX, y: cy - h/2.0, width: w * (1 - ratioSplit), height: h)
        let rightPath = Path(roundedRect: rightRect, cornerRadius: 4)
        context.fill(rightPath, with: .color(Color(hex: "#BD00FF").opacity(0.15)))
        context.stroke(rightPath, with: .color(Color(hex: "#BD00FF")), lineWidth: 2.0)
        
        drawLabel(context: context, text: findLarger == 0 ? "?" : "\(Int(r1))k", at: CGPoint(x: startX + (w * ratioSplit)/2.0, y: cy - 25))
        drawLabel(context: context, text: findLarger == 1 ? "?" : "\(Int(r2))k", at: CGPoint(x: splitX + (w * (1 - ratioSplit))/2.0, y: cy - 25))
        
        drawLabel(context: context, text: "TOTAL = \(Int(total))", at: CGPoint(x: cx, y: cy + 25))
    }
    
    private func drawParabolaVertices(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let h = question.numericValues["h"] ?? 2.0
        let k = question.numericValues["k"] ?? 3.0
        
        let cx = size.width / 2.0
        let cy = size.height / 2.0
        
        var axes = Path()
        axes.move(to: CGPoint(x: cx - 100, y: cy))
        axes.addLine(to: CGPoint(x: cx + 100, y: cy))
        axes.move(to: CGPoint(x: cx, y: cy - 80))
        axes.addLine(to: CGPoint(x: cx, y: cy + 80))
        context.stroke(axes, with: .color(.white.opacity(0.25)), lineWidth: 1.5)
        
        let scale: CGFloat = 12.0
        let vertexPt = CGPoint(x: cx + CGFloat(h) * scale, y: cy - CGFloat(k) * scale)
        
        var curve = Path()
        var first = true
        for dxVal in stride(from: -3.5, through: 3.5, by: 0.1) {
            let px = h + dxVal
            let py = (px - h) * (px - h) + k
            
            let screenX = cx + CGFloat(px) * scale
            let screenY = cy - CGFloat(py) * scale
            
            if screenY >= cy - 85 && screenY <= cy + 85 {
                if first {
                    curve.move(to: CGPoint(x: screenX, y: screenY))
                    first = false
                } else {
                    curve.addLine(to: CGPoint(x: screenX, y: screenY))
                }
            }
        }
        strokeGlowPath(curve, in: context, style: strokeStyle, color: glowColor)
        
        var dot = Path()
        dot.addEllipse(in: CGRect(x: vertexPt.x - 5, y: vertexPt.y - 5, width: 10, height: 10))
        context.fill(dot, with: .color(Color(hex: "#BD00FF")))
        
        var projection = Path()
        projection.move(to: vertexPt)
        projection.addLine(to: CGPoint(x: vertexPt.x, y: cy))
        projection.move(to: vertexPt)
        projection.addLine(to: CGPoint(x: cx, y: vertexPt.y))
        context.stroke(projection, with: .color(.white.opacity(0.35)), style: StrokeStyle(lineWidth: 1.0, dash: [4, 4]))
        
        drawLabel(context: context, text: "T", at: CGPoint(x: vertexPt.x, y: vertexPt.y - 16))
    }
    
    private func drawLogarithmBasics(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let cx = size.width / 2.0
        let cy = size.height / 2.0
        
        var axes = Path()
        axes.move(to: CGPoint(x: cx - 100, y: cy + 40))
        axes.addLine(to: CGPoint(x: cx + 100, y: cy + 40))
        axes.move(to: CGPoint(x: cx - 60, y: cy - 70))
        axes.addLine(to: CGPoint(x: cx - 60, y: cy + 70))
        context.stroke(axes, with: .color(.white.opacity(0.25)), lineWidth: 1.5)
        
        var curve = Path()
        let startX = cx - 55
        let endX = cx + 80
        curve.move(to: CGPoint(x: startX, y: cy + 60))
        for xVal in stride(from: Double(startX), through: Double(endX), by: 2.0) {
            let dxVal = xVal - Double(cx - 60)
            let logY = log(dxVal / 15.0) * 25.0
            let screenY = cy + 40 - CGFloat(logY)
            if screenY > cy - 80 && screenY < cy + 80 {
                curve.addLine(to: CGPoint(x: CGFloat(xVal), y: screenY))
            }
        }
        strokeGlowPath(curve, in: context, style: strokeStyle, color: Color(hex: "#BD00FF"))
        
        drawLabel(context: context, text: "y = log_b(x)", at: CGPoint(x: cx + 30, y: cy - 40))
    }
    
    private func drawTransformations(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let px = question.numericValues["px"] ?? 2.0
        let py = question.numericValues["py"] ?? 3.0
        let fx = question.numericValues["fx"] ?? -2.0
        let fy = question.numericValues["fy"] ?? 1.0
        
        let cx = size.width / 2.0
        let cy = size.height / 2.0
        
        let scale: CGFloat = 12.0
        
        var axes = Path()
        axes.move(to: CGPoint(x: cx - 90, y: cy))
        axes.addLine(to: CGPoint(x: cx + 90, y: cy))
        axes.move(to: CGPoint(x: cx, y: cy - 70))
        axes.addLine(to: CGPoint(x: cx, y: cy + 70))
        context.stroke(axes, with: .color(.white.opacity(0.25)), lineWidth: 1.5)
        
        let ptP = CGPoint(x: cx + CGFloat(px) * scale, y: cy - CGFloat(py) * scale)
        let ptF = CGPoint(x: cx + CGFloat(fx) * scale, y: cy - CGFloat(fy) * scale)
        
        var pathP = Path()
        pathP.addEllipse(in: CGRect(x: ptP.x - 4.5, y: ptP.y - 4.5, width: 9, height: 9))
        context.fill(pathP, with: .color(glowColor))
        context.stroke(pathP, with: .color(glowColor.opacity(0.5)), lineWidth: 2.0)
        drawLabel(context: context, text: "P(\(Int(px)),\(Int(py)))", at: CGPoint(x: ptP.x + 10, y: ptP.y - 12))
        
        var pathF = Path()
        pathF.addEllipse(in: CGRect(x: ptF.x - 4.5, y: ptF.y - 4.5, width: 9, height: 9))
        context.fill(pathF, with: .color(Color(hex: "#BD00FF")))
        context.stroke(pathF, with: .color(Color(hex: "#BD00FF").opacity(0.5)), lineWidth: 2.0)
        drawLabel(context: context, text: "P' = ?", at: CGPoint(x: ptF.x - 10, y: ptF.y + 12))
        
        var arrow = Path()
        arrow.move(to: ptP)
        arrow.addLine(to: ptF)
        context.stroke(arrow, with: .color(.white.opacity(0.4)), style: StrokeStyle(lineWidth: 1.5, dash: [4, 4]))
    }
    
    private func drawTytNumbers(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let cx = size.width / 2.0
        let cy = size.height / 2.0
        let r: CGFloat = 60.0
        
        var baseCircle = Path()
        baseCircle.addEllipse(in: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2))
        context.stroke(baseCircle, with: .color(glowColor.opacity(0.3)), lineWidth: 1.5)
        
        let slices = 4
        
        var slicePath = Path()
        slicePath.move(to: CGPoint(x: cx, y: cy))
        slicePath.addArc(center: CGPoint(x: cx, y: cy), radius: r, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        slicePath.closeSubpath()
        context.fill(slicePath, with: .color(glowColor.opacity(0.2)))
        strokeGlowPath(slicePath, in: context, style: strokeStyle, color: glowColor)
        
        var dividers = Path()
        for i in 0..<slices {
            let angle = Double(i) * (360.0 / Double(slices))
            let rad = angle * .pi / 180.0
            dividers.move(to: CGPoint(x: cx, y: cy))
            dividers.addLine(to: CGPoint(x: cx + r * cos(rad), y: cy + r * sin(rad)))
        }
        context.stroke(dividers, with: .color(.white.opacity(0.4)), lineWidth: 1.5)
        
        drawLabel(context: context, text: "1/4", at: CGPoint(x: cx - 25, y: cy - 25))
    }
    
    private func drawTytEquations(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let cx = size.width / 2.0
        let cy = size.height / 2.0
        
        var line = Path()
        line.move(to: CGPoint(x: cx - 110, y: cy))
        line.addLine(to: CGPoint(x: cx + 110, y: cy))
        context.stroke(line, with: .color(.white.opacity(0.3)), lineWidth: 2.0)
        
        let scale: CGFloat = 30.0
        let points = [-3, -2, -1, 0, 1, 2, 3]
        for p in points {
            let x = cx + CGFloat(p) * scale
            var tick = Path()
            tick.move(to: CGPoint(x: x, y: cy - 5))
            tick.addLine(to: CGPoint(x: x, y: cy + 5))
            context.stroke(tick, with: .color(.white.opacity(0.5)), lineWidth: 1.0)
            drawLabel(context: context, text: "\(p)", at: CGPoint(x: x, y: cy + 20))
        }
        
        let startX = cx + 1.0 * scale
        let endX = cx + 3.0 * scale
        let highlightRect = CGRect(x: startX, y: cy - 3, width: endX - startX, height: 6)
        let highlightPath = Path(roundedRect: highlightRect, cornerRadius: 3)
        context.fill(highlightPath, with: .color(glowColor.opacity(0.25)))
        context.stroke(highlightPath, with: .color(glowColor), lineWidth: 2.0)
    }
    
    private func drawTytProblems(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let cx = size.width / 2.0
        let cy = size.height / 2.0
        
        var road = Path()
        road.move(to: CGPoint(x: cx - 120, y: cy + 20))
        road.addLine(to: CGPoint(x: cx + 120, y: cy + 20))
        context.stroke(road, with: .color(.white.opacity(0.3)), style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
        
        let rectA = CGRect(x: cx - 90, y: cy - 10, width: 24, height: 16)
        let pathA = Path(roundedRect: rectA, cornerRadius: 4)
        context.stroke(pathA, with: .color(glowColor), lineWidth: 2.0)
        drawLabel(context: context, text: "A", at: CGPoint(x: cx - 78, y: cy - 22))
        
        var vectorA = Path()
        vectorA.move(to: CGPoint(x: cx - 66, y: cy - 2))
        vectorA.addLine(to: CGPoint(x: cx - 40, y: cy - 2))
        vectorA.move(to: CGPoint(x: cx - 45, y: cy - 6))
        vectorA.addLine(to: CGPoint(x: cx - 40, y: cy - 2))
        vectorA.addLine(to: CGPoint(x: cx - 45, y: cy + 2))
        context.stroke(vectorA, with: .color(glowColor), lineWidth: 1.5)
        
        let rectB = CGRect(x: cx + 66, y: cy - 10, width: 24, height: 16)
        let pathB = Path(roundedRect: rectB, cornerRadius: 4)
        context.stroke(pathB, with: .color(Color(hex: "#BD00FF")), lineWidth: 2.0)
        drawLabel(context: context, text: "B", at: CGPoint(x: cx + 78, y: cy - 22))
        
        var vectorB = Path()
        vectorB.move(to: CGPoint(x: cx + 66, y: cy - 2))
        vectorB.addLine(to: CGPoint(x: cx + 40, y: cy - 2))
        vectorB.move(to: CGPoint(x: cx + 45, y: cy - 6))
        vectorB.addLine(to: CGPoint(x: cx + 40, y: cy - 2))
        vectorB.addLine(to: CGPoint(x: cx + 45, y: cy + 2))
        context.stroke(vectorB, with: .color(Color(hex: "#BD00FF")), lineWidth: 1.5)
    }
    
    private func drawTytFoundations(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let cx = size.width / 2.0
        let cy = size.height / 2.0
        
        let ovalA = CGRect(x: cx - 90, y: cy - 50, width: 60, height: 100)
        let pathA = Path(ellipseIn: ovalA)
        context.stroke(pathA, with: .color(glowColor.opacity(0.4)), lineWidth: 1.5)
        drawLabel(context: context, text: "A", at: CGPoint(x: cx - 60, y: cy - 65))
        
        let ovalB = CGRect(x: cx + 30, y: cy - 50, width: 60, height: 100)
        let pathB = Path(ellipseIn: ovalB)
        context.stroke(pathB, with: .color(Color(hex: "#BD00FF").opacity(0.4)), lineWidth: 1.5)
        drawLabel(context: context, text: "B", at: CGPoint(x: cx + 60, y: cy - 65))
        
        let pA1 = CGPoint(x: cx - 60, y: cy - 20)
        let pA2 = CGPoint(x: cx - 60, y: cy + 20)
        context.fill(Path(ellipseIn: CGRect(x: pA1.x-3, y: pA1.y-3, width: 6, height: 6)), with: .color(.white))
        context.fill(Path(ellipseIn: CGRect(x: pA2.x-3, y: pA2.y-3, width: 6, height: 6)), with: .color(.white))
        drawLabel(context: context, text: "x", at: CGPoint(x: pA1.x - 12, y: pA1.y - 10))
        drawLabel(context: context, text: "y", at: CGPoint(x: pA2.x - 12, y: pA2.y - 10))
        
        let pB1 = CGPoint(x: cx + 60, y: cy - 20)
        let pB2 = CGPoint(x: cx + 60, y: cy + 20)
        context.fill(Path(ellipseIn: CGRect(x: pB1.x-3, y: pB1.y-3, width: 6, height: 6)), with: .color(.white))
        context.fill(Path(ellipseIn: CGRect(x: pB2.x-3, y: pB2.y-3, width: 6, height: 6)), with: .color(.white))
        drawLabel(context: context, text: "f(x)", at: CGPoint(x: pB1.x + 16, y: pB1.y - 10))
        drawLabel(context: context, text: "f(y)", at: CGPoint(x: pB2.x + 16, y: pB2.y - 10))
        
        var arrow1 = Path()
        arrow1.move(to: pA1)
        arrow1.addQuadCurve(to: pB1, control: CGPoint(x: cx, y: cy - 35))
        context.stroke(arrow1, with: .color(glowColor), lineWidth: 1.5)
        
        var arrow2 = Path()
        arrow2.move(to: pA2)
        arrow2.addQuadCurve(to: pB2, control: CGPoint(x: cx, y: cy + 5))
        context.stroke(arrow2, with: .color(Color(hex: "#BD00FF")), lineWidth: 1.5)
        
        drawLabel(context: context, text: "f", at: CGPoint(x: cx, y: cy - 35))
    }
    
    private func drawTytProbability(context: GraphicsContext, size: CGSize, strokeStyle: StrokeStyle) {
        let cx = size.width / 2.0
        let cy = size.height / 2.0
        
        let diceRect1 = CGRect(x: cx - 60, y: cy - 25, width: 50, height: 50)
        let path1 = Path(roundedRect: diceRect1, cornerRadius: 8)
        strokeGlowPath(path1, in: context, style: strokeStyle, color: glowColor)
        
        let dot1 = Path(ellipseIn: CGRect(x: cx - 40, y: cy - 5, width: 10, height: 10))
        context.fill(dot1, with: .color(.white))
        
        let diceRect2 = CGRect(x: cx + 10, y: cy - 25, width: 50, height: 50)
        let path2 = Path(roundedRect: diceRect2, cornerRadius: 8)
        strokeGlowPath(path2, in: context, style: strokeStyle, color: Color(hex: "#BD00FF"))
        
        let dot2 = Path(ellipseIn: CGRect(x: cx + 18, y: cy + 7, width: 8, height: 8))
        let dot3 = Path(ellipseIn: CGRect(x: cx + 31, y: cy - 4, width: 8, height: 8))
        let dot4 = Path(ellipseIn: CGRect(x: cx + 44, y: cy - 15, width: 8, height: 8))
        context.fill(dot2, with: .color(.white))
        context.fill(dot3, with: .color(.white))
        context.fill(dot4, with: .color(.white))
    }
}
