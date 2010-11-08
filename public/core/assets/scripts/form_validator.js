// validate.js v 1.98
// a generic form validator 
// (cc) Brian Lalonde http://webcoder.info/downloads/validate.html
// License: http://creativecommons.org/licenses/by-sa/2.0/


//TODO:  figure out why javascript form validation doesnt verify required select-one boxes
function formFocus(frm)
{ // convenient way to start the form onLoad
  if(!document.forms.length) return;
  var els= ( frm || document.forms[0] ).elements;
  for(var i= 0; i < els.length; i++)
    if(els[i].type != 'hidden') { els[i].focus(); return; }
}

function formChanged(frm)
{ // determine whether any form fields have changed
  if(!document.forms.length) return;
  var els= ( frm || document.forms[0] ).elements;
  for(var i= 0; i < els.length; i++)
    switch(els[i].type)
    {
      case 'text': 
      case 'textarea': 
      case 'password': 
      case 'hidden':
      case 'file':
        if(els[i].defaultValue!=els[i].value)
        { status= 'The '+fieldname(els[i])+' field has changed.'; return true; } 
        break;
      case 'checkbox':
        if(els[i].defaultChecked!=els[i].checked)
        { status= 'The '+fieldname(els[i])+' checkbox has changed.'; return true; }
        break;
      case 'select-one':
        for(var j= 1; j < els[i].options.length; j++)
          if(els[i].options[j].defaultSelected!=els[i].options[j].selected)
          { status= 'The '+fieldname(els[i])+' selection has changed.'; return true; }
        break;
      case 'select-multiple':
        for(var j= 0; j < els[i].options.length; j++)
          if(els[i].options[j].defaultSelected!=els[i].options[j].selected)
          { status= 'The '+fieldname(els[i])+' selections have changed.'; return true; }
        break;
      case 'radio':
        if(els[i].length)
          for(var j= 0; j < els[i].length; j++)
            if(els[i][j].defaultChecked!=els[i][j].checked)
            { status= 'The '+fieldname(els[i])+' choice has changed.'; return true; }
        break;
    }
  return false;
}

function fieldname(fld)
{ // get the field label text or name
  if(fld.id && document.getElementsByTagName)
  {
    for(var i= 0, lbl= document.getElementsByTagName('LABEL'); i < lbl.length; i++)
      if(lbl[i].htmlFor==fld.id) return lbl[i].nodeValue||lbl[i].textContent||lbl[i].innerText;
    for(var i= 0, lbl= document.getElementsByTagName('label'); i < lbl.length; i++)
      if(lbl[i].htmlFor==fld.id) return lbl[i].nodeValue||lbl[i].textContent||lbl[i].innerText;
  }
  return fld.name||fld.type;
}

function requireValue(fld)
{ // disallow a blank field
  if(fld.disabled) return true;
  if(!fld.value.length)
  { status= 'The '+fieldname(fld)+' field cannot be left blank.'; return false; }
  return true;
}

function requireChecked(fld)
{ // require a checkbox to be checked
  if(fld.disabled) return true;
  if(!fld.checked)
  { status= 'The '+fieldname(fld)+' checkbox must be checked.'; return false; }
  return true;
}

function requireConfirmation(fld,confirmfld)
{ // require fields to match
  if(fld.disabled) return true;
  if(fld.value != confirmfld.value)
  { status= 'The '+fieldname(fld)+' field does not match the '+fieldname(confirmfld)+' field.'; return false; }
  return true;
}

function requireRadio(radios)
{ // require at least one radio in this group to be checked
  if(!radios.length) return true; // invalid parameter
  var visible= false, enabled= false;
  for(var i= 0; i < radios.length; i++)
  {
    if(!enabled) enabled= !radios[i].disabled;
    if(radios[i].checked) return true;
    else if(radios[i].offsetWidth == undefined || radios[i].offsetWidth > 0) visible= true;
  }
  if(!visible||!enabled) return true; // no visible/enabled options in this group
  status= 'You must select one of the '+radios[0].name+' options.';
  return false;
}

