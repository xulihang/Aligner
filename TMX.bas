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

Sub exportQuick(segments As List,sourceLang As String,targetLang As String,path As String)
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
		source=EscapeXml(source)
		target=EscapeXml(target)
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
