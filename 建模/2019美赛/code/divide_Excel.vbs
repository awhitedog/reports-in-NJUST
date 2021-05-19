Sub divide() 
Dim I As Long, J As Long, S As String
Dim Str As String, xlbook As Workbook
Dim N As Long, R As Long, M As Long
Application.ScreenUpdating = False
Application.DisplayAlerts = False
For I = 1 To Range("F65536").End(xlUp).Row
Str = Range("F" & I).Text
If InStr(S, Str) = 0 And Str <> "" Then
S = S & Str & " "
N = N + 1
Workbooks.Add xlWBATWorksheet
Rows(I).Copy ActiveSheet.Rows(N)
R = Range("F:F").Find(Range("F" & I)).Row
M = R
Do
R = Range("F:F").FindNext(Range("F" & R)).Row
If R = M Then Exit Do
N = N + 1
Rows(R).Copy ActiveSheet.Rows(N)
Loop
ActiveWorkbook.SaveAs "C:\Users\25467\Desktop\ICM\51\" & Str & ".XLSX" 
ActiveWorkbook.Close
N = 0
Str = ""
End If
Next
Application.ScreenUpdating = True
Application.DisplayAlerts = True
End Sub