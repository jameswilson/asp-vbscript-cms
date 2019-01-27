<%
'Format the time for display as milliseconds
function FormatMS(Value)
	FormatMS = FormatNumber(1000 * Value, 1)
end function

' Convert a regular date to a Unix Timestamp date.
function UDate(oldDate)
	UDate = DateDiff("s", "01/01/1970 00:00:00", oldDate)
end function
' return a formatted date given a Unix Timestamp or regular date
function formatDate(format, intTimeStamp)
' %A - AM or PM
' %a - am or pm
' %m - Month with leading zeroes (01 - 12)
' %n - Month without leading zeroes (1 - 12)
' %F - Month name (January - December)
' %M - Three letter month name (Jan - Dec)
' $d - Day with leading zeroes (01 - 31)
' %j - Day without leading zeroes (1 - 31)
' %H - Hour with leading zeroes (12 hour)
' %h - Hour with leading zeroes (24 hour)
' %G - Hour without leading zeroes (12 hour)
' %g - Hour without leading zeroes (24 hour)
' %i - Minute with leading zeroes (01 to 60)
' %I - Minute without leading zeroes (1 to 60)
' %s - Second with leading zeroes (01 to 60)
' %S - Second without leading zeroes (1 to 60)
' %L - Number of day of week (1 to 7)
' %l - Name of day of week (Sunday to Saturday)
' %D - Three letter name of day of week (Sun to Sat)
' %O - Ordinal suffix (st, nd rd, th)
' %U - UNIX Timestamp
' %Y - Four digit year (2003)
' %y - Two digit year (03)
	dim unUDate, A

	' Test to see if intTimeStamp looks valid. If not, they have passed a normal date
	if not (isnumeric(intTimeStamp)) then
		if isdate(intTimeStamp) then
			intTimeStamp = DateDiff("S", "01/01/1970 00:00:00", intTimeStamp)
		else
			debugError("Date.formatDate(): '" & intTimeStamp & "' is an invalid date format!")
		exit function
		end if
	end if

	if (intTimeStamp = 0) then
		unUDate = now()
	else
		unUDate = DateAdd("s", intTimeStamp, "01/01/1970 00:00:00")
	end if

	unUDate = trim(unUDate)

	dim startM : startM = InStr(1, unUDate, "/", vbTextCompare) + 1
	dim startY : startY = InStr(startM, unUDate, "/", vbTextCompare) + 1
	dim startHour : startHour = InStr(startY, unUDate, " ", vbTextCompare) + 1
	dim startMin : startMin = InStr(startHour, unUDate, ":", vbTextCompare) + 1

	dim dateDay : dateDay = mid(unUDate, 1, 2)
	dim dateMonth : dateMonth = mid(unUDate, startM, 2)
	dim dateYear : dateYear = mid(unUDate, startY, 4)
	dim dateHour : dateHour = replace(mid(unUDate, startHour, 2), ":", "")
	dim dateMinute : dateMinute = mid(unUDate, startMin, 2)
	dim dateSecond : dateSecond = mid(unUDate, InStr(startMin, unUDate, ":", vbTextCompare) + 1, 2)

	format = replace(format, "%Y", right(dateYear, 4))
	format = replace(format, "%y", right(dateYear, 2))
	format = replace(format, "%m", dateMonth)
	format = replace(format, "%n", cint(dateMonth))
	format = replace(format, "%F", monthname(cint(dateMonth)))
	format = replace(format, "%M", left(monthname(cint(dateMonth)), 3))
	format = replace(format, "%d", dateDay)
	format = replace(format, "%j", cint(dateDay))
	format = replace(format, "%h", mid(unUDate, startHour, 2))
	format = replace(format, "%g", cint(replace(mid(unUDate, startHour, 2), ":", "")))

	if (cint(dateHour) > 12) then
		A = "PM"
	else
		A = "AM"
	end if
	format = replace(format, "%A", A)
	format = replace(format, "%a", lcase(A))
	if (A = "PM") then format = replace(format, "%H", left("0" & dateHour - 12, 2 ))
	format = replace(format, "%H", dateHour)
	if (A = "PM") then format = replace(format, "%G", left("0" & cint(dateHour) - 12, 2))
	format = replace(format, "%G", cint(dateHour))
	format = replace(format, "%i", dateMinute)
	format = replace(format, "%I", cint(dateMinute))
	format = replace(format, "%s", dateSecond)
	format = replace(format, "%S", cint(dateSecond))
	format = replace(format, "%L", WeekDay(unUDate))
	format = replace(format, "%D", left(WeekDayName(WeekDay(unUDate)), 3))
	format = replace(format, "%l", WeekDayName(WeekDay(unUDate)))
	format = replace(format, "%U", intTimeStamp)
	format = replace(format, "11%O", "11th")
	format = replace(format, "1%O", "1st")
	format = replace(format, "12%O", "12th")
	format = replace(format, "2%O", "2nd")
	format = replace(format, "13%O", "13th")
	format = replace(format, "3%O", "3rd")
	format = replace(format, "%O", "th")

	formatDate = format

end function
%>
