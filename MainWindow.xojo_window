#tag Window
Begin Window MainWindow
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Compatibility   =   ""
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   400
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   692872940
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   False
   Title           =   "8 Queens Solution"
   Visible         =   True
   Width           =   334
   Begin PushButton SolveButton
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
      Cancel          =   False
      Caption         =   "Solve"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   362
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin Label StaticText1
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
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   3
      TabPanelIndex   =   0
      Text            =   "Board Size:"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   319
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   100
   End
   Begin TextField BoardSizeField
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   121
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   317
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   80
   End
   Begin ChessBoardContainer ChessBoard
      AcceptFocus     =   False
      AcceptTabs      =   False
      AutoDeactivate  =   True
      BackColor       =   &cFFFFFF00
      Backdrop        =   0
      Enabled         =   True
      EraseBackground =   True
      HasBackColor    =   False
      Height          =   300
      HelpTag         =   ""
      InitialParent   =   ""
      Left            =   14
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   10
      Transparent     =   True
      UseFocusRing    =   False
      Visible         =   True
      Width           =   300
   End
   Begin CheckBox PauseCheck
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Pause after each solution"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   121
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      State           =   1
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   362
      Underline       =   False
      Value           =   True
      Visible         =   True
      Width           =   193
   End
   Begin Timer ChessBoardUpdateTimer
      Height          =   32
      Index           =   -2147483648
      Left            =   -9
      LockedInPosition=   False
      Mode            =   0
      Period          =   50
      Scope           =   0
      TabPanelIndex   =   0
      Top             =   481
      Width           =   32
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  BoardSizeField.Text = Str(kDefaultBoardSize)
		  
		  ChessBoard.CreateChessboard(kDefaultBoardSize)
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h21
		Private mEightQueens As EightQueensThread
	#tag EndProperty


	#tag Constant, Name = kDefaultBoardSize, Type = Double, Dynamic = False, Default = \"8", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events SolveButton
	#tag Event
		Sub Action()
		  mEightQueens = New EightQueensThread
		  mEightQueens.Priority = Thread.LowestPriority
		  
		  Dim boardSize As Integer
		  boardSize = Val(BoardSizeField.Text)
		  
		  ChessBoard.CreateChessboard(boardSize)
		  
		  mEightQueens.WatchSolutions = PauseCheck.Value
		  mEightQueens.BoardSize = boardSize
		  mEightQueens.Run
		  
		  ChessBoardUpdateTimer.Mode = Timer.ModeMultiple
		  ChessBoardUpdateTimer.Enabled = True
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ChessBoardUpdateTimer
	#tag Event
		Sub Action()
		  If mEightQueens.State = Thread.Suspended Then
		    // Display a solution
		    ChessBoard.DrawBoard(mEightQueens.ChessBoard)
		    ChessBoard.Text = "Solution #" + Str(mEightQueens.SolutionNumber)
		    
		    // If that was the last solution then stop and display totals and times
		    If mEightQueens.Finished Then
		      ChessBoard.Text = (Str(mEightQueens.SolutionNumber) + " solutions found.") // in " + Format((Ticks-start)/60, "##0.000") + " seconds")
		      
		      Me.Enabled = False
		      
		      mEightQueens.Kill
		    Else
		      // Otherwise, restart thread after a short delay
		      App.SleepCurrentThread(500)
		      mEightQueens.Resume
		    End If
		  Else
		    // Update the chess board
		    ChessBoard.DrawBoard(mEightQueens.ChessBoard)
		  End If
		  
		End Sub
	#tag EndEvent
#tag EndEvents
