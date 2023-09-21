//
//  HealthKitManager.swift
//  Vessel
//
//  Created by v.martin.peshevski on 6.9.23.
//

import Foundation
import HealthKit

enum HKError: Error
{
    case notAvailable
}

class HealthKitManager: HKHealthStore
{
    static let shared = HealthKitManager()
    
    private let healthStore = HKHealthStore()
    
    var isAccessGranted: Bool
    {
        // TODO: check for Authorization Status for required types
        get
        {
            UserDefaults.standard.bool(forKey: Constants.KEY_HEALTH_KIT_AUTH)
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: Constants.KEY_HEALTH_KIT_AUTH)
        }
    }
    
    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> ())
    {
        guard HKHealthStore.isHealthDataAvailable() else
        {
            completion(false, HKError.notAvailable)
            return
        }
        let allTypes = Set([HKObjectType.workoutType(),
                            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                            HKObjectType.quantityType(forIdentifier: .heartRate)!,
                            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
                            HKObjectType.quantityType(forIdentifier: .stepCount)!])

        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            self.isAccessGranted = success
            completion(success, nil)
            UserDefaults.standard.setValue(success, forKey: Constants.KEY_HEALTH_KIT_AUTH)
        }
    }
}

extension HealthKitManager
{
    func getSteps(completion: @escaping (Double) -> Void)
    {
        let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        var interval = DateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: type,
                                                quantitySamplePredicate: nil,
                                                options: [.cumulativeSum],
                                                anchorDate: startOfDay,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = { _, result, error in
                var resultCount = 0.0
                result!.enumerateStatistics(from: startOfDay, to: now) { statistics, _ in
                if let sum = statistics.sumQuantity()
                {
                    resultCount = sum.doubleValue(for: HKUnit.count())
                }

                DispatchQueue.main.async
                {
                    completion(resultCount)
                }
            }
        }
        
        query.statisticsUpdateHandler =
        {
            query, statistics, statisticsCollection, error in

            if let sum = statistics?.sumQuantity()
            {
                let resultCount = sum.doubleValue(for: HKUnit.count())
                DispatchQueue.main.async
                {
                    completion(resultCount)
                }
            }
        }
        healthStore.execute(query)
    }
    
    func getBodyMass()
    {
        guard let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass) else
        {
            fatalError("*** Unable to get the body mass type ***")
        }
        
        // Create the query.
        let query = HKAnchoredObjectQuery(type: bodyMassType,
                                          predicate: nil,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit)
        { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
            guard let samples = samplesOrNil, let deletedObjects = deletedObjectsOrNil else
            {
                fatalError("*** An error occurred during the initial query: \(errorOrNil!.localizedDescription) ***")
            }
            
            for bodyMassSample in samples
            {
                print("Samples: \(bodyMassSample)")
            }
            
            for deletedBodyMassSample in deletedObjects
            {
                print("deleted: \(deletedBodyMassSample)")
            }
        }
        healthStore.execute(query)
    }
}

extension HealthKitManager
{
    func getStepCount(completion: @escaping (Double) -> Void)
    {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else
        {
            fatalError("*** Unable to get the body mass type ***")
        }
        
        var anchor = HKQueryAnchor.init(fromValue: 0)
        
        if UserDefaults.standard.object(forKey: "Anchor") != nil
        {
            let data = UserDefaults.standard.object(forKey: "Anchor") as! Data
            do
            {
                if let unarchived = try NSKeyedUnarchiver.unarchivedObject(ofClass: HKQueryAnchor.self, from: data)
                {
                    anchor = unarchived
                }
            }
            catch
            {
                print("*** error unarchiving anchor ***")
            }
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: HKQueryOptions.strictEndDate)
        
        let query = HKAnchoredObjectQuery(type: stepCountType,
                                          predicate: predicate,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit)
        { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
            guard let samples = samplesOrNil, let deletedObjects = deletedObjectsOrNil else
            {
                fatalError("*** An error occurred during the initial query: \(errorOrNil!.localizedDescription) ***")
            }
            
            anchor = newAnchor!
            do
            {
                let data = try NSKeyedArchiver.archivedData(withRootObject: newAnchor as Any, requiringSecureCoding: true)
                UserDefaults.standard.set(data, forKey: "Anchor")
            }
            catch
            {
            }
//            print("samples: \(samples)")

            var sum = 0.0
            for sample in samples
            {
                guard let quantitySample: HKQuantitySample = sample as? HKQuantitySample else { return }
//                stepsSample.quantity.doubleValue(for: <#T##HKUnit#>)
//
//                print("quantitySample: \(String(describing: quantitySample.quantity.doubleValue(for: HKUnit.count())))")
//                print("Samples: \(String(describing: sample))")
                sum += quantitySample.quantity.doubleValue(for: HKUnit.count())
            }
            print("sum: \(String(describing: sum))")

            for deletedBodyMassSample in deletedObjects
            {
                print("deleted: \(deletedBodyMassSample)")
            }
            print("Anchor: \(anchor)")
        }
        
        query.updateHandler = { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
            guard let samples = samplesOrNil, let deletedObjects = deletedObjectsOrNil else
            {
                // Handle the error here.
                fatalError("*** An error occurred during an update: \(errorOrNil!.localizedDescription) ***")
            }

            anchor = newAnchor!
            do
            {
                let data = try NSKeyedArchiver.archivedData(withRootObject: newAnchor as Any, requiringSecureCoding: true)
                UserDefaults.standard.set(data, forKey: "Anchor")
            }
            catch
            {
            }
            
            print("updateHandler samples: \(samples)")

            for stepsSample in samples
            {
                print("samples: \(stepsSample)")
            }

            for deletedBodyMassSample in deletedObjects
            {
                print("deleted: \(deletedBodyMassSample)")
            }
        }
        
        healthStore.execute(query)
    }
}
