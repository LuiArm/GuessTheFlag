//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by luis armendariz on 3/28/23.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.bold))
            .foregroundColor(.white)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    @State private var showAlert = false
    @State private var isFinished = false
    @State private var numberOfRounds = 1
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnwer = Int.random(in: 0...2)
    @State private var score = 0
    
    struct FlagImage: View {
        var image: String
        
        var body: some View {
            Image(image)
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
    }
    
   
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Text("Guess the Flag")
                       .titleStyle()
                
                VStack(spacing: 15){
                    VStack {
                       Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnwer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){ number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(image: countries[number])
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Text("Round: \(numberOfRounds)")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showAlert){
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        
        .alert("Finished", isPresented: $isFinished) {
            Button("Restart", action: restart)
        } message: {
            Text("Your score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int){
        if numberOfRounds >= 8 {
           restart()
        }else {
            if number == correctAnwer {
                scoreTitle = "Correct"
                score += 1
            }else {
                scoreTitle = "Wrong"
            }
        }
        numberOfRounds += 1
        showAlert = true
       
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnwer = Int.random(in: 0...2)
    }
    
    func restart() {
        isFinished = true
        score = 0
        numberOfRounds = 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
