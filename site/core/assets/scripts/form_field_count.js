function textCounter(fld,n){
if(fld.value.length>n){fld.value=fld.value.substring(0,n);}
else{if(document.getElementById(fld.id+"_count")){document.getElementById(fld.id+"_count").innerHTML=n-fld.value.length;}}
};