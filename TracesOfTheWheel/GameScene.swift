//
//  GameScene.swift
//  GenerativeArt00
//
//  Created by Aleksandr Amirkhanov on 09.06.2024.
//

import SpriteKit
import GameplayKit

protocol RandomHypotrochoidGenerator {
    func generate() -> Hypotrochoid
}

class GameScene: SKScene {
    
    fileprivate func randomHypotrochoid(r_fixed: Int) -> Hypotrochoid {
        let divisor = Int.random(in: 8...32)
        let r_rolling = r_fixed * Int.random(in: 1..<divisor) / divisor
        let d = r_rolling * Int.random(in: 4..<16) / 8
        
        return Hypotrochoid(r_fixed: r_fixed, r_rolling: r_rolling, d: d)
    }
    
    fileprivate func backgroundColor() -> NSColor {
        let intensity = CGFloat(0)
        return NSColor(red: intensity, green: intensity, blue: intensity, alpha: CGFloat(1))
    }
    
    fileprivate func randomColor() -> NSColor {
        let predefined_colors = [
            NSColor(red: CGFloat(112/255), green: CGFloat(100/255), blue: CGFloat(1), alpha: CGFloat(1)),
            NSColor(red: CGFloat(255/255), green: CGFloat(112/255), blue: CGFloat(166/255), alpha: CGFloat(1)),
            NSColor(red: CGFloat(255/255), green: CGFloat(151/255), blue: CGFloat(112/255), alpha: CGFloat(1)),
            NSColor(red: CGFloat(255/255), green: CGFloat(214/255), blue: CGFloat(112/255), alpha: CGFloat(1)),
            NSColor(red: CGFloat(233/255), green: CGFloat(255/255), blue: CGFloat(112/255), alpha: CGFloat(1))
        ]
        
        return predefined_colors.randomElement()!
    }
    
    fileprivate func createShapeNode(from: Hypotrochoid, color1: NSColor, color2: NSColor) -> SKShapeNode {
        let delta = Float(0.01)
        var theta = from.theta_max
        var points: [CGPoint] = []
        
        while theta > -delta {
            let (x, y) = from.point(theta: max(theta, 0))
            points.append(CGPoint(x: CGFloat(x), y: CGFloat(y)))
            theta -= delta
        }
        
        let path = CGMutablePath()
        path.addLines(between: points)
        
        let node = SKShapeNode(path: path)
        let gradientShader = SKShader(source: """
            void main() {
                float normalizedPosition = v_path_distance / u_path_length;
                gl_FragColor = mix(color1, color2, normalizedPosition);
            }
""")
        gradientShader.uniforms = [
            SKUniform(name: "color1",
                      vectorFloat4: vector_float4(Float(color1.redComponent), Float(color1.greenComponent), Float(color1.blueComponent), Float(color1.alphaComponent))),
            SKUniform(name: "color2",
                      vectorFloat4: vector_float4(Float(color2.redComponent), Float(color2.greenComponent), Float(color2.blueComponent), Float(color2.alphaComponent)))
        ]
        node.strokeShader = gradientShader
        node.lineWidth = 3
        
        return node
    }
    
    fileprivate func newShape() {
        self.removeAllChildren()
        
        let background_color = backgroundColor()
        self.backgroundColor = background_color
        
        let columns = Int.random(in: 1...6)
        let rows = columns > 1 ? Int.random(in: 1..<columns) : 1
        
        let r_fixed = 200 / max(columns, rows)
        
        for column in 0..<columns {
            for row in 0..<rows {
                let hypotrochoid = randomHypotrochoid(r_fixed: r_fixed)
                let color = randomColor()
                let node = createShapeNode(from: hypotrochoid, color1: color, color2: background_color)
                
                let h_spacing = self.size.width / CGFloat(columns)
                let w_spacing = self.size.height / CGFloat(rows)
                
                let x = (CGFloat(column) + 0.5) * h_spacing - self.size.width / 2
                let y = (CGFloat(row) + 0.5) * w_spacing - self.size.height / 2
                node.position = CGPoint(x: x, y: y)
                
                self.addChild(node)
            }
        }
    }
    
    override func didMove(to view: SKView) {
        newShape()
    }
    
    override func mouseDown(with event: NSEvent) {
        newShape()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
