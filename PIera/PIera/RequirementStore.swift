import UIKit

class RequirementStore {
    var allRequirements = [String]()
    
    func createRequirement(_ input: String) -> String {
        let newRequirement = input
        
        allRequirements.append(newRequirement)
        
        return newRequirement
    }
    
    func removeItem(_ requirement: String){
        if let index = allRequirements.index(of: requirement){
            allRequirements.remove(at: index)
        }
    }
    
    func moveItemAtIndex(_ fromIndex: Int, toIndex: Int){
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = allRequirements[fromIndex]
        
        allRequirements.remove(at: fromIndex)
        
        allRequirements.insert(movedItem, at: toIndex)
    }
}
