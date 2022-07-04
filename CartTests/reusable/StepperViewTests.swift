//
//  StepperViewTests.swift
//  CartTests
//
//  Created by Victor Noel Barrera on 7/4/22.
//

import XCTest
import SnapshotTesting
@testable import Cart

class StepperViewTests: XCTestCase {

    func testStepper_default() {
        // given
        let stepperView = StepperView(frame: CGRect(origin: .zero, size: CGSize(width: 112, height: 32)))
        
        // then
        assertSnapshot(matching: stepperView, as: .image)
    }

    func testStepper_countChanged() {
        // given
        let stepperView = StepperView(frame: CGRect(origin: .zero, size: CGSize(width: 112, height: 32)))
        
        // when
        stepperView.count = 10
        
        // then
        assertSnapshot(matching: stepperView, as: .image)
    }
    
    func testStepper_increased() {
        // given
        let stepperView = StepperView(frame: CGRect(origin: .zero, size: CGSize(width: 112, height: 32)))
        
        // when
        stepperView.count = 10
        stepperView.addButton.sendActions(for: .touchUpInside)
        
        // then
        assertSnapshot(matching: stepperView, as: .image)
    }
    
    func testStepper_decreased() {
        // given
        let stepperView = StepperView(frame: CGRect(origin: .zero, size: CGSize(width: 112, height: 32)))
        
        // when
        stepperView.count = 10
        stepperView.subtractButton.sendActions(for: .touchUpInside)
        
        // then
        assertSnapshot(matching: stepperView, as: .image)
    }
    
    func testStepper_minimum() {
        // given
        let stepperView = StepperView(frame: CGRect(origin: .zero, size: CGSize(width: 112, height: 32)))
        
        // when
        stepperView.count = 0
        stepperView.subtractButton.sendActions(for: .touchUpInside)
        
        // then
        assertSnapshot(matching: stepperView, as: .image)
    }
    
    func testStepper_maximum() {
        // given
        let stepperView = StepperView(frame: CGRect(origin: .zero, size: CGSize(width: 112, height: 32)))
        
        // when
        stepperView.count = 100
        stepperView.addButton.sendActions(for: .touchUpInside)
        
        // then
        assertSnapshot(matching: stepperView, as: .image)
    }
}
