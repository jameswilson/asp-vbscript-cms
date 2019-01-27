<%
const DAY_FIRST = 1
const MONTH_FIRST = 2
const UNKNOWN_FORMAT = 3
dim my_SHORT_DATE_FORMAT

'**
'* get the server's date format
'*
function ShortDateFormat()
	if my_SHORT_DATE_FORMAT = 0 then
		dim testDate : testDate = "01/02/1970 03:04:05"
		if cint(Day(testDate)) = 1 then
			my_SHORT_DATE_FORMAT = DAY_FIRST
			debugInfo("ShortDateFormat: day comes before month (dd/mm), eg " & Day(testDate) & " " & Monthname(Month(testDate)))
		elseif cint(Month(testDate)) = 1 then
			debugInfo("ShortDateFormat: month comes before day (mm/dd), eg " & Monthname(Month(testDate)) & " " & Day(testDate))
			my_SHORT_DATE_FORMAT = MONTH_FIRST
		end if
	end if
	ShortDateFormat = my_SHORT_DATE_FORMAT
end function


'**
'* Format the time for display as milliseconds
'*
function FormatMS(Value)
	FormatMS = FormatNumber(1000 * Value, 1)
end function

'**
'* Convert a regular date to a Unix Timestamp date.
'*
function UDate(oldDate)
	UDate = DateDiff("s", "01/01/1970 00:00:00", oldDate)
end function

'**
'* Return a formatted date given a Unix Timestamp or regular date
'*
'*    %A - AM or PM
'*    %a - am or pm
'*    %m - Month with leading zeroes (01 - 12)
'*    %n - Month without leading zeroes (1 - 12)
'*    %F - Month name (January - December)
'*    %M - Three letter month name (Jan - Dec)
'*    %d - Day with leading zeroes (01 - 31)
'*    %j - Day without leading zeroes (1 - 31)
'*    %H - Hour with leading zeroes (12 hour)
'*    %h - Hour with leading zeroes (24 hour)
'*    %G - Hour without leading zeroes (12 hour)
'*    %g - Hour without leading zeroes (24 hour)
'*    %i - Minute with leading zeroes (01 to 60)
'*    %I - Minute without leading zeroes (1 to 60)
'*    %s - Second with leading zeroes (01 to 60)
'*    %S - Second without leading zeroes (1 to 60)
'*    %L - Number of day of week (1 to 7)
'*    %l - Name of day of week (Sunday to Saturday)
'*    %D - Three letter name of day of week (Sun to Sat)
'*    %O - Ordinal suffix (st, nd rd, th)
'*    %U - UNIX Timestamp
'*    %Y - Four digit year (2003)
'*    %y - Two digit year (03)
'*
function formatDate(byval format,byval intTimeStamp)
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

	if (intTimeStamp=0) then
		unUDate = now()
	else
		unUDate = DateAdd("s", intTimeStamp, "01/01/1970 00:00:00")
	end if

	unUDate = trim(unUDate)

	dim startM : startM = InStr(1, unUDate, "/", vbTextCompare) + 1
	dim startY : startY = InStr(startM, unUDate, "/", vbTextCompare) + 1
	dim startHour : startHour = InStr(startY, unUDate, " ", vbTextCompare) + 1
	dim startMin : startMin = InStr(startHour, unUDate, ":", vbTextCompare) + 1

	dim dateDay : dateDay = leftPad(Day(unUDate),2,"0") 'mid(unUDate, 1, startM-2)  'had to fix this from 2 to startM-2
	dim dateMonth : dateMonth = leftPad(Month(unUDate),2,"0") 'mid(unUDate, startM, 2)
	dim dateYear : dateYear = Year(unUDate)'mid(unUDate, startY, 4)
	dim dateHour : dateHour = leftPad(Hour(unUDate),2,"0")'replace(mid(unUDate, startHour, 2), ":", "")
	dim dateMinute : dateMinute = leftPad(Minute(unUDate),2,"0") 'mid(unUDate, startMin, 2)
	dim dateSecond : dateSecond = leftPad(Second(unUDate),2,"0")'mid(unUDate, InStr(startMin, unUDate, ":", vbTextCompare) + 1, 2)

	trace( "date(" & unUDate & "): Month:" & dateMonth & "(" & monthname(dateMonth) & ") Day:" & dateDay & "")

	on error resume next
	format = replace(format, "%Y", right(dateYear, 4))
	format = replace(format, "%y", right(dateYear, 2))
	format = replace(format, "%m", dateMonth)
	format = replace(format, "%n", cint(dateMonth))
	format = replace(format, "%F", monthname(dateMonth,false))
	format = replace(format, "%M", left(monthname(dateMonth,true), 3))
	format = replace(format, "%d", dateDay)
	format = replace(format, "%j", cint(dateDay))
	format = replace(format, "%h", dateHour)
	format = replace(format, "%H", iif(dateHour>12, leftPad(dateHour-12,2,"0"),dateHour))
	format = replace(format, "%g", cint(replace(mid(unUDate, startHour, 2), ":", "")))
	format = replace(format, "%G", iif(dateHour>12, cint(dateHour-12),cint(dateHour)))
	trapError
	on error goto 0

	if (cint(dateHour) > 12) then
		A = "PM"
	else
		A = "AM"
	end if
	format = replace(format, "%A", A)
	format = replace(format, "%a", lcase(A))

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