function requireLength(fld,min,max)
{ // set minimum and/or maximum field lengths
  if(!fld.value.length||fld.disabled) return true; // blank fields are the domain of requireValue 
  var len= fld.value.length;
  if(min > -1 && len < min)
  { status= 'The '+fieldname(fld)+' field must be at least '+min+
    ' characters long; it is currently '+len+' characters long.'; return false; }
  if(max > -1 && len > max)
  { status= 'The '+fieldname(fld)+' field must be no more than '+max+
    ' characters long; it is currently '+len+' characters long.'; return false; }
  return true;
}

function dependants(enabled,elements)
{ // convenience function to enable/disable dependant fields, passed in as an array 
  if(!elements.length) return true;
  for(var i= 0; i < elements.length; i++)
    elements[i].disabled= !enabled;
}

function allowChars(fld,chars)
{ // provide a string of acceptable chars for a field
  if(fld.disabled) return true;
  for(var i= 0; i < fld.value.length; i++)
  {
    if(chars.indexOf(fld.value.charAt(i)) == -1)
    { status= 'The '+fieldname(fld)+' field may not contain "'+fld.value.charAt(i)+'" characters.'; return false; }
  }
  return true;
}

function disallowChars(fld,chars)
{ // provide a string of unacceptable chars for a field
  if(fld.disabled) return true;
  for(var i= 0; i < fld.value.length; i++)
  {
    if(chars.indexOf(fld.value.charAt(i)) != -1)
    { status= 'The '+fieldname(fld)+' field may not contain "'+fld.value.charAt(i)+'" characters.'; return false; }
  }
  return true;
}

function checkEmail(fld)
{ // simple email check
  if(!fld.value.length||fld.disabled) return true; // blank fields are the domain of requireValue 
  var phony= /@(\w+\.)*example\.(com|net|org)$/i;
  if(phony.test(fld.value))
  { status= 'Please enter your email address in the '+fieldname(fld)+' field.'; return false; }
  var emailfmt= /^\w+([.-]\w+)*@\w+([.-]\w+)*\.\w{2,8}$/;
  if(!emailfmt.test(fld.value))
  { status= 'The '+fieldname(fld)+' field must contain a valid email address.'; return false; }
  return true;
}

function checkIntRange(fld,minVal,maxVal,sep)
{
  if(!fixInt(fld)) return false;
  var val= parseInt(fld.value);
  if(val < minVal) { status= 'The '+fieldname(fld)+' field must be no less than '+minVal+'.'; return false; }
  if(val > maxVal) { status= 'The '+fieldname(fld)+' field must be no greater than than '+maxVal+'.'; return false; }
  return true;
}

function checkFloatRange(fld,minVal,maxVal,sep)
{
  if(!fixFloat(fld)) return false;
  var val= parseFloat(fld.value);
  if(val < minVal) { status= 'The '+fieldname(fld)+' field must be no less than '+minVal+'.'; return false; }
  if(val > maxVal) { status= 'The '+fieldname(fld)+' field must be no greater than than '+maxVal+'.'; return false; }
  return true;
}

function fixInt(fld,sep)
{ // integer check/complainer 
  if(!fld.value.length||fld.disabled) return true; // blank fields are the domain of requireValue 
  var val= fld.value;
  if(typeof(sep)!='undefined') val= val.replace(new RegExp(sep,'g'),'');
  val= parseInt(val);
  if(isNaN(val))
  { // parse error 
    status= 'The '+fieldname(fld)+' field must contain a whole number.';
    return false;
  }
  fld.value= val;
  return true;
}

function fixFloat(fld,sep)
{ // decimal number check/complainer 
  if(!fld.value.length||fld.disabled) return true; // blank fields are the domain of requireValue 
  var val= fld.value;
  if(typeof(sep)!='undefined') val= val.replace(new RegExp(sep,'g'),'');
  val= parseFloat(fld.value);
  if(isNaN(val))
  { // parse error 
    status= 'The '+fieldname(fld)+' field must contain a number.';
    return false;
  }
  fld.value= val;
  return true;
}

