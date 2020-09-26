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

Sub getBitext(path As String,langPair As Map) As Map
	Dim sourceLang As String = langPair.Get("source")
	Dim targetLang As String = langPair.Get("target")
	Dim segments As List=importedList(path,"",sourceLang,targetLang)
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

Sub getTransUnits(xml As String) As List
	Dim parser As XmlParser
	parser.Initialize
	Dim root As XmlNode=XMLUtils.Parse(xml)
	Dim body As XmlNode=root.Get("body").Get(0)
	Dim tus As List=body.Get("tu")
	Return tus
End Sub

Sub importedList(dir As String, filename As String, sourceLang As String,targetLang As String) As List
	Dim xml As String=File.ReadString(dir,filename)
	Return importedList2(xml,sourceLang,targetLang)
End Sub

Sub importedList2(xml As String,sourceLang As String,targetLang As String) As List
	Dim segments As List
	segments.Initialize
	sourceLang=sourceLang.ToLowerCase
	targetLang=targetLang.ToLowerCase
	Dim tus As List=getTransUnits(xml)
	For Each tu As XmlNode In tus
		Dim tuvList As List= tu.Get("tuv")
		Dim segment As List
		segment.Initialize
		segment.Add("source")
		segment.Add("target")
		Dim addedTimes As Int=0
		For Each tuv As XmlNode In tuvList
			Dim lang As String
			Dim seg As XmlNode=tuv.Get("seg").Get(0)
			If tuv.Attributes.ContainsKey("xml:lang") Then
				lang=tuv.Attributes.Get("xml:lang")
			else if tuv.Attributes.ContainsKey("lang") Then
				lang=tuv.Attributes.Get("lang")
			End If
			lang=lang.ToLowerCase
			If lang.StartsWith(sourceLang) Then
				segment.Set(0,getSegText(seg))
				addedTimes=addedTimes+1
			else if lang.StartsWith(targetLang) Then
				segment.Set(1,getSegText(seg))
				addedTimes=addedTimes+1
			Else
				Continue
			End If
		Next
		If addedTimes=2 Then
			segments.Add(segment)
		End If
	Next
	Return segments
End Sub

Sub getSegText(seg As XmlNode) As String
	If XMLUtils.XmlNodeContainsOnlyText(seg) Then
		Dim text As String=XMLUtils.XmlNodeText(seg)
		Return text
	End If
	Return XMLUtils.XMLToText(removeTMXTags(seg.innerXML))
End Sub

Sub removeTMXTags(s As String) As String
	'<bpt i="1">&lt;g1&gt;</bpt>
	Dim sb As StringBuilder
	sb.Initialize
	Dim parts As List
	parts.Initialize
	Dim tags As String
	tags="(bpt|ept|ph)"
	Dim previousEndIndex As Int=0
	Dim matcher As Matcher
	matcher=Regex.Matcher($"<${tags}.*?>(.*?)</${tags}>"$,s)
	Do While matcher.Find
		Dim textBefore As String
		textBefore=s.SubString2(previousEndIndex,matcher.GetStart(0))
		If textBefore<>"" Then
			parts.Add(textBefore)
		End If
		parts.add(XMLUtils.UnescapeXml(matcher.Group(2)))
		previousEndIndex=matcher.GetEnd(0)
	Loop
	Dim textAfter As String
	textAfter=s.SubString2(previousEndIndex,s.Length)
	If textAfter<>"" Then
		parts.Add(textAfter)
	End If
	For Each part As String In parts
		sb.Append(part)
	Next
	Return Regex.Replace($"<${tags}.*?>"$,sb.ToString,"")
End Sub


Sub exportQuick(segments As List,sourceLang As String,targetLang As String,path As String,includeTags As Boolean,useTMXTags As Boolean)
	Dim head As String=$"<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<tmx version="1.4">
    <header>
        <creationtool>BasicCAT</creationtool>
        <creationtoolversion>1.0.0</creationtoolversion>
        <adminlang>en</adminlang>
        <srclang>en</srclang>
        <segtype>sentence</segtype>
        <o-tmf>BasicCAT</o-tmf>
    </header>
    <body>"$
	head=head&CRLF
	Dim tail As String=$"    </body>
