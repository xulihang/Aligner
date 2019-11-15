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

Sub getBitext(files As List,separator As String,sourceIsFirst As Boolean) As Map
	Dim result As Map
	result.Initialize
	Dim notes As List
	notes.Initialize
	Dim sourceLines As List
	sourceLines.Initialize
	Dim targetLines As List
	targetLines.Initialize
	For Each filepath As String In files
		Dim dialogs As List
		dialogs=readDialogs(filepath)
		For Each dialog As Map In dialogs
			Dim text As String=dialog.Get("text")
			Dim timeline As String=dialog.Get("timeline")
			If text.Contains(separator)=False Then
				Continue
			End If
			text=text.Replace(separator,CRLF)
			Dim source,target As String
			If sourceIsFirst Then
				source=Regex.Split(CRLF,text)(0)
				target=Regex.Split(CRLF,text)(1)

			Else
				source=Regex.Split(CRLF,text)(1)
				target=Regex.Split(CRLF,text)(0)
			End If
			If source.Trim<>"" And target.Trim<>"" Then
				sourceLines.Add(source)
				targetLines.Add(target)
				notes.Add(File.GetName(filepath)&CRLF&timeline)
			End If
		Next
	Next
	result.Put("source",sourceLines)
	result.Put("target",targetLines)
	result.Put("notes",notes)
	Log(result)
	Return result
End Sub

Sub readDialogs(path As String) As List
	Dim dialogs As List
	dialogs.Initialize
	Dim encoding As String
	encoding=icu4j.getEncoding(path,"")
	Dim textReader As TextReader
	textReader.Initialize2(File.OpenInput(path,""),encoding)
	Dim line As String
	line=textReader.ReadLine
	Do While line<>Null
		'Log(line)
		If line.StartsWith("Dialogue: ") Then
			Dim items As List
			items.Initialize
			items.AddAll(Regex.Split(",",line))
			Dim timeline As String
			timeline=items.Get(1)&","&items.Get(2)
			Dim text As StringBuilder
			text.Initialize
			For index = 9 To items.Size-1
			    text.Append(items.Get(index))
			Next
			Dim dialog As Map
			dialog.Initialize
			dialog.Put("timeline",timeline)
			dialog.Put("text",cleanText(text.ToString))
			dialogs.Add(dialog)
		End If
		line=textReader.ReadLine
	Loop
	textReader.Close
	Log(dialogs)
	Return dialogs
End Sub

Sub cleanText(text As String) As String
	text=Regex.Replace("\{.*?\}",text," ")
	Return text
End Sub