function fixMoney(fld,sep)
{ // monetary field check
  if(!fld.value.length||fld.disabled) return true; // blank fields are the domain of requireValue 
	
  var val= fld.value;
  if(typeof(sep)!='undefined') val= val.replace(new RegExp(sep,'g'),'');
  if(val.indexOf('$') == 0)
	{
    val= parseFloat(val.substring(1,40));
		if (!val.length) return true;
  }
	else
    val= parseFloat(val);
  if(isNaN(val))
  { // parse error 
    status= 'The '+fieldname(fld)+' field must contain a dollar amount.';
    return false;
  }
  var sign= ( val < 0 ? '-': '' );
  val= Number(Math.round(Math.abs(val)*100)).toString();
  while(val.length < 2) val= '0'+val;
  var len= val.length;
  val= sign + ( len == 2 ? '0' : val.substring(0,len-2) ) + '.' + val.substring(len-2,len+1);
  fld.value= val;
  return true;
}

function fixFixed(fld,dec,sep)
{ // fixed decimal fields 
  if(!fld.value.length||fld.disabled) return true; // blank fields are the domain of requireValue 
  var val= fld.value;
  if(typeof(sep)!='undefined') val= val.replace(new RegExp(sep,'g'),'');
  val= parseFloat(fld.value);
  if(isNaN(val))
  { // parse error 
    status= 'The '+fieldname(fld)+' field must contain a number.';
    return false;
  }
  var sign= ( val < 0 ? '-': '' );
  val= Number(Math.round(Math.abs(val)*Math.pow(10,dec))).toString();
  while(val.length < dec) val= '0'+val;
  var len= val.length;
  val= sign + ( len == dec ? '0' : val.substring(0,len-dec) ) + '.' + val.substring(len-dec,len+1);
  fld.value= val;
  return true;
}

function fixDate(fld)
{ // tenacious date correction 
  if(!fld.value.length||fld.disabled) return true; // blank fields are the domain of requireValue 
  var val= fld.value;
  var dt= new Date(val.replace(/\D/g,'/'));
  if(!dt.valueOf())
  { // the date was unparseable 
    status= 'The '+fieldname(fld)+' field has the wrong date.';
    return false;
  }
  fld.value= (dt.getMonth()+1)+'/'+dt.getDate()+'/'+dt.getFullYear();
  return true;
}

function fixRecentDate(fld,minyear)
{ // tenacious date correction 
  if(!fld.value.length||fld.disabled) return true; // blank fields are the domain of requireValue 
  var val= fld.value;
  var dt= new Date(val.replace(/\D/g,'/'));
  if(!dt.valueOf())
  { // the date was unparseable 
    status= 'The '+fieldname(fld)+' field has the wrong date.';
    return false;
  }
  while(dt.getFullYear() < minyear) { dt.setFullYear(dt.getFullYear()+100); }
  fld.value= (dt.getMonth()+1)+'/'+dt.getDate()+'/'+dt.getFullYear();
  return true;
}

function fixTime(fld,starthour) 
{ // tenacious time correction 
  if(!fld.value.length||fld.disabled) return true; // blank fields are the domain of requireValue 
  var hour= 0; 
  var mins= 0;
  var ampm= 'am';
  val= fld.value;
  var dt= new Date('1/1/2000 ' + val);
  if(('9'+val) == parseInt('9'+val))
  { hour= val; }
  else if(dt.valueOf())
  { hour= dt.getHours(); mins= dt.getMinutes(); }
  else
  {
    val= val.replace(/\D+/g,':');
    hour= parseInt(val);
    mins= parseInt(val.substring(val.indexOf(':')+1,20));
    if(val.indexOf('pm') > -1) ampm= 'pm';
    if(isNaN(hour)) hour= 0;
    if(isNaN(mins)) mins= 0;
  }
  if(hour < starthour) { ampm= 'pm'; }
  while(hour > 12) { hour-= 12; ampm= 'pm'; }
  while(mins > 60) { mins-= 60; hour++; }
  if(mins < 10) mins= '0' + mins;
  if(!hour)
  { // the date was unparseable 
    status= 'The '+fieldname(fld)+' field has the wrong time.';
    return false;
  }
  fld.value= hour + ':' + mins + ampm;
  return true;
}

function fixTime24(fld) 
{ // tenacious time correction 
  if(!fld.value.length||fld.disabled) return true; // blank fields are the domain of requireValue 
  var hour= 0; 
  var mins= 0;
  val= fld.value;
  var dt= new Date('1/1/2000 ' + val);
  if(('9'+val) == parseInt('9'+val))
  { hour= val; }
  else if(dt.valueOf())
  { hour= dt.getHours(); mins= dt.getMinutes(); }
  else
  {
    val= val.replace(/\D+/g,':');
    hour= parseInt(val);
    mins= parseInt(val.substring(val.indexOf(':')+1,20));
    if(isNaN(hour)) hour= 0;
    if(isNaN(mins)) mins= 0;
    if(val.indexOf('pm') > -1) hour+= 12;
  }
  hour%= 24;
  mins%= 60;
  if(mins < 10) mins= '0' + mins;
  fld.value= hour + ':' + mins;
  return true;
}

