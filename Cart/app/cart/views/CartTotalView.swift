//
//  CartTotalView.swift
//  Cart
//
//  Created by Victor Noel Barrera on 7/4/22.
//

import UIKit

struct CartTotalViewModel {
    let amount: String
}

class CartTotalView: UIView {
    
    var viewModel: CartTotalViewModel! {
        didSet {
            amountLabel.text = viewModel.amount
        }
    }

    private struct Constant {
        static let spacing = CGFloat(8)
    }
    
    private let containerView = UIView()
    
    private let totalLabel : UILabel = {
        let label = UILabel()
        label.text = "Total"
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        return label
    }()
    
    private let amountLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(containerView)
        
        [
            totalLabel,
            amountLabel
        ].forEach({ containerView.addSubview($0) })
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constant.spacing)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(amountLabel.snp.left).offset(-Constant.spacing)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.greaterThanOrEqualTo(0)
        }
    }
}
