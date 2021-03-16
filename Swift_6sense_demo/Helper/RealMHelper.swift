//
//  RealMHelper.swift
//  Swift_6sense_demo
//
//  Created by Sam on 16/03/21.
//

import RealmSwift

class RealMHelper {
    
    private var database: Realm
    static let shared = RealMHelper()
    
    private init() {
        database = try! Realm()
        print("Path: \(database.configuration.fileURL!)")
    }
    
    func getDataFromDB() -> [DataModel] {
        
        let results = database.objects(DataModel.self)
        return Array(results)
    }
    
    func addData(object: DataModel)   {
        try! database.write {
            database.add(object)
            //print("New Object Added...")
        }
    }
    
    //MARK: Private Methods
    func addDataIntoDB(){
        
        let arr = readDataFromFile()
        
        for element in arr{
            
            let arrData = element.components(separatedBy: "|")
            let model = DataModel()
            model.surahNo = Int(arrData.first ?? "0") ?? 0
            model.ayahNo = Int(arrData[1]) ?? 0
            model.textStr = arrData[2]
            RealMHelper.shared.addData(object: model)
        }
    }
    
    private func readDataFromFile() -> [String]{
        
        guard let reader = StringReader(path: Bundle.main.path(forResource: "quran-simple", ofType: "txt") ?? "") else {
            return [] // cannot open file
        }
        
        var arr = [String]()
        
        reader.forEach { line in
            
            arr.append(line)
        }
        return arr
    }
}

public class StringReader {
    public let path: String
    
    fileprivate let file: UnsafeMutablePointer<FILE>!
    
    init?(path: String) {
        self.path = path
        file = fopen(path, "r")
        guard file != nil else { return nil }
    }
    
    public var nextLine: String? {
        var line:UnsafeMutablePointer<CChar>? = nil
        var linecap:Int = 0
        defer { free(line) }
        return getline(&line, &linecap, file) > 0 ? String(cString: line!) : nil
    }
    
    deinit {
        fclose(file)
    }
}

extension StringReader: Sequence {
    public func  makeIterator() -> AnyIterator<String> {
        return AnyIterator<String> {
            return self.nextLine
        }
    }
}
