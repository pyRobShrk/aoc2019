VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "IntCode"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Class Module for running Advent of Code 2019's IntCode in Excel
' IntCode is read in and modified as a Range beginning in A1
' Each time a value in the IntCode changes, it makes a copy on the next row

Private homeCell As Range
Private relativeBase As LongLong
Public halt As Boolean
Private i As LongLong

Private Sub Class_Initialize()
    halt = False
    relativeBase = 0
    i = 0
End Sub

Public Sub Load(Program As Range)
    Program.Offset(1, 0).Value = Program.Value 'Make a Copy
    Set homeCell = Program.Cells(1)
    Range(homeCell.End(xlToRight).Offset(0, 1), homeCell.End(xlToRight).End(xlToRight).Offset(1, 0)).Value = 0
End Sub

Private Function getItem(n As LongLong) As LongLong
    getItem = homeCell.Offset(0, n).End(xlDown).Value
End Function

Private Function setItem(n As LongLong) As Range
    Set setItem = homeCell.Offset(0, n).End(xlDown).Offset(1, 0)
End Function

Public Function Run(Optional inVal) As LongLong
    Dim p1 As LongLong
    Dim p2 As LongLong
    Dim p3 As LongLong
    Dim opCode As LongLong
    
    Do While Not getItem(i) = 99
        opCode = getItem(i)
        p1 = getItem(i + 1)
        p2 = getItem(i + 2)
        p3 = getItem(i + 3)
        
        'Parameter Three Mode
        If opCode > 20000 Then
            opCode = opCode - 20000
            p3 = p3 + relativeBase
        End If
        
        'Parameter Two Mode
        If opCode > 1000 Then
            opCode = opCode - 1000
            If opCode > 1000 Then
                opCode = opCode - 1000
                p2 = getItem(relativeBase + p2)
            End If
        ElseIf InStr(1, Right(str(opCode), 1), "349") Then
            p2 = getItem(p2)
        End If
        
        'Parameter One Mode
        If opCode > 100 Then
            opCode = opCode - 100
            If opCode > 100 Then
                opCode = opCode - 100
                If Not opCode = 3 Then
                    p1 = getItem(relativeBase + p1)
                Else
                    p1 = relativeBase + p1
                End If
            End If
        ElseIf Not opCode = 3 Then
            p1 = getItem(p1)
        End If
        
        Select Case opCode
            Case 1
                setItem(p3).Value = p1 + p2
            Case 2
                setItem(p3).Value = p1 * p2
            Case 7
                If p1 < p2 Then
                    setItem(p3).Value = 1
                Else
                    setItem(p3).Value = 0
                End If
            Case 8
                If p1 = p2 Then
                    setItem(p3).Value = 1
                Else
                    setItem(p3).Value = 0
                End If
            Case 3
                If inVal Is Nothing Then
                    setItem(p1).Value = Int(InputBox("Input:"))
                Else
                    setItem(p1).Value = inVal
                    inVal = Nothing
                End If
            Case 4
                i = i + 2
                Run = p1
            Case 5
                If Not p1 = 0 Then
                    i = p2
                Else
                    i = i + 3
                End If
            Case 6
                If p1 = 0 Then
                    i = p2
                Else
                    i = i + 3
                End If
            Case 9
                relativeBase = relativeBase + p1
        End Select
        Select Case opCode
            Case 1, 2, 7, 8
                i = i + 4
            Case 3, 9
                i = i + 2
        End Select
    Loop
    halt = True
End Function
