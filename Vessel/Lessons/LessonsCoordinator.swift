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
    var steps: [Step]
    {
        lesson.steps
    }
    var currentStepIndex = -1
    
    var currentStep: Step?
    {
        return steps[safe: currentStepIndex]
    }

    init(lesson: Lesson)
    {
        self.lesson = lesson
    }
    
    func back()
    {
        currentStepIndex -= 1
    }
    
    func shouldShowSuccessScreen() -> Bool
    {
        guard let step = currentStep else { return false }

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
        return steps.count == currentStepIndex
    }
    
    func answerStep(answer: String, answerId: Int)
    {
        guard let step = currentStep else { return }
        
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
        currentStepIndex += 1
        if hasCompletedLesson()
        {
            return nil
        }
        else
        {
            let storyboard = UIStoryboard(name: "Lesson", bundle: nil)
            guard let step = currentStep else { return nil }
            
            switch step.type
            {
            case .quiz:
                let quizVC = storyboard.instantiateViewController(identifier: "QuizLessonStepViewController") as! QuizLessonStepViewController
                quizVC.coordinator = self
                quizVC.viewModel = StepViewModel(step: step, lesson: lesson)
                return quizVC
            default:
                return nil
            }
        }
    }
}
