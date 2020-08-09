//
//  PlayingCardView.swift
//  PlayingApp
//
//  Created by Maxim Potapov on 05.08.2020.
//  Copyright © 2020 Maxim Potapov. All rights reserved.
//  VIEW

import UIKit

class PlayingCardView: UIView {
    
    var rank: Int = 11 { didSet { setNeedsDisplay(); setNeedsLayout() } } // update rank
    var suit: String = "♥️" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var isFaceUp: Bool = true { didSet { setNeedsDisplay(); setNeedsLayout() } }
   
    private var cornerString: NSAttributedString {
        return centredAttributedString(rankString+"\n"+suit, fontSize:cornerFontSize)
    }
    
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var loweRightCornerLabel = createCornerLabel()
    
    
    private func centredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString { // custom string to display rank and suit of a card
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize) // set body font style
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font) // make it able to resize( scale from another font(basic))!
        let paragraphStyle = NSMutableParagraphStyle() // set mutble paragraph style
        paragraphStyle.alignment = .center // align items: center
           
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle,.font:font])
           
       }
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp // hide face down card view
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { // checks if font size changes -> change rank & suit sizes as well
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() { // positioning responsible(setNeedsLayout calls -> layoutSubviews())
        super.layoutSubviews()
        
        configureCornerLabel(upperLeftCornerLabel) // positioning upper left corner rank & suit view
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configureCornerLabel(loweRightCornerLabel) // positioning lower right corner rank & siut view
        loweRightCornerLabel.transform = CGAffineTransform.identity.translatedBy(x: loweRightCornerLabel.frame.size.width, y: loweRightCornerLabel.frame.size.height).rotated(by: CGFloat.pi) //
        loweRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
        .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -loweRightCornerLabel.frame.size.width, dy: -loweRightCornerLabel.frame.size.height)

    }

    override func draw(_ rect: CGRect) { // setNeedsDisplay() calls -> draw()
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius) // draw ROUNDED rect
        roundedRect.addClip() // func to draw only inside our rect
        UIColor.white.setFill() // fill rect wth clr
        roundedRect.fill()
        
        if let faceCardImage = UIImage(named: rankString+suit) { // place pic suit on card view from Assets
            faceCardImage.draw(in: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
        }
    }
    

}

// some idk wtf is this extensions

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
// jk i know
