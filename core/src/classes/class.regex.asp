<%
'**
'* @file
'*   A custom implementation of the RegExp system object.
'*
'*   The RegularExpression class encapsulates RegExp VBScript system object in
'*   an accessible, easy-to-use, interface.
'*

'!!
'! @class RegluarExpression
'!
'! The RegularExpression class provides a an enhanced and simplified interface
'! for regular expressions by wrapping the RegExp VBScript system object in a
'! custom encapsulation that permit one-line function calls for what normally
'! takes three to four lines of code.
'!
'!
'! Example:
'!
'!   Strip HTML from a string, in regular VBScript.
'!
'!
'! \code
'! dim html_string : html_string = "<p align=center><i>Hello World!</i></p>"
'! dim html_regex : set html_regex = new RegExp
'! html_regex.pattern = "<[^>]+>"
'! html_regex.global = TRUE
'! html_regex.ignorecase = TRUE
'! plain_text = html_regex.replace("")
'! \endcode
'!
'!   Strip HTML from a string, using the RegularExpression class.
'!
'! \code
'! dim html_string : html_string = "<p align=center><i>Hello World!</i></p>"
'! dim regex : set regex = new RegularExpression
'! plain_text = regex.replace(regex.HTML_TAGS, html_string, "")
'! \endcode
'!
'!
'! Note that while RegExp.IgnoreCase defaults to TRUE, our class defaults
'! to FALSE, so to perform a case-insensitive search use the case-insensitive
'! functions:
'!            ireplace, ireplace_first, itest and imatch
'!
'! RegularExpression class implements all of the regular RegExp object's methods
'! however, note that the RegExp.Execute() function has been implemented as:
'! RegularExpression.match() and RegularExpression.imatch() for case-sensitive
'! and case-insensitive pattern matching (respectively).
'!
class RegularExpression

	'**
	'* The class' internal RegExp object.
	private m_regex

	'**
	'* TODO: determine if VBScript supports public constants, and convert this
	'* to one line if possible (eg public const HTML_TAGS = "<[^>]+>")
	public property get HTML_TAGS
		HTML_TAGS = "<[^>]+>"
	end property

	'**
	'* Constructor initializes a RegExp object.
	public function class_initialize
		set m_regex = new RegExp
		reset
	end function

	'**
	'* Clear the regular expression and re-instantiate the object.
	public function reset
		' While RegExp.IgnoreCase defaults to TRUE, our class defaults to FALSE.
		' if you want case-insensitive search use ireplace,  ireplace_first,
		' itest and imatch
		m_regex.ignorecase = FALSE

		' RegExp.Global defaults to TRUE, this makes it explicit.
		m_regex.global = TRUE
	end function

	'**
	'* A case-sensitive global search and replace.
	'*
	'* This function searchs the provided string for the specified pattern,
	'* replacing all matches with the provided substitution string.
	'*
	'* @param subject (string)
	'*   The string to search.
	'*
	'* @param pattern (string)
	'*   A regular expression used for pattern matching. This pattern is case-
	'*   sensitive.
	'*
	'* @param substitution (string)
	'*   The value by which all matched patterns are replaced.
	'*
	'* @return (string)
	'*   The subject string with all matching patterns replaced.
	'*
	'* @see RegExp.replace()
	'* TODO: determine if replace supports backreferences and provide example.
	public function replace(subject, pattern, substitution)
		m_regex.pattern = pattern
		replace = m_regex.replace(subject, substitution)
		this.reset
	end function

	'**
	'* A Case-insensitive global search and replace.
	'*
	'* This function searches the provided string for the specified pattern,
	'* replacing all matches with the specified substitution string.
	'*
	'* @param subject (string)
	'*   The string to search.
	'*
	'* @param pattern (string)
	'*   A regular expression used for pattern matching. This pattern is case-
	'*   insensitive.
	'*
	'* @param substitution (string)
	'*   The value by which all matched patterns are replaced.
	'*
	'* @return (string)
	'*   The subject string with all matching patterns replaced.
	'*
	'* @see RegExp.replace()
	'* TODO: determine if replace supports backreferences and provide example.
	public function ireplace(subject, pattern, substitution)
		m_regex.pattern = pattern
		m_regex.ignorecase = TRUE
		ireplace = this.replace(subject, pattern, substitution)
	end function

	'**
	'* A case-sensitive global search and replace.
	'*
	'* This function searchs the provided string for the specified pattern,
	'* replacing the first matching instance with the provided substitution.
	'*
	'* @param subject (string)
	'*   The string to search.
	'*
	'* @param pattern (string)
	'*   A regular expression used for pattern matching. This pattern is case-
	'*   sensitive.
	'*
	'* @param substitution (string)
	'*   The value by which all matched patterns are replaced.
	'*
	'* @return (string)
	'*   The subject string with all matching patterns replaced.
	'*
	'* @see RegExp.replace()
	'* TODO: determine if replace supports backreferences and provide example.
	public function replace_first(subject, pattern, substitution)
		m_regex.pattern = pattern
		m_regex.global = FALSE
		replace_first = m_regex.replace(subject, substitution)
		this.reset
	end function

	'**
	'* A case-insensitive search and replace.
	'*
	'* This function searches the provided string for the specified pattern,
	'* replacing the first matching instance with the specified substitution.
	'*
	'* @param subject (string)
	'*   The string to search.
	'*
	'* @param pattern (string)
	'*   A regular expression used for pattern matching. This pattern is case-
	'*   insensitive.
	'*
	'* @param substitution (string)
	'*   The value by which all matched patterns are replaced.
	'*
	'* @return (string)
	'*   The subject string with all matching patterns replaced.
	'*
	'* @see RegExp.replace()
	'* TODO: determine if replace supports backreferences and provide example.
	public function ireplace_first(subject, pattern, substitution)
		m_regex.ignorecase = TRUE
		ireplace_first = this.replace_first(subject, pattern, substitution)
	end function

	'**
	'* A simple case-sensitive query that returns TRUE if the specified
	'* regular expression was matched in the provided string.
	'*
	'* @param subject (string)
	'*   The string to search.
	'*
	'* @param pattern (string)
	'*   A regular expression used for pattern matching.
	'*
	'* @return (bool)
	'*   Returns TRUE if and only if the pattern was found in the provided
	'*   subject string.
	'*
	'* @see RegExp.Test
	public function test(pattern, subject)
		m_regex.pattern = pattern
		test = m_regex.test(subject)
		this.reset
	end function

	'**
	'* A simple case-insensitive query that returns TRUE if the specified
	'* regular expression was matched in the provided string.
	'*
	'* @param subject (string)
	'*   The string to search.
	'*
	'* @param pattern (string)
	'*   A regular expression used for pattern matching.
	'*
	'* @return (bool)
	'*   Returns TRUE if and only if the pattern was found in the provided
	'*   subject string.
	'*
	'* @see RegExp.Test
	public function itest(pattern, subject)
		m_regex.ignorecase = TRUE
		itest = this.test(pattern, subject)
	end function
	
	'**
	'* An enhanced implementation of RegExp.Execute(). This function executes
	'* a regular expression returning a collection of all matching instances
	'* within the provided subject string. With the colleciton you can count 
	'* the number of matches found and at which position in the string the 
	'* match(es) were made.
	'*
	'* @param subject (string)
	'*   The string to search.
	'*
	'* @param pattern (string)
	'*   A regular expression used for pattern matching. This expression is
	'*   case-sensitive.
	'*
	'* @return (collection)
	'*   Returns a collection of each matched instance of the provided pattern.
	'*
	'* @usage
	'* \code
	'* matches = regex.match("Th\w+", "This & That")
	'* writeln("Found "& matches.count & " matches.<br />")
	'* for each match in matches
	'*     writeln(expressionmatched.Value _
	'*         & " was matched at position " _
	'*         & expressionmatched.FirstIndex _
	'*         & "<br />")
	'* end for
	'* \endcode
	'*
	'* @see RegExp.Execute
	public function match(pattern, subject)
		m_regex.pattern = pattern
		match = m_regex.execute(subject)
		this.reset
	end function
	'**
	'* An enhanced implementation of RegExp.Execute(). This function executes
	'* a regular expression returning a collection of all matching instances
	'* within the provided subject string. With the colleciton you can count 
	'* the number of matches found and at which position in the string the 
	'* match(es) were made.
	'*
	'* @param subject (string)
	'*   The string to search.
	'*
	'* @param pattern (string)
	'*   A regular expression used for pattern matching. This expression is
	'*   case-insensitive.
	'*
	'* @return (collection)
	'*   Returns a collection of each matched instance of the provided pattern.
	'*
	'* @usage
	'* \code
	'* matches = regex.match("Th\w+", "This & That")
	'* writeln("Found "& matches.count & " matches.<br />")
	'* for each match in matches
	'*     writeln(expressionmatched.Value _
	'*         & " was matched at position " _
	'*         & expressionmatched.FirstIndex _
	'*         & "<br />")
	'* end for
	'* \endcode
	'*
	'* @see RegExp.Execute
	public function imatch(pattern, subject)
		m_regex.ignorecase = TRUE
		imatch = this.match(pattern, subject)
	end function
end class
