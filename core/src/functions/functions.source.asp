<script language="javascript" runat="server">
/*
Function: getFormatAspJsHtmlAdoSource()
Description: Syntax-highlight code and script through CSS and simply HTML - currently configured for ASP, Javascript, JScript, ADO and HTML
Returns: String (XHTML)
History:
20050111 1744GMT	v1		Andrew Urquhart		Created
20050211 0108GMT	v2		"					Completely re-written to process char-by-char
20050211 2035GMT	v2.1	"					Expanded to include HTML elements and attributes
20050212 1609GMT	v2.2	"					Implemented proportional tab character replacement
20070402 2206BST	v2.3	"					Fixed bugs: truncated whitespace chars, spurious quote when linebreak in string
*/
function getFormatAspJsHtmlAdoSource(strSource) {
	try {
		if (!strSource) {
			throw new Error(1, "Required parameter \"strSource\" was not defined");
		}

		var TABLEN			= 4; // Number of equivalent spaces in a full-width tab
		var WORDSEP			= RegExp().compile("(\\.|\\s|\\u00a0)"); // characters that delimit words
		var WHITESPACE		= RegExp().compile("(\\s)"); // characters that make up white-space
		var WORDCHR			= RegExp().compile("\\w"); // characters that make up a word
		var MARKUPCHR		= RegExp().compile("[a-z0-6\\-\\:\\!]", "i"); // characters that make up HTML words
		var MARKUPLANG		= RegExp().compile("[a-z0-6\\s\\-\\:\"'\\<\\>/=\\!]", "i"); // character that make up HTML words and structure
		var RE_BRACKET		= RegExp().compile("(\\[|\\]|\\{|\\}|\\(|\\))"); // characters that make up brackets

		//new ones to add:  cint|clng|cdate|const|CreateObject|DateAdd|DateDiff|dim|InStr|InStrRev|instr|instrrev|isdate|isnumeric|isNull|lcase|Now|now|Response|response|Server|server|trim|Trim|ucase|Write|write|
		var RE_KEYWORDS		= RegExp().compile("^(Array|Boolean|Date|Image|Math|Object|RegExp|ScriptEngine|ScriptEngineBuildVersion|ScriptEngineMajorVersion|ScriptEngineMinorVersion|String|UTC|abs|acos|addParameter|alert|all|anchor|appendChild|appendData|arguments|asin|async|atEnd|atan|atan2|attributes|back|backgroundColor|big|blink|blur|body|bold|break|byteToString|callee|caller|captureEvents|case|catch|ceil|charAt|charCodeAt|childNodes|children|clearInterval|clearTimeout|click|cloneNode|close|closed|compile|concat|confirm|contains|continue|cos|createAttribute|createComment|createDocument|createDocumentFragment|createElement|createProcessingInstruction|createProcessor|createTextNode|cursor|data|decodeURI|decodeURIComponent|default|delete|deleteData|description|disableExternalCapture|display|do|document|documentElement|elements|else|enableExternalCapture|encodeURI|encodeURIComponent|elsif|end|not|and|else|exit|then|errorCode|escape|eval|event|exp|export|false|files|finally|find|firstChild|fixed|floor|focus|fontcolor|fontsize|for|forms|forward|fromCharCode|function|getAttribute|getAttributeNode|getDate|getDay|getElementById|getElementsByName|getElementsByTagName|getFullYear|getHours|getMilliseconds|getMinutes|getMonth|getOptionValue|getOptionValueCount|getSeconds|getSelection|getTime|getTimezoneOffset|getUTCDate|getUTCDay|getUTCFullYear|getUTCHours|getUTCMilliseconds|getUTCMinutes|getUTCMonth|getUTCSeconds|getYear|go|handleEvent|hasAttribute|hasAttributes|hasChildNodes|hasFeature|home|if|import|in|indexOf|innerHTML|input|insertBefore|insertData|instanceof|isNaN|italics|item|javaEnabled|join|lastChild|lastIndexOf|length|line|link|load|loadXML|location|log|match|max|mimeTypes|min|moveAbove|moveBelow|moveBy|moveNext|moveTo|moveToAbsolute|NaN|name|navigator|new|nextSibling|nodeName|nodeType|nodeValue|normalize|null|number|open|options|output|ownerDocument|parentNode|parse|parseError|parseFloat|parseInt|plugins|pop|pow|preference|previousSibling|print|prompt|prototype|push|random|readyState|reason|refresh|releaseEvents|reload|removeAttribute|removeAttributeNode|removeChild|replace|replaceChild|replaceData|reset|resizeBy|resizeTo|resolveExternals|return|reverse|round|routeEvent|screen|scroll|scrollBy|scrollTo|search|select|selectNodes|setAttribute|setAttributeNode|setDate|setFullYear|setHours|setInterval|setMinutes|setMonth|setSeconds|setTime|setTimeout|setUTCDate|setUTCDay|setUTCFullYear|setUTCHours|setUTCMilliseconds|setUTCMinutes|setUTCMonth|setUTCSeconds|setYear|shift|sin|slice|small|sort|sourceIndex|specified|splice|split|splitText|sqrt|srcElement|stop|strike|style|stylesheet|sub|submit|substr|substring|substringData|sup|switch|tagName|taintEnabled|tan|test|this|throw|toGMTString|toLocaleString|toLowerCase|toString|toUTCString|toUpperCase|transform|transformNode|true|try|typeof|undefined|unescape|unit|unshift|unwatch|validateOnParse|value|valueOf|var|void|watch|while|window|with|write|writeln|xml)$"); // words that make up language keywords

		var RE_OBJECT		= RegExp().compile("^(#include|LANGUAGE|CODEPAGE|Abandon|AbsolutePage|AbsolutePosition|ActiveConnection|ActiveXObject|ActualSize|AddHeader|AddNew|Append|AppendChunk|AppendToLog|Application|Application_OnEnd|Application_OnStart|AtEnd|Attributes|BOF|BeginTrans|BinaryRead|BinaryWrite|Bookmark|Buffer|CacheControl|CacheSize|Cancel|CancelBatch|CancelUpdate|CharSet|Clear|ClientCertificate|Clone|Close|CodePage|Command|CommandText|CommandTimeout|CommandType|CommitTrans|Connection|ConnectionString|ConnectionTimeout|ContentType|Contents|Cookies|CopyFile|CopyFolder|CopyTo|Count|CreateFile|CreateFolder|CreateObject|CreateParameter|CreateTextFile|CursorLocation|CursorType|DateCreated|DateLastModified|DefaultDatabase|DefinedSize|Delete|Description|Direction|Domain|EOF|EOS|EditMode|EnableSessionState|End|Enumerator|Error|Errors|Execute|Expires|ExpiresAbsolute|Field|Fields|FileExists|Files|Filter|Flush|FolderExists|ForAppending|ForReading|ForWriting|Form|GetChunk|GetFile|GetFolder|GetLastError|GetObject|HasKeys|HTMLEncode|HelpContext|HelpFile|Index|IsClientConnected|IsolationLevel|Item|Key|LCID|Language|LineSeparator|LoadFromFile|Lock|LockType|MapPath|MarshalOptions|Mode|Move|MoveFirst|MoveLast|MoveNext|MovePrevious|Name|NamedParameters|NativeError|Number|NumericScale|ObjectContext|OnTransactionAbort|OnTransactionCommit|Open|OpenAsTextStream|OpenSchema|OpenTextFile|OriginalValue|PageCount|PageSize|Parameter|Parameters|Path|Pics|Position|Precision|Prepared|Properties|Property|Provider|QueryString|Read|ReadLine|ReadText|RecordCount|Recordset|Redirect|Requery|Request|Response|Resync|RollbackTrans|SQLState|Save|SaveToFile|ScriptTimeout|Seek|Server|ServerVariables|Session|SessionID|Session_OnEnd|Session_OnStart|SetAbort|SetComplete|Size|Sort|Source|State|StaticObjects|Status|SubFolders|Supports|Timeout|TotalBytes|Transfer|TristateFalse|TristateTrue|TristateUseDefault|Type|URLEncode|URLPathEncode|UnderlyingValue|Unlock|Update|UpdateBatch|Value|Version|Write|WriteLine|WriteText|adAddNew|adAffectAll|adAffectAllChapter|adAffectCurrent|adAffectGroup|adApproxPosition|adAsyncConnect|adAsyncExecute|adAsyncFetch|adAsyncFetchNonBlocking|adBSTR|adBigInt|adBinary|adBinary|adBookmark|adBookmarkCurrent|adBookmarkFirst|adBookmarkLast|adBoolean|adChapter|adChar|adChar|adClipString|adCmdFile|adCmdStoredProc|adCmdTable|adCmdTableDirect|adCmdText|adCmdUnknown|adCompareEqual|adCompareGreaterThan|adCompareLessThan|adCompareNotComparable|adCompareNotEqual|adCriteriaAllCol|adCriteriaKey|adCriteriaTimeStamp|adCriteriaUpdCol|adCurrency|adDBDate|adDBFileTime|adDBTime|adDBTimeStamp|adDate|adDecimal|adDelete|adDouble|adEditAdd|adEditDelete|adEditInProgre|adEditNone|adEmpty|adErrBoundToCommand|adErrDataConversion|adErrFeatureNotAvailable|adErrIllegalOperation|adErrInTransaction|adErrInvalidArgument|adErrInvalidConnection|adErrInvalidParamInfo|adErrItemNotFound|adErrNoCurrentRecord|adErrNotExecuting|adErrNotReentrant|adErrObjectClosed|adErrObjectInCollection|adErrObjectNotSet|adErrObjectOpen|adErrOperationCancelled|adErrProviderNotFound|adErrStillConnecting|adErrStillExecuting|adErrUnsafeOperation|adError|adExecuteNoRecords|adFileTime|adFilterAffectedRecord|adFilterConflictingRecord|adFilterFetchedRecord|adFilterNone|adFilterPendingRecord|adFilterPredicate|adFind|adFldCacheDeferred|adFldFixed|adFldisNullable|adFldKeyColumn|adFldLong|adFldMayBeNull|adFldMayDefer|adFldRowID|adFldRowVersion|adFldUnknownUpdatable|adFldUpdatable|adGUID|adGetRowsRest|adHoldRecord|adHoldRecords|adIDispatch|adIUnknown|adIndex|adInteger|adLockBatchOptimistic|adLockOptimistic|adLockPessimistic|adLockReadOnly|adLongBinary|adLongChar|adLongVarBinary|adLongVarChar|adLongVarWChar|adLongWChar|adMarshalAll|adMarshalModifiedOnly|adModeRead|adModeReadWrite|adModeShareDenyNone|adModeShareDenyRead|adModeShareDenyWrite|adModeShareExclusive|adModeUnknown|adModeWrite|adMovePrevious|adNotify|adNumeric|adNumeric|adOpenDynamic|adOpenForwardOnly|adOpenKeyset|adOpenStatic|adParamInput|adParamInputOutput|adParamLong|adParamNullable|adParamOutput|adParamReturnValue|adParamSigned|adParamUnknown|adPersistADTG|adPersistXML|adPosBOF|adPosEOF|adPosUnknown|adPriorityAboveNormal|adPriorityBelowNormal|adPriorityHighest|adPriorityLowest|adPriorityNormal|adPromptAlway|adPromptComplete|adPromptCompleteRequired|adPromptNever|adPropNotSupported|adPropOptional|adPropRead|adPropRequired|adPropWrite|adPropiant|adPropVariant|adReadAll|adReadLine|adRecCanceled|adRecCantRelease|adRecConcurrencyViolation|adRecDBDeleted|adRecDeleted|adRecIntegrityViolation|adRecInvalid|adRecMaxChangesExceeded|adRecModified|adRecMultipleChange|adRecNew|adRecOK|adRecObjectOpen|adRecOutOfMemory|adRecPendingChange|adRecPermissionDenied|adRecSchemaViolation|adRecUnmodified|adRecalcAlway|adRecalcUpFront|adResync|adResyncAll|adResyncAllValue|adResyncAutoIncrement|adResyncConflict|adResyncInsert|adResyncNone|adResyncUnderlyingValue|adResyncUpdate|adRsnAddNew|adRsnClose|adRsnDelete|adRsnFirstChange|adRsnMove|adRsnMoveFirst|adRsnMoveLast|adRsnMoveNext|adRsnMovePreviou|adRsnRequery|adRsnResynch|adRsnUndoAddNew|adRsnUndoDelete|adRsnUndoUpdate|adRsnUpdate|adRunAsync|adSaveCreateNotExist|adSaveCreateOverWrite|adSchemaAssert|adSchemaCatalog|adSchemaCharacterSet|adSchemaCheckConstraint|adSchemaCollation|adSchemaColumn|adSchemaColumnPrivilege|adSchemaColumnsDomainUsage|adSchemaConstraintColumnUsage|adSchemaConstraintTableUsage|adSchemaCube|adSchemaDBInfoKeyword|adSchemaDBInfoLiteral|adSchemaDimension|adSchemaForeignKey|adSchemaHierarchie|adSchemaIndexe|adSchemaKeyColumnUsage|adSchemaLevel|adSchemaMeasure|adSchemaMember|adSchemaPrimaryKey|adSchemaProcedure|adSchemaProcedureColumn|adSchemaProcedureParameter|adSchemaPropertie|adSchemaProviderSpecific|adSchemaProviderType|adSchemaReferentialConstraint|adSchemaSQLLanguage|adSchemaSchemata|adSchemaStatistic|adSchemaTable|adSchemaTableConstraint|adSchemaTablePrivilege|adSchemaTranslation|adSchemaUsagePrivilege|adSchemaView|adSchemaViewColumnUsage|adSchemaViewTableUsage|adSearchBackward|adSearchForward|adSeek|adSeekAfter|adSeekAfterEQ|adSeekBefore|adSeekBeforeEQ|adSeekFirstEQ|adSeekLastEQ|adSingle|adSmallInt|adStateClosed|adStateConnecting|adStateExecuting|adStateFetching|adStateOpen|adStatusCancel|adStatusCantDeny|adStatusErrorsOccurred|adStatusOK|adStatusUnwantedEvent|adStringHTML|adStringXML|adTinyInt|adTypeBinary|adTypeText|adUnsignedBigInt|adUnsignedInt|adUnsignedSmallInt|adUnsignedTinyInt|adUpdate|adUpdateBatch|adUseClient|adUseServer|adUserDefined|adVarBinary|adVarchar|adVarChar|adVariant|adVarWChar|adVarNumeric|adWChar|adWChar|adXactAbortRetaining|adXactBrowse|adXactChao|adXactCommitRetaining|adXactCursorStability|adXactIsolated|adXactReadCommitted|adXactReadUncommitted|adXactRepeatableRead|adXactSerializable|adXactUnspecified|adiant|getAllResponseHeaders|getResponseHeader|open|responseText|responseXML|send|setRequestHeader|setTimeouts|status|virtual)$"); // words that make up native language objects and functions

		var RE_MARKUP		= RegExp().compile("^(a|abbr|acronym|address|applet|area|b|base|basefont|bdo|bgsound|big|blink|blockquote|body|br|button|caption|center|cite|code|col|colgroup|comment|dd|del|dfn|dir|div|dl|dt|em|embed|fieldset|font|form|frame|frameset|h|h1|h2|h3|h4|h5|h6|head|hr|hta:application|html|i|iframe|img|input|ins|isindex|kbd|label|legend|li|link|listing|map|marquee|menu|meta|multicol|nextid|nobr|noframes|noscript|object|ol|optgroup|option|p|param|plaintext|pre|q|s|samp|script|select|server|small|sound|spacer|span|strike|strong|style|sub|sup|table|tbody|td|textarea|textflow|tfoot|th|thead|title|tr|tt|u|ul|var|wbr|xmp|!DOCTYPE)$", "i"); // names of HTML elements

		var RE_MARKUP_ATTR	= RegExp().compile("^(abbr|accept-charset|accept|accesskey|action|addEventListener|align|alink|alt|applicationname|attachEvent|archive|autoFlush|axis|background|behavior|bgcolor|bgproperties|border|bordercolor|bordercolordark|bordercolorlight|borderstyle|buffer|caption|cellpadding|cellspacing|char|charoff|charset|checked|cite|class|className|classid|clear|code|codebase|codetype|color|cols|colspan|compact|content|contentType|coords|data|datetime|declare|defer|dir|direction|disabled|dynsrc|encoding|enctype|errorPage|extends|face|file|flush|for|frame|frameborder|framespacing|gutter|headers|height|href|hreflang|hspace|http-equiv|icon|id|import|info|isErrorPage|ismap|isThreadSafe|label|language|lang|leftmargin|link|longdesc|loop|lowsrc|marginheight|marginwidth|maximizebutton|maxlength|media|method|methods|minimizebutton|multiple|name|nohref|noresize|noshade|nowrap|object|onabort|onAbort|onblur|onBlur|onchange|onChange|onclick|onClick|ondblclick|onDblClick|onerror|onError|onfocus|onFocus|onkeydown|onKeyDown|onkeypress|onKeyPress|onkeyup|onKeyUp|onload|onLoad|onmousedown|onMouseDown|onmousemove|onMouseMove|onmouseout|onMouseOut|onmouseover|onMouseOver|onmouseup|onMouseUp|onreset|onReset|onselect|onSelect|onsubmit|onSubmit|onunload|onUnload|page|param|profile|prompt|property|readonly|rel|rev|rows|rowspan|rules|runat|scheme|scope|scrollamount|scrolldelay|scrolling|selected|session|shape|showintaskbar|singleinstance|size|span|src|standby|start|style|summary|sysmenu|tabindex|target|text|title|topmargin|type|urn|usemap|valign|value|valuetype|version|vlink|vrml|vspace|width|windowstate|wrap|xmlns|xmlns:jsp|xml:lang)$", "i"); // names of HTML attributes


		// STUFF THAT DOESN'T NEED EDITING
		strSource			= strSource.replace(/\r\n|\r/g, "\n"); // Reduce all linebreaks to 1 newline char for simplicity sake
		var SOURCELEN		= strSource.length;
		var arr				= []; // a stack representing the function output
		var markuptmp		= []; // a temporary output stack
		var c				= -1; // index of character in source being processed
		var wordtmp			= ""; // a temporary string used to hold word fragments during parsing
		var FULLTAB			= "";
		var LINEFEED		= "\n"; // single character in source that represents a linebreak
		var TABCHAR			= "\t"; // single character in source that represents a tab
		var SPACE			= " ";
		var RESETCOL		= -1;
		var COMMENT_C		= 1;
		var COMMENT_CPP		= 2;
		var STRING_DBL		= 3;
		var STRING_SNGL		= 4;
		var WORD			= 5;
		var REGEXP			= 6;
		var HTML			= 7;
		var HTML_ATTR		= 8;
		var COMMENT_HTML	= 9;
		var NORMAL			= null;
		var STATE			= NORMAL;	// sentinel
		var SUBSTATE		= NORMAL;	// secondary sentinel
		var colCount		= RESETCOL;	// The current character in a given row
		// /STUFF THAT DOESN'T NEED EDITING


		// Build up a string of non-breaking spaces to represent a full-width tab
		for (var i=0; i<TABLEN; ++i) {
			FULLTAB += "\u00a0";
		}


		// Loop over every character 'c' in the source code
		while (++c < SOURCELEN) {
			++colCount;
			var chr		= strSource.charAt(c); // current character (Nth char)
			var nChr	= (c+1 < SOURCELEN	? strSource.charAt(c+1) : null); // next char
			var pChr	= (c-1 > 0			? strSource.charAt(c-1) : null); // previous char
			var p2Chr	= (c-2 > 0			? strSource.charAt(c-2) : null); // previous previous char

			if (STATE == COMMENT_C) {
				if (chr == "*" && nChr == "/") {
					// Terminate C comment
					arr.push("*/</i>");
					++c;
					++colCount;
					STATE = NORMAL;
				}
				else if (chr == LINEFEED) {
					// Linebreak in C comment
					arr.push("<br />");
					colCount = RESETCOL;
				}
				else if (chr == TABCHAR) {
					// Add tab equivalents that snap to a column grid of 'TABLEN' characters wide.
					var equivTabLen = colCount % TABLEN;
					arr.push(FULLTAB.substr(equivTabLen));
					colCount += (TABLEN - equivTabLen - 1);
				}
				else if (chr == SPACE) {
					arr.push((pChr == SPACE) ? "\u00a0" : SPACE); // Alternate &nbsp; with space character so that we have the ability to line-wrap, but don't lose the specified number of spaces in the string
				}
				else {
					// Continuation of C comment
					arr.push(Server.HtmlEncode(chr));
				}
				continue;
			}
			else if (STATE == NORMAL && chr == "/" && nChr == "*") {
				// Start of C-style comment
				STATE = COMMENT_C;
				arr.push("<i class=\"cmt\">/*");
				++c;
				++colCount;
				continue;
			}
			else if (STATE == COMMENT_CPP) {
				if (chr == LINEFEED) {
					// Terminate C++ comment
					arr.push("</i><br />");
					STATE = NORMAL;
					colCount = RESETCOL;
				}
				else if (chr == TABCHAR) {
					// Add tab equivalents that snap to a column grid of 'TABLEN' characters wide.
					var equivTabLen = colCount % TABLEN;
					arr.push(FULLTAB.substr(equivTabLen));
					colCount += (TABLEN - equivTabLen - 1);
				}
				else if (chr == SPACE) {
					arr.push((pChr == SPACE) ? "\u00a0" : SPACE); // Alternate &nbsp; with space character so that we have the ability to line-wrap, but don't lose the specified number of spaces in the string
				}
				else {
					// Continuation of C comment
					arr.push(Server.HtmlEncode(chr));
				}
				continue;
			}
			else if (STATE == NORMAL && chr == "/" && nChr == "/") {
				// Start of C++ style comment
				STATE = COMMENT_CPP;
				arr.push("<i class=\"cmt\">//");
				++c;
				++colCount;
				continue;
			}
			else if (STATE == NORMAL && chr.match(RE_BRACKET)) {
				// Bracket
				arr.push("<b class=\"brkt\">" + RegExp.$1 + "</b>");
				continue;
			}
			else if (STATE == STRING_DBL) {
				if ((chr == "\"" && (pChr != "\\" || (pChr == "\\" && p2Chr == "\\"))) || nChr == LINEFEED) {
					// Terminate " string
					if (nChr == LINEFEED) {
						arr.push(Server.HtmlEncode(chr) + "</span>");
					}
					else {
						arr.push("\"</span>");
					}
					STATE = NORMAL;
				}
				else if (chr == SPACE) {
					arr.push((pChr == SPACE) ? "\u00a0" : SPACE); // Alternate &nbsp; with space character so that we have the ability to line-wrap, but don't lose the specified number of spaces in the string
				}
				else {
					// Continuation " string
					arr.push(Server.HtmlEncode(chr));
				}
				continue;
			}
			else if (STATE == NORMAL && chr == "\"" && pChr != "\\") {
				// Start of " string
				STATE = STRING_DBL;
				arr.push("<span class=\"str\">\"");
				continue;
			}
			else if (STATE == STRING_SNGL) {
				if ((chr == "'" && (pChr != "\\" || (pChr == "\\" && p2Chr == "\\"))) || nChr == LINEFEED) {
					// Terminate ' string
					arr.push("'</span>");
					STATE = NORMAL;
				}
				else if (chr == SPACE) {
					arr.push((pChr == SPACE) ? "\u00a0" : SPACE); // Alternate &nbsp; with space character so that we have the ability to line-wrap, but don't lose the specified number of spaces in the string
				}
				else {
					// Continuation ' string
					arr.push(Server.HtmlEncode(chr));
				}
				continue;
			}
			else if (STATE == NORMAL && chr == "'" && pChr != "\\") {
				// Start of ' string
				STATE = STRING_SNGL;
				arr.push("<span class=\"str\">'");
				continue;
			}
			else if (STATE == WORD) {
				// Continuation of word

				var blnValidChar = WORDCHR.test(chr);
				if (blnValidChar) {
					wordtmp += chr;
				}


				if (WORDSEP.test(nChr) || nChr == LINEFEED || !WORDCHR.test(nChr) || !blnValidChar) {
					// end of word, check if exists in dictionary

					var encWord = Server.HtmlEncode(wordtmp);
					if (RE_KEYWORDS.test(wordtmp)) {
						arr.push("<b class=\"kywd\">" + encWord + "</b>");
					}
					else if (RE_OBJECT.test(wordtmp)) {
						arr.push("<b class=\"obj\">" + encWord + "</b>");
					}
					else {
						arr.push(encWord);
					}
					STATE = NORMAL;
					wordtmp = "";

					if (!blnValidChar) {
						// Character that came in wasn't a valid word character, so we didn't add it to the word earlier in the statement block so we'll add it now.
						arr.push(Server.HtmlEncode(chr));
					}
				}

				continue;
			}
			else if (STATE == NORMAL && WORDCHR.test(chr)) {
				// Start of word

				if (!WORDCHR.test(nChr)) {
					// If only a 1 letter word, don't start the WORD STATE as we can sometimes fail to process following brackets
					var encChr = Server.HtmlEncode(chr);
					if (RE_KEYWORDS.test(chr)) {
						arr.push("<b class=\"kywd\">" + encChr + "</b>");
					}
					else if (RE_OBJECT.test(chr)) {
						arr.push("<b class=\"obj\">" + encChr + "</b>");
					}
					else {
						arr.push(encChr);
					}
				}
				else {
					STATE = WORD;
					wordtmp = chr;
				}
				continue;
			}
			else if (STATE == REGEXP) {
				if (chr == "/" && pChr != "\\") {
					// Terminate Regular Expression
					arr.push("/");
					STATE = NORMAL;
				}
				else {
					// Continuation of Regular Expression
					arr.push(Server.HtmlEncode(chr));
				}
				continue;
			}
			else if (STATE == NORMAL && chr == "/" && nChr != "/" && pChr == "(") {
				// Start of Regular Expression
				STATE = REGEXP;
				arr.push("/");
				continue;
			}
			else if (STATE == HTML) {
				if (chr == TABCHAR) {
					var equivTabLen = colCount % TABLEN;
					markuptmp.push(FULLTAB.substr(equivTabLen));
					colCount += (TABLEN - equivTabLen - 1);
				}
				else if (SUBSTATE == NORMAL && (chr == ">" || !MARKUPLANG.test(chr))) {
					// End of HTML
					STATE		= NORMAL;
					SUBSTATE	= NORMAL;
					if (chr == ">") {
						arr.push("<span class=\"mrk\">" + markuptmp.join("") + Server.HtmlEncode(wordtmp + chr) + "</span>");
					}
					else {
						arr.push(markuptmp.join("") + Server.HtmlEncode(wordtmp + chr)); // Content turned out not to be valid markup - say an opening < without valid markup inside
					}
					wordtmp		= "";
					markuptmp	= [];
				}
				else {
					var blnValidChar = MARKUPCHR.test(chr);
					if (blnValidChar) {
						wordtmp += chr;
					}

					if (SUBSTATE == STRING_DBL) {
						if ((chr == "\"" && (pChr != "\\" || (pChr == "\\" && p2Chr == "\\"))) || nChr == LINEFEED) {
							// Terminate " string
							if (nChr == LINEFEED) {
								markuptmp.push(Server.HtmlEncode(chr) + "</i>");
							}
							else {
								markuptmp.push("\"</i>");
							}
							SUBSTATE = NORMAL;
						}
						else {
							// Continuation " string
							markuptmp.push(Server.HtmlEncode(chr));
							wordtmp = "";
						}
						continue;
					}
					else if (SUBSTATE == NORMAL && chr == "\"" && pChr != "\\") {
						// Start of " string
						SUBSTATE = STRING_DBL;
						markuptmp.push("<i class=\"str\">\"");
						continue;
					}
					else if (SUBSTATE == COMMENT_HTML) {
						if (chr == "-" && nChr == "-") {
							// Terminate HTML comment
							markuptmp.push("--</i>");
							++c;
							++colCount;
							SUBSTATE = NORMAL;
						}
						else if (chr == LINEFEED) {
							// Linebreak in HTML comment
							markuptmp.push("<br />");
							colCount = RESETCOL;
						}
						else if (chr == TABCHAR) {
							// Add tab equivalents that snap to a column grid of 'TABLEN' characters wide.
							var equivTabLen = colCount % TABLEN;
							arr.push(FULLTAB.substr(equivTabLen));
							colCount += (TABLEN - equivTabLen - 1);
						}
						else if (chr == SPACE) {
							arr.push((pChr == SPACE) ? "\u00a0" : SPACE); // Alternate &nbsp; with space character so that we have the ability to line-wrap, but don't lose the specified number of spaces in the string
						}
						else {
							// Continuation of HTML comment
							markuptmp.push(Server.HtmlEncode(chr));
						}
						wordtmp = "";
						continue;
					}
					else if (SUBSTATE == NORMAL && chr == "-" && nChr == "-" && pChr == "!" && p2Chr == "<") {
						// Start of HTML comment
						SUBSTATE = COMMENT_HTML;
						markuptmp.push("<i class=\"mrkcmt\">" + wordtmp);
						wordtmp = "";
						continue;
					}
					else if (SUBSTATE == STRING_SNGL) {
						if ((chr == "'" && (pChr != "\\" || (pChr == "\\" && p2Chr == "\\"))) || nChr == LINEFEED) {
							// Terminate ' string
							markuptmp.push("'</i>");
							SUBSTATE = NORMAL;
						}
						else {
							// Continuation ' string
							markuptmp.push(Server.HtmlEncode(chr));
							wordtmp = "";
						}
						continue;
					}
					else if (SUBSTATE == NORMAL && chr == "'" && pChr != "\\") {
						// Start of ' string
						SUBSTATE = STRING_SNGL;
						markuptmp.push("<i class=\"str\">'");
						continue;
					}
					else if (SUBSTATE == NORMAL && (!MARKUPCHR.test(nChr) || nChr == LINEFEED || !blnValidChar)) {
						// end of element, check if exists in dictionary

						var encTag = Server.HtmlEncode(wordtmp);
						if (RE_MARKUP.test(wordtmp)) {
							markuptmp.push("<b class=\"mrktag\">" + encTag + "</b>");
						}
						else if (RE_MARKUP_ATTR.test(wordtmp)) {
							markuptmp.push("<b class=\"mrkattr\">" + encTag + "</b>");
						}
						else {
							markuptmp.push(encTag);
						}
						wordtmp	= "";

						if (!blnValidChar) {
							// Character that came in wasn't a valid word character, so we didn't add it to the word earlier in the statement block so we'll add it now.
							markuptmp.push(Server.HtmlEncode(chr));
						}
					}
				}
				continue;
			}
			else if (STATE == NORMAL && chr == "<" && !WHITESPACE.test(nChr)) {
				// Start of HTML
				STATE		= HTML;
				SUBSTATE	= NORMAL;
				wordtmp		= "";
				markuptmp.push("&lt;");
				continue;
			}
			else {
				switch (chr) {
					case LINEFEED	: arr.push("<br />"); colCount = RESETCOL; break;
					case TABCHAR	: {
						// Add tab equivalents that snap to a column grid of 'TABLEN' characters wide.
						var equivTabLen = colCount % TABLEN;
						arr.push(FULLTAB.substr(equivTabLen));
						colCount += (TABLEN - equivTabLen - 1);
						break;
					}
					case SPACE		: arr.push((pChr == SPACE) ? "\u00a0" : SPACE);  break; // Alternate &nbsp; with space character so that we have the ability to line-wrap, but don't lose the specified number of spaces in the string
					default			: arr.push(Server.HtmlEncode(chr));
				}
			}
		}

		return "<div class=\"sourcecode\"><samp>" + arr.join("") + "</samp></div>";
	}
	catch (err) {
		throw new Error(err.number, "Function getFormatAspJsHtmlAdoSource() failed with message=\r\n" + err.description);
	}
}

</script>