function fixPhone(fld,defaultAreaCode,sep,noext)
{ // tenacious phone # correction 
  if(!fld.value.length||fld.disabled) return true; // blank fields are the domain of requireValue 
  if(typeof(sep)=='undefined') sep= '-';
  if(typeof(defaultAreaCode)!='undefined') defaultAreaCode= defaultAreaCode + sep;
  var ext= '', val= fld.value.toLowerCase();
  if(val.indexOf('x') > 0)
  {
    if(!noext) ext= ' x'+val.substr(val.indexOf('x')).replace(/\D/g,'');
    val= val.substr(0,val.indexOf('x'));
  }
  val= val.replace(/\D/g,'');
  if(val.length == 7)
  {
    fld.value= defaultAreaCode + val.substring(0,3) + sep + val.substring(3,20) + ext;
    return true;
  }
  if(val.length == 10)
  {
    fld.value= val.substring(0,3) + sep + val.substring(3,6) + sep + val.substring(6,20) + ext;
    return true;
  }
  if(val.length < 7)
  {
    status= 'The phone number you supplied for the '+fieldname(fld)+' field was too short.';
    return false;
  }
  if(val.length > 10)
  {
    status= 'The phone number you supplied for the '+fieldname(fld)+' field was too long.';
    return false;
  }
  status= 'The phone number you supplied for the '+fieldname(fld)+' field was wrong.';
  return false;
}

function fixSSN(fld)
{ // tenacious SSN correction; fieldname isn't a big consideration, probably only one SSN per form 
  if(!fld.value.length||fld.disabled) return true; // blank fields are the domain of requireValue 
  var val= fld.value;
  val= val.replace(/\D/g,'');
  if( val.length < 9 )
  {
    status= 'The Social Security Number you provided is not long enough.';
    return false;
  }
  if( val.length > 9 )
  {
    status= 'The Social Security Number you provided is too long.';
    return false;
  }
  fld.value= val.substring(0,3)+'-'+val.substring(3,5)+'-'+val.substring(5,12);
  return true;
}

function fixCreditCard(fld)
{ // tenacious credit card correction; fieldname isn't a big consideration, probably only one card per form 
  if(!fld.value.length||fld.disabled) return true; // blank fields are the domain of requireValue 
  var val= fld.value, ctype= 'credit card';
  val= val.replace(/\D/g,'');
  var prefix2= parseInt(val.substr(0,2));
  if( val.substr(0,1) == '4' )
  { // Visa
    ctype= 'Visa\xae';
    if( val.length == 16 );
    else if( val.length == 13 ); // very old #, should be reassigned
    else if( val.length < 13 )
    { status= 'The Visa\xae number you provided is not long enough.'; return false; }
    else if( val.length > 16 )
    { status= 'The Visa\xae number you provided is too long.'; return false; }
    else
    { status= 'The Visa\xae number you provided is either not long enough, or too long.'; return false; }
  }
  else if( prefix2 >= 51 && prefix2 <= 55 )
  { // MC
    ctype= 'MasterCard\xae';
    if( val.length < 16 )
    { status= 'The MasterCard\xae number you provided is not long enough.'; return false; }
    else if( val.length > 16 )
    { status= 'The MasterCard\xae number you provided is too long.'; return false; }
  }
  else if( (prefix2 == 34) || (prefix2 == 37) )
  { // AmEx
    ctype= 'American Express\xae card';
    if( val.length < 15 )
    { status= 'The American Express\xae card number you provided is not long enough.'; return false; }
    else if( val.length > 15 )
    { status= 'The American Express\xae card number you provided is too long.'; return false; }
  }
  else if( val.substr(0,4) == '6011' )
  { // Novus/Discover
    ctype= 'Discover\xae card';
    if( val.length < 16 )
    { status= 'The Discover\xae card number you provided is not long enough.'; return false; }
    else if( val.length > 16 )
    { status= 'The Discover\xae card number you provided is too long.'; return false; }
  }
  else
  { // other
    if( val.length < 13 )
    { status= 'The credit card number you provided is not long enough.'; return false; }
    if( val.length > 19 )
    { status= 'The credit card number you provided is too long.'; return false; }
  }
  var sum= 0, dbl= false;
  for(var i= val.length-1; i >= 0; i--)
  {
    var digit= parseInt(val.charAt(i))*((dbl=!dbl)?1:2);
    sum+= ( digit > 9 ? (digit%10)+1 : digit );
  }
  if(sum%10)
  {
    status= 'The '+ctype+' number you provided is not valid.\nPlease double-check it and try again.';
    return false;
  }
  fld.value= val;
  return true;
}

