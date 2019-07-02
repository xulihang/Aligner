B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.51
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
End Sub


Sub readFileIntoParagraphs(filepath As String) As List
	Dim textContent As String = getText(OpenDocx(filepath,""))
	Dim segmentsList As List
	segmentsList.Initialize
	For Each source As String In Regex.Split("\n",textContent)
		If source.Trim="" Then
			Continue
		End If
		segmentsList.Add(source)
	Next
	Return segmentsList
End Sub

Sub getBitext(path As String) As Map
	Dim doc As JavaObject=OpenDocx(path,"")
	Dim text As String=getText(doc)
	Return Utils.getBitext(text)
End Sub

Sub getText(doc As JavaObject) As String
	Dim extractor As JavaObject
	extractor.InitializeNewInstance("org.apache.poi.xwpf.extractor.XWPFWordExtractor",Array(doc))
	Return extractor.RunMethod("getText",Null)
End Sub

Sub OpenDocx(Dir As String, FileName As String) As JavaObject
	Dim in As InputStream = File.OpenInput(Dir, FileName)
	Dim document As JavaObject
	document.InitializeNewInstance("org.apache.poi.xwpf.usermodel.XWPFDocument", _
       Array(in))
	Return document
End Sub