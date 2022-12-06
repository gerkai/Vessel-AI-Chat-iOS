//
//  LessonsManager.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/17/22.
//

import Foundation

let MAX_LESSONS_PER_DAY = 4

class LessonsManager
{
    static let shared = LessonsManager()
    private var lessons = [Lesson]()
    var planBuilt = false
    var unlockMoreInsights = false
    var loadedLessonsCount = 0
    
    var todayLessons: [Lesson]
    {
        let firstUncompletedIndex = min(MAX_LESSONS_PER_DAY, lessons.firstIndex(where: { $0.completedDate == nil }) ?? MAX_LESSONS_PER_DAY)
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
    
    func buildLessonPlan(onDone done: @escaping () -> Void)
    {
        guard let contact = Contact.main() else { return }
        let allCurriculums = Storage.retrieve(as: Curriculum.self)
        let goalsCurriculums = allCurriculums.filter({ contact.goal_ids.contains($0.goalId) })
        if goalsCurriculums.count != 0
        {
            let lessons = Array<LessonRank>(goalsCurriculums.map({ $0.lessonRanks }).joined())
            let uniqueLessons = Array(Set(lessons))
            let sortedLessons = uniqueLessons.sorted(by: { $0.rank < $1.rank })
            
            if sortedLessons.count != 0
            {
                //get all the lessons indicated by ids[]
                ObjectStore.shared.get(type: Lesson.self, ids: sortedLessons.map({ $0.id }))
                { lessons in
                    self.lessons = lessons.sorted(by: { $0.rank == $1.rank ? $0.id < $1.id : $0.rank < $1.rank }).filter({ !$0.isComplete || $0.completedToday })
                    self.planBuilt = true
                    self.loadStepsForLessons(onDone:
                    {
                        self.loadActivitiesForLessons(onDone: {done()})
                    })
                }
                onFailure:
                {
                    done()
                }
            }
            else
            {
                done()
            }
        }
        else
        {
            done()
        }
    }
    
    func resetLessonProgress()
    {
        //resets your lesson progress back to the beginning. Used for QA testing
        var updatedSteps: [Step] = []
        //go through all lessons
        for lesson in lessons
        {
            //clear completion date
            lesson.completedDate = nil
            
            //go through each step in this lesson
            for step in lesson.steps
            {
                //if it was read by the user, mark it unread and clear its answers. Save to ObjectStore
                if step.questionRead == true
                {
                    step.questionRead = false
                    step.answers = []
                    updatedSteps.append(step)
                }
            }
        }
        //This saves all modified steps to both local storage and the back end
        ObjectStore.shared.ClientSave(updatedSteps)
    }
    
    func shiftLessonDaysBack()
    {
        //shifts lesson completed dates back one day so today becomes a new day and a new lesson will appear.
        //go through all lessons
        for lesson in lessons
        {
            if let completedDate = lesson.completedDate
            {
                let formatter = Date.serverDateFormatter
                if let date = formatter.date(from: completedDate)
                {
                    let dateBefore = Calendar.current.date(byAdding: .day, value: -1, to: date)!
                    lesson.completedDate = Date.serverDateFormatter.string(from: dateBefore)
                }
            }
        }
        NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Lesson.self)])
    }
    
    //called when logging out
    func clearLessons()
    {
        loadedLessonsCount = 0
        planBuilt = false
        unlockMoreInsights = false
        lessons = []
    }
    
    private func loadStepsForLessons(onDone done: @escaping () -> Void)
    {
        var stepIDs: [Int] = []
        for lesson in self.lessons
        {
            stepIDs.append(contentsOf: lesson.stepIds)
            lesson.steps = []
        }
        let uniqueStepIds = Array(Set(stepIDs))
        ObjectStore.shared.get(type: Step.self, ids: uniqueStepIds)
        { steps in
            for lesson in self.lessons
            {
                for stepID in lesson.stepIds
                {
                    if let step = steps.filter({$0.id == stepID}).first
                    {
                        lesson.steps.append(step)
                    }
                }
            }
            done()
        }
    onFailure:
        {
            done()
        }
    }
    
    private func loadActivitiesForLessons(onDone done: @escaping () -> Void)
    {
        var activityIDs: [Int] = []
        for lesson in self.lessons
        {
            let stepsActivityIds = lesson.steps.map({ $0.activityIds }).joined()
            activityIDs.append(contentsOf: stepsActivityIds)
        }
        let uniqueActivityIds = Array(Set(activityIDs))
        if uniqueActivityIds.count != 0
        {
            ObjectStore.shared.get(type: Tip.self, ids: uniqueActivityIds)
            { activities in
                done()
            }
            onFailure:
            {
                done()
            }
        }
    }
}
