Class SimpleSpellchecker.Core
{

Parameter LETTERS = {$Listbuild("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")};

/// Add text for the training model.
ClassMethod Train(term As %String) As %Integer
{
	Set ^DICTIONARY(term) = $Get(^DICTIONARY(term)) + 1
	Quit $Get(^DICTIONARY(term))
}

/// Given a word, attempts to correct the spelling of that word.
ClassMethod Correct(word As %String) As %String
{
	Set word = $ZConvert(word, "l")
	Quit:($Get(^DICTIONARY(word))'="") word
	Do ..FindCandidate(word, .maxCount, .correctWord)
	Do ..FindCandidate(word, .maxCount2, .correctWord2, $$$YES)

	if ($Length(word) < 6) {
		Quit:(maxCount2 > (100 * maxCount)) correctWord2
		Quit correctWord
	}
	Quit:(maxCount2 > ( 4 * maxCount)) correctWord2
	Quit correctWord
}

/// Find the Most probable spelling correction for word.
/// The correction will be selected by counting the number of times each word appears
ClassMethod FindCandidate(word As %String, Output maxCount As %Integer = 0, Output correctWord As %String, distance2words As %Boolean = 0) As %Status
{
	Set:(distance2words = $$$NO) distanceWords = ..EditDistance1(word)
	Set:(distance2words = $$$YES) distanceWords = ..EditDistance2(..EditDistance1(word))
	Set correctWord = ""
	Set key = 0
	While (key'="") {
		Set value = distanceWords.GetNext(.key)
		Continue:(value="")
		Set wordCount = $Get(^DICTIONARY(value))
		Set:(wordCount > maxCount) maxCount = wordCount, correctWord = value
	}
}

/// Returns the set of all strings 1 edit distance away from the input word.
ClassMethod EditDistance1(word As %String) As %ListOfDataTypes
{
	Set word = $ZConvert(word, "l")
	Set results = ##class(%Library.ListOfDataTypes).%New()

	Do ..AddingCharacter(word, .results)
	Do ..RemovingCharacter(word, .results)
	Do ..TransposingCharacters(word, .results)
	Do ..SubstitutingCharacter(word, .results)

	Quit results
}

/// Returns the set of all strings 2 edit distance away from the input word.
ClassMethod EditDistance2(oneDistance As %ListOfDataTypes) As %ListOfDataTypes
{
	Set results = ##class(%Library.ListOfDataTypes).%New()
	For idx=1:1:oneDistance.Count() {
		Set distance2 = ..EditDistance1(oneDistance.GetAt(idx))
		For idx2=1:1:distance2.Count() {
		Do results.Insert(distance2.GetAt(idx2))
		}
	}

	Quit results
}

/// Adding any one character anywhere in the word.
ClassMethod AddingCharacter(word As %String, ByRef results As %ListOfDataTypes)
{
	For idx=1:1:$Length(word) {
		Set pointer= 0
		While $ListNext(..#LETTERS, pointer, alphabet) {
			Set newWord = word
			Set:(idx>1) newWord = $Extract(newWord,1,idx)_alphabet_$Extract(newWord,idx+1,*)
			Set:(idx=1) newWord = alphabet_newWord
			Do results.Insert(newWord)
		}
	}
}

/// Removing any one character from the word.
ClassMethod RemovingCharacter(word As %String, ByRef results As %ListOfDataTypes)
{
	Quit:($Length(word)<2)
	For idx=1:1:$Length(word) {
		Set newWord = word
		Set $Extract(newWord,idx) = ""
		Do results.Insert(newWord)
	}
}

/// Transposing (switching) the order of any two adjacent characters in a word.
ClassMethod TransposingCharacters(word As %String, ByRef results As %ListOfDataTypes)
{
	Quit:($Length(word)<2)
	For idx=1:1:($Length(word)-1) {
		Set newWord = word
		Set tmp = $Extract(newWord,idx)
		Set $Extract(newWord,idx) = $Extract(newWord,idx+1)
		Set $Extract(newWord,idx+1) = tmp
		Do results.Insert(newWord)
	}
}

/// Substituting any character in the word with another character.
ClassMethod SubstitutingCharacter(word As %String, ByRef results As %ListOfDataTypes)
{
	For idx=1:1:$Length(word) {
		Set pointer= 0
		While $ListNext(..#LETTERS, pointer, alphabet) {
		Set newWord = word
		Set $Extract(newWord,idx) = alphabet
		Do results.Insert(newWord)
		}
	}
}

}