function nameContains(name,str)
{ // Check for nontrivial inclusion 
  // OK, *some* trivial cases must be handled...
  if(name == str || name.toLowerCase() == str.toLowerCase()) return true;
  var nlen= name.length;
  var slen= str.length;
  var endat= nlen - slen;
  // too small to fit?
  if(nlen > str) return false;
  if(name.toLowerCase() == name || name.toUpperCase() == name)
  { // all lower/upper case name? underscores separate
    if(name.indexOf('_') == -1) return false;
    str= str.toLowerCase();
    if( name.indexOf(str+'_') == 0 ||
      name.indexOf('_'+str+'_') > -1 ||
      name.substring(endat-1,nlen+1) == ('_'+str) )
      return true;
  }
  else
  { // proper case name? uppercase starts new words 
    var sep= name.substring(slen,slen+1);
    if( name.indexOf(str) == 0 && sep == sep.toUpperCase() ) return true;
    if( name.indexOf(str.toLowerCase()) == 0 && sep == sep.toUpperCase() ) return true;
    var sep= name.substring(endat-1,endat);
    if( name.substring(endat,nlen+1) == str ) return true;
    for(var index= name.indexOf(str); index > -1; index= name.indexOf(str,index+1))
    { // for each occurence of the word, is it followed by a non-lowercase char? 
      endat= index+slen;
      sep= name.substring(endat,endat+1);
      if(sep == sep.toUpperCase()) return true;
    }
  }
  return false;
}

function autocheckByName(frm) 
{ // uses names of form elements to determine type 
  for(var index= 0; index < frm.elements.length; index++)
  {
    var el= frm.elements[index];
    if(!el.type) continue;
    if(el.type == 'text' || el.type == 'password')
    { // text fields 
      if(( /*el.name.substring(0,1) == el.name.substring(0,1).toUpperCase() || */ nameContains(el.name,'Required')) && el.value.length == 0)
      { alert('The '+fieldname(el)+' field cannot be left blank.'); el.focus(); return false; }
      if(nameContains(el.name,'Date') && !fixDate(el))
      { alert(status); el.focus(); return false; }
      if(nameContains(el.name,'Time24') && !fixTime24(el))
      { alert(status); el.focus(); return false; }
      if(nameContains(el.name,'Time') && !fixTime(el))
      { alert(status); el.focus(); return false; }
      if(nameContains(el.name,'SSN') && !fixSSN(el))
      { alert(status); el.focus(); return false; }
      if(nameContains(el.name,'CC') && !fixCreditCard(el))
      { alert(status); el.focus(); return false; }
      if(nameContains(el.name,'Email') && !checkEmail(el))
      { alert(status); el.focus(); return false; }
      if( ( nameContains(el.name,'Phone') ||
        nameContains(el.name,'Fax') || 
        nameContains(el.name,'Pager') ) &&
        !fixPhone(el))
      { alert(status); el.focus(); return false; }
    }
    // handle required select and select-multiple 
    else if(el.type.substring(0,3) == 'sel' && 
      (el.name.substring(0,1) == el.name.substring(0,1).toUpperCase() || 
      nameContains(el.name,'Required')) && el.selectedIndex == -1)
    { alert(status); el.focus(); return false; }
    // handle required checkbox
    else if(el.type == 'checkbox' && 
      (el.name.substring(0,1) == el.name.substring(0,1).toUpperCase() || 
      nameContains(el.name,'Required')) && !requireChecked(el))
    { alert(status); el.focus(); return false; }
    else if(el.type == 'radio' && !requireRadio(frm[el.name]))
    { alert(status); frm.elements[index].focus(); return false; }
  }
  for(var index= 0; index < frm.elements.length; index++)
    if(frm.elements[index].type == 'submit') frm.elements[index].disabled= true;
  return true;
}

