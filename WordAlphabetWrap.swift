// WordAlphabetWrap.swift
//
// Created by Remy Skelton
// Created on 2025-May-2
// Version 1.0
// Copyright (c) Remy Skelton. All rights reserved.
//
// This file contains 2 different programs.
// The first program will display a sentence on
// one line with certain amounts of characters
// and the second program will display
// a certain amount of letters in the alphabet.
// Both programs read from and write to a file.

// Import Foundation to use File handling and error handling
import Foundation

// Define the InputError enum to handle errors
enum InputError: Error {
    case invalidInput // This will be thrown when input is invalid
}

// Main function
func main() {
    // Welcome message introducing the program
    print("This file contains 2 different programs.")
    print("The first program will display a sentence on ", terminator: "")
    print("one line with a certain number of characters.")
    print("The second program will display ", terminator: "")
    print("a certain amount of letters in the alphabet. ", terminator: "")
    print("Both programs read from and write to a file.")

    // Prompt the user to choose between two programs
    print("Please enter 1 for the first program "
                   + "or 2 for the second program: ")

    // Read the user's input from the console
    guard let userInput = readLine() else {
        // If input is empty, print an error message and return
        print("Invalid input. Please enter 1 or 2.")
        return
    }

    // Check if the user input is 1 or 2
    if userInput == "1" {
        // Call the wordWrap function if the user chooses the first program
        wordWrap()
    } else if userInput == "2" {
        // Call the alphabetWrap function if the user chooses the second program
        alphabetWrap()
    } else {
        // Error message for invalid input
        print("Invalid input: \(userInput). Please enter 1 or 2.")
    }
}

// Function to wrap a sentence to a specified width
func wordWrap() {
    // Initialize the output string which will contain the final result
    var outputStr = ""

    // Define the file paths for input and output files
    let inputFile = "inputWord.txt"
    let outputFile = "outputWord.txt"

    // Open the input file for reading
    guard let input = FileHandle(forReadingAtPath: inputFile) else {
        // If file cannot be opened, print an error and return
        print("Unable to open input file.")
        return
    }

    // Read all data from the input file
    let inputData = input.readDataToEndOfFile()

    // Convert the raw data to a string
    guard let inputStr = String(data: inputData, encoding: .utf8) else {
        // If conversion fails, print an error and return
        print("Unable to read the data from the input file.")
        return
    }

    // Split the input string into lines
    let inputLines = inputStr.components(separatedBy: "\n")

    // Create position variable to keep track of the current line
    var position = 0

    // While loop to read each line in the input
    while position < inputLines.count {
        // Get the current line, trimming leading and trailing whitespaces
        let sentence = inputLines[position].trimmingCharacters(in: .whitespaces)
        // Increment the position to move to the next line
        position += 1

        // Check if the sentence is empty
        if sentence.isEmpty {
            // Add an error message to the output string if the sentence is empty
            outputStr += "Invalid: \(sentence) is not a valid sentence.\n"
            // Continue to the next iteration
            continue
        } else {
            // Check if position is less than the number of lines
            if position < inputLines.count {
                // Get the next line, which should be the maximum number of characters
                let maxChars = inputLines[position].trimmingCharacters(in: .whitespaces)

                // Increment the position
                position += 1

                // Convert the maxChars to an integer
                guard let maxCharsInt = Int(maxChars) else {
                    // If conversion fails, add an error message to the output
                    outputStr += "\(sentence) \n"
                        + "Invalid: \(maxChars) is not a valid number.\n"
                    // Continue to the next iteration
                    continue
                }

                // Check if maxChars is less than 1
                if maxCharsInt < 1 {
                    // If invalid, add an error message to the output
                    outputStr += "\(sentence) \n"
                        + "Invalid: \(maxChars) is not a valid number.\n"
                    continue
                } else {
                    // If valid, call the recursive wordWrap function and append the result
                    outputStr += "Valid: \n"
                    outputStr += recWordWrap(sentence: sentence, maxChars: maxCharsInt) + "\n"
                }
            }
        }
    }

    // Write the output string to the output file
    do {
        try outputStr.write(toFile: outputFile, atomically: true, encoding: .utf8)
        print("Output written to \(outputFile).")
    } catch {
        print("Failed to write output to file: \(error)")
    }
}

