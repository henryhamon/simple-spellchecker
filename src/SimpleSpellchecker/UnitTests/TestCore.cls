Class SimpleSpellchecker.UnitTests.TestCore Extends %UnitTest.TestCase
{

/// Set ^UnitTestRoot = "/opt/irisapp/src/SimpleSpellchecker/UnitTests/"
ClassMethod factory() As %ListOfDataTypes
{
	Quit ##class(%ListOfDataTypes).%New()
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
	Do $$$AssertTrue(list.Count() > 1)
	Do $$$AssertEquals(list.GetAt(1),"aaguns")
}

}
