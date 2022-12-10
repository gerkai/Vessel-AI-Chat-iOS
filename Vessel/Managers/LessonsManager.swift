//
//  LessonsManager.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/17/22.
//

import UIKit

let MAX_LESSONS_PER_DAY = 4

class LessonsManager
{
    static let shared = LessonsManager()
    private var lessons = [Lesson]()
    var planBuilt = false
    var unlockMoreInsights = false
    var loadedLessonsCount = 0
    
    init()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(dayChanged), name: UIApplication.significantTimeChangeNotification, object: nil)
    }
    
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
    
    var nextLesson: Lesson?
    {
        guard let firstUncompletedIndex = lessons.firstIndex(where: { $0.completedDate == nil }) else { return nil }
        return lessons[safe: firstUncompletedIndex]
    }
    
    func refreshLessonPlan()
    {
        let lessons = Storage.retrieve(as: Lesson.self)
        self.lessons = lessons.sorted(by: { $0.rank == $1.rank ? $0.id < $1.id : $0.rank < $1.rank }).filter({ !$0.isComplete || $0.completedToday })
    }
    
    func buildLessonPlan(onDone done: @escaping () -> Void)
    {
        Log_Add("buildLessonPlan()")
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
                print("GET LESSONS") //will remove once login data loading is speedy
                ObjectStore.shared.get(type: Lesson.self, ids: sortedLessons.map({ $0.id }))
                { lessons in
                    self.lessons = lessons.sorted(by: { $0.rank == $1.rank ? $0.id < $1.id : $0.rank < $1.rank }).filter({ !$0.isComplete || $0.completedToday })
                    self.planBuilt = true
                    self.loadStepsForLessons(onDone:
                    {
                        self.loadActivitiesForLessons(onDone:
                        {
                            done()
                        })
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
            for stepID in lesson.stepIds
            {
                ObjectStore.shared.get(type: Step.self, id: stepID)
                { step in
                    //if it was read by the user, mark it unread and clear its answers. Save to ObjectStore
                    if step.questionRead == true
                    {
                        step.questionRead = false
                        step.answers = []
                        updatedSteps.append(step)
                    }
                }
                onFailure:
                {
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
            if let completedDate = lesson.completedDate,
               let completedLocalDateString = Date.utcToLocal(dateStr: completedDate),
               let completedDate = Date.isoUTCDateFormatter.date(from: completedLocalDateString)
            {
                let dateBefore = Calendar.current.date(byAdding: .day, value: -1, to: completedDate)!
                lesson.completedDate = Date.localToUTC(dateStr: Date.isoLocalDateFormatter.string(from: dateBefore))
                Storage.store(lesson)
            }
        }
        Log_Add("LessonsManager: shiftLessonDaysBack() - post .newDataArrived: Lesson")
        refreshLessonPlan()
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
        }
        let uniqueStepIds = Array(Set(stepIDs))
        ObjectStore.shared.get(type: Step.self, ids: uniqueStepIds)
        { steps in
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
        var stepIDs: [Int] = []
        for lesson in self.lessons
        {
            stepIDs.append(contentsOf: lesson.stepIds)
        }
        let uniqueStepIds = Array(Set(stepIDs))
        for stepID in uniqueStepIds
        {
            ObjectStore.shared.get(type: Step.self, id: stepID)
            { step in
                activityIDs.append(contentsOf: step.activityIds)
            }
            onFailure:
            {
            }
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
        else
        {
            done()
        }
    }
    
    func buildLessonPlanIfNeeded()
    {
        let lastOpenedDay = UserDefaults.standard.string(forKey: Constants.KEY_LAST_OPENED_DAY)
        let todayString: String = Date.serverDateFormatter.string(from: Date())
        
        if todayString != lastOpenedDay
        {
            refreshLessonPlan()
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: Lesson.self)])
        }
    }
    
    @objc
    func dayChanged(_ notification: Notification)
    {
        WaterManager.shared.resetDrinkedWaterGlassesIfNeeded()
        LessonsManager.shared.buildLessonPlanIfNeeded()
    }
}
