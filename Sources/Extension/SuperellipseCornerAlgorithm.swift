import SwiftUI

public struct SuperellipseCornerAlgorithm: PanelCornerAlgorithm {
    public var n: CGFloat // shape exponent, >2
    public var samplesPerQuarter: Int
    
    public init(n: CGFloat = 5.0, samplesPerQuarter: Int = 16) {
        self.n = max(n, 2.001)
        self.samplesPerQuarter = max(samplesPerQuarter, 4)
    }

    public func panelPath(rect: CGRect, cornerKind: PanelCornerKind, cornerRadius: CGFloat) -> Path {
        // Build a superellipse rounded rect by sampling each quarter and connecting
        return buildPath(rect: rect, cornerKind: cornerKind, cornerRadius: cornerRadius, gapWidth: nil)
    }

    public func gapPanelPath(rect: CGRect, cornerKind: PanelCornerKind, cornerRadius: CGFloat, gapWidth: CGFloat) -> Path {
        return buildPath(rect: rect, cornerKind: cornerKind, cornerRadius: cornerRadius, gapWidth: gapWidth)
    }

    private func buildPath(rect: CGRect, cornerKind: PanelCornerKind, cornerRadius: CGFloat, gapWidth: CGFloat?) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        guard w > 0, h > 0 else { return p }
        let maxR = min(w, h) / 2
        let r = min(cornerRadius, maxR)
        let minX = rect.minX, maxX = rect.maxX, minY = rect.minY, maxY = rect.maxY

        // Quarter superellipse generator around a corner with radii (rx, ry)
        func quarterPoints(rx: CGFloat, ry: CGFloat, start: CGPoint, to end: CGPoint, orientation: String) -> [CGPoint] {
            // orientation: "topLeft", "topRight", "bottomRight", "bottomLeft"
            var pts: [CGPoint] = []
            for i in 0...samplesPerQuarter {
                let t = CGFloat(i) / CGFloat(samplesPerQuarter) * (.pi/2)
                let ct = cos(t)
                let st = sin(t)
                let x = pow(abs(ct), 2.0 / n) * (ct < 0 ? -1 : 1)
                let y = pow(abs(st), 2.0 / n) * (st < 0 ? -1 : 1)
                let px: CGFloat
                let py: CGFloat
                switch orientation {
                case "topLeft":
                    px = start.x - rx * x
                    py = start.y + ry * y
                case "topRight":
                    px = start.x + rx * x
                    py = start.y + ry * y
                case "bottomRight":
                    px = start.x + rx * x
                    py = start.y - ry * y
                default: // bottomLeft
                    px = start.x - rx * x
                    py = start.y - ry * y
                }
                pts.append(CGPoint(x: px, y: py))
            }
            return pts
        }

        let gap: CGFloat? = gapWidth.map { min($0, max(0, w - 2*r)) }

        switch cornerKind {
        case .convex:
            // Bezier approximation per quarter for smoother superellipse corners
            let kCircle: CGFloat = 0.5522847498307936
            // Tune k based on n (n in [>2, ~8]) so that larger n (sharper) pulls control points slightly inward
            let t = max(0, min((n - 2.0) / 4.0, 1.0)) // map n∈[2..6] -> t∈[0..1]
            let k = kCircle * (1.0 - 0.18 * t)

            // Radii
            let rx = r
            let ry = r

            // Gap handling on top edge
            let gapLeft: CGFloat? = gap.map { rect.midX - $0/2 }
            let gapRight: CGFloat? = gap.map { rect.midX + $0/2 }

            // Start at top-left horizontal start point
            p.move(to: CGPoint(x: minX + rx, y: minY))

            // Top edge to gap or to top-right start
            if let gl = gapLeft, let gr = gapRight {
                p.addLine(to: CGPoint(x: gl, y: minY))
                // skip gap
                p.move(to: CGPoint(x: gr, y: minY))
            }
            p.addLine(to: CGPoint(x: maxX - rx, y: minY))

            // Top-right quarter (to right edge)
            p.addCurve(to: CGPoint(x: maxX, y: minY + ry),
                       control1: CGPoint(x: maxX - rx + k*rx, y: minY),
                       control2: CGPoint(x: maxX, y: minY + ry - k*ry))

            // Right edge
            p.addLine(to: CGPoint(x: maxX, y: maxY - ry))

            // Bottom-right quarter (to bottom edge)
            p.addCurve(to: CGPoint(x: maxX - rx, y: maxY),
                       control1: CGPoint(x: maxX, y: maxY - ry + k*ry),
                       control2: CGPoint(x: maxX - rx + k*rx, y: maxY))

            // Bottom edge
            p.addLine(to: CGPoint(x: minX + rx, y: maxY))

            // Bottom-left quarter (to left edge)
            p.addCurve(to: CGPoint(x: minX, y: maxY - ry),
                       control1: CGPoint(x: minX + rx - k*rx, y: maxY),
                       control2: CGPoint(x: minX, y: maxY - ry + k*ry))

            // Left edge
            p.addLine(to: CGPoint(x: minX, y: minY + ry))

            // Top-left quarter (to top edge)
            p.addCurve(to: CGPoint(x: minX + rx, y: minY),
                       control1: CGPoint(x: minX, y: minY + ry - k*ry),
                       control2: CGPoint(x: minX + rx - k*rx, y: minY))

            p.closeSubpath()

        case .concave:
            // For simplicity, reuse existing concave implementation for now
            return PanelBaseShape(cornerKind: cornerKind, cornerRadius: cornerRadius).path(in: rect)
        }
        return p
    }
}
