//
//  LessonsManager.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/17/22.
//

import Foundation

class LessonsManager
{
    static let shared = LessonsManager()
    var lessons = [Lesson]()
    var planBuilt = false
    
    func getLessonSteps(lesson: Lesson, onSuccess success: @escaping (_ objects: [Step]) -> Void, onFailure failure: @escaping () -> Void)
    {
        ObjectStore.shared.get(type: Step.self, ids: lesson.stepIds) { objects in
           success(objects)
        } onFailure: {
            failure()
        }
    }
    
    func buildLessonPlan()
    {
        guard let contact = Contact.main() else { return }
        let goalsCurriculums = Storage.retrieve(as: Curriculum.self).filter({ contact.goal_ids.contains($0.goalId) })
        let lessons = Array<LessonRank>(goalsCurriculums.map({ $0.lessonRanks }).joined())
        let filteredLessons = lessons.filter({ !$0.completed })
        let sortedLessons = filteredLessons.sorted(by: { $0.rank < $1.rank })
        
        var count = 0
        for lessonRank in sortedLessons
        {
            /*guard let curriculumIndex = goalsCurriculums.firstIndex(where: { curriculum in
                curriculum.lessonRanks.contains(where: { $0.id == lessonRank.id }) }),
                  let lessonIndex = goalsCurriculums[curriculumIndex].lessonRanks.firstIndex(where: { $0.id == lessonRank.id }) else { return }
            let lessonId = goalsCurriculums[curriculumIndex].lessonIds[lessonIndex]*/
            
            ObjectStore.shared.get(type: Lesson.self, id: lessonRank.id) { [weak self] lesson in
                guard let self = self else { return }
                self.lessons.append(lesson)
                count += 1
                if count == sortedLessons.count
                {
                    self.onPlanBuiltComplete()
                }
            } onFailure: {
                count += 1
                if count == sortedLessons.count
                {
                    self.onPlanBuiltComplete()
                }
            }
        }
    }
    
    private func onPlanBuiltComplete()
    {
        self.lessons = self.lessons.sorted(by: { $0.rank < $1.rank })
        
        guard let firstLesson = lessons.first else { return }
        getLessonSteps(lesson: firstLesson) { [weak self] steps in
            guard let self = self else { return }
            self.lessons.first!.steps = steps
            // Remove lesson if doens't have any step and load the next one
            if self.lessons.first!.steps.count == 0
            {
                self.lessons.remove(at: 0)
                self.onPlanBuiltComplete()
            }
            else
            {
                for step in self.lessons.first!.steps
                {
                    print("Step: \(step.text!)")
                    print("Type: \(step.type)")
                    print("Ansers: \(step.answers.map({ $0.primaryText }).joined(separator: ", "))")
                    print("Correct answer: \(step.answers.filter({ $0.correct }).map({ $0.primaryText }).joined(separator: ", "))")
                    print("======================================================================================================")
                }
                NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Lesson.self)])
            }
        } onFailure: {
        }
        
        planBuilt = true
    }
}
