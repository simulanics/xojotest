#tag Class
Protected Class EightQueensThread
Inherits Thread
	#tag Event
		Sub Run()
		  Solve
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub Backup(ByRef row As Integer, ByRef column As Integer)
		  // Go back one column and try the next row
		  // If the next row is higher than the board size
		  // then we go back another column.
		  // If we reach column 0 then we've found all the solutions.
		  Do
		    column = column - 1
		    
		    If column > 0 Then
		      // Clear the current column settings since we've just
		      // removed the queen.
		      row = mPicked(column)
		      ChessBoard(row, column) = ""
		      mPicked(column) = 0
		      mRowCheck(row) = False
		      mDiagonalSum(column+row) = False
		      mDiagonalDifference(column-row+mDiagonalArrayOffset) = False
		      
		      // Try the next row
		      row = row + 1
		    End If
		  Loop Until row <= mBoardSize Or column = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ControlBackups(ByRef row As Integer, ByRef column As Integer, ByRef isFound As Boolean)
		  // If we've reached the size of the board and have a solution
		  // then show it
		  If column = mBoardSize And isFound Then
		    DisplaySolution
		    isFound = False
		    column = mBoardSize + 1
		    Backup(row, column)
		  Else
		    // We've reached the end of the board and have no more
		    // room for queens.  It's time to back up and
		    // try again.
		    If row > mBoardSize Then
		      Backup(row, column)
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DisplaySolution()
		  mSolutionNumber = mSolutionNumber + 1
		  
		  If WatchSolutions Then Self.Suspend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub FindSolutions()
		  Dim start As Integer = 1
		  Dim solutionNumber As Integer
		  Dim row As Integer
		  Dim column As Integer
		  
		  Dim isFound As Boolean
		  Dim allDone As Boolean
		  
		  // Start with the upper left corner of the chessboard
		  mPicked(1) = start
		  mRowCheck(start) = True
		  mDiagonalSum(1+start) = True
		  mDiagonalDifference(1-start+mDiagonalArrayOffset) = True
		  
		  // We can immediately start with column 2 since we've already placed
		  // queen in column 1
		  column = 2
		  
		  Do
		    row = 1
		    Do
		      If WatchSolutions Then
		        #If TargetMacOS Then
		          App.SleepCurrentThread(1)
		        #Endif
		      End If
		      
		      isFound = False
		      
		      If column > 0 Then
		        // If there is no queen on the same row or diagonal for this column
		        // and row then we can try a queen here.
		        If Not mRowCheck(row) And Not mDiagonalSum(column+row) And _
		          Not mDiagonalDifference(column-row+mDiagonalArrayOffset) Then
		          
		          isFound = True
		          mRowCheck(row) = True
		          ChessBoard(row, column) = "Q"
		          mDiagonalSum(column+row) = True
		          mDiagonalDifference(column-row+mDiagonalArrayOffset) = True
		          mPicked(Column) = row
		        Else
		          // Try the next row in the column
		          row = row + 1
		        End If
		        
		        // We need to backup if we've reached beyond the last row
		        ControlBackups(row, column, isFound)
		      Else
		        isFound = True
		        allDone = True
		      End If
		    Loop Until isFound
		    
		    column = column + 1
		    
		  Loop Until allDone
		  
		  mFinished = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Solve()
		  mBoardSize = boardSize
		  mDiagonalArrayOffset = mBoardSize-1
		  
		  ReDim mPicked(mBoardSize)
		  ReDim mRowCheck(mBoardSize)
		  ReDim mDiagonalDifference(mBoardSize*2)
		  ReDim mDiagonalSum(mBoardSize*2)
		  ReDim ChessBoard(mBoardSize, mBoardSize)
		  
		  ChessBoard(1, 1) = "Q"
		  
		  FindSolutions
		  
		  Self.Suspend
		End Sub
	#tag EndMethod


	#tag Note, Name = About the 8 Queens Problem
		The 8 Queens Problem is a common challenge given to first year computer science students.
		
		On a chessboard (which is an 8x8 grid) there are a finite number of ways that 8 queens
		can be placed.  If you don't know chess, a queen can move any number of spaces in
		any direction, horizontal, vertical and diagonal.  There are 92 possible ways
		to place 8 queens on a standard 8x8 chessboard chessboard.
		
		This program uses a brute-force algorithm to repeatedly try solutions until it finds all 92.
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBoardSize
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mBoardSize = value
			End Set
		#tag EndSetter
		BoardSize As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		ChessBoard(8,8) As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mFinished
			End Get
		#tag EndGetter
		Finished As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mBoardSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDiagonalArrayOffset As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			The DiagonalDifference array tracks squares on the board from a upper left to lower right diagonal.
			
			It works the same way as the DiagonalSum, but we instead take the difference of the column and row.
			Note that this results in a negative number for many squares and since REALbasic does not allow
			negative values for array indices, we simple offset it by 7.
		#tag EndNote
		Private mDiagonalDifference(16) As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			The DiagonalSum array identifes all the squares on the board that are on a lower-left to to right diagonal.
			
			For example, look at column 2, row 4.  It's sum (column+row) is 6.  Now also look at column 5, row 1.  It is on the diagonal
			for column 2, row 4.  And it's sum is also 6.  So when we find a place to put a Queen, we also set
			the DiagonalSum value to True.  This allows us to quickly find diagonal "hits" for future possible positions.
			
			1 2 3 4 5 6 7 8
			1 + + + + + + + +
			2 + + + + + + + +
			3 + + + + + + + +
			4 + + + + + + + +
			5 + + + + + + + +
			6 + + + + + + + +
			7 + + + + + + + +
			8 + + + + + + + +
		#tag EndNote
		Private mDiagonalSum(16) As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			Indicates whether solutions should be displayed.
		#tag EndNote
		Private mDisplay As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFinished As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			The Picked array identifies the row containing a Queen for each column on the board.
			
			Picked(2) = 6 indicates the the Queen is on row 6 in column 2.
		#tag EndNote
		Private mPicked(8) As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			The RowCheck array contains a value of True if a Queen was placed in the row.
			Otherwise it is False.
			
			If a Queen is in a row then we can immediately move to the next row.
		#tag EndNote
		Private mRowCheck(8) As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSolutionNumber As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mSolutionNumber
			End Get
		#tag EndGetter
		SolutionNumber As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		WatchSolutions As Boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="BoardSize"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Priority"
			Visible=true
			Group="Behavior"
			InitialValue="5"
			Type="Integer"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SolutionNumber"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StackSize"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WatchSolutions"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
