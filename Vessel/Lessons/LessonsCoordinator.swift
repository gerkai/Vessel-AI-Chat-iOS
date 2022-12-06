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
        guard let stepId = lesson.stepIds[safe: currentStepIndex],
              let index = steps.firstIndex(where: { $0.id == stepId }) else { return nil }
        return steps[index]
    }
    
    @Resolved private var analytics: Analytics

    init(lesson: Lesson)
    {
        self.lesson = lesson
        analytics.log(event: .lessonStarted(lessonId: lesson.id, lessonName: lesson.title))
    }
    
    func back()
    {
        currentStepIndex -= 1
    }
    
    func shouldFadeBack() -> Bool
    {
        currentStepIndex >= 0
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
        default:
            return false
        }
    }
    
    func hasCompletedLesson() -> Bool
    {
        return steps.count == currentStepIndex
    }
    
    func answerStep(answer: String, answerId: Int)
    {
        guard let step = currentStep,
              let type = step.type else { return }
        
        switch type
        {
        case .input:
            step.answerText = answer
            step.questionRead = true
        case .quiz, .survey:
            step.answerId = answerId
            step.questionRead = true
        case .readonly:
            step.questionRead = true
        }
        
        step.lessonId = lesson.id
        ObjectStore.shared.ClientSave(step)
    }
    
    func getNextStepViewController(state: StepViewControllerState = .answering) -> UIViewController?
    {
        if shouldShowSuccessScreen() && state == .answering
        {
            let storyboard = UIStoryboard(name: "Lesson", bundle: nil)
            let resultsVC = storyboard.instantiateViewController(identifier: "LessonResultsViewController") as! LessonResultsViewController
            return resultsVC
        }
        else
        {
            currentStepIndex += 1
            if hasCompletedLesson()
            {
                return nil
            }
            else
            {
                let storyboard = UIStoryboard(name: "Lesson", bundle: nil)
                guard let step = currentStep,
                      let type = step.type else { return nil }

                switch type
                {
                case .quiz, .survey:
                    let quizVC = storyboard.instantiateViewController(identifier: "QuizSurveyLessonStepViewController") as! QuizSurveyLessonStepViewController
                    quizVC.coordinator = self
                    quizVC.viewModel = StepViewModel(step: step, lesson: lesson)
                    return quizVC
                case .readonly:
                    let readOnlyVC = storyboard.instantiateViewController(identifier: "ReadOnlyLessonStepViewController") as! ReadOnlyLessonStepViewController
                    readOnlyVC.coordinator = self
                    readOnlyVC.viewModel = StepViewModel(step: step, lesson: lesson)
                    return readOnlyVC
                case .input:
                    let inputVC = storyboard.instantiateViewController(identifier: "InputLessonStepViewController") as! InputLessonStepViewController
                    inputVC.coordinator = self
                    inputVC.viewModel = StepViewModel(step: step, lesson: lesson)
                    return inputVC
                }
            }
        }
    }
    
    func finishLesson(navigationController: UINavigationController)
    {
        analytics.log(event: .lessonCompleted(lessonId: lesson.id, lessonName: lesson.title))
        lesson.completedDate = Date.serverDateFormatter.string(from: Date())
        LessonsManager.shared.unlockMoreInsights = false
        navigationController.popToRootViewController(animated: true)
    }
}
