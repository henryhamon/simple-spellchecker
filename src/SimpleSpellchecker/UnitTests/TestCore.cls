Class SimpleSpellchecker.UnitTests.TestCore Extends %UnitTest.TestCase
{

/// Set ^UnitTestRoot = "/opt/irisapp/src/SimpleSpellchecker/UnitTests/"
/// Do ##class(%UnitTest.Manager).RunTest("","/loadudl")
ClassMethod factory() As %ListOfDataTypes
{
	Quit ##class(%ListOfDataTypes).%New()
}

ClassMethod forcedTrained()
{
	Set ^DICTIONARY("beginning") = 143
	Set ^DICTIONARY("beginnings") = 17
	Set ^DICTIONARY("reining") = 2
	Set ^DICTIONARY("begging") = 18
	Set ^DICTIONARY("peeling") = 2
	Set ^DICTIONARY("spelling") = 4
	Set ^DICTIONARY("speeding") = 2
	Set ^DICTIONARY("spoiling") = 7
	Set ^DICTIONARY("sealing") = 8
	Set ^DICTIONARY("stealing") = 3
	Set ^DICTIONARY("spelling") = 4
	Set ^DICTIONARY("corrected") = 14
	Set ^DICTIONARY("bicycle") = 1
	Set ^DICTIONARY("inconvenient") = 40
	Set ^DICTIONARY("convient") = 1
	Set ^DICTIONARY("entry") = 21
	Set ^DICTIONARY("poetry") = 10
	Set ^DICTIONARY("perry") = 5
	Set ^DICTIONARY("petty") = 17
}

Method TestAddingCharacter()
{
	Set list = ..factory()
	Do $$$AssertTrue(list.Count() = 0)
	Do ##class(SimpleSpellchecker.Core).AddingCharacter("guns", .list)
	Do $$$AssertTrue(list.Count() > 50)
	Do $$$AssertEquals(list.GetAt(1),"aguns")
	Do $$$AssertEquals(list.GetAt(list.Count()), "gunsz")
}

Method TestRemovingCharacter()
{
	Set list = ..factory()
	Do $$$AssertTrue(list.Count() = 0)
	Do ##class(SimpleSpellchecker.Core).RemovingCharacter("guns", .list)
	Do $$$AssertTrue(list.Count() > 1)
	Do $$$AssertEquals(list.GetAt(1),"uns")
	Do $$$AssertEquals(list.GetAt(list.Count()), "gun")
}

Method TestTransposingCharacters()
{
	Set list = ..factory()
	Do $$$AssertTrue(list.Count() = 0)
	Do ##class(SimpleSpellchecker.Core).TransposingCharacters("guns", .list)
	Do $$$AssertTrue(list.Count() > 1)
	Do $$$AssertEquals(list.GetAt(1),"ugns")
	Do $$$AssertEquals(list.GetAt(list.Count()), "gusn")
}

Method TestSubstitutingCharacters()
{
	Set list = ..factory()
	Do $$$AssertTrue(list.Count() = 0)
	Do ##class(SimpleSpellchecker.Core).SubstitutingCharacter("guns", .list)
	Do $$$AssertTrue(list.Count() > 1)
	Do $$$AssertEquals(list.GetAt(1),"auns")
	Do $$$AssertEquals(list.GetAt(list.Count()), "gunz")
}

Method TestEditDistance1()
{
	Set list = ##class(SimpleSpellchecker.Core).EditDistance1("guns")
	Do $$$AssertTrue(list.Count() > 1)
	Do $$$AssertEquals(list.GetAt(1),"aguns")
	Do $$$AssertEquals(list.GetAt(list.Count()), "gunz")
}

Method TestEditDistance2()
{
	Set list = ..factory()
	Set list2 = ##class(SimpleSpellchecker.Core).EditDistance2(.list)
	Do $$$AssertTrue(list.Count() = 0)
	Set list = ##class(SimpleSpellchecker.Core).EditDistance1("guns")
	Set list2 = ##class(SimpleSpellchecker.Core).EditDistance2(.list)
	Do $$$AssertTrue(list.Count() > 1)
	Do $$$AssertTrue(list2.Count() > 1)
	Do $$$AssertTrue(list2.Find("aaguns")'="")
}

Method TestFindCandidate()
{
	Set temp = $Get(^NWORD("guns"))
	Set ^DICTIONARY("guns") = 90000

	Do ##class(SimpleSpellchecker.Core).FindCandidate("gusn", .maxCount, .correct)
	Do $$$AssertTrue(maxCount > 0)
	Do $$$AssertEquals(correct,"guns")

	Set:(temp '= "") ^DICTIONARY("guns") = temp
}

Method TestCorrect()
{
	Do ..forcedTrained()

	// Insert
	Do $$$AssertEquals(##class(SimpleSpellchecker.Core).Correct("speling"),"spelling")
	// Replace 2
	Do $$$AssertEquals(##class(SimpleSpellchecker.Core).Correct("korrectud"),"corrected")
	// Replace
	Do $$$AssertEquals(##class(SimpleSpellchecker.Core).Correct("bycycle"),"bicycle")
	// Insert 2
	Do $$$AssertEquals(##class(SimpleSpellchecker.Core).Correct("inconvient"),"inconvenient")
	// transpose
	Do $$$AssertEquals(##class(SimpleSpellchecker.Core).Correct("peotry"),"poetry")
	// transpose + delete
	Do $$$AssertEquals(##class(SimpleSpellchecker.Core).Correct("peotryy"),"poetry")
}

Method TestTraining()
{
	If ($Get(^DICTIONARY("test")) '= "") {
		Kill ^DICTIONARY("test")
	}
	Do $$$AssertEquals(##class(SimpleSpellchecker.Core).Train("test"), 1)
	Do $$$AssertEquals($Get(^DICTIONARY("test")), 1)
}

}
