//
//  ViewController.swift
//  recipePuppyAssessment
//
//  Created by Tyler Cockburn on 3/25/2019
//  Copyright © 2019 Harold. All rights reserved.
//

import UIKit


struct WebDescription: Decodable{
    let title:String
    let version:Double
    let href: String
    var results: [Recipe]
}

struct Recipe: Decodable{
    var title: String
    let href: String
    let ingredients: String
    let thumbnail: String
}

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonString = "http://www.recipepuppy.com/api/?i=bacon,onion&q=vegetable&p=1"
        guard let url = URL(string: jsonString) else{
            return
        }
        URLSession.shared.dataTask(with: url){(data, response, err) in
            guard let data = data else{
                return
            }
            do{
                //Decodes the JSON information, links to structs
                let webDesc = try
                    JSONDecoder().decode(WebDescription.self, from: data)
                print("Title: " + webDesc.title)
                print("Version: " + String(webDesc.version) + "\n")
                //**CHALLENGE 4: can be seen after unblocking the following lines of code and commenting out the equivalent lines below it
                /**
                var specificList = self.certainRecipes(recipes: webDesc.results)
                let sortedList = specificList.sorted(by: { (rec1, rec2) -> Bool in
                    let rec1Name = String(rec1.title.filter{!"\n\t\r".contains($0)}) ?? ""
                    let rec2Name = String(rec2.title.filter{!"\n\t\r".contains($0)}) ?? ""
                    return (rec1Name.localizedCaseInsensitiveCompare(rec2Name) == .orderedAscending)
                    
                })
                **/
                //Sorts the entire recipe list into alphabetical
                let sortedList = webDesc.results.sorted(by: { (rec1, rec2) -> Bool in
                    let rec1Name = String(rec1.title.filter{!"\n\t\r".contains($0)}) ?? ""
                    let rec2Name = String(rec2.title.filter{!"\n\t\r".contains($0)}) ?? ""
                    return (rec1Name.localizedCaseInsensitiveCompare(rec2Name) == .orderedAscending)
                })
                
                for result in sortedList{
                    //removes unnecessary characters and trims white spaces
                    let newTitle = String(result.title.filter{!"\n\t\r".contains($0)}.trimmingCharacters(in: .whitespacesAndNewlines))
                    print("Recipe: " + newTitle)
                    //calls a separate method to sort the ingredients into alphabetical
                    let sortedIngredients = self.orderIngredients(ingredients: result.ingredients)
                    print("Ingredients: " + sortedIngredients)
                    print("href: " + result.href + "\n")
                }
                
            }catch let jsonErr{
                print("Error serializing", jsonErr)
            }
            
        }.resume()
        
    }
    func certainRecipes(recipes:[Recipe]) -> [Recipe]{
        var newList = [Recipe]()
        //initializes the given list of ingredients to compare recipes with. a string is used so 2 split strings are compared rather than a regular array and split string array, which would throw an error
        var ingredients = "bacon, broccoli, cauliflower, eggs, lettuce, mayonnaise, peas, raisins, red onions, shallot, spinach, sugar"
        //each ingredient list with be compared with the given list, and if the recipe contains all of the ingredients needed, it will add the recipe to a new list, which is returned where Challenge 4 is commented out above
        for ing in recipes{
            var recipeIng = ing.ingredients.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",")
            var fullIng = ingredients.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",")
            //using sets to compare, boolean result
            let fullIngSet = Set(fullIng)
            let recipeSet = Set(recipeIng)
            let allContained = recipeSet.isSubset(of: fullIngSet)
            
            if allContained{
                newList.append(ing)
            }
        }
        return newList
        
    }
    
    func orderIngredients(ingredients:String) -> String{
        //orders ingredients by trimming white spaces and comparing elements in the array
        var list = ingredients.split(separator: ",")
        let sortedList = list.sorted (by: {(l1, l2) -> Bool in
            let l1Name = l1.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let l2Name = l2.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return (l1Name.localizedCaseInsensitiveCompare(l2Name) == .orderedAscending)
        })
        var sortedString = sortedList.joined(separator: ",")
        return sortedString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

