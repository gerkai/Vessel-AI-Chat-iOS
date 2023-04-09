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
        
        //testLessons()
    }
    
    var nextLesson: Lesson?
    {
        guard let firstUncompletedIndex = lessons.firstIndex(where: { $0.completedDate == nil }) else { return nil }
        return lessons[safe: firstUncompletedIndex]
    }
    
    var todayLessons: [Lesson]
    {
        //get index of first incomplete lesson (or completed today). If none found, return empty array.
        let filteredLessons = lessons.filter({ $0.completedDate == nil || $0.completedToday })
        guard let todayIndex = filteredLessons.firstIndex(where: { $0.completedDate == nil || $0.completedToday }) else { return [] }
        let completedTodayCount = min(MAX_LESSONS_PER_DAY, filteredLessons.filter({ $0.completedToday }).count)
        let lastIndex = max(todayIndex, (todayIndex + completedTodayCount + (unlockMoreInsights ? 0 : -1 )))
        if filteredLessons.count <= todayIndex
        {
            return filteredLessons
        }
        else
        {
            return Array<Lesson>(filteredLessons[todayIndex...lastIndex])
        }
    }
    
    func refreshLessonPlan()
    {
        let lessons = Storage.retrieve(as: Lesson.self)
        self.lessons = lessons.sorted(by: { $0.rank == $1.rank ? $0.id < $1.id : $0.rank < $1.rank })
    }
    
    func buildLessonPlan(onDone done: @escaping () -> Void)
    {
        Log_Add("buildLessonPlan()")
        guard let contact = Contact.main() else
        {
            assertionFailure("LessonsManager-buildLessonPlan: mainContact not available")
            return
        }
        let allCurriculums = Storage.retrieve(as: Curriculum.self)
        let allLessons = Array<LessonRank>(allCurriculums.map({ $0.lessonRanks }).joined())
        let completedLessons = allLessons.filter({ $0.completed })
        let goalsCurriculums = allCurriculums.filter({ contact.goal_ids.contains($0.goalId) })
        if goalsCurriculums.count != 0
        {
            var lessonRanks = Array<LessonRank>(goalsCurriculums.map({ $0.lessonRanks }).joined())
            lessonRanks.append(contentsOf: completedLessons)
            let uniqueLessonRanks = Array(Set(lessonRanks))
            let sortedLessonRanks = uniqueLessonRanks.sorted(by: { $0.rank < $1.rank })
            
            if sortedLessonRanks.count != 0
            {
                //get all the lessons indicated by ids[]
                print("GET LESSONS") //will remove once login data loading is speedy
                ObjectStore.shared.get(type: Lesson.self, ids: sortedLessonRanks.map({ $0.id }))
                { lessons in
                    self.lessons = lessons.sorted(by: { $0.rank == $1.rank ? $0.id < $1.id : $0.rank < $1.rank })
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
        ObjectStore.shared.clientSave(updatedSteps)
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
    
    func getLessonsCompletedOn(dateString: String) -> [Lesson]
    {
        return lessons.filter({ $0.completedDate != nil }).filter { lesson in
            guard let completedDateString = lesson.completedDate,
                  let completedDate = Date.isoUTCDateFormatter.date(from: completedDateString),
                  let date = Date.serverDateFormatter.date(from: dateString) else { return false }
            
            return Date.isSameDay(date1: completedDate, date2: date)
        }
    }
    
    func lessonsAvailable(forDate date: String) -> Bool
    {
        if let firstLesssonCompletedDate = lessons.first?.completedDate
        {
            if let lastLessonCompletedDate = lessons.last?.completedDate
            {
                return date > firstLesssonCompletedDate && date < lastLessonCompletedDate
            }
            else
            {
                return date > firstLesssonCompletedDate
            }
        }
        
        return true
    }
    
    @objc
    func dayChanged(_ notification: Notification)
    {
        WaterManager.shared.resetDrinkedWaterGlassesIfNeeded()
        LessonsManager.shared.buildLessonPlanIfNeeded()
    }
    
    func completedLessonsDates() -> [String]
    {
        return lessons.compactMap
        {
            guard let completedDateString = $0.completedDate,
                  let completedDate = Date.isoUTCDateFormatter.date(from: completedDateString) else { return nil }
            return Date.serverDateFormatter.string(from: completedDate)
        }
    }
}
