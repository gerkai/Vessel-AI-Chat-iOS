import Foundation

class StaffSelectViewModel
{
    var staff = [Staff]()
    var selectedStaff: Int?
    
    func setSelectedStaff(onCompletion: @escaping () -> ())
    {
        guard let staff = staff[safe: selectedStaff ?? -1] else { return }
        Server.shared.setExpertAttribution(expertId: staff.expert_id ?? staff.staff_id ?? staff.id, onSuccess: onCompletion) { message in
            onCompletion()
        }
    }
}
