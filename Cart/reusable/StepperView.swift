//
//  StepperView.swift
//  Cart
//
//  Created by Victor Noel Barrera on 7/3/22.
//

import UIKit
import SnapKit

class StepperView: UIView {
    
    var didUpdateCount: ((Int) -> Void)?
    var count : Int {
        set {
            _count = min(Constant.countBounds.upper, max(Constant.countBounds.lower, newValue))
            counterLabel.text = "\(_count)"
            didUpdateCount?(_count)
        }
        get {
            return _count
        }
    }
    
    private var _count = 0
    
    private struct Constant {
        static let cornerRadius = CGFloat(4)
        static let countBounds = (lower: 0, upper: 100)
        static let counterLabelWidth = CGFloat(48)
        static let buttonWidth = CGFloat(32)
    }
    
    private let contentStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private (set) var subtractButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("-", for: .normal)
        button.titleLabel?.textColor = .black
        button.layer.cornerRadius = Constant.cornerRadius
        button.layer.masksToBounds = true
        return button
    }()
    
    private (set) var addButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("+", for: .normal)
        button.titleLabel?.textColor = .black
        button.layer.cornerRadius = Constant.cornerRadius
        button.layer.masksToBounds = true
        return button
    }()
    
    private let counterLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(contentStackView)
        
        [
            subtractButton,
            counterLabel,
            addButton
        ].forEach({ contentStackView.addArrangedSubview($0) })
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        counterLabel.snp.makeConstraints { make in
            make.width.equalTo(Constant.counterLabelWidth)
        }
        
        [
            subtractButton,
            addButton
        ].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(Constant.buttonWidth)
            }
        }
        
        subtractButton.addTarget(self, action: #selector(didTapSubtractButton(sender:)), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(didTapAddButton(sender:)), for: .touchUpInside)
        
        count = 0
    }
    
    //MARK: Callbacks
    @objc private func didTapSubtractButton(sender: UIButton) {
        count = count - 1
    }
    
    @objc private func didTapAddButton(sender: UIButton) {
        count = count + 1
    }
}
