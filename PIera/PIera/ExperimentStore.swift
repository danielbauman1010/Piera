import UIKit

class ExperimentStore {
    var allExperiments = [Experiment]()
    
    func createExperiment() -> Experiment {
        let newExperiment = Experiment(random: false)
        
        allExperiments.append(newExperiment)
        
        return newExperiment
    }
    
    func removeItem(_ experiment: Experiment){
        if let index = allExperiments.index(of: experiment){
            allExperiments.remove(at: index)
        }
    }
    
    func moveItemAtIndex(_ fromIndex: Int, toIndex: Int){
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = allExperiments[fromIndex]
        
        allExperiments.remove(at: fromIndex)
        
        allExperiments.insert(movedItem, at: toIndex)
    }
}
