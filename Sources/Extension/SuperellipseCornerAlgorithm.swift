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
            // Start at top edge, left of gap or near top-left arc start
            let startX = minX + r
            p.move(to: CGPoint(x: startX, y: minY))
            if let g = gap {
                // top edge to gap left
                let gapLeft = rect.midX - g/2
                let gapRight = rect.midX + g/2
                p.addLine(to: CGPoint(x: gapLeft, y: minY))
                // move to gap right
                p.move(to: CGPoint(x: gapRight, y: minY))
                // continue to top-right arc start
                p.addLine(to: CGPoint(x: maxX - r, y: minY))
            } else {
                // straight to top-right arc start
                p.addLine(to: CGPoint(x: maxX - r, y: minY))
            }
            // top-right quarter
            let tr = quarterPoints(rx: r, ry: r, start: CGPoint(x: maxX - r, y: minY), to: CGPoint(x: maxX, y: minY + r), orientation: "topRight")
            tr.forEach { p.addLine(to: $0) }
            // right edge to bottom-right start
            p.addLine(to: CGPoint(x: maxX, y: maxY - r))
            // bottom-right quarter
            let br = quarterPoints(rx: r, ry: r, start: CGPoint(x: maxX, y: maxY - r), to: CGPoint(x: maxX - r, y: maxY), orientation: "bottomRight")
            br.forEach { p.addLine(to: $0) }
            // bottom edge to bottom-left start
            p.addLine(to: CGPoint(x: minX + r, y: maxY))
            // bottom-left quarter
            let bl = quarterPoints(rx: r, ry: r, start: CGPoint(x: minX + r, y: maxY), to: CGPoint(x: minX, y: maxY - r), orientation: "bottomLeft")
            bl.forEach { p.addLine(to: $0) }
            // left edge to top-left start
            p.addLine(to: CGPoint(x: minX, y: minY + r))
            // top-left quarter
            let tl = quarterPoints(rx: r, ry: r, start: CGPoint(x: minX, y: minY + r), to: CGPoint(x: minX + r, y: minY), orientation: "topLeft")
            tl.forEach { p.addLine(to: $0) }
            p.closeSubpath()
        case .concave:
            // For simplicity, reuse existing concave implementation for now
            return PanelBaseShape(cornerKind: cornerKind, cornerRadius: cornerRadius).path(in: rect)
        }
        return p
    }
}

