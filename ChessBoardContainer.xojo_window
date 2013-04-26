#tag Window
Begin ContainerControl ChessBoardContainer
   AcceptFocus     =   False
   AcceptTabs      =   False
   AutoDeactivate  =   True
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   Compatibility   =   ""
   Enabled         =   True
   EraseBackground =   True
   HasBackColor    =   False
   Height          =   300
   HelpTag         =   ""
   InitialParent   =   ""
   Left            =   0
   LockBottom      =   False
   LockLeft        =   False
   LockRight       =   False
   LockTop         =   False
   TabIndex        =   0
   TabPanelIndex   =   0
   TabStop         =   True
   Top             =   0
   Transparent     =   True
   UseFocusRing    =   False
   Visible         =   True
   Width           =   300
   Begin Label SolutionLabel
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   10
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      Text            =   "Solution #"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   0
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   270
   End
   Begin Canvas ChessBoard
      AcceptFocus     =   False
      AcceptTabs      =   False
      AutoDeactivate  =   True
      Backdrop        =   0
      DoubleBuffer    =   False
      Enabled         =   True
      EraseBackground =   False
      Height          =   264
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   25
      Transparent     =   True
      UseFocusRing    =   True
      Visible         =   True
      Width           =   264
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h0
		Sub CreateChessboard(boardSize As Integer)
		  mBoardSize = boardSize
		  
		  ChessBoard.Refresh(False)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawBoard(b(,) As String)
		  Board = b
		  
		  ChessBoard.Refresh(False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Text(Assigns t As String)
		  SolutionLabel.Text = t
		  SolutionLabel.Refresh
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Board(-1,-1) As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBoardSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mChessBoardSquareCount As Integer
	#tag EndProperty


#tag EndWindowCode

#tag Events ChessBoard
	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  // Draw background
		  Dim rowWidth As Integer = g.Height \ mBoardSize
		  Dim colWidth As Integer = g.Width \ mBoardSize
		  
		  g.ForeColor = &c000000
		  For row As Integer = 1 To mBoardSize
		    For col As Integer = 1 To mBoardSize
		      g.ForeColor = &cffffff
		      If row Mod 2 = 0 Then
		        If col Mod 2 = 0 Then
		          g.ForeColor = &ccccccc
		        End If
		      Else
		        If col Mod 2 <> 0 Then
		          g.ForeColor = &ccccccc
		        End If
		      End If
		      g.FillRect((col-1)*rowWidth, (row-1)*colWidth, rowWidth, colWidth)
		    Next
		  Next
		  
		  For col As Integer = 1 To Ubound(Board, 1)
		    For row As Integer = 1 To Ubound(Board, 2)
		      If Board(row, col) = "Q" Then
		        'g.DrawPicture(star, (col-1)*rowWidth + (rowWidth-star.Width)\2, (row-1)*colWidth + (colWidth-star.Width)\2)
		        g.DrawPicture(star, (col-1)*rowWidth, (row-1)*colWidth, rowWidth, colWidth, 0, 0, star.Width, star.Height)
		      End If
		    Next
		  Next
		  
		End Sub
	#tag EndEvent
#tag EndEvents
