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


Sub getXmlMap(xmlstring As String) As Map
	Dim ParsedData As Map
	Dim xm As Xml2Map
	xm.Initialize
	ParsedData = xm.Parse(xmlstring)
	Return ParsedData
End Sub

Sub getXmlFromMap(map1 As Map) As String
	Dim mx As Map2Xml
	mx.Initialize
	Return mx.MapToXml(map1)
End Sub

Sub GetElements (m As Map, key As String) As List
	Dim res As List
	If m.ContainsKey(key) = False Then
		res.Initialize
		Return res
	Else
		Dim value As Object = m.Get(key)
		If value Is List Then Return value
		res.Initialize
		res.Add(value)
		Return res
	End If
End Sub