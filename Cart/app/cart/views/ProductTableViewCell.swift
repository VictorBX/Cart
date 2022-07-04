//
//  ProductTableViewCell.swift
//  Cart
//
//  Created by Victor Noel Barrera on 7/4/22.
//

import UIKit
import SnapKit

struct ProductTableViewCellModel {
    let name : String
    let count : Int
    let price: String
}

class ProductTableViewCell: UITableViewCell {
    var didUpdateCount: ((Int) -> Void)?
    
    var viewModel: ProductTableViewCellModel! {
        didSet {
            nameLabel.text = viewModel.name
            stepper.count = viewModel.count
            priceLabel.text = viewModel.price
        }
    }
    
    private struct Constant {
        static let spacing = CGFloat(8)
        static let priceWidth = CGFloat(70)
        static let stepperWidth = CGFloat(112)
    }
    
    private let containerView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constant.spacing
        stackView.distribution = .fill
        return stackView
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let stepper = StepperView()
    private let priceLabel : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        selectionStyle = .none
        contentView.addSubview(containerView)
        [
            nameLabel,
            stepper,
            priceLabel
        ].forEach({ containerView.addArrangedSubview($0) })
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constant.spacing)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.width.equalTo(Constant.priceWidth)
        }
        
        stepper.snp.makeConstraints { make in
            make.width.equalTo(Constant.stepperWidth)
        }
        
        stepper.didUpdateCount = { [weak self] count in
            guard let self = self else { return }
            self.didUpdateCount?(count)
        }
    }
}
