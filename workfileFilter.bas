B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.8
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
End Sub


Sub getBitext(path As String) As Map
	Dim segments As List=readWorkFile(path,"")
	Dim sourceLines As List
	sourceLines.Initialize
	Dim targetLines As List
	targetLines.Initialize
	For Each segment As List In segments
		sourceLines.Add(segment.Get(0))
		targetLines.Add(segment.Get(1))
	Next
	Dim result As Map
	result.Initialize
	result.Put("source",sourceLines)
	result.Put("target",targetLines)
	Return result
End Sub

Sub readWorkFile(dir As String,filename As String) As List
	Dim segments As List
	segments.Initialize
	Dim workfile As Map
	Dim json As JSONParser
	json.Initialize(File.ReadString(dir,filename))
	workfile=json.NextObject
	Dim sourceFiles As List
	sourceFiles=workfile.Get("files")
	For Each sourceFileMap As Map In sourceFiles
		Dim innerFilename As String
		innerFilename=sourceFileMap.GetKeyAt(0)
		Dim segmentsList As List
		segmentsList=sourceFileMap.Get(innerFilename)
		segments.AddAll(segmentsList)
	Next
	Return segments
End Sub
