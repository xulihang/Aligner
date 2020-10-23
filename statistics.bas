B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=6.51
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private sourceLang,targetLang As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(langPair As Map)
	sourceLang=langPair.Get("source")
	targetLang=langPair.Get("target")
End Sub

Public Sub MsgBox(frm As Form,segments As List)
	Dim sourceWords As Int
	Dim targetWords As Int
	For Each segment As Map In segments
		Dim source,target As String
		source=segment.Get("source")
		target=segment.Get("target")
		sourceWords=sourceWords+calculateWords(source,sourceLang)
		targetWords=targetWords+calculateWords(target,targetLang)
	Next
	Dim sb As StringBuilder
	sb.Initialize
	sb.Append("source: ").Append(sourceWords).Append(" words")
	sb.Append(CRLF)
	sb.Append("target: ").Append(targetWords).Append(" words")
	sb.Append(CRLF)
	sb.Append("source/target: ").Append(sourceWords/targetWords)
	sb.Append(CRLF)
	sb.Append("target/source: ").Append(targetWords/sourceWords)
	fx.Msgbox(frm,sb.ToString,"")
End Sub

Public Sub TargetSourceRatio(segments As List) As Double
	Dim sourceWords As Int
	Dim targetWords As Int
	For Each segment As Map In segments
		Dim source,target As String
		source=segment.Get("source")
		target=segment.Get("target")
		sourceWords=sourceWords+calculateWords(source,sourceLang)
		targetWords=targetWords+calculateWords(target,targetLang)
	Next
	Return targetWords/sourceWords
End Sub

Public Sub TargetSourceRatio2(source As String,target As String) As Double
	Dim sourceWords As Int
	Dim targetWords As Int
	sourceWords=calculateWords(source,sourceLang)
	targetWords=calculateWords(target,targetLang)
	Return targetWords/sourceWords
End Sub

Public Sub calculateWords(text As String,lang As String) As Int
	If Utils.LanguageHasSpace(lang) Then
		If lang.StartsWith("ko") Then
			Return calculateHanzi(text)
		End If
		Return calculateWordsForLanguageWithSpace(text)
	Else
		Return calculateHanzi(text)
	End If
End Sub

Sub calculateWordsForLanguageWithSpace(text As String) As Int
	text=TagRemoved(text)
	text=Regex.Replace(" +",text," ")
	Return Regex.Split(" ",text).Length
End Sub

Sub calculateHanzi(text As String) As Int
	text=TagRemoved(text)
	text=Regex.Replace("[\x00-\x19\x21-\xff]+",text,"字") 'Replace English words to Hanzi
	text=text.Replace(" ","")
	Return text.Length
End Sub

Sub TagRemoved(text As String) As String
	text=Regex.Replace2("<.*?>",32,text,"")
	Return text
End Sub

