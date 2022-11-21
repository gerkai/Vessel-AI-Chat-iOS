//
//  LessonsCoordinator.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/19/22.
//

import UIKit

class LessonsCoordinator
{
    let lesson: Lesson
    let steps: [Step]
    var currentStepIndex = 0
    
    /*var currentStep: Step
    {
        return steps[currentStep]
    }*/

    init(lesson: Lesson, steps: [Step])
    {
        self.lesson = lesson
        self.steps = steps
    }
    
    func shouldShowSuccessScreen() -> Bool
    {
        guard let step = steps[safe: currentStepIndex] else { return false }

        switch step.type
        {
        case .quiz:
            return true
        case .survey, .readonly, .input:
            return false
        }
    }
    
    func hasCompletedLesson() -> Bool
    {
        return steps.count == currentStepIndex - 1
    }
    
    func answerStep(answer: String, answerId: Int)
    {
        guard let step = steps[safe: currentStepIndex] else { return }
        
        switch step.type
        {
        case .input:
            // TODO: Add answer to step
            break
        case .quiz, .survey:
            step.answerId = answerId
        case .readonly:
            break
        }
    }
    
    func getNextStepViewController() -> UIViewController?
    {
        if hasCompletedLesson()
        {
            return nil
        }
        else
        {
            // TODO: Implement StepsViewControllers
            currentStepIndex += 1
            return nil
        }
    }
}
