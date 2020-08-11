//
//  PlayingCardView.swift
//  PlayingApp
//
//  Created by Maxim Potapov on 05.08.2020.
//  Copyright © 2020 Maxim Potapov. All rights reserved.
//  VIEW

import UIKit

class PlayingCardView: UIView {
    
    /// The cards rank
    @IBInspectable
    var rank: Int = 9 { didSet{ updateView() } }
    
    /// The cards suit
    @IBInspectable
    var suit: String = "♥️" { didSet{ updateView() } }
    
    /// Whether or not the card is facing up
    @IBInspectable
    var isFaceUp: Bool = true { didSet{ updateView() } }
    
    /// The scale of the face card
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize { didSet { updateView() } }
   
    private var cornerString: NSAttributedString {
        return centredAttributedString(rankString+"\n"+suit, fontSize:cornerFontSize)
    }
    
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var loweRightCornerLabel = createCornerLabel()
    
    @objc func adjustFaceCardScale(gestureRecognizer: UIPinchGestureRecognizer) {
        switch gestureRecognizer.state {
        case .changed, .ended:
            faceCardScale *= gestureRecognizer.scale
            gestureRecognizer.scale = 1.0 // reset it to get incremental changes only
        default:
            break
        }
    }
    
    
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
    
    private func drawPips()
    {
        let pipsPerRowForRank = [[0], [1], [1,1], [1,1,1], [2,2], [2,1,2], [2,2,2], [2,1,2,2], [2,2,2,2], [2,2,1,2,2], [2,2,2,2,2]]

        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0)})
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0)})
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centredAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centredAttributedString(suit, fontSize: probablyOkayPipStringFontSize /
                    (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }

        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
    
    private func updateView() {
        setNeedsDisplay()
        setNeedsLayout()
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
        
        if isFaceUp {
            if let faceCardImage = UIImage(named: rankString+suit) { // place pic suit on card view from Assets
                    faceCardImage.draw(in: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
                } else {
                   drawPips()
                }
        } else {
            if let cardBackImage = UIImage(named: "cardback") {
                cardBackImage.draw(in: bounds)
            }
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
