import Foundation

protocol FiltersTime{
    func filterTime(_ experiments: [Experiment], comparisonType: ComparisonResult)->[Experiment]{
    //orderedAscending - Past, orderedSame - Present, orderedDescending - Future
    return experiments.filter{($0.time?.compare(Date())) == comparisonType}
    }
}
