//
//  PlayingCardView.swift
//  PlayingApp
//
//  Created by Maxim Potapov on 05.08.2020.
//  Copyright © 2020 Maxim Potapov. All rights reserved.
//  VIEW

import UIKit

class PlayingCardView: UIView {
    
    var rank: Int = 5 { didSet { setNeedsDisplay(); setNeedsLayout() } } // update rank
    var suit: String = "♥️" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var isFaceUp: Bool = true { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    private func centredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString { // custom string to display rank and suit of a card
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize) // set body font style
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font) // make it able to resize( scale from another font(basic))!
        let paragraphStyle = NSMutableParagraphStyle() // set mutble paragraph style
        paragraphStyle.alignment = .center // align items: center
        
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle,.font:font])
        
    }
    
    private var centeredString: NSAttributedString {
        return centredAttributedString(rankString+"\n"+suit, fontSize:cornerFontSize)
    }
    
    private lazy var upperLeftCorner = createCornerLabel()
    private lazy var loweRightCornerLabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        
        return label
    }

    override func draw(_ rect: CGRect) {
// **************************************************************************************//
        
        // Drawing code(Cirlce)
//        if let context = UIGraphicsGetCurrentContext() {
//            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true) // draw a crcl
//
//            context.setLineWidth(10.0) // crcl border width
//            UIColor.green.setFill() // idk ?
//            UIColor.black.setStroke() // crlc border clr
//            context.strokePath() // paints the line along
//            context.fillPath()  // fill the line wth clr
//        }
        
//        let path = UIBezierPath() // USE Redraw in Storyboard Content mode to get a circle when device is turned
//        path.addArc(withCenter: CGPoint(x:  bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true) // draw a crcl
//        path.lineWidth = 5.0
//        UIColor.green.setFill() // fill crcl wth clr
//        UIColor.black.setStroke() // crlc border clr
//        path.stroke()
//        path.fill()
        
// **************************************************************************************//
        
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius) // draw ROUNDED rect
        roundedRect.addClip() // func to draw only inside our rect
        UIColor.white.setFill() // fill rect wth clr
        roundedRect.fill()
    }
    

}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}


extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

extension PlayingCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    public var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    public var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    public var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    public var rankString: String {
        switch rank {
        case 1:
            return "A"
        case 2...10:
            return String(rank)
        case 11:
            return "J"
        case 12:
            return "Q"
        case 13:
            return "K"
        default:
            return "?"
        }
    }
}
