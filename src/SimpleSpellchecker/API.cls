Class SimpleSpellchecker.API Extends SimpleSpellchecker.REST.Base
{

Parameter Version = "1.0.1";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Build the dictionary with correctly spelled words from a training text document -->
<Route Url="/train/txt/" Method="POST" Call="TrainText" />
<!-- Return the Frequency of a Trained Term -->
<Route Url="/train/:term" Method="GET" Call="GetTrainedTermFreq" />
<!-- Add Term on Trained Model -->
<Route Url="/train/:term" Method="PUT" Call="TrainTerm" />
<!-- Remove a Term from Trained Model -->
<Route Url="/train/:term" Method="DELETE" Call="DeleteTerm" />
<!-- Add Multiples Terms on Trained Model -->
<Route Url="/train/" Method="POST" Call="Train" />

<!-- Search corrected word -->
<Route Url="/:word" Method="GET" Call="GetCorrection" />

<!-- Server Info -->
<Route Url="/" Method="GET" Call="GetInfo" Cors="true"/>
<!-- Swagger specs -->
<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />

</Routes>
}

/// General information
ClassMethod GetInfo() As %Status
{
	Set version = ..#Version
	Set info = {
		"version": (version)
	}
	Return ..%ProcessResult($$$OK, info)
}

/// Did you mean ...
/// Check if the received word it's correct
/// * Must to train the model first
ClassMethod GetCorrection(word As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		Set resp = {}
		Set resp.suggest = ##class(SimpleSpellchecker.Core).Correct(word)
		Set %response.Status = 200
		Set %response.ContentType = ..#CONTENTTYPEJSON

		Write resp.%ToJSON()

	} Catch tException {
		Set:$$$ISOK(tSC) tSC = tException.AsStatus()
	}
	Quit tSC
}

/// Return the Frequency of a Trained Term
/// Frequency is the number of times the word occurs in your index
ClassMethod GetTrainedTermFreq(term As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		Set resp = {}
		Set resp.frequency = $Get(^DICTIONARY(term))
		Set resp.actions = []
		If (resp.frequency = "") {
			Set resp.frequency = 0
			Do resp.actions.%Push(..Action("Add a new term", "PUT", "/train/"_term))
			Do resp.actions.%Push(..Action("Add a list of terms", "POST", "/train/","terms:collection"))
			Set resp.message = "Term not found. Do you want to add?"
		} Else {
			Do resp.actions.%Push(..Action("Remove term from Trained Model", "DELETE", "/train/"_term))
		}
		Set %response.Status = 200
		Set %response.ContentType = ..#CONTENTTYPEJSON

		Write resp.%ToJSON()
	} Catch tException {
		Set:$$$ISOK(tSC) tSC = tException.AsStatus()
	}
	Quit tSC
}

/// Add term to Train Model
ClassMethod TrainTerm(term As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		Set resp = {}
		Set:(term '= "") resp.frequency = ##class(SimpleSpellchecker.Core).Train(term)
		Set resp.actions = []

		Do resp.actions.%Push(..Action("Get the Frequency of a Trained Term", "GET", "/train/"_term))
		Do resp.actions.%Push(..Action("Remove term from Trained Model", "DELETE", "/train/"_term))
		Do resp.actions.%Push(..Action("Add a list of terms", "POST", "/train/","terms:collection"))

		Set %response.Status = 200
		Set %response.ContentType = ..#CONTENTTYPEJSON

		Write resp.%ToJSON()
	} Catch tException {
		Set:$$$ISOK(tSC) tSC = tException.AsStatus()
	}
	Quit tSC
}

/// Train Model
ClassMethod Train() As %Status
{
	Set tSC = $$$OK
	Try {
		Set data = %request.Content
		Set resp = {}
		Set resp.trained = []
			Set iter = data.terms.%GetIterator()
			While iter.%GetNext(.key, .value) {
				Set term = {}
				Set term.term = value
				Set term.frequency = ##class(SimpleSpellchecker.Core).Train(value)
				Do resp.trained.%Push(term)
			}
		Set resp.actions = []

		Do resp.actions.%Push(..Action("Get the Frequency of a Trained Term", "GET", "/train/", "term"))
		Do resp.actions.%Push(..Action("Remove term from Trained Model", "DELETE", "/train/", "term"))

		Set %response.Status = 200
		Set %response.ContentType = ..#CONTENTTYPEJSON

		Write resp.%ToJSON()
	} Catch tException {
		Set:$$$ISOK(tSC) tSC = tException.AsStatus()
	}
	Quit tSC
}

/// Remove term from Trained Model
ClassMethod DeleteTerm(term As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		Set resp = {}
		If ($Get(^DICTIONARY(term)) '= "") {
			Kill ^DICTIONARY(term)
		}

		Set %response.Status = 200
		Set %response.ContentType = ..#CONTENTTYPEJSON

	} Catch tException {
		Set:$$$ISOK(tSC) tSC = tException.AsStatus()
	}
	Quit tSC
}

/// Build the dictionary with correctly spelled words from a training text document
ClassMethod TrainText() As %Status
{
	Set tSC = $$$OK
	Try {
		Set data = %request.Content
		Set resp = {}
		$$$THROWONERROR(tSC, ##class(SimpleSpellchecker.Core).TrainText(.total, data.text))
		Set resp.imported = total

		Set %response.Status = 200
		Set %response.ContentType = ..#CONTENTTYPEJSON

		Write resp.%ToJSON()
	} Catch tException {
		Set:$$$ISOK(tSC) tSC = tException.AsStatus()
	}
	Quit tSC
}

ClassMethod SwaggerSpec() As %Status
{
	Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
	Do swagger.info.%Remove("x-ISC_Namespace")
	Set swagger.basePath = "/simplespellchecker"
	Set swagger.info.title = "InterSystems IRIS REST Simple Spellchecker"
	Set swagger.info.version = "0.1"
	Set swagger.host = "localhost:52773"
	Return ..%ProcessResult($$$OK, swagger)
}

/// HATEAOS feelings
ClassMethod Action(title As %String, method As %String, href As %String, fields As %String = "", Output tSC As %Status) As %DynamicObject
{
	Set action = {}
	Set tSC = $$$OK
	Try {
		Set action.title = title
		Set action.method = $ZConvert(method, "U")
		Set action.href = "/simplespellchecker"_href
		Set action.fields = []
		Set fields = $Listfromstring(fields,";")
		SET ptr=0
		While $ListNext(fields, ptr, field) {
			Do action.fields.%Push(field)
		}
	} Catch tException {
		Set:$$$ISOK(tSC) tSC = tException.AsStatus()
	}
	Quit action
}

}
