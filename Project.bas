B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=6.8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private ProjectFile As Map
	Public segments As List
	Private path As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(projectPath As String)
	ProjectFile.Initialize
	segments.Initialize
	path=projectPath
End Sub

' segment paragraphs into sentences
Public Sub loadSegmentsInSentenceLevel(srxPath As String) As ResumableSub
	Log("segmenting...")
	Log(srxPath)
	Dim segmentsForIteration As List
	segmentsForIteration.Initialize
	segmentsForIteration.AddAll(segments)
	segments.Clear
	Dim sourceSegments,targetSegments,notes,ids As List
	sourceSegments.Initialize
	targetSegments.Initialize
	notes.Initialize
	ids.Initialize
	For i=0 To segmentsForIteration.Size-1
		'Log(i)
		Dim segment As Map
		segment.Initialize
		segment=segmentsForIteration.Get(i)
		Dim source,target As String
		source=segment.Get("source")
		target=segment.Get("target")
		
		Dim langPair As Map=ProjectFile.Get("langPair")
		Dim index As Int=0
		wait for (segmentation.segmentedTxt(source,True,langPair.Get("source"),srxPath,True)) Complete (segmented As List)
		For Each sentence As String In segmented
			If sentence.Trim<>"" Then
				sourceSegments.Add(sentence.Trim)
				If index=0 Then
					notes.Add(segment.Get("note"))
				Else
					notes.Add("")
				End If
				index=index+1
			End If
		Next
		
		Wait For (segmentation.segmentedTxt(target,True,langPair.Get("target"),srxPath,False)) Complete (segmented As List)
		For Each sentence As String In segmented
			If sentence.Trim<>"" Then
				targetSegments.Add(sentence.Trim)
			End If
		Next
		
		If targetSegments.Size<sourceSegments.Size Then
			For j=1 To sourceSegments.Size-targetSegments.Size
				targetSegments.Add("")
			Next
		else if targetSegments.Size>sourceSegments.Size Then
			For j=1 To targetSegments.Size-sourceSegments.Size
				sourceSegments.Add("")
				notes.Add("")
			Next
		End If
		
		For k=0 To sourceSegments.Size-1
			ids.Add(i)
		Next
		
	Next
	Dim result As Map
	result.Initialize
	result.Put("source",sourceSegments)
	result.Put("target",targetSegments)
	result.Put("notes",notes)
	result.Put("ids",ids)
	loadItemsToSegments(result)
	Return ""
End Sub

Public Sub loadItemsToSegments(result As Map)
	segments.Clear
	Dim sourceSegments,targetSegments,notes,ids As List
	sourceSegments=result.Get("source")
	targetSegments=result.Get("target")
	If result.ContainsKey("notes") Then
		notes=result.Get("notes")
	Else
		notes.Initialize
	End If
	If result.ContainsKey("ids") Then
		ids=result.Get("ids")
	Else
		ids.Initialize
	End If
	For i=0 To Max(sourceSegments.Size-1,targetSegments.size-1)
		Dim segment As Map
		segment.Initialize
		If i<=sourceSegments.Size-1 Then
			segment.Put("source",sourceSegments.Get(i))
		Else
			segment.Put("source","")
		End If
		If i<=targetSegments.Size-1 Then
			segment.Put("target",targetSegments.Get(i))
		Else
			segment.Put("target","")
		End If
		If i<=notes.Size-1 Then
			segment.Put("note",notes.Get(i))
		Else
			segment.Put("note","")
		End If
		If i<=ids.Size-1 Then
			segment.Put("id",ids.Get(i))
		End If
		segments.Add(segment)
	Next
End Sub

Public Sub setProjectFileValue(key As Object,value As Object)
	ProjectFile.Put(key,value)
End Sub

Public Sub getProjectFileValue(key As Object) As Object
	Return ProjectFile.GetDefault(key,Null)
End Sub

Public Sub saveProjectFile
	Dim json As JSONGenerator
	json.Initialize(ProjectFile)
	File.WriteString(path,"",json.ToPrettyString(4))
End Sub

Public Sub readProjectFile
	Dim json As JSONParser
	json.Initialize(File.ReadString(path,""))
	ProjectFile=json.NextObject
	If ProjectFile.ContainsKey("segments") Then
		segments=ProjectFile.Get("segments")
	End If
End Sub

Public Sub save
	ProjectFile.Put("segments",segments)
	Dim json As JSONGenerator
	json.Initialize(ProjectFile)
	File.WriteString(path,"",json.ToPrettyString(4))
End Sub