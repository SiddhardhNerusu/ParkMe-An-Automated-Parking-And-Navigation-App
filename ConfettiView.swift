import SwiftUI
import UIKit

struct ConfettiView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)

        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: -10)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: UIScreen.main.bounds.width, height: 1)

        emitter.emitterCells = generateConfettiCells()

        view.layer.addSublayer(emitter)


        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            emitter.birthRate = 0
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    private func generateConfettiCells() -> [CAEmitterCell] {
        let colours: [UIColor] = [
            .systemRed, .systemYellow, .systemGreen,
            .systemBlue, .systemOrange, .white
        ]

        return colours.map { color in
            let cell = CAEmitterCell()
            cell.contents = makeConfettiImage(color: color).cgImage
            cell.birthRate = 6
            cell.lifetime = 5.0
            cell.velocity = 200
            cell.velocityRange = 100
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            cell.spin = 3.5
            cell.spinRange = 1.5
            cell.scale = 0.6
            cell.scaleRange = 0.3
            return cell
        }
    }

    private func makeConfettiImage(color: UIColor) -> UIImage {
        let size = CGSize(width: 10, height: 10)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
