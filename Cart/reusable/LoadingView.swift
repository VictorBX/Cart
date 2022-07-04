//
//  LoadingView.swift
//  Cart
//
//  Created by Victor Noel Barrera on 7/4/22.
//

import UIKit
import SnapKit

class LoadingView: UIView {
    
    private let spinnerView = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(spinnerView)
        spinnerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        spinnerView.startAnimating()
    }
}
