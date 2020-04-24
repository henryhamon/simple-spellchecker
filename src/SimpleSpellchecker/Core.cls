Class SimpleSpellchecker.Core
{

Parameter LETTERS = {$Listbuild("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")};

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
}

/// Transposing (switching) the order of any two adjacent characters in a word.
ClassMethod TransposingCharacters(word As %String, ByRef results As %ListOfDataTypes)
{
}

/// Substituting any character in the word with another character.
ClassMethod SubstitutingCharacter(word As %String, ByRef results As %ListOfDataTypes)
{
}

}
