/* 
  set display:inline if the element with the specified id 
	only if compare1 and compare2 are equal strings. Otherwise 
	set display:none on the element. When set to none, the 
	element is hidden from view, and all surrounding content 
	cinches up to occupy whatever space the element would 
	normally occupy. This is different from the visibility 
	attribute, which reserves space for the element while 
	hiding it from view.
*/
function displayIfTrue(elementID, compare1, compare2) {
	var eid=elementID.toString()
	if (compare1.toString() == compare2.toString()) {
			document.getElementById(eid).style.display="inline";
	} else {
		document.getElementById(eid).style.display="none";
	}
}
/* 
  Show the element with the specified id only if compare1 and 
  compare2 are equal strings. Otherwise hide the element.
*/
function visibleIfTrue(elementID, compare1, compare2) {
	var eid=elementID.toString()
	if (compare1.toString() == compare2.toString()) {
			document.getElementById(eid).style.visibility="visible";
	} else {
		document.getElementById(eid).style.visibility="hidden";
	}
}