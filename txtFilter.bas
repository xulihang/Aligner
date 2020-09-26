B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=6.51
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
End Sub


Sub readFileIntoParagraphs(filepath As String) As List
	Dim textContent As String = readTxt(filepath)
	Dim segmentsList As List=Text2Paragraphs(textContent)
	Return segmentsList
End Sub

Public Sub Text2Paragraphs(text As String) As List
	Dim segmentsList As List
	segmentsList.Initialize
	For Each source As String In Regex.Split("\n",text)
		If source.Trim="" Then
			Continue
		End If
		segmentsList.Add(source)
	Next
	Return segmentsList
End Sub

Sub readTxt(filepath As String) As String
	Dim encoding As String
	encoding=icu4j.getEncoding(filepath,"")
	Dim textContent As String
	Dim textReader As TextReader
	textReader.Initialize2(File.OpenInput(filepath,""),encoding)
	textContent=textReader.ReadAll
	textReader.Close
	Return textContent
End Sub

Sub getBitext(path As String,langPair As Map,highPrecisionForZH As Boolean) As Map
	Dim text As String=readTxt(path)
	Return Utils.getBitext(text,langPair,highPrecisionForZH)
End Sub

