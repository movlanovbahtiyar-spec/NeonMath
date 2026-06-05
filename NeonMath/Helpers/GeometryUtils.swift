import CoreGraphics

/// Math and coordinate utilities to calculate points, angles, and alignments for procedural geometry rendering.
public struct GeometryUtils {
    
    /// Calculates the vertices of a regular polygon (triangle, square, etc.) centered at a given point.
    /// - Parameters:
    ///   - sides: Number of sides of the polygon (e.g., 3 for triangle, 4 for square).
    ///   - center: The center point of the polygon.
    ///   - radius: The distance from the center to any vertex.
    ///   - rotation: Angle (in radians) to rotate the entire shape (default starts pointing up).
    /// - Returns: Array of vertex coordinates.
    public static func regularPolygonVertices(
        sides: Int,
        center: CGPoint,
        radius: CGFloat,
        rotation: CGFloat = -.pi / 2.0
    ) -> [CGPoint] {
        guard sides >= 3 else { return [] }
        var vertices: [CGPoint] = []
        let angleStep = (2.0 * .pi) / CGFloat(sides)
        
        for i in 0..<sides {
            let currentAngle = rotation + angleStep * CGFloat(i)
            let pt = CGPoint(
                x: center.x + radius * cos(currentAngle),
                y: center.y + radius * sin(currentAngle)
            )
            vertices.append(pt)
        }
        return vertices
    }
    
    /// Finds a point on a circle perimeter given the center, radius, and angle in radians.
    public static func pointOnCircle(
        center: CGPoint,
        radius: CGFloat,
        angleInRadians: CGFloat
    ) -> CGPoint {
        return CGPoint(
            x: center.x + radius * cos(angleInRadians),
            y: center.y + radius * sin(angleInRadians)
        )
    }
    
    /// Calculates the centroid (geometric center) of a set of 2D coordinates.
    public static func centroid(of points: [CGPoint]) -> CGPoint {
        guard !points.isEmpty else { return .zero }
        let sumX = points.reduce(0.0) { $0 + $1.x }
        let sumY = points.reduce(0.0) { $0 + $1.y }
        let count = CGFloat(points.count)
        return CGPoint(x: sumX / count, y: sumY / count)
    }
    
    /// Projects a point from a starting position, moving a specific distance along a given angle.
    public static func projectPoint(
        from start: CGPoint,
        distance: CGFloat,
        angleInRadians: CGFloat
    ) -> CGPoint {
        return CGPoint(
            x: start.x + distance * cos(angleInRadians),
            y: start.y + distance * sin(angleInRadians)
        )
    }
    
    /// Resolves the bisecting angle between two rays originating from a vertex.
    /// Corrects for angular wrap-around.
    public static func bisectorAngle(from start: CGFloat, to end: CGFloat) -> CGFloat {
        var diff = end - start
        while diff < -.pi { diff += 2.0 * .pi }
        while diff > .pi { diff -= 2.0 * .pi }
        return start + diff / 2.0
    }
}
