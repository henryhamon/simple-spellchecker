# Simple Spell Checker

Can be used to suggest the correct spelling of text similar to Google "Did you mean" but based on a pure InterSystems IRIS ObjectScript implementation of Peter Norvig correct spelling suggestion algorithm.
You can read more about the approach in the [original article](http://norvig.com/spell-correct.html).
It takes a given word and returns a suggestion of the probable correct spelling of the word.

The API can build a dictionary with correctly spelled words.

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation

Open terminal and clone/git pull the repo into any local directory as shown below:

```
$ git clone https://github.com/henryhamon/simple-spellchecker
```

Open the terminal in this directory and run:

```
cd irisapp
$ docker-compose build
```

## Installation with ZPM

```
zpm:USER>install simple-spellchecker
```


## How to Test

### Unit Test

Open IRIS terminal:

```
$ docker-compose exec iris iris session iris
USER>zn "IRISAPP"
IRISAPP>Set ^UnitTestRoot = "/opt/irisapp/src/SimpleSpellchecker/UnitTests/"
IRISAPP>Do ##class(%UnitTest.Manager).RunTest("","/loadudl")
```

## Testing POST request

POST request are used to train the model, this REST API exposes two POST requests:
1. To add words to dictionary
2. To train using a text

### 1. To add words to dictionary

Prepare a collection of terms, e.g. in Postman with raw data in JSON. e.g.

```
{"terms":["poetry","entry"]}
```

Adjust the authorisation if needed - it is basic for container with default login and password for IRIS Community edition container

and send the POST request to localhost:52773/simplespellchecker/train/

This will build a dictionary with correctly spelled words.

### 2. To train using a text

Train a dictionary from a text document, just prepare the JSON with a text, e.g.
```
{"text":"A very long text here."}
```

In *Assert* folder has a sample training text document, obtained from Peter Norvig site that you can use to train the language model, it is a concatenation of public domain book excerpts from Project Gutenberg.

## Testing PUT request

PUT request could be used to add a single term to dictionary.
E.g. we want to add the word _spelling_  Prepare in Postman and send the put request to:
```
localhost:52773/simplespellchecker/train/spelling
```

## Testing DELETE request

Delete will completely remove a term from dictionary.
For delete request this REST API expects only the word to delete. E.g. if the _spelling_ the following DELETE call will delete the record:

```
localhost:52773/simplespellchecker/train/spelling
```

## Testing GET requests

To spell check test GET you need to train the dictionary. You can create it with POST request (see above)

This REST API exposes two GET requests:
1. The spell check
2. A Frequency of a word in the dictionary

To spell check:

```
localhost:52773/simplespellchecker/:word
```
E.g. To get the correct word for _**speling**_

```
localhost:52773/simplespellchecker/speling
```

This will return JSON data for the suggestion word, something like that:
```
{"suggest": "spelling"}
```

To check the frequency of a particular word in the dictionary, a GET request like 'localhost:52773/simplespellchecker/train/word' . E.g.:

```
localhost:52773/simplespellchecker/train/spelling
```

This will return JSON data with the frequency of this term in the dictionary , something like that:

```
{
    "frequency": 40,
    "actions": [
        {
            "title": "Remove term from Trained Model",
            "method": "DELETE",
            "href": "/simplespellchecker/train/spelling",
            "fields": []
        }
    ]
}
```

You can get swagger Open API 2.0 documentation on:
```
localhost:52773/simplespellchecker/_spec
```


## Author ##

 * Henry "HammZ" Hamon Pereira [github](https://github.com/henryhamon)