</tmx>"$
	Dim body As StringBuilder
	body.Initialize
	
	For Each bitext As Map In segments
		body.Append("        <tu>").Append(CRLF)
		Dim note As String
		note=bitext.Get("note")
		If note<>"" Then
			note=EscapeXml(note)
			body.Append($"            <note>${note}</note>"$).Append(CRLF)
		End If
		
		Dim source As String=bitext.Get("source")
		Dim target As String=bitext.Get("target")
		source=HandleTags(source,includeTags,useTMXTags)
		target=HandleTags(target,includeTags,useTMXTags)
		If useTMXTags=False Then
			source=EscapeXml(source)
			target=EscapeXml(target)
		End If
		body.Append($"            <tuv xml:lang="${sourceLang}">"$).Append(CRLF)
		body.Append($"                <seg>${source}</seg>"$).Append(CRLF)
		body.Append("            </tuv>").Append(CRLF)
		body.Append($"            <tuv xml:lang="${targetLang}">"$).Append(CRLF)
		body.Append($"                <seg>${target}</seg>"$).Append(CRLF)
		body.Append("            </tuv>").Append(CRLF)

		body.Append("        </tu>").Append(CRLF)
	Next

	File.WriteString(path,"",head&body.ToString&tail)
End Sub

Sub HandleTags(text As String,includeTags As Boolean,useTMXTags As Boolean) As String
	If includeTags Then
		If useTMXTags Then
			text=TagsConvertedXML(text)
		End If
	Else
		text=XMLUtils.TagsRemoved(text,False)
	End If
	Return text
End Sub

Sub TagsConvertedXML(text As String) As String
	text=XMLUtils.HandleXMLEntities(text,True)
	text=Regex.Replace2("`(&lt;.*?&gt;)`",32,text,"$1")
	Return convertToTMXTags(text)
End Sub


Sub convertToTMXTags(xml As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	Dim matcher As Matcher
	matcher=Regex.Matcher("</*(.*?)(\d+) */*>",xml)
	Dim previousEndIndex As Int=0
	Do While matcher.Find
		sb.Append(xml.SubString2(previousEndIndex,matcher.GetStart(0)))
		previousEndIndex=matcher.GetEnd(0)
		If matcher.Group(1).StartsWith("g") Then
			Dim id As Int
			id=matcher.Group(2)
			If matcher.match.Contains("/") Then
				sb.Append($"<ept i="${id}">"$)
				sb.Append(XMLUtils.EscapeXml(matcher.match))
				sb.Append("</ept>")
			Else
				sb.Append($"<bpt i="${id}">"$)
				sb.Append(XMLUtils.EscapeXml(matcher.match))
				sb.Append("</bpt>")
			End If
		Else If matcher.Group(1).StartsWith("x") Then
			sb.Append("<ph>")
			sb.Append(XMLUtils.EscapeXml(matcher.Match))
			sb.Append("</ph>")
		Else
			sb.Append(matcher.Match)
		End If
	Loop
	If previousEndIndex<>xml.Length-1 Then
		sb.Append(xml.SubString2(previousEndIndex,xml.Length))
	End If
	Return sb.ToString
End Sub

Public Sub EscapeXml(Raw As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To Raw.Length - 1
		Dim c As Char = Raw.CharAt(i)
		Select c
			Case QUOTE
				sb.Append("&quot;")
			Case "'"
				sb.Append("&apos;")
			Case "<"
				sb.Append("&lt;")
			Case ">"
				sb.Append("&gt;")
			Case "&"
				sb.Append("&amp;")
			Case Else
				sb.Append(c)
		End Select
	Next
	Return sb.ToString
End Sub
