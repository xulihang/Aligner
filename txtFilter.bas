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

Sub getBitext(path As String) As Map
	Dim text As String=readTxt(path)
	Return Utils.getBitext(text)
End Sub


Sub shouldAddSpace(sourceLang As String,targetLang As String,index As Int,segmentsList As List) As Boolean
	Dim bitext As List=segmentsList.Get(index)
	Dim fullsource As String=bitext.Get(2)
	If Utils.LanguageHasSpace(sourceLang)=False And Utils.LanguageHasSpace(targetLang)=True Then
		If index+1<=segmentsList.Size-1 Then
			Dim nextBitext As List
			nextBitext=segmentsList.Get(index+1)
			Dim nextfullsource As String=nextBitext.Get(2)
			If fullsource.EndsWith(CRLF)=False And nextfullsource.StartsWith(CRLF)=False Then
				Try
					If Regex.IsMatch("\s",nextfullsource.CharAt(0))=False And Regex.IsMatch("\s",fullsource.CharAt(fullsource.Length-1))=False Then
						Return True
					End If
				Catch
					Log(LastException)
				End Try
			End If
		End If
	End If
	Return False
End Sub