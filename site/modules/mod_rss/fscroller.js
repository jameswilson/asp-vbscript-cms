//function to change content
function changecontent(){
if (index>=fcontent.length)
index=0
if (DOM2){
document.getElementById("fscroller").style.color="rgb(255,255,255)"
document.getElementById("fscroller").innerHTML=begintag+fcontent[index]+closetag
if (document.getElementById("fscroller").style.display="none"){document.getElementById("fscroller").style.display="block"}
colorfade()
}
else if (ie4)
document.all.fscroller.innerHTML=begintag+fcontent[index]+closetag
else if (ns4){
document.fscrollerns.document.fscrollerns_sub.document.write(begintag+fcontent[index]+closetag)
document.fscrollerns.document.fscrollerns_sub.document.close()
}

index++
setTimeout("changecontent()",delay+faderdelay)
}

// colorfade() partially by Marcio Galli for Netscape Communications.  ////////////



function colorfade() {	         	
// 20 frames fading process
maxcolor=0
step=parseInt((255-maxcolor)/20)
if(frame>0) {	
hex-=step; // increase color value
document.getElementById("fscroller").style.color="rgb("+hex+","+hex+","+hex+")"; // Set color value.
frame--;
setTimeout("colorfade()",20);	
}
else{

document.getElementById("fscroller").style.color="rgb("+maxcolor+","+maxcolor+","+maxcolor+")";
frame=20;
hex=255

}   
}
