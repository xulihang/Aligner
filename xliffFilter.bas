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


Sub getFilesList(path As String) As List
	Dim xmlstring As String=File.ReadString(path,"")
	Dim root As XmlNode=XMLUtils.parse(xmlstring)
	Dim files As List
	files=root.Get("file")
	Return files
End Sub

Sub getBitext(path As String) As Map
	Dim sourceLines,targetLines As List
	sourceLines.Initialize
	targetLines.Initialize
	Dim files As List=getFilesList(path)
	Dim st As SimpleTag
	st.Initialize
	For Each fileNode As XmlNode In files
		Dim body As XmlNode=fileNode.Get("body").Get(0)
		Dim segmentsList As List
		segmentsList.Initialize
		For Each tu As Map In getTransUnits(body)
			Dim source As String
			source=tu.Get("source")
			Dim target As String
			target=tu.GetDefault("target","")
			Dim mrkList As List
			mrkList=tu.Get("mrkList")
			Dim targetMrkList As List
			targetMrkList=tu.Get("targetMrkList")
			
			If mrkList.Size<>0 Then
				sourceLines.AddAll(getSegmentedSourceList(mrkList,st))
				targetLines.AddAll(getSegmentedSourceList(targetMrkList,st))
			Else
				source=st.Convert(source,False,"")
				sourceLines.Add(source)
				target=st.Convert(target,False,"")
				targetLines.Add(target)
			End If
		Next
	Next
	Dim result As Map
	result.Initialize
	result.Put("source",sourceLines)
	result.Put("target",targetLines)
	Return result
End Sub

Sub getSegmentedSourceList(mrkList As List,st As SimpleTag) As List
	Dim segmentedSourceList As List
	segmentedSourceList.Initialize
	For Each mrk As XmlNode In mrkList
		Dim text As String
		text=mrk.innerText
		text=st.Convert(text,False,"")
		segmentedSourceList.Add(text)
	Next
	Return segmentedSourceList
End Sub

Sub getTransUnits(body As XmlNode) As List
	Dim tidyTransUnits As List
	tidyTransUnits.Initialize
	Dim groups As List
	groups.Initialize
	Dim groupIndex As Int=0
	addFromParentNode(body,tidyTransUnits,groupIndex)
	Return tidyTransUnits
End Sub

Sub addFromParentNode(Parent As XmlNode,tidyTransUnits As List,groupIndex As Int)
	For Each children As XmlNode In Parent.Children
		If children.Name="group" Then
			addFromParentNode(children,tidyTransUnits,groupIndex)
			groupIndex=groupIndex+1
		else if children.Name="trans-unit" Then
			addTransUnit(children,tidyTransUnits,-1)
		End If
	Next
End Sub

Sub addTransUnit(transUnit As XmlNode,tidyTransUnits As List,groupIndex As Int)
	Dim attributes As Map
	attributes=transUnit.Attributes
	Dim id As String
	id=attributes.Get("id")

	Dim source As XmlNode
	source=transUnit.Get("source").Get(0)
	Dim text As String
	text=source.innerText
	
	Dim mrkList As List
	Dim targetMrkList As List
	If transUnit.Contains("seg-source") Then
		Dim segSource As XmlNode
		segSource=transUnit.Get("seg-source").Get(0)
		mrkList=segSource.Get("mrk")
	Else
		mrkList.Initialize
	End If
	
	Dim oneTransUnit As Map
	oneTransUnit.Initialize
	oneTransUnit.put("source",text)
	oneTransUnit.Put("id",id)
	oneTransUnit.Put("mrkList",mrkList)
	oneTransUnit.Put("groupIndex",groupIndex)
	
	If transUnit.Contains("target") Then
		Dim target As String
		Dim targetNode As XmlNode
		targetNode=transUnit.Get("target").get(0)
		target=targetNode.innerText
		If target<>"null" Then
			oneTransUnit.Put("target",target)
		End If
		If targetNode.Contains("mrk") Then
			targetMrkList=targetNode.Get("mrk")
		End If
	End If
	
	If targetMrkList.IsInitialized=False Then
		targetMrkList.Initialize
	End If
	
	oneTransUnit.Put("targetMrkList",targetMrkList)
	tidyTransUnits.Add(oneTransUnit)
End Sub