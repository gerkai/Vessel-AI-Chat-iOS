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
                            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!])

        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if !success
            {
                // Handle the error here.
                
            }
            else
            {
                completion(true, nil)
            }
        }
        
        let status = healthStore.authorizationStatus(for: HKObjectType.workoutType())
        switch status
        {
            case .notDetermined, .sharingDenied:
                healthStore.getRequestStatusForAuthorization(toShare: Set([HKObjectType.workoutType()]), read: Set([HKObjectType.workoutType()]), completion: { status, error in
                    print("getRequestStatusForAuthorization: \(status)")
                })
                healthStore.requestAuthorization(toShare: Set([HKObjectType.workoutType()]), read: Set([HKObjectType.workoutType()])) {(success, error) in
                }
            default:
            break
        }
    }
}