// Function to recursively wrap a sentence to a specified width
func recWordWrap(sentence: String, maxChars: Int) -> String {
    // Trim leading and trailing whitespaces from the sentence
    let trimmed = sentence.trimmingCharacters(in: .whitespaces)

    // Base case: if the sentence is empty, return an empty string
    if trimmed.isEmpty {
        return ""
    }

    // If the sentence length is less than or equal to maxChars, return the sentence
    if trimmed.count <= maxChars {
        return trimmed + "\n"
    }

    // Find the last space before maxChars to break the sentence
    let endIndex =
    trimmed.index(trimmed.startIndex, offsetBy: maxChars, limitedBy: trimmed.endIndex) ?? trimmed.endIndex
    let beforeMax = String(trimmed[..<endIndex])

    // Check if there is a space to break the sentence
    // Used https://www.avanderlee.com/swift/ranges-explained/
    if let breakRange = beforeMax.range(of: " ", options: .backwards) {
        // Break at the last space
        // Used https://how.dev/answers/what-is-the-lowerbound-property-of-a-range-in-swift
        let line = String(trimmed[..<breakRange.lowerBound])
        let rest = String(trimmed[trimmed.index(after: breakRange.lowerBound)...])
        return line + "\n" + recWordWrap(sentence: rest, maxChars: maxChars)
    } else {
        // If no space is found, break at maxChars
        let line = String(trimmed[..<endIndex])
        let rest = String(trimmed[endIndex...])
        return line + "\n" + recWordWrap(sentence: rest, maxChars: maxChars)
    }
}

// Function to wrap the alphabet to a specified number of lines
func alphabetWrap() {
    // Initialize the output string for the alphabet wrapping result
    var outputStr = ""

    // Define file paths for input and output files
    let inputFile = "inputAlphabet.txt"
    let outputFile = "outputAlphabet.txt"

    // Open the input file for reading
    guard let input = FileHandle(forReadingAtPath: inputFile) else {
        // If file cannot be opened, print an error and return
        print("Unable to open input file.")
        return
    }

    // Read all data from the input file
    let inputData = input.readDataToEndOfFile()

    // Convert the raw data to a string
    guard let inputStr = String(data: inputData, encoding: .utf8) else {
        // If conversion fails, print an error and return
        print("Unable to read the data from the input file.")
        return
    }

    // Split the input string into lines
    let inputLines = inputStr.components(separatedBy: "\n")

    // Create position variable to keep track of the current line
    var position = 0

    // While loop to read each line in the input
    while position < inputLines.count {
        // Set the current line to letterStr
        let letterStr = inputLines[position].trimmingCharacters(in: .whitespaces)

        // Increment the position
        position += 1

        // Check if the letterStr is empty
        if letterStr.isEmpty {
            // Add an error message to the output string
            outputStr += "Invalid: \(letterStr) is not a valid letter.\n"
            continue
        } else if letterStr.count > 1 {
            // If letterStr is more than one character, it's invalid
            outputStr += "Invalid: \(letterStr) is not a valid letter.\n"
            continue
        }
        // Convert letter to lower case
        let letter = letterStr.lowercased()

        // Check if the letter is in the alphabet
        if letter < "a" || letter > "z" {
            // If not, add an error message to the output
            outputStr += "Invalid: \(letterStr) is not a valid letter.\n"
            continue
        } else {
            // Check if there is another line for the number of letters to display
            if position < inputLines.count {
                let numberOfLettersStr = inputLines[position].trimmingCharacters(in: .whitespaces)

                // Increment the position
                position += 1

                // Convert the numberOfLettersStr to an integer
                guard let maxCharsInt = Int(numberOfLettersStr) else {
                    // If conversion fails, add an error message to the output
                    outputStr += "\(letterStr) \n"
                        + "Invalid: \(numberOfLettersStr) is not a valid number.\n"
                    continue
                }
                // Check if maxChars is less than 1
                if maxCharsInt < 1 {
                    // Add an error message to the output if invalid
                    outputStr += "\(letterStr) \n"
                        + "Invalid: \(numberOfLettersStr) is not a valid number.\n"
                    continue
                } else {
                    // If valid, call the recursive function to wrap the alphabet
                    outputStr += "Valid: \n"
                    outputStr += recAlphabetWrap(letter: letter, numberOfLetters: maxCharsInt) + "\n"
                }
            }
        }
    }

    // Write the result to the output file
    do {
        try outputStr.write(toFile: outputFile, atomically: true, encoding: .utf8)
        print("Output written to \(outputFile).")
    } catch {
        print("Failed to write output to file: \(error)")
    }
}

// Function to recursively wrap the alphabet to a specified number of lines
func recAlphabetWrap(letter: String, numberOfLetters: Int) -> String {
    // Set the next letter in the alphabet; 97 is 'a' and 122 is 'z'
    // Used https://developer.apple.com/documentation/swift/character/asciivalue
    guard let unicodeValue = letter.first?.asciiValue else { return "" }
    let nextValue = (unicodeValue - 97 + 1) % 26 + 97
    // Convert the next value back to a character
    // Used https://forums.swift.org/t/best-way-to-append-a-unicodescalar-to-a-string/56802/2
    let nextChar = UnicodeScalar(nextValue)

    // Base case: if the number of letters is less than or equal to 1, return the letter
    if numberOfLetters <= 1 {
        return "\(letter)\n"
    } else {
        // Recursively call the function with the next letter and reduced number of letters
        return "\(letter)\n" + recAlphabetWrap(letter: String(nextChar), numberOfLetters: numberOfLetters - 1)
    }
}

// Run the main function
main()
