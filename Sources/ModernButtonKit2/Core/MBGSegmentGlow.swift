//
//  MBGSegmentGlow.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/01/18.
//


public enum MBGSegmentGlow {
    public enum Strength { case subtle, normal, strong }
    public enum Spread   { case tight, medium, wide }

    public struct Halo {
        public var color: Color
        public var strength: Strength
        public var spread: Spread
        public var tuning: MBGGlowTuning

        public init(
            color: Color,
            strength: Strength,
            spread: Spread,
            tuning: MBGGlowTuning = .standard
        ) {
            self.color = color
            self.strength = strength
            self.spread = spread
            self.tuning = tuning
        }
    }
}