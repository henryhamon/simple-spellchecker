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

}
