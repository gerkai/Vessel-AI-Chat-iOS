//
//  StepViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/22/22.
//

import Foundation

enum StepViewControllerState
{
    case answering
    case result
}

enum StepViewResult
{
    case correct
    case wrong
}

class StepViewModel
{
    let step: Step
    let lesson: Lesson
    var state: StepViewControllerState = .answering
    
    var selectedAnswerId: Int?
    var answer: String?
    
    var result: StepViewResult?
    {
        return selectedAnswerId == step.correctAnswerId ? .correct : .wrong
    }
    
    init(step: Step, lesson: Lesson)
    {
        self.step = step
        self.lesson = lesson
    }
}
