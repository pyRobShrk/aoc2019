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
' Design Philosophy: Avoid 32-Bit Long Integer overflow by allowing dynamic typing in Excel/VBA
' Avoid ReDimming Arrays by Using Cells to read/write int codes
' Take advantage of Excel functionality whenever possible

Private runSheet As Worksheet
Private relBase As Single
Private i As Single
Public Halt As Boolean

Private Sub Class_Initialize()
    Halt = False
    relBase = 0
    i = 0
End Sub

Public Sub Load(Program As Range)
    Set runSheet = Program.Parent
    hasI = False
    hasBase = False
    
    For Each nm In runSheet.Names
        If nm.Name = runSheet.Name & "!_i" Then
            i = [_i]
            hasI = True
        ElseIf nm.Name = runSheet.Name & "!_base" Then
            relBase = [_base]
            hasBase = True
        End If
    Next nm
    
    If Not hasI Then
        runSheet.Names.Add "_i", "=0"
    End If
    
    If Not hasBase Then
        runSheet.Names.Add "_base", "=0"
    End If
End Sub

Private Function Item(n As Single) As Range
    Set Item = runSheet.Cells(n + 1)
End Function

Public Function Run(Optional inVal) As Double
Application.ScreenUpdating = False
    Dim p1 As Variant
    Dim p2 As Variant
    Dim p3 As Variant
    Dim opCode As Integer
    
    Do Until Int(Item(i)) = 99
        opCode = Int(Item(i))
        Set p1 = Item(i + 1)
        Set p2 = Item(i + 2)
        Set p3 = Item(i + 3)
        
        'Parameter Three Mode
        If opCode > 20000 Then
            opCode = opCode - 20000
            p3 = CSng(p3) + relBase
        End If
        
        'Parameter Two Mode
        If opCode > 1000 Then 'Immediate Mode
            opCode = opCode - 1000
            If opCode > 1000 Then 'Relative Mode
                opCode = opCode - 1000
                Set p2 = Item(CSng(p2) + relBase)
            End If
        ElseIf Not CBool(InStr(1, "349", Right(Str(opCode), 1))) Then 'Position Mode
            Set p2 = Item(CSng(p2))
        End If
        
        'Parameter One Mode
        If opCode > 100 Then 'Immediate Mode
            opCode = opCode - 100
            If opCode > 100 Then 'Relative Mode
                opCode = opCode - 100
                If opCode = 3 Then
                    p1 = CSng(p1) + relBase
                Else
                    Set p1 = Item(CSng(p1) + relBase)
                End If
            End If
        ElseIf Not opCode = 3 Then 'Position Mode
            Set p1 = Item(CSng(p1))
        End If
        
        If p1 = "" Then p1 = 0
        If p2 = "" Then p2 = 0
        If p3 = "" Then p3 = 0
        
        Select Case opCode
            Case 1 'Addition
                Item(CSng(p3)) = p1 + p2
            Case 2 'Multiplication
                Item(CSng(p3)) = p1 * p2
            Case 3 'Input
                Item(CSng(p1)) = inVal
            Case 4 'Output
                i = i + 2
                Run = p1
                runSheet.Names("_i").RefersTo = "=" & i
                Exit Function
            Case 5, 6 'Goto
                isZero = p1 = 0
                If opCode = 5 Then isZero = Not isZero
                If isZero Then
                    i = CSng(p2)
                Else
                    i = i + 3
                End If
            Case 7 'Less Than
                Item(CSng(p3)) = Abs(CSng(p1 < p2))
            Case 8 'Equal To
                Item(CSng(p3)) = Abs(CSng(p1 = p2))
            Case 9 'Relative Address
                relBase = relBase + CSng(p1)
                runSheet.Names("_base").RefersTo = "=" & relBase
            Case Else
                Debug.Print opCode
                Exit Function
        End Select
        
        Select Case opCode
            Case 1, 2, 7, 8
                i = i + 4
            Case 3, 9
                i = i + 2
        End Select
        
    Loop
    Halt = True
Application.ScreenUpdating = True
End Function
