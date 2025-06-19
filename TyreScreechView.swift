import SwiftUI
import UIKit

struct TyreScreechView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)

        let tyreImage = UIImageView(image: UIImage(systemName: "car.fill"))
        tyreImage.tintColor = .red
        tyreImage.contentMode = .scaleAspectFit
        tyreImage.frame = CGRect(x: 0, y: 0, width: 40, height: 40)

        view.addSubview(tyreImage)


        let bounce = CABasicAnimation(keyPath: "position.y")
        bounce.fromValue = tyreImage.center.y
        bounce.toValue = tyreImage.center.y - 10
        bounce.duration = 0.1
        bounce.autoreverses = true
        bounce.repeatCount = 3

        let rotate = CAKeyframeAnimation(keyPath: "transform.rotation")
        rotate.values = [0, -0.2, 0.2, -0.2, 0.2, 0]
        rotate.duration = 0.4
        rotate.repeatCount = 1

        let group = CAAnimationGroup()
        group.animations = [bounce, rotate]
        group.duration = 0.5

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            tyreImage.layer.add(group, forKey: "tyreScreech")
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
