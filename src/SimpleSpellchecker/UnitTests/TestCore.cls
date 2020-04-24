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

}