'**
'* fill out the specified to the specified number of characters
'* by left padding the number with the specified character
'* @param str the string to add padding
'* @param expected length of the string, if its infact shorter
'* @return a string of the specified lenth, filled with the specified char
'*
private function leftPad(byval str,byval length,byval char)
	leftPad = str
	if len(cstr(str)) < cint(length) then
		leftPad = String(cint(length) - len(cstr(str)), char) & str
	end if
end function

function getRelativeDate(sDate)
	dim desc, amount, units, seconds, minutes, hours, days, months, years, nowDate

	if cDate(sDate) then
		nowDate = Now()
		sDate = cDate(sDate)
		if ShortDateFormat() = MONTH_FIRST then
			'American Variant
			desc = Pcase(formatDate("%M %j%O", sDate))
		else
			'International Version
			desc = Pcase(formatDate("%j %M", sDate))
		end if
		seconds = DateDiff("s", "" & sDate, "" & nowDate)
		minutes = DateDiff("n", "" & sDate, "" & nowDate)
		hours = DateDiff("h", "" & sDate, "" & nowDate)
		days = DateDiff("d", "" & sDate, "" & nowDate)
		months = DateDiff("m", "" & sDate, "" & nowDate)
		years = DateDiff("yyyy", "" & sDate, "" & nowDate)
		if minutes < 1 then
			amount = 0
			units = "moments"
			desc = "Today"
		elseif hours < 1 then
			amount = minutes
			units = "minute"
			desc = "Today"
		elseif days < 2 then
			amount = hours
			units = "hour"
			if days < 1 then
				desc = "Today"
			else
				desc = "Yesterday"
			end if
		elseif months < 1  then
			if days < 8 then
				amount = days
				units = "day"
			elseif days < 15 then
				amount = -1
				units = "last week"
			elseif days < 22 then
				amount = 3
				units = "week"
			elseif days < 31 then
				amount = 4
				units = "week"
			end if
		elseif years < 1 then
			amount = months
			units = "month"
		else
			desc = desc & ", " & year(sDate)
			amount = years
			units = "year"
		end if
		getRelativeDate = desc & " (" & iif(amount < 1, "",amount & " &nbsp;") & units & iif(amount > 1, "s", "") & iif(amount = -1,""," &nbsp;ago") & ")"
	else
		getRelativeDate = sDate
	end if
end function
%>
