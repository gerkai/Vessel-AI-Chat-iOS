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
    private var lessons = [Lesson]()
    var planBuilt = false
    var unlockMoreInsights = false
    var loadedLessonsCount = 0
    
    var todayLessons: [Lesson]
    {
        let firstUncompletedIndex = min(4, lessons.firstIndex(where: { $0.completedDate == nil }) ?? 4)
        let index = max(0, unlockMoreInsights ? firstUncompletedIndex : firstUncompletedIndex - 1)
        if lessons.count < index
        {
            return lessons
        }
        else
        {
            return Array<Lesson>(lessons[0...index])
        }
    }
    
    func getLessonSteps(lesson: Lesson, onSuccess success: @escaping (_ objects: [Step]) -> Void, onFailure failure: @escaping () -> Void)
    {
        ObjectStore.shared.get(type: Step.self, ids: lesson.stepIds) { objects in
           success(objects)
        } onFailure: {
            failure()
        }
    }
    
    func getLessonActivities(lesson: Lesson, onSuccess success: @escaping (_ objects: [Tip]) -> Void, onFailure failure: @escaping () -> Void)
    {
        let stepsActivityIds = lesson.steps.map({ $0.activityIds }).joined()
        var activityIds = lesson.activityIds
        activityIds.append(contentsOf: stepsActivityIds)
        let uniqueActivityIds = Array(Set(activityIds)).sorted(by: { $0 < $1 })

        ObjectStore.shared.get(type: Tip.self, ids: uniqueActivityIds) { objects in
            // TODO: Remove when backend sends ids for Tips
            let objectsWithIds = objects.map { tip in
                if let index = objects.firstIndex(where: { $0.title == tip.title })
                {
                    tip.id = uniqueActivityIds[index]
                }
                return tip
            }
            
            success(objectsWithIds)
        } onFailure: {
            failure()
        }
    }
    
    func buildLessonPlan()
    {
        guard let contact = Contact.main() else { return }
        let goalsCurriculums = Storage.retrieve(as: Curriculum.self).filter({ contact.goal_ids.contains($0.goalId) })
        let lessons = Array<LessonRank>(goalsCurriculums.map({ $0.lessonRanks }).joined())
        let uniqueLessons = Array(Set(lessons))
        let sortedLessons = uniqueLessons.sorted(by: { $0.rank < $1.rank })
        
        ObjectStore.shared.get(type: Lesson.self, ids: sortedLessons.map({ $0.id })) { lessons in
            self.lessons.append(contentsOf: lessons)
            self.lessons = self.lessons.sorted(by: { $0.rank == $1.rank ? $0.id < $1.id : $0.rank < $1.rank }).filter({ !$0.isComplete || $0.completedToday })
            self.planBuilt = true
            self.loadStepsForLessons()
        } onFailure: {
        }
    }
    
    private func loadStepsForLessons()
    {
        if loadedLessonsCount < 4 && loadedLessonsCount <= lessons.count
        {
            guard let lesson = lessons[safe: loadedLessonsCount] else { return }
            getLessonSteps(lesson: lesson) { [weak self] steps in
                guard let self = self else { return }
                self.lessons[self.loadedLessonsCount].steps = steps.filter({ $0.type != nil })
                // Remove lesson if doens't have any step and load the next one
                if self.lessons[self.loadedLessonsCount].steps.count == 0
                {
                    self.lessons.remove(at: self.loadedLessonsCount)
                }
                else
                {
                    self.loadedLessonsCount += 1
                    if lesson.completedDate == nil || self.loadedLessonsCount == 4 || self.loadedLessonsCount == self.lessons.count - 1
                    {
                        NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Lesson.self)])
                    }
                }
                self.loadStepsForLessons()
            } onFailure: {
            }
        }
    }
}