function isMemberOf(elem,classname)
{ // checks to see if elem is a member of the (style) class 
  // trivial cases first: no membership or simple equality
  if(!elem.className)
    return false
  else if(elem.className == classname)
    return true;
  else if(elem.className.indexOf(' ') > -1)
  { // multiple class names; use split, if avail 
    if(parseInt(navigator.appVersion) >= 4)
    {
      var names= elem.className.split(' ');
      for(var index= 0; index < names.length; index++)
        if(names[index] == classname)
          return true;
    }
    // older browsers can fake it 
    // WARNING: "fine" can be found in "oldRefined"
    else if(elem.className.indexOf(classname) > -1)
      return true;
  }
  return false;
}

function checkClass(el)
{ // validate the field, based on class membership
  if(el.type == 'text' || el.type == 'password')
  { // text fields 
    if(isMemberOf(el,'required') && !requireValue(el)) return false;
    if(isMemberOf(el,'date') && !fixDate(el)) return false;
    if(isMemberOf(el,'time') && !fixTime(el)) return false;
    if(isMemberOf(el,'time24') && !fixTime24(el)) return false;
    if(isMemberOf(el,'ssn') && !fixSSN(el)) return false;
    if(isMemberOf(el,'cc') && !fixCreditCard(el)) return false;
    if(isMemberOf(el,'phone') && !fixPhone(el)) return false;
    if(isMemberOf(el,'money') && !fixMoney(el)) return false;
    if(isMemberOf(el,'int') && !fixInt(el)) return false;
    if(isMemberOf(el,'float') && !fixFloat(el)) return false;
    if(isMemberOf(el,'email') && !checkEmail(el)) return false;
  } // handle required select and select-multiple 
  else if(el.type == 'checkbox' && 
    isMemberOf(el,'required') && !requireChecked(el)) return false;
  else if(el.type.substring(0,3) == 'sel' && 
    isMemberOf(el,'required') && el.selectedIndex == -1) return false;
  return true;
}

function autocheckByClass(frm) 
{ // uses the CSS class of form elements to determine type 
  for(var index= 0; index < frm.elements.length; index++)
  {
    var el= frm.elements[index];
    if(!el.type) continue;
    if(el.type == 'radio' && !requireRadio(frm[el.name]))
    { alert(status); frm.elements[index].focus(); return false; }
    else if(!checkClass(frm.elements[index])) 
    { alert(status); frm.elements[index].focus(); return false; }
  }
  for(var index= 0; index < frm.elements.length; index++)
    if(frm.elements[index].type == 'submit') frm.elements[index].disabled= true;
  return true;
}

function autocheckByBlur(frm)
{ // uses the onBlur handler of form elements to check value 
  status= '';
  for(var index= 0; index < frm.elements.length; index++)
  {
    var el= frm.elements[index];
    if(!el.type) continue;
    if(el.type == 'radio' && !requireRadio(frm[el.name]))
    { alert(status); frm.elements[index].focus(); return false; }
    else if(el.type != 'hidden' && el.name && el.onblur)
    {
      el.onblur();
      if(status) { alert(status); el.focus(); return false; }
    }
  }
  for(var index= 0; index < frm.elements.length; index++)
    if(frm.elements[index].type == 'submit') frm.elements[index].disabled= true;
  return true;
}

function canCheckByBlur(frm)
{ // determines whether programmatic invocation of form element onblur is available
  for(var index= 0; index < frm.elements.length; index++)
  {
    var el= frm.elements[index];
    if(!el.type) continue;
    if(el.type != 'hidden' && el.name && typeof(el.onblur)=='function') return true;
  }
  return false;
}

function autocheck(frm)
{ // uses the best available method to check form values 
  var bchar= navigator.appName.substring(0,1);
  var result = true
	if(canCheckByBlur(frm)) { result = autocheckByBlur(frm) && result; }
	if(isMemberOf(frm,'autocheck')) { result = autocheckByClass(frm) && result; }
  else { result = autocheckByName(frm) && result; }
  return result;
}
