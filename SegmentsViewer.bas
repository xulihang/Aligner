B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private frm As Form
	Private editorLV As ListView
	Private project1 As Project
	Private mCurrentProject As Project
	Private mID As Int
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(segments As List,currentProject As Project,id As Int)
	frm.Initialize("frm",500,300)
	frm.RootPane.LoadLayout("editorLV")
	project1.Initialize(File.Combine(File.DirTemp,"temp"))
	project1.segments=segments
	project1.setProjectFileValue("langPair",currentProject.getProjectFileValue("langPair"))
	mCurrentProject=currentProject
	mID=id
	loadSegmentsToListView(segments)
End Sub

Public Sub Show
	frm.Show
End Sub

Sub loadSegmentsToListView(segments As List)
	editorLV.Items.Clear
	For Each segment As Map In segments
		Dim p As Pane
		p.Initialize("")
		p.LoadLayout("segment")
		Dim sourceTa,targetTa As TextArea
		sourceTa=p.GetNode(0)
		targetTa=p.GetNode(1)
		sourceTa.Text=segment.Get("source")
		targetTa.Text=segment.Get("target")
		editorLV.Items.Add(p)
	Next
	ListViewParent_Resize
End Sub

Sub ListViewParent_Resize
	Dim itemWidth As Double = editorLV.Width
	For i=0 To editorLV.Items.Size-1
		Dim p As Pane
		p=editorLV.Items.Get(i)
		Dim sourceTa As TextArea = p.GetNode(0)
		Dim targetTa As TextArea = p.GetNode(1)
		Dim sourcelbl,targetlbl As Label
		sourcelbl.Initialize("")
		targetlbl.Initialize("")
		sourcelbl.Font=fx.DefaultFont(16)
		targetlbl.Font=fx.DefaultFont(16)
		Dim sourceHeight,targetHeight As Int
		Dim sourceLineHeight As Int=Utils.MeasureMultilineTextHeight(sourcelbl.Font,itemWidth/2-20dip,CRLF)
		Dim targetLineHeight As Int=Utils.MeasureMultilineTextHeight(targetlbl.Font,itemWidth/2-20dip,CRLF)
		sourceHeight=Utils.MeasureMultilineTextHeight(sourcelbl.Font,itemWidth/2-20dip,sourceTa.Text)+sourceLineHeight
		targetHeight=Utils.MeasureMultilineTextHeight(targetlbl.Font,itemWidth/2-20dip,targetTa.Text)+targetLineHeight
		Dim h As Int = Max(Max(20, sourceHeight + 10), targetHeight + 10)
		setLayout(p,i,h)
	Next
End Sub


Public Sub setLayout(p As Pane,index As Int,h As Int)
	Dim itemwidth As Double
	itemwidth=editorLV.Width
	p.Left=0
	p.SetSize(itemwidth-40dip,h)
	Dim sourceTa As TextArea = p.GetNode(0)
	Dim targetTa As TextArea = p.GetNode(1)
	sourceTa.Left=0
	sourceTa.SetSize(itemwidth/2-20dip,h)
	targetTa.Left=itemwidth/2-20dip
	targetTa.SetSize(itemwidth/2-20dip,h)
End Sub

Sub frm_Resize (Width As Double, Height As Double)
	CallSubDelayed(Me,"ListViewParent_Resize")
End Sub

Sub SegmentButton_MouseClicked (EventData As MouseEvent)
	Dim srxfilePicker As SrxPicker
	srxfilePicker.Initialize
	Dim srxPath As String=srxfilePicker.ShowAndWait
	wait for (project1.loadSegmentsInSentenceLevel(srxPath)) Complete (temp As Object)
	loadSegmentsToListView(project1.segments)
End Sub

Public Sub SegmentInSilence As ResumableSub
	wait for (project1.loadSegmentsInSentenceLevel("")) Complete (temp As Object)
	Return ""
End Sub

Sub ReplaceButton_MouseClicked (EventData As MouseEvent)
	Replace
End Sub

Public Sub Replace
	Dim startIndex As Int=-1
	Dim new As List
	new.Initialize
	Dim index As Int=0
	For Each segment As Map In mCurrentProject.segments
		If segment.GetDefault("id",-1)=mID And startIndex=-1 Then
			IDReset(project1.segments,mID)
			new.AddAll(project1.segments)
			startIndex=index
		End If
		If segment.GetDefault("id",-1)<>mID Then
			new.Add(segment)
		End If
		index=index+1
	Next
	mCurrentProject.segments.Clear
	mCurrentProject.segments.AddAll(new)
	Main.loadSegmentsToListView(Null)
End Sub

Sub IDReset(segments As List,id As Int)
	For Each segment As Map In segments
		segment.Put("id",id)
	Next
End Sub
