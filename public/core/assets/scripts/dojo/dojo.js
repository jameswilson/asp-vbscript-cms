/*
	Copyright (c) 2004-2006, The Dojo Foundation
	All Rights Reserved.

	Licensed under the Academic Free License version 2.1 or above OR the
	modified BSD license. For more information on Dojo licensing, see:

		http://dojotoolkit.org/community/licensing.shtml
*/

/*
	This is a compiled version of Dojo, built for deployment and not for
	development. To get an editable version, please visit:

		http://dojotoolkit.org

	for documentation and information on getting the source.
*/

if(typeof dojo=="undefined"){
var dj_global=this;
var dj_currentContext=this;
function dj_undef(_1,_2){
return (typeof (_2||dj_currentContext)[_1]=="undefined");
}
if(dj_undef("djConfig",this)){
var djConfig={};
}
if(dj_undef("dojo",this)){
var dojo={};
}
dojo.global=function(){
return dj_currentContext;
};
dojo.locale=djConfig.locale;
dojo.version={major:0,minor:4,patch:3,flag:"",revision:Number("$Rev: 8617 $".match(/[0-9]+/)[0]),toString:function(){
with(dojo.version){
return major+"."+minor+"."+patch+flag+" ("+revision+")";
}
}};
dojo.evalProp=function(_3,_4,_5){
if((!_4)||(!_3)){
return undefined;
}
if(!dj_undef(_3,_4)){
return _4[_3];
}
return (_5?(_4[_3]={}):undefined);
};
dojo.parseObjPath=function(_6,_7,_8){
var _9=(_7||dojo.global());
var _a=_6.split(".");
var _b=_a.pop();
for(var i=0,l=_a.length;i<l&&_9;i++){
_9=dojo.evalProp(_a[i],_9,_8);
}
return {obj:_9,prop:_b};
};
dojo.evalObjPath=function(_e,_f){
if(typeof _e!="string"){
return dojo.global();
}
if(_e.indexOf(".")==-1){
return dojo.evalProp(_e,dojo.global(),_f);
}
var ref=dojo.parseObjPath(_e,dojo.global(),_f);
if(ref){
return dojo.evalProp(ref.prop,ref.obj,_f);
}
return null;
};
dojo.errorToString=function(_11){
if(!dj_undef("message",_11)){
return _11.message;
}else{
if(!dj_undef("description",_11)){
return _11.description;
}else{
return _11;
}
}
};
dojo.raise=function(_12,_13){
if(_13){
_12=_12+": "+dojo.errorToString(_13);
}else{
_12=dojo.errorToString(_12);
}
try{
if(djConfig.isDebug){
dojo.hostenv.println("FATAL exception raised: "+_12);
}
}
catch(e){
}
throw _13||Error(_12);
};
dojo.debug=function(){
};
dojo.debugShallow=function(obj){
};
dojo.profile={start:function(){
},end:function(){
},stop:function(){
},dump:function(){
}};
function dj_eval(_15){
return dj_global.eval?dj_global.eval(_15):eval(_15);
}
dojo.unimplemented=function(_16,_17){
var _18="'"+_16+"' not implemented";
if(_17!=null){
_18+=" "+_17;
}
dojo.raise(_18);
};
dojo.deprecated=function(_19,_1a,_1b){
var _1c="DEPRECATED: "+_19;
if(_1a){
_1c+=" "+_1a;
}
if(_1b){
_1c+=" -- will be removed in version: "+_1b;
}
dojo.debug(_1c);
};
dojo.render=(function(){
function vscaffold(_1d,_1e){
var tmp={capable:false,support:{builtin:false,plugin:false},prefixes:_1d};
for(var i=0;i<_1e.length;i++){
tmp[_1e[i]]=false;
}
return tmp;
}
return {name:"",ver:dojo.version,os:{win:false,linux:false,osx:false},html:vscaffold(["html"],["ie","opera","khtml","safari","moz"]),svg:vscaffold(["svg"],["corel","adobe","batik"]),vml:vscaffold(["vml"],["ie"]),swf:vscaffold(["Swf","Flash","Mm"],["mm"]),swt:vscaffold(["Swt"],["ibm"])};
})();
dojo.hostenv=(function(){
var _21={isDebug:false,allowQueryConfig:false,baseScriptUri:"",baseRelativePath:"",libraryScriptUri:"",iePreventClobber:false,ieClobberMinimal:true,preventBackButtonFix:true,delayMozLoadingFix:false,searchIds:[],parseWidgets:true};
if(typeof djConfig=="undefined"){
djConfig=_21;
}else{
for(var _22 in _21){
if(typeof djConfig[_22]=="undefined"){
djConfig[_22]=_21[_22];
}
}
}
return {name_:"(unset)",version_:"(unset)",getName:function(){
return this.name_;
},getVersion:function(){
return this.version_;
},getText:function(uri){
dojo.unimplemented("getText","uri="+uri);
}};
})();
dojo.hostenv.getBaseScriptUri=function(){
if(djConfig.baseScriptUri.length){
return djConfig.baseScriptUri;
}
var uri=new String(djConfig.libraryScriptUri||djConfig.baseRelativePath);
if(!uri){
dojo.raise("Nothing returned by getLibraryScriptUri(): "+uri);
}
var _25=uri.lastIndexOf("/");
djConfig.baseScriptUri=djConfig.baseRelativePath;
return djConfig.baseScriptUri;
};
(function(){
var _26={pkgFileName:"__package__",loading_modules_:{},loaded_modules_:{},addedToLoadingCount:[],removedFromLoadingCount:[],inFlightCount:0,modulePrefixes_:{dojo:{name:"dojo",value:"src"}},setModulePrefix:function(_27,_28){
this.modulePrefixes_[_27]={name:_27,value:_28};
},moduleHasPrefix:function(_29){
var mp=this.modulePrefixes_;
return Boolean(mp[_29]&&mp[_29].value);
},getModulePrefix:function(_2b){
if(this.moduleHasPrefix(_2b)){
return this.modulePrefixes_[_2b].value;
}
return _2b;
},getTextStack:[],loadUriStack:[],loadedUris:[],post_load_:false,modulesLoadedListeners:[],unloadListeners:[],loadNotifying:false};
for(var _2c in _26){
dojo.hostenv[_2c]=_26[_2c];
}
})();
dojo.hostenv.loadPath=function(_2d,_2e,cb){
var uri;
if(_2d.charAt(0)=="/"||_2d.match(/^\w+:/)){
uri=_2d;
}else{
uri=this.getBaseScriptUri()+_2d;
}
if(djConfig.cacheBust&&dojo.render.html.capable){
uri+="?"+String(djConfig.cacheBust).replace(/\W+/g,"");
}
try{
return !_2e?this.loadUri(uri,cb):this.loadUriAndCheck(uri,_2e,cb);
}
catch(e){
dojo.debug(e);
return false;
}
};
dojo.hostenv.loadUri=function(uri,cb){
if(this.loadedUris[uri]){
return true;
}
var _33=this.getText(uri,null,true);
if(!_33){
return false;
}
this.loadedUris[uri]=true;
if(cb){
_33="("+_33+")";
}
var _34=dj_eval(_33);
if(cb){
cb(_34);
}
return true;
};
dojo.hostenv.loadUriAndCheck=function(uri,_36,cb){
var ok=true;
try{
ok=this.loadUri(uri,cb);
}
catch(e){
dojo.debug("failed loading ",uri," with error: ",e);
}
return Boolean(ok&&this.findModule(_36,false));
};
dojo.loaded=function(){
};
dojo.unloaded=function(){
};
dojo.hostenv.loaded=function(){
this.loadNotifying=true;
this.post_load_=true;
var mll=this.modulesLoadedListeners;
for(var x=0;x<mll.length;x++){
mll[x]();
}
this.modulesLoadedListeners=[];
this.loadNotifying=false;
dojo.loaded();
};
dojo.hostenv.unloaded=function(){
var mll=this.unloadListeners;
while(mll.length){
(mll.pop())();
}
dojo.unloaded();
};
dojo.addOnLoad=function(obj,_3d){
var dh=dojo.hostenv;
if(arguments.length==1){
dh.modulesLoadedListeners.push(obj);
}else{
if(arguments.length>1){
dh.modulesLoadedListeners.push(function(){
obj[_3d]();
});
}
}
if(dh.post_load_&&dh.inFlightCount==0&&!dh.loadNotifying){
dh.callLoaded();
}
};
dojo.addOnUnload=function(obj,_40){
var dh=dojo.hostenv;
if(arguments.length==1){
dh.unloadListeners.push(obj);
}else{
if(arguments.length>1){
dh.unloadListeners.push(function(){
obj[_40]();
});
}
}
};
dojo.hostenv.modulesLoaded=function(){
if(this.post_load_){
return;
}
if(this.loadUriStack.length==0&&this.getTextStack.length==0){
if(this.inFlightCount>0){
dojo.debug("files still in flight!");
return;
}
dojo.hostenv.callLoaded();
}
};
dojo.hostenv.callLoaded=function(){
if(typeof setTimeout=="object"||(djConfig["useXDomain"]&&dojo.render.html.opera)){
setTimeout("dojo.hostenv.loaded();",0);
}else{
dojo.hostenv.loaded();
}
};
dojo.hostenv.getModuleSymbols=function(_42){
var _43=_42.split(".");
for(var i=_43.length;i>0;i--){
var _45=_43.slice(0,i).join(".");
if((i==1)&&!this.moduleHasPrefix(_45)){
_43[0]="../"+_43[0];
}else{
var _46=this.getModulePrefix(_45);
if(_46!=_45){
_43.splice(0,i,_46);
break;
}
}
}
return _43;
};
dojo.hostenv._global_omit_module_check=false;
dojo.hostenv.loadModule=function(_47,_48,_49){
if(!_47){
return;
}
_49=this._global_omit_module_check||_49;
var _4a=this.findModule(_47,false);
if(_4a){
return _4a;
}
if(dj_undef(_47,this.loading_modules_)){
this.addedToLoadingCount.push(_47);
}
this.loading_modules_[_47]=1;
var _4b=_47.replace(/\./g,"/")+".js";
var _4c=_47.split(".");
var _4d=this.getModuleSymbols(_47);
var _4e=((_4d[0].charAt(0)!="/")&&!_4d[0].match(/^\w+:/));
var _4f=_4d[_4d.length-1];
var ok;
if(_4f=="*"){
_47=_4c.slice(0,-1).join(".");
while(_4d.length){
_4d.pop();
_4d.push(this.pkgFileName);
_4b=_4d.join("/")+".js";
if(_4e&&_4b.charAt(0)=="/"){
_4b=_4b.slice(1);
}
ok=this.loadPath(_4b,!_49?_47:null);
if(ok){
break;
}
_4d.pop();
}
}else{
_4b=_4d.join("/")+".js";
_47=_4c.join(".");
var _51=!_49?_47:null;
ok=this.loadPath(_4b,_51);
if(!ok&&!_48){
_4d.pop();
while(_4d.length){
_4b=_4d.join("/")+".js";
ok=this.loadPath(_4b,_51);
if(ok){
break;
}
_4d.pop();
_4b=_4d.join("/")+"/"+this.pkgFileName+".js";
if(_4e&&_4b.charAt(0)=="/"){
_4b=_4b.slice(1);
}
ok=this.loadPath(_4b,_51);
if(ok){
break;
}
}
}
if(!ok&&!_49){
dojo.raise("Could not load '"+_47+"'; last tried '"+_4b+"'");
}
}
if(!_49&&!this["isXDomain"]){
_4a=this.findModule(_47,false);
if(!_4a){
dojo.raise("symbol '"+_47+"' is not defined after loading '"+_4b+"'");
}
}
return _4a;
};
dojo.hostenv.startPackage=function(_52){
var _53=String(_52);
var _54=_53;
var _55=_52.split(/\./);
if(_55[_55.length-1]=="*"){
_55.pop();
_54=_55.join(".");
}
var _56=dojo.evalObjPath(_54,true);
this.loaded_modules_[_53]=_56;
this.loaded_modules_[_54]=_56;
return _56;
};
dojo.hostenv.findModule=function(_57,_58){
var lmn=String(_57);
if(this.loaded_modules_[lmn]){
return this.loaded_modules_[lmn];
}
if(_58){
dojo.raise("no loaded module named '"+_57+"'");
}
return null;
};
dojo.kwCompoundRequire=function(_5a){
var _5b=_5a["common"]||[];
var _5c=_5a[dojo.hostenv.name_]?_5b.concat(_5a[dojo.hostenv.name_]||[]):_5b.concat(_5a["default"]||[]);
for(var x=0;x<_5c.length;x++){
var _5e=_5c[x];
if(_5e.constructor==Array){
dojo.hostenv.loadModule.apply(dojo.hostenv,_5e);
}else{
dojo.hostenv.loadModule(_5e);
}
}
};
dojo.require=function(_5f){
dojo.hostenv.loadModule.apply(dojo.hostenv,arguments);
};
dojo.requireIf=function(_60,_61){
var _62=arguments[0];
if((_62===true)||(_62=="common")||(_62&&dojo.render[_62].capable)){
var _63=[];
for(var i=1;i<arguments.length;i++){
_63.push(arguments[i]);
}
dojo.require.apply(dojo,_63);
}
};
dojo.requireAfterIf=dojo.requireIf;
dojo.provide=function(_65){
return dojo.hostenv.startPackage.apply(dojo.hostenv,arguments);
};
dojo.registerModulePath=function(_66,_67){
return dojo.hostenv.setModulePrefix(_66,_67);
};
if(typeof djConfig["useXDomain"]=="undefined"){
djConfig.useXDomain=true;
}
dojo.registerModulePath("dojo","http://o.aolcdn.com/dojo/0.4.3/src");
if(djConfig["modulePaths"]){
for(var param in djConfig["modulePaths"]){
dojo.registerModulePath(param,djConfig["modulePaths"][param]);
}
}
dojo.setModulePrefix=function(_68,_69){
dojo.deprecated("dojo.setModulePrefix(\""+_68+"\", \""+_69+"\")","replaced by dojo.registerModulePath","0.5");
return dojo.registerModulePath(_68,_69);
};
dojo.exists=function(obj,_6b){
var p=_6b.split(".");
for(var i=0;i<p.length;i++){
if(!obj[p[i]]){
return false;
}
obj=obj[p[i]];
}
return true;
};
dojo.hostenv.normalizeLocale=function(_6e){
var _6f=_6e?_6e.toLowerCase():dojo.locale;
if(_6f=="root"){
_6f="ROOT";
}
return _6f;
};
dojo.hostenv.searchLocalePath=function(_70,_71,_72){
_70=dojo.hostenv.normalizeLocale(_70);
var _73=_70.split("-");
var _74=[];
for(var i=_73.length;i>0;i--){
_74.push(_73.slice(0,i).join("-"));
}
_74.push(false);
if(_71){
_74.reverse();
}
for(var j=_74.length-1;j>=0;j--){
var loc=_74[j]||"ROOT";
var _78=_72(loc);
if(_78){
break;
}
}
};
dojo.hostenv.localesGenerated;
dojo.hostenv.registerNlsPrefix=function(){
dojo.registerModulePath("nls","nls");
};
dojo.hostenv.preloadLocalizations=function(){
if(dojo.hostenv.localesGenerated){
dojo.hostenv.registerNlsPrefix();
function preload(_79){
_79=dojo.hostenv.normalizeLocale(_79);
dojo.hostenv.searchLocalePath(_79,true,function(loc){
for(var i=0;i<dojo.hostenv.localesGenerated.length;i++){
if(dojo.hostenv.localesGenerated[i]==loc){
dojo["require"]("nls.dojo_"+loc);
return true;
}
}
return false;
});
}
preload();
var _7c=djConfig.extraLocale||[];
for(var i=0;i<_7c.length;i++){
preload(_7c[i]);
}
}
dojo.hostenv.preloadLocalizations=function(){
};
};
dojo.requireLocalization=function(_7e,_7f,_80,_81){
dojo.hostenv.preloadLocalizations();
var _82=dojo.hostenv.normalizeLocale(_80);
var _83=[_7e,"nls",_7f].join(".");
var _84="";
if(_81){
var _85=_81.split(",");
for(var i=0;i<_85.length;i++){
if(_82.indexOf(_85[i])==0){
if(_85[i].length>_84.length){
_84=_85[i];
}
}
}
if(!_84){
_84="ROOT";
}
}
var _87=_81?_84:_82;
var _88=dojo.hostenv.findModule(_83);
var _89=null;
if(_88){
if(djConfig.localizationComplete&&_88._built){
return;
}
var _8a=_87.replace("-","_");
var _8b=_83+"."+_8a;
_89=dojo.hostenv.findModule(_8b);
}
if(!_89){
_88=dojo.hostenv.startPackage(_83);
var _8c=dojo.hostenv.getModuleSymbols(_7e);
var _8d=_8c.concat("nls").join("/");
var _8e;
dojo.hostenv.searchLocalePath(_87,_81,function(loc){
var _90=loc.replace("-","_");
var _91=_83+"."+_90;
var _92=false;
if(!dojo.hostenv.findModule(_91)){
dojo.hostenv.startPackage(_91);
var _93=[_8d];
if(loc!="ROOT"){
_93.push(loc);
}
_93.push(_7f);
var _94=_93.join("/")+".js";
_92=dojo.hostenv.loadPath(_94,null,function(_95){
var _96=function(){
};
_96.prototype=_8e;
_88[_90]=new _96();
for(var j in _95){
_88[_90][j]=_95[j];
}
});
}else{
_92=true;
}
if(_92&&_88[_90]){
_8e=_88[_90];
}else{
_88[_90]=_8e;
}
if(_81){
return true;
}
});
}
if(_81&&_82!=_84){
_88[_82.replace("-","_")]=_88[_84.replace("-","_")];
}
};
(function(){
var _98=djConfig.extraLocale;
if(_98){
if(!_98 instanceof Array){
_98=[_98];
}
var req=dojo.requireLocalization;
dojo.requireLocalization=function(m,b,_9c,_9d){
req(m,b,_9c,_9d);
if(_9c){
return;
}
for(var i=0;i<_98.length;i++){
req(m,b,_98[i],_9d);
}
};
}
})();
dojo.hostenv.resetXd=function(){
this.isXDomain=djConfig.useXDomain||false;
this.xdTimer=0;
this.xdInFlight={};
this.xdOrderedReqs=[];
this.xdDepMap={};
this.xdContents=[];
this.xdDefList=[];
};
dojo.hostenv.resetXd();
dojo.hostenv.createXdPackage=function(_9f,_a0,_a1){
var _a2=[];
var _a3=/dojo.(requireLocalization|require|requireIf|requireAll|provide|requireAfterIf|requireAfter|kwCompoundRequire|conditionalRequire|hostenv\.conditionalLoadModule|.hostenv\.loadModule|hostenv\.moduleLoaded)\(([\w\W]*?)\)/mg;
var _a4;
while((_a4=_a3.exec(_9f))!=null){
if(_a4[1]=="requireLocalization"){
eval(_a4[0]);
}else{
_a2.push("\""+_a4[1]+"\", "+_a4[2]);
}
}
var _a5=[];
_a5.push("dojo.hostenv.packageLoaded({\n");
if(_a2.length>0){
_a5.push("depends: [");
for(var i=0;i<_a2.length;i++){
if(i>0){
_a5.push(",\n");
}
_a5.push("["+_a2[i]+"]");
}
_a5.push("],");
}
_a5.push("\ndefinePackage: function(dojo){");
_a5.push(_9f);
_a5.push("\n}, resourceName: '"+_a0+"', resourcePath: '"+_a1+"'});");
return _a5.join("");
};
dojo.hostenv.loadPath=function(_a7,_a8,cb){
var _aa=_a7.indexOf(":");
var _ab=_a7.indexOf("/");
var uri;
var _ad=false;
if(_aa>0&&_aa<_ab){
uri=_a7;
this.isXDomain=_ad=true;
}else{
uri=this.getBaseScriptUri()+_a7;
_aa=uri.indexOf(":");
_ab=uri.indexOf("/");
if(_aa>0&&_aa<_ab&&(!location.host||uri.indexOf("http://"+location.host)!=0)){
this.isXDomain=_ad=true;
}
}
if(djConfig.cacheBust&&dojo.render.html.capable){
uri+="?"+String(djConfig.cacheBust).replace(/\W+/g,"");
}
try{
return ((!_a8||this.isXDomain)?this.loadUri(uri,cb,_ad,_a8):this.loadUriAndCheck(uri,_a8,cb));
}
catch(e){
dojo.debug(e);
return false;
}
};
dojo.hostenv.loadUri=function(uri,cb,_b0,_b1){
if(this.loadedUris[uri]){
return 1;
}
if(this.isXDomain&&_b1){
if(uri.indexOf("__package__")!=-1){
_b1+=".*";
}
this.xdOrderedReqs.push(_b1);
if(_b0||uri.indexOf("/nls/")==-1){
this.xdInFlight[_b1]=true;
this.inFlightCount++;
}
if(!this.xdTimer){
this.xdTimer=setInterval("dojo.hostenv.watchInFlightXDomain();",100);
}
this.xdStartTime=(new Date()).getTime();
}
if(_b0){
var _b2=uri.lastIndexOf(".");
if(_b2<=0){
_b2=uri.length-1;
}
var _b3=uri.substring(0,_b2)+".xd";
if(_b2!=uri.length-1){
_b3+=uri.substring(_b2,uri.length);
}
var _b4=document.createElement("script");
_b4.type="text/javascript";
_b4.src=_b3;
if(!this.headElement){
this.headElement=document.getElementsByTagName("head")[0];
if(!this.headElement){
this.headElement=document.getElementsByTagName("html")[0];
}
}
this.headElement.appendChild(_b4);
}else{
var _b5=this.getText(uri,null,true);
if(_b5==null){
return 0;
}
if(this.isXDomain&&uri.indexOf("/nls/")==-1){
var pkg=this.createXdPackage(_b5,_b1,uri);
dj_eval(pkg);
}else{
if(cb){
_b5="("+_b5+")";
}
var _b7=dj_eval(_b5);
if(cb){
cb(_b7);
}
}
}
this.loadedUris[uri]=true;
return 1;
};
dojo.hostenv.packageLoaded=function(pkg){
var _b9=pkg.depends;
var _ba=null;
var _bb=null;
var _bc=[];
if(_b9&&_b9.length>0){
var dep=null;
var _be=0;
var _bf=false;
for(var i=0;i<_b9.length;i++){
dep=_b9[i];
if(dep[0]=="provide"||dep[0]=="hostenv.moduleLoaded"){
_bc.push(dep[1]);
}else{
if(!_ba){
_ba=[];
}
if(!_bb){
_bb=[];
}
var _c1=this.unpackXdDependency(dep);
if(_c1.requires){
_ba=_ba.concat(_c1.requires);
}
if(_c1.requiresAfter){
_bb=_bb.concat(_c1.requiresAfter);
}
}
var _c2=dep[0];
var _c3=_c2.split(".");
if(_c3.length==2){
dojo[_c3[0]][_c3[1]].apply(dojo[_c3[0]],dep.slice(1));
}else{
dojo[_c2].apply(dojo,dep.slice(1));
}
}
var _c4=this.xdContents.push({content:pkg.definePackage,resourceName:pkg["resourceName"],resourcePath:pkg["resourcePath"],isDefined:false})-1;
for(var i=0;i<_bc.length;i++){
this.xdDepMap[_bc[i]]={requires:_ba,requiresAfter:_bb,contentIndex:_c4};
}
for(var i=0;i<_bc.length;i++){
this.xdInFlight[_bc[i]]=false;
}
}
};
dojo.hostenv.xdLoadFlattenedBundle=function(_c5,_c6,_c7,_c8){
_c7=_c7||"root";
var _c9=dojo.hostenv.normalizeLocale(_c7).replace("-","_");
var _ca=[_c5,"nls",_c6].join(".");
var _cb=dojo.hostenv.startPackage(_ca);
_cb[_c9]=_c8;
var _cc=[_c5,_c9,_c6].join(".");
var _cd=dojo.hostenv.xdBundleMap[_cc];
if(_cd){
for(var _ce in _cd){
_cb[_ce]=_c8;
}
}
};
dojo.hostenv.xdBundleMap={};
dojo.xdRequireLocalization=function(_cf,_d0,_d1,_d2){
var _d3=_d2.split(",");
var _d4=dojo.hostenv.normalizeLocale(_d1);
var _d5="";
for(var i=0;i<_d3.length;i++){
if(_d4.indexOf(_d3[i])==0){
if(_d3[i].length>_d5.length){
_d5=_d3[i];
}
}
}
var _d7=_d5.replace("-","_");
var _d8=dojo.evalObjPath([_cf,"nls",_d0].join("."));
if(_d8&&_d8[_d7]){
bundle[_d4.replace("-","_")]=_d8[_d7];
}else{
var _d9=[_cf,(_d7||"root"),_d0].join(".");
var _da=dojo.hostenv.xdBundleMap[_d9];
if(!_da){
_da=dojo.hostenv.xdBundleMap[_d9]={};
}
_da[_d4.replace("-","_")]=true;
dojo.require(_cf+".nls"+(_d5?"."+_d5:"")+"."+_d0);
}
};
(function(){
var _db=djConfig.extraLocale;
if(_db){
if(!_db instanceof Array){
_db=[_db];
}
dojo._xdReqLoc=dojo.xdRequireLocalization;
dojo.xdRequireLocalization=function(m,b,_de,_df){
dojo._xdReqLoc(m,b,_de,_df);
if(_de){
return;
}
for(var i=0;i<_db.length;i++){
dojo._xdReqLoc(m,b,_db[i],_df);
}
};
}
})();
dojo.hostenv.unpackXdDependency=function(dep){
var _e2=null;
var _e3=null;
switch(dep[0]){
case "requireIf":
case "requireAfterIf":
case "conditionalRequire":
if((dep[1]===true)||(dep[1]=="common")||(dep[1]&&dojo.render[dep[1]].capable)){
_e2=[{name:dep[2],content:null}];
}
break;
case "requireAll":
dep.shift();
_e2=dep;
dojo.hostenv.flattenRequireArray(_e2);
break;
case "kwCompoundRequire":
case "hostenv.conditionalLoadModule":
var _e4=dep[1];
var _e5=_e4["common"]||[];
var _e2=(_e4[dojo.hostenv.name_])?_e5.concat(_e4[dojo.hostenv.name_]||[]):_e5.concat(_e4["default"]||[]);
dojo.hostenv.flattenRequireArray(_e2);
break;
case "require":
case "requireAfter":
case "hostenv.loadModule":
_e2=[{name:dep[1],content:null}];
break;
}
if(dep[0]=="requireAfterIf"||dep[0]=="requireIf"){
_e3=_e2;
_e2=null;
}
return {requires:_e2,requiresAfter:_e3};
};
dojo.hostenv.xdWalkReqs=function(){
var _e6=null;
var req;
for(var i=0;i<this.xdOrderedReqs.length;i++){
req=this.xdOrderedReqs[i];
if(this.xdDepMap[req]){
_e6=[req];
_e6[req]=true;
this.xdEvalReqs(_e6);
}
}
};
dojo.hostenv.xdEvalReqs=function(_e9){
while(_e9.length>0){
var req=_e9[_e9.length-1];
var pkg=this.xdDepMap[req];
if(pkg){
var _ec=pkg.requires;
if(_ec&&_ec.length>0){
var _ed;
for(var i=0;i<_ec.length;i++){
_ed=_ec[i].name;
if(_ed&&!_e9[_ed]){
_e9.push(_ed);
_e9[_ed]=true;
this.xdEvalReqs(_e9);
}
}
}
var _ef=this.xdContents[pkg.contentIndex];
if(!_ef.isDefined){
var _f0=_ef.content;
_f0["resourceName"]=_ef["resourceName"];
_f0["resourcePath"]=_ef["resourcePath"];
this.xdDefList.push(_f0);
_ef.isDefined=true;
}
this.xdDepMap[req]=null;
var _ec=pkg.requiresAfter;
if(_ec&&_ec.length>0){
var _ed;
for(var i=0;i<_ec.length;i++){
_ed=_ec[i].name;
if(_ed&&!_e9[_ed]){
_e9.push(_ed);
_e9[_ed]=true;
this.xdEvalReqs(_e9);
}
}
}
}
_e9.pop();
}
};
dojo.hostenv.clearXdInterval=function(){
clearInterval(this.xdTimer);
this.xdTimer=0;
};
dojo.hostenv.watchInFlightXDomain=function(){
var _f1=(djConfig.xdWaitSeconds||15)*1000;
if(this.xdStartTime+_f1<(new Date()).getTime()){
this.clearXdInterval();
var _f2="";
for(var _f3 in this.xdInFlight){
if(this.xdInFlight[_f3]){
_f2+=_f3+" ";
}
}
dojo.raise("Could not load cross-domain packages: "+_f2);
}
for(var _f3 in this.xdInFlight){
if(this.xdInFlight[_f3]){
return;
}
}
this.clearXdInterval();
this.xdWalkReqs();
var _f4=this.xdDefList.length;
for(var i=0;i<_f4;i++){
var _f6=dojo.hostenv.xdDefList[i];
if(djConfig["debugAtAllCosts"]&&_f6["resourceName"]){
if(!this["xdDebugQueue"]){
this.xdDebugQueue=[];
}
this.xdDebugQueue.push({resourceName:_f6.resourceName,resourcePath:_f6.resourcePath});
}else{
_f6(dojo);
}
}
for(var i=0;i<this.xdContents.length;i++){
var _f7=this.xdContents[i];
if(_f7.content&&!_f7.isDefined){
_f7.content(dojo);
}
}
this.resetXd();
if(this["xdDebugQueue"]&&this.xdDebugQueue.length>0){
this.xdDebugFileLoaded();
}else{
this.xdNotifyLoaded();
}
};
dojo.hostenv.xdNotifyLoaded=function(){
this.inFlightCount=0;
if(this._djInitFired&&!this.loadNotifying){
this.callLoaded();
}
};
dojo.hostenv.flattenRequireArray=function(_f8){
if(_f8){
for(var i=0;i<_f8.length;i++){
if(_f8[i] instanceof Array){
_f8[i]={name:_f8[i][0],content:null};
}else{
_f8[i]={name:_f8[i],content:null};
}
}
}
};
dojo.hostenv.xdHasCalledPreload=false;
dojo.hostenv.xdRealCallLoaded=dojo.hostenv.callLoaded;
dojo.hostenv.callLoaded=function(){
if(this.xdHasCalledPreload||dojo.hostenv.getModulePrefix("dojo")=="src"||!this.localesGenerated){
this.xdRealCallLoaded();
}else{
if(this.localesGenerated){
this.registerNlsPrefix=function(){
dojo.registerModulePath("nls",dojo.hostenv.getModulePrefix("dojo")+"/../nls");
};
this.preloadLocalizations();
}
}
this.xdHasCalledPreload=true;
};
}
if(typeof window!="undefined"){
(function(){
if(djConfig.allowQueryConfig){
var _fa=document.location.toString();
var _fb=_fa.split("?",2);
if(_fb.length>1){
var _fc=_fb[1];
var _fd=_fc.split("&");
for(var x in _fd){
var sp=_fd[x].split("=");
if((sp[0].length>9)&&(sp[0].substr(0,9)=="djConfig.")){
var opt=sp[0].substr(9);
try{
djConfig[opt]=eval(sp[1]);
}
catch(e){
djConfig[opt]=sp[1];
}
}
}
}
}
if(((djConfig["baseScriptUri"]=="")||(djConfig["baseRelativePath"]==""))&&(document&&document.getElementsByTagName)){
var _101=document.getElementsByTagName("script");
var _102=/(__package__|dojo|bootstrap1)\.js([\?\.]|$)/i;
for(var i=0;i<_101.length;i++){
var src=_101[i].getAttribute("src");
if(!src){
continue;
}
var m=src.match(_102);
if(m){
var root=src.substring(0,m.index);
if(src.indexOf("bootstrap1")>-1){
root+="../";
}
if(!this["djConfig"]){
djConfig={};
}
if(djConfig["baseScriptUri"]==""){
djConfig["baseScriptUri"]=root;
}
if(djConfig["baseRelativePath"]==""){
djConfig["baseRelativePath"]=root;
}
break;
}
}
}
var dr=dojo.render;
var drh=dojo.render.html;
var drs=dojo.render.svg;
var dua=(drh.UA=navigator.userAgent);
var dav=(drh.AV=navigator.appVersion);
var t=true;
var f=false;
drh.capable=t;
drh.support.builtin=t;
dr.ver=parseFloat(drh.AV);
dr.os.mac=dav.indexOf("Macintosh")>=0;
dr.os.win=dav.indexOf("Windows")>=0;
dr.os.linux=dav.indexOf("X11")>=0;
drh.opera=dua.indexOf("Opera")>=0;
drh.khtml=(dav.indexOf("Konqueror")>=0)||(dav.indexOf("Safari")>=0);
drh.safari=dav.indexOf("Safari")>=0;
var _10e=dua.indexOf("Gecko");
drh.mozilla=drh.moz=(_10e>=0)&&(!drh.khtml);
if(drh.mozilla){
drh.geckoVersion=dua.substring(_10e+6,_10e+14);
}
drh.ie=(document.all)&&(!drh.opera);
drh.ie50=drh.ie&&dav.indexOf("MSIE 5.0")>=0;
drh.ie55=drh.ie&&dav.indexOf("MSIE 5.5")>=0;
drh.ie60=drh.ie&&dav.indexOf("MSIE 6.0")>=0;
drh.ie70=drh.ie&&dav.indexOf("MSIE 7.0")>=0;
var cm=document["compatMode"];
drh.quirks=(cm=="BackCompat")||(cm=="QuirksMode")||drh.ie55||drh.ie50;
dojo.locale=dojo.locale||(drh.ie?navigator.userLanguage:navigator.language).toLowerCase();
dr.vml.capable=drh.ie;
drs.capable=f;
drs.support.plugin=f;
drs.support.builtin=f;
var tdoc=window["document"];
var tdi=tdoc["implementation"];
if((tdi)&&(tdi["hasFeature"])&&(tdi.hasFeature("org.w3c.dom.svg","1.0"))){
drs.capable=t;
drs.support.builtin=t;
drs.support.plugin=f;
}
if(drh.safari){
var tmp=dua.split("AppleWebKit/")[1];
var ver=parseFloat(tmp.split(" ")[0]);
if(ver>=420){
drs.capable=t;
drs.support.builtin=t;
drs.support.plugin=f;
}
}else{
}
})();
dojo.hostenv.startPackage("dojo.hostenv");
dojo.render.name=dojo.hostenv.name_="browser";
dojo.hostenv.searchIds=[];
dojo.hostenv._XMLHTTP_PROGIDS=["Msxml2.XMLHTTP","Microsoft.XMLHTTP","Msxml2.XMLHTTP.4.0"];
dojo.hostenv.getXmlhttpObject=function(){
var http=null;
var _115=null;
try{
http=new XMLHttpRequest();
}
catch(e){
}
if(!http){
for(var i=0;i<3;++i){
var _117=dojo.hostenv._XMLHTTP_PROGIDS[i];
try{
http=new ActiveXObject(_117);
}
catch(e){
_115=e;
}
if(http){
dojo.hostenv._XMLHTTP_PROGIDS=[_117];
break;
}
}
}
if(!http){
return dojo.raise("XMLHTTP not available",_115);
}
return http;
};
dojo.hostenv._blockAsync=false;
dojo.hostenv.getText=function(uri,_119,_11a){
if(!_119){
this._blockAsync=true;
}
var http=this.getXmlhttpObject();
function isDocumentOk(http){
var stat=http["status"];
return Boolean((!stat)||((200<=stat)&&(300>stat))||(stat==304));
}
if(_119){
var _11e=this,_11f=null,gbl=dojo.global();
var xhr=dojo.evalObjPath("dojo.io.XMLHTTPTransport");
http.onreadystatechange=function(){
if(_11f){
gbl.clearTimeout(_11f);
_11f=null;
}
if(_11e._blockAsync||(xhr&&xhr._blockAsync)){
_11f=gbl.setTimeout(function(){
http.onreadystatechange.apply(this);
},10);
}else{
if(4==http.readyState){
if(isDocumentOk(http)){
_119(http.responseText);
}
}
}
};
}
http.open("GET",uri,_119?true:false);
try{
http.send(null);
if(_119){
return null;
}
if(!isDocumentOk(http)){
var err=Error("Unable to load "+uri+" status:"+http.status);
err.status=http.status;
err.responseText=http.responseText;
throw err;
}
}
catch(e){
this._blockAsync=false;
if((_11a)&&(!_119)){
return null;
}else{
throw e;
}
}
this._blockAsync=false;
return http.responseText;
};
dojo.hostenv.defaultDebugContainerId="dojoDebug";
dojo.hostenv._println_buffer=[];
dojo.hostenv._println_safe=false;
dojo.hostenv.println=function(line){
if(!dojo.hostenv._println_safe){
dojo.hostenv._println_buffer.push(line);
}else{
try{
var _124=document.getElementById(djConfig.debugContainerId?djConfig.debugContainerId:dojo.hostenv.defaultDebugContainerId);
if(!_124){
_124=dojo.body();
}
var div=document.createElement("div");
div.appendChild(document.createTextNode(line));
_124.appendChild(div);
}
catch(e){
try{
document.write("<div>"+line+"</div>");
}
catch(e2){
window.status=line;
}
}
}
};
dojo.addOnLoad(function(){
dojo.hostenv._println_safe=true;
while(dojo.hostenv._println_buffer.length>0){
dojo.hostenv.println(dojo.hostenv._println_buffer.shift());
}
});
function dj_addNodeEvtHdlr(node,_127,fp){
var _129=node["on"+_127]||function(){
};
node["on"+_127]=function(){
fp.apply(node,arguments);
_129.apply(node,arguments);
};
return true;
}
dojo.hostenv._djInitFired=false;
function dj_load_init(e){
dojo.hostenv._djInitFired=true;
var type=(e&&e.type)?e.type.toLowerCase():"load";
if(arguments.callee.initialized||(type!="domcontentloaded"&&type!="load")){
return;
}
arguments.callee.initialized=true;
if(typeof (_timer)!="undefined"){
clearInterval(_timer);
delete _timer;
}
var _12c=function(){
if(dojo.render.html.ie){
dojo.hostenv.makeWidgets();
}
};
if(dojo.hostenv.inFlightCount==0){
_12c();
dojo.hostenv.modulesLoaded();
}else{
dojo.hostenv.modulesLoadedListeners.unshift(_12c);
}
}
if(document.addEventListener){
if(dojo.render.html.opera||(dojo.render.html.moz&&(djConfig["enableMozDomContentLoaded"]===true))){
document.addEventListener("DOMContentLoaded",dj_load_init,null);
}
window.addEventListener("load",dj_load_init,null);
}
if(dojo.render.html.ie&&dojo.render.os.win){
document.attachEvent("onreadystatechange",function(e){
if(document.readyState=="complete"){
dj_load_init();
}
});
}
if(/(WebKit|khtml)/i.test(navigator.userAgent)){
var _timer=setInterval(function(){
if(/loaded|complete/.test(document.readyState)){
dj_load_init();
}
},10);
}
if(dojo.render.html.ie){
dj_addNodeEvtHdlr(window,"beforeunload",function(){
dojo.hostenv._unloading=true;
window.setTimeout(function(){
dojo.hostenv._unloading=false;
},0);
});
}
dj_addNodeEvtHdlr(window,"unload",function(){
dojo.hostenv.unloaded();
if((!dojo.render.html.ie)||(dojo.render.html.ie&&dojo.hostenv._unloading)){
dojo.hostenv.unloaded();
}
});
dojo.hostenv.makeWidgets=function(){
var sids=[];
if(djConfig.searchIds&&djConfig.searchIds.length>0){
sids=sids.concat(djConfig.searchIds);
}
if(dojo.hostenv.searchIds&&dojo.hostenv.searchIds.length>0){
sids=sids.concat(dojo.hostenv.searchIds);
}
if((djConfig.parseWidgets)||(sids.length>0)){
if(dojo.evalObjPath("dojo.widget.Parse")){
var _12f=new dojo.xml.Parse();
if(sids.length>0){
for(var x=0;x<sids.length;x++){
var _131=document.getElementById(sids[x]);
if(!_131){
continue;
}
var frag=_12f.parseElement(_131,null,true);
dojo.widget.getParser().createComponents(frag);
}
}else{
if(djConfig.parseWidgets){
var frag=_12f.parseElement(dojo.body(),null,true);
dojo.widget.getParser().createComponents(frag);
}
}
}
}
};
dojo.addOnLoad(function(){
if(!dojo.render.html.ie){
dojo.hostenv.makeWidgets();
}
});
try{
if(dojo.render.html.ie){
document.namespaces.add("v","urn:schemas-microsoft-com:vml");
document.createStyleSheet().addRule("v\\:*","behavior:url(#default#VML)");
}
}
catch(e){
}
dojo.hostenv.writeIncludes=function(){
};
if(!dj_undef("document",this)){
dj_currentDocument=this.document;
}
dojo.doc=function(){
return dj_currentDocument;
};
dojo.body=function(){
return dojo.doc().body||dojo.doc().getElementsByTagName("body")[0];
};
dojo.byId=function(id,doc){
if((id)&&((typeof id=="string")||(id instanceof String))){
if(!doc){
doc=dj_currentDocument;
}
var ele=doc.getElementById(id);
if(ele&&(ele.id!=id)&&doc.all){
ele=null;
eles=doc.all[id];
if(eles){
if(eles.length){
for(var i=0;i<eles.length;i++){
if(eles[i].id==id){
ele=eles[i];
break;
}
}
}else{
ele=eles;
}
}
}
return ele;
}
return id;
};
dojo.setContext=function(_137,_138){
dj_currentContext=_137;
dj_currentDocument=_138;
};
dojo._fireCallback=function(_139,_13a,_13b){
if((_13a)&&((typeof _139=="string")||(_139 instanceof String))){
_139=_13a[_139];
}
return (_13a?_139.apply(_13a,_13b||[]):_139());
};
dojo.withGlobal=function(_13c,_13d,_13e,_13f){
var rval;
var _141=dj_currentContext;
var _142=dj_currentDocument;
try{
dojo.setContext(_13c,_13c.document);
rval=dojo._fireCallback(_13d,_13e,_13f);
}
finally{
dojo.setContext(_141,_142);
}
return rval;
};
dojo.withDoc=function(_143,_144,_145,_146){
var rval;
var _148=dj_currentDocument;
try{
dj_currentDocument=_143;
rval=dojo._fireCallback(_144,_145,_146);
}
finally{
dj_currentDocument=_148;
}
return rval;
};
}
dojo.requireIf((djConfig["isDebug"]||djConfig["debugAtAllCosts"]),"dojo.debug");
dojo.requireIf(djConfig["debugAtAllCosts"]&&!window.widget&&!djConfig["useXDomain"],"dojo.browser_debug");
dojo.requireIf(djConfig["debugAtAllCosts"]&&!window.widget&&djConfig["useXDomain"],"dojo.browser_debug_xd");
dojo.provide("dojo.string.common");
dojo.string.trim=function(str,wh){
if(!str.replace){
return str;
}
if(!str.length){
return str;
}
var re=(wh>0)?(/^\s+/):(wh<0)?(/\s+$/):(/^\s+|\s+$/g);
return str.replace(re,"");
};
dojo.string.trimStart=function(str){
return dojo.string.trim(str,1);
};
dojo.string.trimEnd=function(str){
return dojo.string.trim(str,-1);
};
dojo.string.repeat=function(str,_14f,_150){
var out="";
for(var i=0;i<_14f;i++){
out+=str;
if(_150&&i<_14f-1){
out+=_150;
}
}
return out;
};
dojo.string.pad=function(str,len,c,dir){
var out=String(str);
if(!c){
c="0";
}
if(!dir){
dir=1;
}
while(out.length<len){
if(dir>0){
out=c+out;
}else{
out+=c;
}
}
return out;
};
dojo.string.padLeft=function(str,len,c){
return dojo.string.pad(str,len,c,1);
};
dojo.string.padRight=function(str,len,c){
return dojo.string.pad(str,len,c,-1);
};
dojo.provide("dojo.string");
dojo.provide("dojo.lang.common");
dojo.lang.inherits=function(_15e,_15f){
if(!dojo.lang.isFunction(_15f)){
dojo.raise("dojo.inherits: superclass argument ["+_15f+"] must be a function (subclass: ["+_15e+"']");
}
_15e.prototype=new _15f();
_15e.prototype.constructor=_15e;
_15e.superclass=_15f.prototype;
_15e["super"]=_15f.prototype;
};
dojo.lang._mixin=function(obj,_161){
var tobj={};
for(var x in _161){
if((typeof tobj[x]=="undefined")||(tobj[x]!=_161[x])){
obj[x]=_161[x];
}
}
if(dojo.render.html.ie&&(typeof (_161["toString"])=="function")&&(_161["toString"]!=obj["toString"])&&(_161["toString"]!=tobj["toString"])){
obj.toString=_161.toString;
}
return obj;
};
dojo.lang.mixin=function(obj,_165){
for(var i=1,l=arguments.length;i<l;i++){
dojo.lang._mixin(obj,arguments[i]);
}
return obj;
};
dojo.lang.extend=function(_168,_169){
for(var i=1,l=arguments.length;i<l;i++){
dojo.lang._mixin(_168.prototype,arguments[i]);
}
return _168;
};
dojo.inherits=dojo.lang.inherits;
dojo.mixin=dojo.lang.mixin;
dojo.extend=dojo.lang.extend;
dojo.lang.find=function(_16c,_16d,_16e,_16f){
if(!dojo.lang.isArrayLike(_16c)&&dojo.lang.isArrayLike(_16d)){
dojo.deprecated("dojo.lang.find(value, array)","use dojo.lang.find(array, value) instead","0.5");
var temp=_16c;
_16c=_16d;
_16d=temp;
}
var _171=dojo.lang.isString(_16c);
if(_171){
_16c=_16c.split("");
}
if(_16f){
var step=-1;
var i=_16c.length-1;
var end=-1;
}else{
var step=1;
var i=0;
var end=_16c.length;
}
if(_16e){
while(i!=end){
if(_16c[i]===_16d){
return i;
}
i+=step;
}
}else{
while(i!=end){
if(_16c[i]==_16d){
return i;
}
i+=step;
}
}
return -1;
};
dojo.lang.indexOf=dojo.lang.find;
dojo.lang.findLast=function(_175,_176,_177){
return dojo.lang.find(_175,_176,_177,true);
};
dojo.lang.lastIndexOf=dojo.lang.findLast;
dojo.lang.inArray=function(_178,_179){
return dojo.lang.find(_178,_179)>-1;
};
dojo.lang.isObject=function(it){
if(typeof it=="undefined"){
return false;
}
return (typeof it=="object"||it===null||dojo.lang.isArray(it)||dojo.lang.isFunction(it));
};
dojo.lang.isArray=function(it){
return (it&&it instanceof Array||typeof it=="array");
};
dojo.lang.isArrayLike=function(it){
if((!it)||(dojo.lang.isUndefined(it))){
return false;
}
if(dojo.lang.isString(it)){
return false;
}
if(dojo.lang.isFunction(it)){
return false;
}
if(dojo.lang.isArray(it)){
return true;
}
if((it.tagName)&&(it.tagName.toLowerCase()=="form")){
return false;
}
if(dojo.lang.isNumber(it.length)&&isFinite(it.length)){
return true;
}
return false;
};
dojo.lang.isFunction=function(it){
return (it instanceof Function||typeof it=="function");
};
(function(){
if((dojo.render.html.capable)&&(dojo.render.html["safari"])){
dojo.lang.isFunction=function(it){
if((typeof (it)=="function")&&(it=="[object NodeList]")){
return false;
}
return (it instanceof Function||typeof it=="function");
};
}
})();
dojo.lang.isString=function(it){
return (typeof it=="string"||it instanceof String);
};
dojo.lang.isAlien=function(it){
if(!it){
return false;
}
return !dojo.lang.isFunction(it)&&/\{\s*\[native code\]\s*\}/.test(String(it));
};
dojo.lang.isBoolean=function(it){
return (it instanceof Boolean||typeof it=="boolean");
};
dojo.lang.isNumber=function(it){
return (it instanceof Number||typeof it=="number");
};
dojo.lang.isUndefined=function(it){
return ((typeof (it)=="undefined")&&(it==undefined));
};
dojo.provide("dojo.lang.extras");
dojo.lang.setTimeout=function(func,_185){
var _186=window,_187=2;
if(!dojo.lang.isFunction(func)){
_186=func;
func=_185;
_185=arguments[2];
_187++;
}
if(dojo.lang.isString(func)){
func=_186[func];
}
var args=[];
for(var i=_187;i<arguments.length;i++){
args.push(arguments[i]);
}
return dojo.global().setTimeout(function(){
func.apply(_186,args);
},_185);
};
dojo.lang.clearTimeout=function(_18a){
dojo.global().clearTimeout(_18a);
};
dojo.lang.getNameInObj=function(ns,item){
if(!ns){
ns=dj_global;
}
for(var x in ns){
if(ns[x]===item){
return new String(x);
}
}
return null;
};
dojo.lang.shallowCopy=function(obj,deep){
var i,ret;
if(obj===null){
return null;
}
if(dojo.lang.isObject(obj)){
ret=new obj.constructor();
for(i in obj){
if(dojo.lang.isUndefined(ret[i])){
ret[i]=deep?dojo.lang.shallowCopy(obj[i],deep):obj[i];
}
}
}else{
if(dojo.lang.isArray(obj)){
ret=[];
for(i=0;i<obj.length;i++){
ret[i]=deep?dojo.lang.shallowCopy(obj[i],deep):obj[i];
}
}else{
ret=obj;
}
}
return ret;
};
dojo.lang.firstValued=function(){
for(var i=0;i<arguments.length;i++){
if(typeof arguments[i]!="undefined"){
return arguments[i];
}
}
return undefined;
};
dojo.lang.getObjPathValue=function(_193,_194,_195){
with(dojo.parseObjPath(_193,_194,_195)){
return dojo.evalProp(prop,obj,_195);
}
};
dojo.lang.setObjPathValue=function(_196,_197,_198,_199){
dojo.deprecated("dojo.lang.setObjPathValue","use dojo.parseObjPath and the '=' operator","0.6");
if(arguments.length<4){
_199=true;
}
with(dojo.parseObjPath(_196,_198,_199)){
if(obj&&(_199||(prop in obj))){
obj[prop]=_197;
}
}
};
dojo.provide("dojo.io.common");
dojo.io.transports=[];
dojo.io.hdlrFuncNames=["load","error","timeout"];
dojo.io.Request=function(url,_19b,_19c,_19d){
if((arguments.length==1)&&(arguments[0].constructor==Object)){
this.fromKwArgs(arguments[0]);
}else{
this.url=url;
if(_19b){
this.mimetype=_19b;
}
if(_19c){
this.transport=_19c;
}
if(arguments.length>=4){
this.changeUrl=_19d;
}
}
};
dojo.lang.extend(dojo.io.Request,{url:"",mimetype:"text/plain",method:"GET",content:undefined,transport:undefined,changeUrl:undefined,formNode:undefined,sync:false,bindSuccess:false,useCache:false,preventCache:false,jsonFilter:function(_19e){
if((this.mimetype=="text/json-comment-filtered")||(this.mimetype=="application/json-comment-filtered")){
var _19f=_19e.indexOf("/*");
var _1a0=_19e.lastIndexOf("*/");
if((_19f==-1)||(_1a0==-1)){
dojo.debug("your JSON wasn't comment filtered!");
return "";
}
return _19e.substring(_19f+2,_1a0);
}
dojo.debug("please consider using a mimetype of text/json-comment-filtered to avoid potential security issues with JSON endpoints");
return _19e;
},load:function(type,data,_1a3,_1a4){
},error:function(type,_1a6,_1a7,_1a8){
},timeout:function(type,_1aa,_1ab,_1ac){
},handle:function(type,data,_1af,_1b0){
},timeoutSeconds:0,abort:function(){
},fromKwArgs:function(_1b1){
if(_1b1["url"]){
_1b1.url=_1b1.url.toString();
}
if(_1b1["formNode"]){
_1b1.formNode=dojo.byId(_1b1.formNode);
}
if(!_1b1["method"]&&_1b1["formNode"]&&_1b1["formNode"].method){
_1b1.method=_1b1["formNode"].method;
}
if(!_1b1["handle"]&&_1b1["handler"]){
_1b1.handle=_1b1.handler;
}
if(!_1b1["load"]&&_1b1["loaded"]){
_1b1.load=_1b1.loaded;
}
if(!_1b1["changeUrl"]&&_1b1["changeURL"]){
_1b1.changeUrl=_1b1.changeURL;
}
_1b1.encoding=dojo.lang.firstValued(_1b1["encoding"],djConfig["bindEncoding"],"");
_1b1.sendTransport=dojo.lang.firstValued(_1b1["sendTransport"],djConfig["ioSendTransport"],false);
var _1b2=dojo.lang.isFunction;
for(var x=0;x<dojo.io.hdlrFuncNames.length;x++){
var fn=dojo.io.hdlrFuncNames[x];
if(_1b1[fn]&&_1b2(_1b1[fn])){
continue;
}
if(_1b1["handle"]&&_1b2(_1b1["handle"])){
_1b1[fn]=_1b1.handle;
}
}
dojo.lang.mixin(this,_1b1);
}});
dojo.io.Error=function(msg,type,num){
this.message=msg;
this.type=type||"unknown";
this.number=num||0;
};
dojo.io.transports.addTransport=function(name){
this.push(name);
this[name]=dojo.io[name];
};
dojo.io.bind=function(_1b9){
if(!(_1b9 instanceof dojo.io.Request)){
try{
_1b9=new dojo.io.Request(_1b9);
}
catch(e){
dojo.debug(e);
}
}
var _1ba="";
if(_1b9["transport"]){
_1ba=_1b9["transport"];
if(!this[_1ba]){
dojo.io.sendBindError(_1b9,"No dojo.io.bind() transport with name '"+_1b9["transport"]+"'.");
return _1b9;
}
if(!this[_1ba].canHandle(_1b9)){
dojo.io.sendBindError(_1b9,"dojo.io.bind() transport with name '"+_1b9["transport"]+"' cannot handle this type of request.");
return _1b9;
}
}else{
for(var x=0;x<dojo.io.transports.length;x++){
var tmp=dojo.io.transports[x];
if((this[tmp])&&(this[tmp].canHandle(_1b9))){
_1ba=tmp;
break;
}
}
if(_1ba==""){
dojo.io.sendBindError(_1b9,"None of the loaded transports for dojo.io.bind()"+" can handle the request.");
return _1b9;
}
}
this[_1ba].bind(_1b9);
_1b9.bindSuccess=true;
return _1b9;
};
dojo.io.sendBindError=function(_1bd,_1be){
if((typeof _1bd.error=="function"||typeof _1bd.handle=="function")&&(typeof setTimeout=="function"||typeof setTimeout=="object")){
var _1bf=new dojo.io.Error(_1be);
setTimeout(function(){
_1bd[(typeof _1bd.error=="function")?"error":"handle"]("error",_1bf,null,_1bd);
},50);
}else{
dojo.raise(_1be);
}
};
dojo.io.queueBind=function(_1c0){
if(!(_1c0 instanceof dojo.io.Request)){
try{
_1c0=new dojo.io.Request(_1c0);
}
catch(e){
dojo.debug(e);
}
}
var _1c1=_1c0.load;
_1c0.load=function(){
dojo.io._queueBindInFlight=false;
var ret=_1c1.apply(this,arguments);
dojo.io._dispatchNextQueueBind();
return ret;
};
var _1c3=_1c0.error;
_1c0.error=function(){
dojo.io._queueBindInFlight=false;
var ret=_1c3.apply(this,arguments);
dojo.io._dispatchNextQueueBind();
return ret;
};
dojo.io._bindQueue.push(_1c0);
dojo.io._dispatchNextQueueBind();
return _1c0;
};
dojo.io._dispatchNextQueueBind=function(){
if(!dojo.io._queueBindInFlight){
dojo.io._queueBindInFlight=true;
if(dojo.io._bindQueue.length>0){
dojo.io.bind(dojo.io._bindQueue.shift());
}else{
dojo.io._queueBindInFlight=false;
}
}
};
dojo.io._bindQueue=[];
dojo.io._queueBindInFlight=false;
dojo.io.argsFromMap=function(map,_1c6,last){
var enc=/utf/i.test(_1c6||"")?encodeURIComponent:dojo.string.encodeAscii;
var _1c9=[];
var _1ca=new Object();
for(var name in map){
var _1cc=function(elt){
var val=enc(name)+"="+enc(elt);
_1c9[(last==name)?"push":"unshift"](val);
};
if(!_1ca[name]){
var _1cf=map[name];
if(dojo.lang.isArray(_1cf)){
dojo.lang.forEach(_1cf,_1cc);
}else{
_1cc(_1cf);
}
}
}
return _1c9.join("&");
};
dojo.io.setIFrameSrc=function(_1d0,src,_1d2){
try{
var r=dojo.render.html;
if(!_1d2){
if(r.safari){
_1d0.location=src;
}else{
frames[_1d0.name].location=src;
}
}else{
var idoc;
if(r.ie){
idoc=_1d0.contentWindow.document;
}else{
if(r.safari){
idoc=_1d0.document;
}else{
idoc=_1d0.contentWindow;
}
}
if(!idoc){
_1d0.location=src;
return;
}else{
idoc.location.replace(src);
}
}
}
catch(e){
dojo.debug(e);
dojo.debug("setIFrameSrc: "+e);
}
};
dojo.provide("dojo.lang.array");
dojo.lang.mixin(dojo.lang,{has:function(obj,name){
try{
return typeof obj[name]!="undefined";
}
catch(e){
return false;
}
},isEmpty:function(obj){
if(dojo.lang.isObject(obj)){
var tmp={};
var _1d9=0;
for(var x in obj){
if(obj[x]&&(!tmp[x])){
_1d9++;
break;
}
}
return _1d9==0;
}else{
if(dojo.lang.isArrayLike(obj)||dojo.lang.isString(obj)){
return obj.length==0;
}
}
},map:function(arr,obj,_1dd){
var _1de=dojo.lang.isString(arr);
if(_1de){
arr=arr.split("");
}
if(dojo.lang.isFunction(obj)&&(!_1dd)){
_1dd=obj;
obj=dj_global;
}else{
if(dojo.lang.isFunction(obj)&&_1dd){
var _1df=obj;
obj=_1dd;
_1dd=_1df;
}
}
if(Array.map){
var _1e0=Array.map(arr,_1dd,obj);
}else{
var _1e0=[];
for(var i=0;i<arr.length;++i){
_1e0.push(_1dd.call(obj,arr[i]));
}
}
if(_1de){
return _1e0.join("");
}else{
return _1e0;
}
},reduce:function(arr,_1e3,obj,_1e5){
var _1e6=_1e3;
if(arguments.length==2){
_1e5=_1e3;
_1e6=arr[0];
arr=arr.slice(1);
}else{
if(arguments.length==3){
if(dojo.lang.isFunction(obj)){
_1e5=obj;
obj=null;
}
}else{
if(dojo.lang.isFunction(obj)){
var tmp=_1e5;
_1e5=obj;
obj=tmp;
}
}
}
var ob=obj||dj_global;
dojo.lang.map(arr,function(val){
_1e6=_1e5.call(ob,_1e6,val);
});
return _1e6;
},forEach:function(_1ea,_1eb,_1ec){
if(dojo.lang.isString(_1ea)){
_1ea=_1ea.split("");
}
if(Array.forEach){
Array.forEach(_1ea,_1eb,_1ec);
}else{
if(!_1ec){
_1ec=dj_global;
}
for(var i=0,l=_1ea.length;i<l;i++){
_1eb.call(_1ec,_1ea[i],i,_1ea);
}
}
},_everyOrSome:function(_1ef,arr,_1f1,_1f2){
if(dojo.lang.isString(arr)){
arr=arr.split("");
}
if(Array.every){
return Array[_1ef?"every":"some"](arr,_1f1,_1f2);
}else{
if(!_1f2){
_1f2=dj_global;
}
for(var i=0,l=arr.length;i<l;i++){
var _1f5=_1f1.call(_1f2,arr[i],i,arr);
if(_1ef&&!_1f5){
return false;
}else{
if((!_1ef)&&(_1f5)){
return true;
}
}
}
return Boolean(_1ef);
}
},every:function(arr,_1f7,_1f8){
return this._everyOrSome(true,arr,_1f7,_1f8);
},some:function(arr,_1fa,_1fb){
return this._everyOrSome(false,arr,_1fa,_1fb);
},filter:function(arr,_1fd,_1fe){
var _1ff=dojo.lang.isString(arr);
if(_1ff){
arr=arr.split("");
}
var _200;
if(Array.filter){
_200=Array.filter(arr,_1fd,_1fe);
}else{
if(!_1fe){
if(arguments.length>=3){
dojo.raise("thisObject doesn't exist!");
}
_1fe=dj_global;
}
_200=[];
for(var i=0;i<arr.length;i++){
if(_1fd.call(_1fe,arr[i],i,arr)){
_200.push(arr[i]);
}
}
}
if(_1ff){
return _200.join("");
}else{
return _200;
}
},unnest:function(){
var out=[];
for(var i=0;i<arguments.length;i++){
if(dojo.lang.isArrayLike(arguments[i])){
var add=dojo.lang.unnest.apply(this,arguments[i]);
out=out.concat(add);
}else{
out.push(arguments[i]);
}
}
return out;
},toArray:function(_205,_206){
var _207=[];
for(var i=_206||0;i<_205.length;i++){
_207.push(_205[i]);
}
return _207;
}});
dojo.provide("dojo.lang.func");
dojo.lang.hitch=function(_209,_20a){
var args=[];
for(var x=2;x<arguments.length;x++){
args.push(arguments[x]);
}
var fcn=(dojo.lang.isString(_20a)?_209[_20a]:_20a)||function(){
};
return function(){
var ta=args.concat([]);
for(var x=0;x<arguments.length;x++){
ta.push(arguments[x]);
}
return fcn.apply(_209,ta);
};
};
dojo.lang.anonCtr=0;
dojo.lang.anon={};
dojo.lang.nameAnonFunc=function(_210,_211,_212){
var nso=(_211||dojo.lang.anon);
if((_212)||((dj_global["djConfig"])&&(djConfig["slowAnonFuncLookups"]==true))){
for(var x in nso){
try{
if(nso[x]===_210){
return x;
}
}
catch(e){
}
}
}
var ret="__"+dojo.lang.anonCtr++;
while(typeof nso[ret]!="undefined"){
ret="__"+dojo.lang.anonCtr++;
}
nso[ret]=_210;
return ret;
};
dojo.lang.forward=function(_216){
return function(){
return this[_216].apply(this,arguments);
};
};
dojo.lang.curry=function(_217,func){
var _219=[];
_217=_217||dj_global;
if(dojo.lang.isString(func)){
func=_217[func];
}
for(var x=2;x<arguments.length;x++){
_219.push(arguments[x]);
}
var _21b=(func["__preJoinArity"]||func.length)-_219.length;
function gather(_21c,_21d,_21e){
var _21f=_21e;
var _220=_21d.slice(0);
for(var x=0;x<_21c.length;x++){
_220.push(_21c[x]);
}
_21e=_21e-_21c.length;
if(_21e<=0){
var res=func.apply(_217,_220);
_21e=_21f;
return res;
}else{
return function(){
return gather(arguments,_220,_21e);
};
}
}
return gather([],_219,_21b);
};
dojo.lang.curryArguments=function(_223,func,args,_226){
var _227=[];
var x=_226||0;
for(x=_226;x<args.length;x++){
_227.push(args[x]);
}
return dojo.lang.curry.apply(dojo.lang,[_223,func].concat(_227));
};
dojo.lang.tryThese=function(){
for(var x=0;x<arguments.length;x++){
try{
if(typeof arguments[x]=="function"){
var ret=(arguments[x]());
if(ret){
return ret;
}
}
}
catch(e){
dojo.debug(e);
}
}
};
dojo.lang.delayThese=function(farr,cb,_22d,_22e){
if(!farr.length){
if(typeof _22e=="function"){
_22e();
}
return;
}
if((typeof _22d=="undefined")&&(typeof cb=="number")){
_22d=cb;
cb=function(){
};
}else{
if(!cb){
cb=function(){
};
if(!_22d){
_22d=0;
}
}
}
setTimeout(function(){
(farr.shift())();
cb();
dojo.lang.delayThese(farr,cb,_22d,_22e);
},_22d);
};
dojo.provide("dojo.string.extras");
dojo.string.substituteParams=function(_22f,hash){
var map=(typeof hash=="object")?hash:dojo.lang.toArray(arguments,1);
return _22f.replace(/\%\{(\w+)\}/g,function(_232,key){
if(typeof (map[key])!="undefined"&&map[key]!=null){
return map[key];
}
dojo.raise("Substitution not found: "+key);
});
};
dojo.string.capitalize=function(str){
if(!dojo.lang.isString(str)){
return "";
}
if(arguments.length==0){
str=this;
}
var _235=str.split(" ");
for(var i=0;i<_235.length;i++){
_235[i]=_235[i].charAt(0).toUpperCase()+_235[i].substring(1);
}
return _235.join(" ");
};
dojo.string.isBlank=function(str){
if(!dojo.lang.isString(str)){
return true;
}
return (dojo.string.trim(str).length==0);
};
dojo.string.encodeAscii=function(str){
if(!dojo.lang.isString(str)){
return str;
}
var ret="";
var _23a=escape(str);
var _23b,re=/%u([0-9A-F]{4})/i;
while((_23b=_23a.match(re))){
var num=Number("0x"+_23b[1]);
var _23e=escape("&#"+num+";");
ret+=_23a.substring(0,_23b.index)+_23e;
_23a=_23a.substring(_23b.index+_23b[0].length);
}
ret+=_23a.replace(/\+/g,"%2B");
return ret;
};
dojo.string.escape=function(type,str){
var args=dojo.lang.toArray(arguments,1);
switch(type.toLowerCase()){
case "xml":
case "html":
case "xhtml":
return dojo.string.escapeXml.apply(this,args);
case "sql":
return dojo.string.escapeSql.apply(this,args);
case "regexp":
case "regex":
return dojo.string.escapeRegExp.apply(this,args);
case "javascript":
case "jscript":
case "js":
return dojo.string.escapeJavaScript.apply(this,args);
case "ascii":
return dojo.string.encodeAscii.apply(this,args);
default:
return str;
}
};
dojo.string.escapeXml=function(str,_243){
str=str.replace(/&/gm,"&amp;").replace(/</gm,"&lt;").replace(/>/gm,"&gt;").replace(/"/gm,"&quot;");
if(!_243){
str=str.replace(/'/gm,"&#39;");
}
return str;
};
dojo.string.escapeSql=function(str){
return str.replace(/'/gm,"''");
};
dojo.string.escapeRegExp=function(str){
return str.replace(/\\/gm,"\\\\").replace(/([\f\b\n\t\r[\^$|?*+(){}])/gm,"\\$1");
};
dojo.string.escapeJavaScript=function(str){
return str.replace(/(["'\f\b\n\t\r])/gm,"\\$1");
};
dojo.string.escapeString=function(str){
return ("\""+str.replace(/(["\\])/g,"\\$1")+"\"").replace(/[\f]/g,"\\f").replace(/[\b]/g,"\\b").replace(/[\n]/g,"\\n").replace(/[\t]/g,"\\t").replace(/[\r]/g,"\\r");
};
dojo.string.summary=function(str,len){
if(!len||str.length<=len){
return str;
}
return str.substring(0,len).replace(/\.+$/,"")+"...";
};
dojo.string.endsWith=function(str,end,_24c){
if(_24c){
str=str.toLowerCase();
end=end.toLowerCase();
}
if((str.length-end.length)<0){
return false;
}
return str.lastIndexOf(end)==str.length-end.length;
};
dojo.string.endsWithAny=function(str){
for(var i=1;i<arguments.length;i++){
if(dojo.string.endsWith(str,arguments[i])){
return true;
}
}
return false;
};
dojo.string.startsWith=function(str,_250,_251){
if(_251){
str=str.toLowerCase();
_250=_250.toLowerCase();
}
return str.indexOf(_250)==0;
};
dojo.string.startsWithAny=function(str){
for(var i=1;i<arguments.length;i++){
if(dojo.string.startsWith(str,arguments[i])){
return true;
}
}
return false;
};
dojo.string.has=function(str){
for(var i=1;i<arguments.length;i++){
if(str.indexOf(arguments[i])>-1){
return true;
}
}
return false;
};
dojo.string.normalizeNewlines=function(text,_257){
if(_257=="\n"){
text=text.replace(/\r\n/g,"\n");
text=text.replace(/\r/g,"\n");
}else{
if(_257=="\r"){
text=text.replace(/\r\n/g,"\r");
text=text.replace(/\n/g,"\r");
}else{
text=text.replace(/([^\r])\n/g,"$1\r\n").replace(/\r([^\n])/g,"\r\n$1");
}
}
return text;
};
dojo.string.splitEscaped=function(str,_259){
var _25a=[];
for(var i=0,_25c=0;i<str.length;i++){
if(str.charAt(i)=="\\"){
i++;
continue;
}
if(str.charAt(i)==_259){
_25a.push(str.substring(_25c,i));
_25c=i+1;
}
}
_25a.push(str.substr(_25c));
return _25a;
};
dojo.provide("dojo.dom");
dojo.dom.ELEMENT_NODE=1;
dojo.dom.ATTRIBUTE_NODE=2;
dojo.dom.TEXT_NODE=3;
dojo.dom.CDATA_SECTION_NODE=4;
dojo.dom.ENTITY_REFERENCE_NODE=5;
dojo.dom.ENTITY_NODE=6;
dojo.dom.PROCESSING_INSTRUCTION_NODE=7;
dojo.dom.COMMENT_NODE=8;
dojo.dom.DOCUMENT_NODE=9;
dojo.dom.DOCUMENT_TYPE_NODE=10;
dojo.dom.DOCUMENT_FRAGMENT_NODE=11;
dojo.dom.NOTATION_NODE=12;
dojo.dom.dojoml="http://www.dojotoolkit.org/2004/dojoml";
dojo.dom.xmlns={svg:"http://www.w3.org/2000/svg",smil:"http://www.w3.org/2001/SMIL20/",mml:"http://www.w3.org/1998/Math/MathML",cml:"http://www.xml-cml.org",xlink:"http://www.w3.org/1999/xlink",xhtml:"http://www.w3.org/1999/xhtml",xul:"http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul",xbl:"http://www.mozilla.org/xbl",fo:"http://www.w3.org/1999/XSL/Format",xsl:"http://www.w3.org/1999/XSL/Transform",xslt:"http://www.w3.org/1999/XSL/Transform",xi:"http://www.w3.org/2001/XInclude",xforms:"http://www.w3.org/2002/01/xforms",saxon:"http://icl.com/saxon",xalan:"http://xml.apache.org/xslt",xsd:"http://www.w3.org/2001/XMLSchema",dt:"http://www.w3.org/2001/XMLSchema-datatypes",xsi:"http://www.w3.org/2001/XMLSchema-instance",rdf:"http://www.w3.org/1999/02/22-rdf-syntax-ns#",rdfs:"http://www.w3.org/2000/01/rdf-schema#",dc:"http://purl.org/dc/elements/1.1/",dcq:"http://purl.org/dc/qualifiers/1.0","soap-env":"http://schemas.xmlsoap.org/soap/envelope/",wsdl:"http://schemas.xmlsoap.org/wsdl/",AdobeExtensions:"http://ns.adobe.com/AdobeSVGViewerExtensions/3.0/"};
dojo.dom.isNode=function(wh){
if(typeof Element=="function"){
try{
return wh instanceof Element;
}
catch(e){
}
}else{
return wh&&!isNaN(wh.nodeType);
}
};
dojo.dom.getUniqueId=function(){
var _25e=dojo.doc();
do{
var id="dj_unique_"+(++arguments.callee._idIncrement);
}while(_25e.getElementById(id));
return id;
};
dojo.dom.getUniqueId._idIncrement=0;
dojo.dom.firstElement=dojo.dom.getFirstChildElement=function(_260,_261){
var node=_260.firstChild;
while(node&&node.nodeType!=dojo.dom.ELEMENT_NODE){
node=node.nextSibling;
}
if(_261&&node&&node.tagName&&node.tagName.toLowerCase()!=_261.toLowerCase()){
node=dojo.dom.nextElement(node,_261);
}
return node;
};
dojo.dom.lastElement=dojo.dom.getLastChildElement=function(_263,_264){
var node=_263.lastChild;
while(node&&node.nodeType!=dojo.dom.ELEMENT_NODE){
node=node.previousSibling;
}
if(_264&&node&&node.tagName&&node.tagName.toLowerCase()!=_264.toLowerCase()){
node=dojo.dom.prevElement(node,_264);
}
return node;
};
dojo.dom.nextElement=dojo.dom.getNextSiblingElement=function(node,_267){
if(!node){
return null;
}
do{
node=node.nextSibling;
}while(node&&node.nodeType!=dojo.dom.ELEMENT_NODE);
if(node&&_267&&_267.toLowerCase()!=node.tagName.toLowerCase()){
return dojo.dom.nextElement(node,_267);
}
return node;
};
dojo.dom.prevElement=dojo.dom.getPreviousSiblingElement=function(node,_269){
if(!node){
return null;
}
if(_269){
_269=_269.toLowerCase();
}
do{
node=node.previousSibling;
}while(node&&node.nodeType!=dojo.dom.ELEMENT_NODE);
if(node&&_269&&_269.toLowerCase()!=node.tagName.toLowerCase()){
return dojo.dom.prevElement(node,_269);
}
return node;
};
dojo.dom.moveChildren=function(_26a,_26b,trim){
var _26d=0;
if(trim){
while(_26a.hasChildNodes()&&_26a.firstChild.nodeType==dojo.dom.TEXT_NODE){
_26a.removeChild(_26a.firstChild);
}
while(_26a.hasChildNodes()&&_26a.lastChild.nodeType==dojo.dom.TEXT_NODE){
_26a.removeChild(_26a.lastChild);
}
}
while(_26a.hasChildNodes()){
_26b.appendChild(_26a.firstChild);
_26d++;
}
return _26d;
};
dojo.dom.copyChildren=function(_26e,_26f,trim){
var _271=_26e.cloneNode(true);
return this.moveChildren(_271,_26f,trim);
};
dojo.dom.replaceChildren=function(node,_273){
var _274=[];
if(dojo.render.html.ie){
for(var i=0;i<node.childNodes.length;i++){
_274.push(node.childNodes[i]);
}
}
dojo.dom.removeChildren(node);
node.appendChild(_273);
for(var i=0;i<_274.length;i++){
dojo.dom.destroyNode(_274[i]);
}
};
dojo.dom.removeChildren=function(node){
var _277=node.childNodes.length;
while(node.hasChildNodes()){
dojo.dom.removeNode(node.firstChild);
}
return _277;
};
dojo.dom.replaceNode=function(node,_279){
return node.parentNode.replaceChild(_279,node);
};
dojo.dom.destroyNode=function(node){
if(node.parentNode){
node=dojo.dom.removeNode(node);
}
if(node.nodeType!=3){
if(dojo.evalObjPath("dojo.event.browser.clean",false)){
dojo.event.browser.clean(node);
}
if(dojo.render.html.ie){
node.outerHTML="";
}
}
};
dojo.dom.removeNode=function(node){
if(node&&node.parentNode){
return node.parentNode.removeChild(node);
}
};
dojo.dom.getAncestors=function(node,_27d,_27e){
var _27f=[];
var _280=(_27d&&(_27d instanceof Function||typeof _27d=="function"));
while(node){
if(!_280||_27d(node)){
_27f.push(node);
}
if(_27e&&_27f.length>0){
return _27f[0];
}
node=node.parentNode;
}
if(_27e){
return null;
}
return _27f;
};
dojo.dom.getAncestorsByTag=function(node,tag,_283){
tag=tag.toLowerCase();
return dojo.dom.getAncestors(node,function(el){
return ((el.tagName)&&(el.tagName.toLowerCase()==tag));
},_283);
};
dojo.dom.getFirstAncestorByTag=function(node,tag){
return dojo.dom.getAncestorsByTag(node,tag,true);
};
dojo.dom.isDescendantOf=function(node,_288,_289){
if(_289&&node){
node=node.parentNode;
}
while(node){
if(node==_288){
return true;
}
node=node.parentNode;
}
return false;
};
dojo.dom.innerXML=function(node){
if(node.innerXML){
return node.innerXML;
}else{
if(node.xml){
return node.xml;
}else{
if(typeof XMLSerializer!="undefined"){
return (new XMLSerializer()).serializeToString(node);
}
}
}
};
dojo.dom.createDocument=function(){
var doc=null;
var _28c=dojo.doc();
if(!dj_undef("ActiveXObject")){
var _28d=["MSXML2","Microsoft","MSXML","MSXML3"];
for(var i=0;i<_28d.length;i++){
try{
doc=new ActiveXObject(_28d[i]+".XMLDOM");
}
catch(e){
}
if(doc){
break;
}
}
}else{
if((_28c.implementation)&&(_28c.implementation.createDocument)){
doc=_28c.implementation.createDocument("","",null);
}
}
return doc;
};
dojo.dom.createDocumentFromText=function(str,_290){
if(!_290){
_290="text/xml";
}
if(!dj_undef("DOMParser")){
var _291=new DOMParser();
return _291.parseFromString(str,_290);
}else{
if(!dj_undef("ActiveXObject")){
var _292=dojo.dom.createDocument();
if(_292){
_292.async=false;
_292.loadXML(str);
return _292;
}else{
dojo.debug("toXml didn't work?");
}
}else{
var _293=dojo.doc();
if(_293.createElement){
var tmp=_293.createElement("xml");
tmp.innerHTML=str;
if(_293.implementation&&_293.implementation.createDocument){
var _295=_293.implementation.createDocument("foo","",null);
for(var i=0;i<tmp.childNodes.length;i++){
_295.importNode(tmp.childNodes.item(i),true);
}
return _295;
}
return ((tmp.document)&&(tmp.document.firstChild?tmp.document.firstChild:tmp));
}
}
}
return null;
};
dojo.dom.prependChild=function(node,_298){
if(_298.firstChild){
_298.insertBefore(node,_298.firstChild);
}else{
_298.appendChild(node);
}
return true;
};
dojo.dom.insertBefore=function(node,ref,_29b){
if((_29b!=true)&&(node===ref||node.nextSibling===ref)){
return false;
}
var _29c=ref.parentNode;
_29c.insertBefore(node,ref);
return true;
};
dojo.dom.insertAfter=function(node,ref,_29f){
var pn=ref.parentNode;
if(ref==pn.lastChild){
if((_29f!=true)&&(node===ref)){
return false;
}
pn.appendChild(node);
}else{
return this.insertBefore(node,ref.nextSibling,_29f);
}
return true;
};
dojo.dom.insertAtPosition=function(node,ref,_2a3){
if((!node)||(!ref)||(!_2a3)){
return false;
}
switch(_2a3.toLowerCase()){
case "before":
return dojo.dom.insertBefore(node,ref);
case "after":
return dojo.dom.insertAfter(node,ref);
case "first":
if(ref.firstChild){
return dojo.dom.insertBefore(node,ref.firstChild);
}else{
ref.appendChild(node);
return true;
}
break;
default:
ref.appendChild(node);
return true;
}
};
dojo.dom.insertAtIndex=function(node,_2a5,_2a6){
var _2a7=_2a5.childNodes;
if(!_2a7.length||_2a7.length==_2a6){
_2a5.appendChild(node);
return true;
}
if(_2a6==0){
return dojo.dom.prependChild(node,_2a5);
}
return dojo.dom.insertAfter(node,_2a7[_2a6-1]);
};
dojo.dom.textContent=function(node,text){
if(arguments.length>1){
var _2aa=dojo.doc();
dojo.dom.replaceChildren(node,_2aa.createTextNode(text));
return text;
}else{
if(node.textContent!=undefined){
return node.textContent;
}
var _2ab="";
if(node==null){
return _2ab;
}
for(var i=0;i<node.childNodes.length;i++){
switch(node.childNodes[i].nodeType){
case 1:
case 5:
_2ab+=dojo.dom.textContent(node.childNodes[i]);
break;
case 3:
case 2:
case 4:
_2ab+=node.childNodes[i].nodeValue;
break;
default:
break;
}
}
return _2ab;
}
};
dojo.dom.hasParent=function(node){
return Boolean(node&&node.parentNode&&dojo.dom.isNode(node.parentNode));
};
dojo.dom.isTag=function(node){
if(node&&node.tagName){
for(var i=1;i<arguments.length;i++){
if(node.tagName==String(arguments[i])){
return String(arguments[i]);
}
}
}
return "";
};
dojo.dom.setAttributeNS=function(elem,_2b1,_2b2,_2b3){
if(elem==null||((elem==undefined)&&(typeof elem=="undefined"))){
dojo.raise("No element given to dojo.dom.setAttributeNS");
}
if(!((elem.setAttributeNS==undefined)&&(typeof elem.setAttributeNS=="undefined"))){
elem.setAttributeNS(_2b1,_2b2,_2b3);
}else{
var _2b4=elem.ownerDocument;
var _2b5=_2b4.createNode(2,_2b2,_2b1);
_2b5.nodeValue=_2b3;
elem.setAttributeNode(_2b5);
}
};
dojo.provide("dojo.undo.browser");
try{
if((!djConfig["preventBackButtonFix"])&&(!dojo.hostenv.post_load_)){
document.write("<iframe style='border: 0px; width: 1px; height: 1px; position: absolute; bottom: 0px; right: 0px; visibility: visible;' name='djhistory' id='djhistory' src='"+(djConfig["dojoIframeHistoryUrl"]||dojo.hostenv.getBaseScriptUri()+"iframe_history.html")+"'></iframe>");
}
}
catch(e){
}
if(dojo.render.html.opera){
dojo.debug("Opera is not supported with dojo.undo.browser, so back/forward detection will not work.");
}
dojo.undo.browser={initialHref:(!dj_undef("window"))?window.location.href:"",initialHash:(!dj_undef("window"))?window.location.hash:"",moveForward:false,historyStack:[],forwardStack:[],historyIframe:null,bookmarkAnchor:null,locationTimer:null,setInitialState:function(args){
this.initialState=this._createState(this.initialHref,args,this.initialHash);
},addToHistory:function(args){
this.forwardStack=[];
var hash=null;
var url=null;
if(!this.historyIframe){
if(djConfig["useXDomain"]&&!djConfig["dojoIframeHistoryUrl"]){
dojo.debug("dojo.undo.browser: When using cross-domain Dojo builds,"+" please save iframe_history.html to your domain and set djConfig.dojoIframeHistoryUrl"+" to the path on your domain to iframe_history.html");
}
this.historyIframe=window.frames["djhistory"];
}
if(!this.bookmarkAnchor){
this.bookmarkAnchor=document.createElement("a");
dojo.body().appendChild(this.bookmarkAnchor);
this.bookmarkAnchor.style.display="none";
}
if(args["changeUrl"]){
hash="#"+((args["changeUrl"]!==true)?args["changeUrl"]:(new Date()).getTime());
if(this.historyStack.length==0&&this.initialState.urlHash==hash){
this.initialState=this._createState(url,args,hash);
return;
}else{
if(this.historyStack.length>0&&this.historyStack[this.historyStack.length-1].urlHash==hash){
this.historyStack[this.historyStack.length-1]=this._createState(url,args,hash);
return;
}
}
this.changingUrl=true;
setTimeout("window.location.href = '"+hash+"'; dojo.undo.browser.changingUrl = false;",1);
this.bookmarkAnchor.href=hash;
if(dojo.render.html.ie){
url=this._loadIframeHistory();
var _2ba=args["back"]||args["backButton"]||args["handle"];
var tcb=function(_2bc){
if(window.location.hash!=""){
setTimeout("window.location.href = '"+hash+"';",1);
}
_2ba.apply(this,[_2bc]);
};
if(args["back"]){
args.back=tcb;
}else{
if(args["backButton"]){
args.backButton=tcb;
}else{
if(args["handle"]){
args.handle=tcb;
}
}
}
var _2bd=args["forward"]||args["forwardButton"]||args["handle"];
var tfw=function(_2bf){
if(window.location.hash!=""){
window.location.href=hash;
}
if(_2bd){
_2bd.apply(this,[_2bf]);
}
};
if(args["forward"]){
args.forward=tfw;
}else{
if(args["forwardButton"]){
args.forwardButton=tfw;
}else{
if(args["handle"]){
args.handle=tfw;
}
}
}
}else{
if(dojo.render.html.moz){
if(!this.locationTimer){
this.locationTimer=setInterval("dojo.undo.browser.checkLocation();",200);
}
}
}
}else{
url=this._loadIframeHistory();
}
this.historyStack.push(this._createState(url,args,hash));
},checkLocation:function(){
if(!this.changingUrl){
var hsl=this.historyStack.length;
if((window.location.hash==this.initialHash||window.location.href==this.initialHref)&&(hsl==1)){
this.handleBackButton();
return;
}
if(this.forwardStack.length>0){
if(this.forwardStack[this.forwardStack.length-1].urlHash==window.location.hash){
this.handleForwardButton();
return;
}
}
if((hsl>=2)&&(this.historyStack[hsl-2])){
if(this.historyStack[hsl-2].urlHash==window.location.hash){
this.handleBackButton();
return;
}
}
}
},iframeLoaded:function(evt,_2c2){
if(!dojo.render.html.opera){
var _2c3=this._getUrlQuery(_2c2.href);
if(_2c3==null){
if(this.historyStack.length==1){
this.handleBackButton();
}
return;
}
if(this.moveForward){
this.moveForward=false;
return;
}
if(this.historyStack.length>=2&&_2c3==this._getUrlQuery(this.historyStack[this.historyStack.length-2].url)){
this.handleBackButton();
}else{
if(this.forwardStack.length>0&&_2c3==this._getUrlQuery(this.forwardStack[this.forwardStack.length-1].url)){
this.handleForwardButton();
}
}
}
},handleBackButton:function(){
var _2c4=this.historyStack.pop();
if(!_2c4){
return;
}
var last=this.historyStack[this.historyStack.length-1];
if(!last&&this.historyStack.length==0){
last=this.initialState;
}
if(last){
if(last.kwArgs["back"]){
last.kwArgs["back"]();
}else{
if(last.kwArgs["backButton"]){
last.kwArgs["backButton"]();
}else{
if(last.kwArgs["handle"]){
last.kwArgs.handle("back");
}
}
}
}
this.forwardStack.push(_2c4);
},handleForwardButton:function(){
var last=this.forwardStack.pop();
if(!last){
return;
}
if(last.kwArgs["forward"]){
last.kwArgs.forward();
}else{
if(last.kwArgs["forwardButton"]){
last.kwArgs.forwardButton();
}else{
if(last.kwArgs["handle"]){
last.kwArgs.handle("forward");
}
}
}
this.historyStack.push(last);
},_createState:function(url,args,hash){
return {"url":url,"kwArgs":args,"urlHash":hash};
},_getUrlQuery:function(url){
var _2cb=url.split("?");
if(_2cb.length<2){
return null;
}else{
return _2cb[1];
}
},_loadIframeHistory:function(){
var url=(djConfig["dojoIframeHistoryUrl"]||dojo.hostenv.getBaseScriptUri()+"iframe_history.html")+"?"+(new Date()).getTime();
this.moveForward=true;
dojo.io.setIFrameSrc(this.historyIframe,url,false);
return url;
}};
dojo.provide("dojo.io.BrowserIO");
if(!dj_undef("window")){
dojo.io.checkChildrenForFile=function(node){
var _2ce=false;
var _2cf=node.getElementsByTagName("input");
dojo.lang.forEach(_2cf,function(_2d0){
if(_2ce){
return;
}
if(_2d0.getAttribute("type")=="file"){
_2ce=true;
}
});
return _2ce;
};
dojo.io.formHasFile=function(_2d1){
return dojo.io.checkChildrenForFile(_2d1);
};
dojo.io.updateNode=function(node,_2d3){
node=dojo.byId(node);
var args=_2d3;
if(dojo.lang.isString(_2d3)){
args={url:_2d3};
}
args.mimetype="text/html";
args.load=function(t,d,e){
while(node.firstChild){
dojo.dom.destroyNode(node.firstChild);
}
node.innerHTML=d;
};
dojo.io.bind(args);
};
dojo.io.formFilter=function(node){
var type=(node.type||"").toLowerCase();
return !node.disabled&&node.name&&!dojo.lang.inArray(["file","submit","image","reset","button"],type);
};
dojo.io.encodeForm=function(_2da,_2db,_2dc){
if((!_2da)||(!_2da.tagName)||(!_2da.tagName.toLowerCase()=="form")){
dojo.raise("Attempted to encode a non-form element.");
}
if(!_2dc){
_2dc=dojo.io.formFilter;
}
var enc=/utf/i.test(_2db||"")?encodeURIComponent:dojo.string.encodeAscii;
var _2de=[];
for(var i=0;i<_2da.elements.length;i++){
var elm=_2da.elements[i];
if(!elm||elm.tagName.toLowerCase()=="fieldset"||!_2dc(elm)){
continue;
}
var name=enc(elm.name);
var type=elm.type.toLowerCase();
if(type=="select-multiple"){
for(var j=0;j<elm.options.length;j++){
if(elm.options[j].selected){
_2de.push(name+"="+enc(elm.options[j].value));
}
}
}else{
if(dojo.lang.inArray(["radio","checkbox"],type)){
if(elm.checked){
_2de.push(name+"="+enc(elm.value));
}
}else{
_2de.push(name+"="+enc(elm.value));
}
}
}
var _2e4=_2da.getElementsByTagName("input");
for(var i=0;i<_2e4.length;i++){
var _2e5=_2e4[i];
if(_2e5.type.toLowerCase()=="image"&&_2e5.form==_2da&&_2dc(_2e5)){
var name=enc(_2e5.name);
_2de.push(name+"="+enc(_2e5.value));
_2de.push(name+".x=0");
_2de.push(name+".y=0");
}
}
return _2de.join("&")+"&";
};
dojo.io.FormBind=function(args){
this.bindArgs={};
if(args&&args.formNode){
this.init(args);
}else{
if(args){
this.init({formNode:args});
}
}
};
dojo.lang.extend(dojo.io.FormBind,{form:null,bindArgs:null,clickedButton:null,init:function(args){
var form=dojo.byId(args.formNode);
if(!form||!form.tagName||form.tagName.toLowerCase()!="form"){
throw new Error("FormBind: Couldn't apply, invalid form");
}else{
if(this.form==form){
return;
}else{
if(this.form){
throw new Error("FormBind: Already applied to a form");
}
}
}
dojo.lang.mixin(this.bindArgs,args);
this.form=form;
this.connect(form,"onsubmit","submit");
for(var i=0;i<form.elements.length;i++){
var node=form.elements[i];
if(node&&node.type&&dojo.lang.inArray(["submit","button"],node.type.toLowerCase())){
this.connect(node,"onclick","click");
}
}
var _2eb=form.getElementsByTagName("input");
for(var i=0;i<_2eb.length;i++){
var _2ec=_2eb[i];
if(_2ec.type.toLowerCase()=="image"&&_2ec.form==form){
this.connect(_2ec,"onclick","click");
}
}
},onSubmit:function(form){
return true;
},submit:function(e){
e.preventDefault();
if(this.onSubmit(this.form)){
dojo.io.bind(dojo.lang.mixin(this.bindArgs,{formFilter:dojo.lang.hitch(this,"formFilter")}));
}
},click:function(e){
var node=e.currentTarget;
if(node.disabled){
return;
}
this.clickedButton=node;
},formFilter:function(node){
var type=(node.type||"").toLowerCase();
var _2f3=false;
if(node.disabled||!node.name){
_2f3=false;
}else{
if(dojo.lang.inArray(["submit","button","image"],type)){
if(!this.clickedButton){
this.clickedButton=node;
}
_2f3=node==this.clickedButton;
}else{
_2f3=!dojo.lang.inArray(["file","submit","reset","button"],type);
}
}
return _2f3;
},connect:function(_2f4,_2f5,_2f6){
if(dojo.evalObjPath("dojo.event.connect")){
dojo.event.connect(_2f4,_2f5,this,_2f6);
}else{
var fcn=dojo.lang.hitch(this,_2f6);
_2f4[_2f5]=function(e){
if(!e){
e=window.event;
}
if(!e.currentTarget){
e.currentTarget=e.srcElement;
}
if(!e.preventDefault){
e.preventDefault=function(){
window.event.returnValue=false;
};
}
fcn(e);
};
}
}});
dojo.io.XMLHTTPTransport=new function(){
var _2f9=this;
var _2fa={};
this.useCache=false;
this.preventCache=false;
function getCacheKey(url,_2fc,_2fd){
return url+"|"+_2fc+"|"+_2fd.toLowerCase();
}
function addToCache(url,_2ff,_300,http){
_2fa[getCacheKey(url,_2ff,_300)]=http;
}
function getFromCache(url,_303,_304){
return _2fa[getCacheKey(url,_303,_304)];
}
this.clearCache=function(){
_2fa={};
};
function doLoad(_305,http,url,_308,_309){
if(((http.status>=200)&&(http.status<300))||(http.status==304)||(http.status==1223)||(location.protocol=="file:"&&(http.status==0||http.status==undefined))||(location.protocol=="chrome:"&&(http.status==0||http.status==undefined))){
var ret;
if(_305.method.toLowerCase()=="head"){
var _30b=http.getAllResponseHeaders();
ret={};
ret.toString=function(){
return _30b;
};
var _30c=_30b.split(/[\r\n]+/g);
for(var i=0;i<_30c.length;i++){
var pair=_30c[i].match(/^([^:]+)\s*:\s*(.+)$/i);
if(pair){
ret[pair[1]]=pair[2];
}
}
}else{
if(_305.mimetype=="text/javascript"){
try{
ret=dj_eval(http.responseText);
}
catch(e){
dojo.debug(e);
dojo.debug(http.responseText);
ret=null;
}
}else{
if(_305.mimetype.substr(0,9)=="text/json"||_305.mimetype.substr(0,16)=="application/json"){
try{
ret=dj_eval("("+_305.jsonFilter(http.responseText)+")");
}
catch(e){
dojo.debug(e);
dojo.debug(http.responseText);
ret=false;
}
}else{
if((_305.mimetype=="application/xml")||(_305.mimetype=="text/xml")){
ret=http.responseXML;
if(!ret||typeof ret=="string"||!http.getResponseHeader("Content-Type")){
ret=dojo.dom.createDocumentFromText(http.responseText);
}
}else{
ret=http.responseText;
}
}
}
}
if(_309){
addToCache(url,_308,_305.method,http);
}
_305[(typeof _305.load=="function")?"load":"handle"]("load",ret,http,_305);
}else{
var _30f=new dojo.io.Error("XMLHttpTransport Error: "+http.status+" "+http.statusText);
_305[(typeof _305.error=="function")?"error":"handle"]("error",_30f,http,_305);
}
}
function setHeaders(http,_311){
if(_311["headers"]){
for(var _312 in _311["headers"]){
if(_312.toLowerCase()=="content-type"&&!_311["contentType"]){
_311["contentType"]=_311["headers"][_312];
}else{
http.setRequestHeader(_312,_311["headers"][_312]);
}
}
}
}
this.inFlight=[];
this.inFlightTimer=null;
this.startWatchingInFlight=function(){
if(!this.inFlightTimer){
this.inFlightTimer=setTimeout("dojo.io.XMLHTTPTransport.watchInFlight();",10);
}
};
this.watchInFlight=function(){
var now=null;
if(!dojo.hostenv._blockAsync&&!_2f9._blockAsync){
for(var x=this.inFlight.length-1;x>=0;x--){
try{
var tif=this.inFlight[x];
if(!tif||tif.http._aborted||!tif.http.readyState){
this.inFlight.splice(x,1);
continue;
}
if(4==tif.http.readyState){
this.inFlight.splice(x,1);
doLoad(tif.req,tif.http,tif.url,tif.query,tif.useCache);
}else{
if(tif.startTime){
if(!now){
now=(new Date()).getTime();
}
if(tif.startTime+(tif.req.timeoutSeconds*1000)<now){
if(typeof tif.http.abort=="function"){
tif.http.abort();
}
this.inFlight.splice(x,1);
tif.req[(typeof tif.req.timeout=="function")?"timeout":"handle"]("timeout",null,tif.http,tif.req);
}
}
}
}
catch(e){
try{
var _316=new dojo.io.Error("XMLHttpTransport.watchInFlight Error: "+e);
tif.req[(typeof tif.req.error=="function")?"error":"handle"]("error",_316,tif.http,tif.req);
}
catch(e2){
dojo.debug("XMLHttpTransport error callback failed: "+e2);
}
}
}
}
clearTimeout(this.inFlightTimer);
if(this.inFlight.length==0){
this.inFlightTimer=null;
return;
}
this.inFlightTimer=setTimeout("dojo.io.XMLHTTPTransport.watchInFlight();",10);
};
var _317=dojo.hostenv.getXmlhttpObject()?true:false;
this.canHandle=function(_318){
var mlc=_318["mimetype"].toLowerCase()||"";
return _317&&((dojo.lang.inArray(["text/plain","text/html","application/xml","text/xml","text/javascript"],mlc))||(mlc.substr(0,9)=="text/json"||mlc.substr(0,16)=="application/json"))&&!(_318["formNode"]&&dojo.io.formHasFile(_318["formNode"]));
};
this.multipartBoundary="45309FFF-BD65-4d50-99C9-36986896A96F";
this.bind=function(_31a){
if(!_31a["url"]){
if(!_31a["formNode"]&&(_31a["backButton"]||_31a["back"]||_31a["changeUrl"]||_31a["watchForURL"])&&(!djConfig.preventBackButtonFix)){
dojo.deprecated("Using dojo.io.XMLHTTPTransport.bind() to add to browser history without doing an IO request","Use dojo.undo.browser.addToHistory() instead.","0.4");
dojo.undo.browser.addToHistory(_31a);
return true;
}
}
var url=_31a.url;
var _31c="";
if(_31a["formNode"]){
var ta=_31a.formNode.getAttribute("action");
if((ta)&&(!_31a["url"])){
url=ta;
}
var tp=_31a.formNode.getAttribute("method");
if((tp)&&(!_31a["method"])){
_31a.method=tp;
}
_31c+=dojo.io.encodeForm(_31a.formNode,_31a.encoding,_31a["formFilter"]);
}
if(url.indexOf("#")>-1){
dojo.debug("Warning: dojo.io.bind: stripping hash values from url:",url);
url=url.split("#")[0];
}
if(_31a["file"]){
_31a.method="post";
}
if(!_31a["method"]){
_31a.method="get";
}
if(_31a.method.toLowerCase()=="get"){
_31a.multipart=false;
}else{
if(_31a["file"]){
_31a.multipart=true;
}else{
if(!_31a["multipart"]){
_31a.multipart=false;
}
}
}
if(_31a["backButton"]||_31a["back"]||_31a["changeUrl"]){
dojo.undo.browser.addToHistory(_31a);
}
var _31f=_31a["content"]||{};
if(_31a.sendTransport){
_31f["dojo.transport"]="xmlhttp";
}
do{
if(_31a.postContent){
_31c=_31a.postContent;
break;
}
if(_31f){
_31c+=dojo.io.argsFromMap(_31f,_31a.encoding);
}
if(_31a.method.toLowerCase()=="get"||!_31a.multipart){
break;
}
var t=[];
if(_31c.length){
var q=_31c.split("&");
for(var i=0;i<q.length;++i){
if(q[i].length){
var p=q[i].split("=");
t.push("--"+this.multipartBoundary,"Content-Disposition: form-data; name=\""+p[0]+"\"","",p[1]);
}
}
}
if(_31a.file){
if(dojo.lang.isArray(_31a.file)){
for(var i=0;i<_31a.file.length;++i){
var o=_31a.file[i];
t.push("--"+this.multipartBoundary,"Content-Disposition: form-data; name=\""+o.name+"\"; filename=\""+("fileName" in o?o.fileName:o.name)+"\"","Content-Type: "+("contentType" in o?o.contentType:"application/octet-stream"),"",o.content);
}
}else{
var o=_31a.file;
t.push("--"+this.multipartBoundary,"Content-Disposition: form-data; name=\""+o.name+"\"; filename=\""+("fileName" in o?o.fileName:o.name)+"\"","Content-Type: "+("contentType" in o?o.contentType:"application/octet-stream"),"",o.content);
}
}
if(t.length){
t.push("--"+this.multipartBoundary+"--","");
_31c=t.join("\r\n");
}
}while(false);
var _325=_31a["sync"]?false:true;
var _326=_31a["preventCache"]||(this.preventCache==true&&_31a["preventCache"]!=false);
var _327=_31a["useCache"]==true||(this.useCache==true&&_31a["useCache"]!=false);
if(!_326&&_327){
var _328=getFromCache(url,_31c,_31a.method);
if(_328){
doLoad(_31a,_328,url,_31c,false);
return;
}
}
var http=dojo.hostenv.getXmlhttpObject(_31a);
var _32a=false;
if(_325){
var _32b=this.inFlight.push({"req":_31a,"http":http,"url":url,"query":_31c,"useCache":_327,"startTime":_31a.timeoutSeconds?(new Date()).getTime():0});
this.startWatchingInFlight();
}else{
_2f9._blockAsync=true;
}
if(_31a.method.toLowerCase()=="post"){
if(!_31a.user){
http.open("POST",url,_325);
}else{
http.open("POST",url,_325,_31a.user,_31a.password);
}
setHeaders(http,_31a);
http.setRequestHeader("Content-Type",_31a.multipart?("multipart/form-data; boundary="+this.multipartBoundary):(_31a.contentType||"application/x-www-form-urlencoded"));
try{
http.send(_31c);
}
catch(e){
if(typeof http.abort=="function"){
http.abort();
}
doLoad(_31a,{status:404},url,_31c,_327);
}
}else{
var _32c=url;
if(_31c!=""){
_32c+=(_32c.indexOf("?")>-1?"&":"?")+_31c;
}
if(_326){
_32c+=(dojo.string.endsWithAny(_32c,"?","&")?"":(_32c.indexOf("?")>-1?"&":"?"))+"dojo.preventCache="+new Date().valueOf();
}
if(!_31a.user){
http.open(_31a.method.toUpperCase(),_32c,_325);
}else{
http.open(_31a.method.toUpperCase(),_32c,_325,_31a.user,_31a.password);
}
setHeaders(http,_31a);
try{
http.send(null);
}
catch(e){
if(typeof http.abort=="function"){
http.abort();
}
doLoad(_31a,{status:404},url,_31c,_327);
}
}
if(!_325){
doLoad(_31a,http,url,_31c,_327);
_2f9._blockAsync=false;
}
_31a.abort=function(){
try{
http._aborted=true;
}
catch(e){
}
return http.abort();
};
return;
};
dojo.io.transports.addTransport("XMLHTTPTransport");
};
}
dojo.provide("dojo.io.cookie");
dojo.io.cookie.setCookie=function(name,_32e,days,path,_331,_332){
var _333=-1;
if((typeof days=="number")&&(days>=0)){
var d=new Date();
d.setTime(d.getTime()+(days*24*60*60*1000));
_333=d.toGMTString();
}
_32e=escape(_32e);
document.cookie=name+"="+_32e+";"+(_333!=-1?" expires="+_333+";":"")+(path?"path="+path:"")+(_331?"; domain="+_331:"")+(_332?"; secure":"");
};
dojo.io.cookie.set=dojo.io.cookie.setCookie;
dojo.io.cookie.getCookie=function(name){
var idx=document.cookie.lastIndexOf(name+"=");
if(idx==-1){
return null;
}
var _337=document.cookie.substring(idx+name.length+1);
var end=_337.indexOf(";");
if(end==-1){
end=_337.length;
}
_337=_337.substring(0,end);
_337=unescape(_337);
return _337;
};
dojo.io.cookie.get=dojo.io.cookie.getCookie;
dojo.io.cookie.deleteCookie=function(name){
dojo.io.cookie.setCookie(name,"-",0);
};
dojo.io.cookie.setObjectCookie=function(name,obj,days,path,_33e,_33f,_340){
if(arguments.length==5){
_340=_33e;
_33e=null;
_33f=null;
}
var _341=[],_342,_343="";
if(!_340){
_342=dojo.io.cookie.getObjectCookie(name);
}
if(days>=0){
if(!_342){
_342={};
}
for(var prop in obj){
if(obj[prop]==null){
delete _342[prop];
}else{
if((typeof obj[prop]=="string")||(typeof obj[prop]=="number")){
_342[prop]=obj[prop];
}
}
}
prop=null;
for(var prop in _342){
_341.push(escape(prop)+"="+escape(_342[prop]));
}
_343=_341.join("&");
}
dojo.io.cookie.setCookie(name,_343,days,path,_33e,_33f);
};
dojo.io.cookie.getObjectCookie=function(name){
var _346=null,_347=dojo.io.cookie.getCookie(name);
if(_347){
_346={};
var _348=_347.split("&");
for(var i=0;i<_348.length;i++){
var pair=_348[i].split("=");
var _34b=pair[1];
if(isNaN(_34b)){
_34b=unescape(pair[1]);
}
_346[unescape(pair[0])]=_34b;
}
}
return _346;
};
dojo.io.cookie.isSupported=function(){
if(typeof navigator.cookieEnabled!="boolean"){
dojo.io.cookie.setCookie("__TestingYourBrowserForCookieSupport__","CookiesAllowed",90,null);
var _34c=dojo.io.cookie.getCookie("__TestingYourBrowserForCookieSupport__");
navigator.cookieEnabled=(_34c=="CookiesAllowed");
if(navigator.cookieEnabled){
this.deleteCookie("__TestingYourBrowserForCookieSupport__");
}
}
return navigator.cookieEnabled;
};
if(!dojo.io.cookies){
dojo.io.cookies=dojo.io.cookie;
}
dojo.kwCompoundRequire({common:["dojo.io.common"],rhino:["dojo.io.RhinoIO"],browser:["dojo.io.BrowserIO","dojo.io.cookie"],dashboard:["dojo.io.BrowserIO","dojo.io.cookie"]});
dojo.provide("dojo.io.*");
dojo.provide("dojo.xml.Parse");
dojo.xml.Parse=function(){
var isIE=((dojo.render.html.capable)&&(dojo.render.html.ie));
function getTagName(node){
try{
return node.tagName.toLowerCase();
}
catch(e){
return "";
}
}
function getDojoTagName(node){
var _350=getTagName(node);
if(!_350){
return "";
}
if((dojo.widget)&&(dojo.widget.tags[_350])){
return _350;
}
var p=_350.indexOf(":");
if(p>=0){
return _350;
}
if(_350.substr(0,5)=="dojo:"){
return _350;
}
if(dojo.render.html.capable&&dojo.render.html.ie&&node.scopeName!="HTML"){
return node.scopeName.toLowerCase()+":"+_350;
}
if(_350.substr(0,4)=="dojo"){
return "dojo:"+_350.substring(4);
}
var djt=node.getAttribute("dojoType")||node.getAttribute("dojotype");
if(djt){
if(djt.indexOf(":")<0){
djt="dojo:"+djt;
}
return djt.toLowerCase();
}
djt=node.getAttributeNS&&node.getAttributeNS(dojo.dom.dojoml,"type");
if(djt){
return "dojo:"+djt.toLowerCase();
}
try{
djt=node.getAttribute("dojo:type");
}
catch(e){
}
if(djt){
return "dojo:"+djt.toLowerCase();
}
if((dj_global["djConfig"])&&(!djConfig["ignoreClassNames"])){
var _353=node.className||node.getAttribute("class");
if((_353)&&(_353.indexOf)&&(_353.indexOf("dojo-")!=-1)){
var _354=_353.split(" ");
for(var x=0,c=_354.length;x<c;x++){
if(_354[x].slice(0,5)=="dojo-"){
return "dojo:"+_354[x].substr(5).toLowerCase();
}
}
}
}
return "";
}
this.parseElement=function(node,_358,_359,_35a){
var _35b=getTagName(node);
if(isIE&&_35b.indexOf("/")==0){
return null;
}
try{
var attr=node.getAttribute("parseWidgets");
if(attr&&attr.toLowerCase()=="false"){
return {};
}
}
catch(e){
}
var _35d=true;
if(_359){
var _35e=getDojoTagName(node);
_35b=_35e||_35b;
_35d=Boolean(_35e);
}
var _35f={};
_35f[_35b]=[];
var pos=_35b.indexOf(":");
if(pos>0){
var ns=_35b.substring(0,pos);
_35f["ns"]=ns;
if((dojo.ns)&&(!dojo.ns.allow(ns))){
_35d=false;
}
}
if(_35d){
var _362=this.parseAttributes(node);
for(var attr in _362){
if((!_35f[_35b][attr])||(typeof _35f[_35b][attr]!="array")){
_35f[_35b][attr]=[];
}
_35f[_35b][attr].push(_362[attr]);
}
_35f[_35b].nodeRef=node;
_35f.tagName=_35b;
_35f.index=_35a||0;
}
var _363=0;
for(var i=0;i<node.childNodes.length;i++){
var tcn=node.childNodes.item(i);
switch(tcn.nodeType){
case dojo.dom.ELEMENT_NODE:
var ctn=getDojoTagName(tcn)||getTagName(tcn);
if(!_35f[ctn]){
_35f[ctn]=[];
}
_35f[ctn].push(this.parseElement(tcn,true,_359,_363));
if((tcn.childNodes.length==1)&&(tcn.childNodes.item(0).nodeType==dojo.dom.TEXT_NODE)){
_35f[ctn][_35f[ctn].length-1].value=tcn.childNodes.item(0).nodeValue;
}
_363++;
break;
case dojo.dom.TEXT_NODE:
if(node.childNodes.length==1){
_35f[_35b].push({value:node.childNodes.item(0).nodeValue});
}
break;
default:
break;
}
}
return _35f;
};
this.parseAttributes=function(node){
var _368={};
var atts=node.attributes;
var _36a,i=0;
while((_36a=atts[i++])){
if(isIE){
if(!_36a){
continue;
}
if((typeof _36a=="object")&&(typeof _36a.nodeValue=="undefined")||(_36a.nodeValue==null)||(_36a.nodeValue=="")){
continue;
}
}
var nn=_36a.nodeName.split(":");
nn=(nn.length==2)?nn[1]:_36a.nodeName;
_368[nn]={value:_36a.nodeValue};
}
return _368;
};
};
dojo.provide("dojo.lang.declare");
dojo.lang.declare=function(_36d,_36e,init,_370){
if((dojo.lang.isFunction(_370))||((!_370)&&(!dojo.lang.isFunction(init)))){
var temp=_370;
_370=init;
init=temp;
}
var _372=[];
if(dojo.lang.isArray(_36e)){
_372=_36e;
_36e=_372.shift();
}
if(!init){
init=dojo.evalObjPath(_36d,false);
if((init)&&(!dojo.lang.isFunction(init))){
init=null;
}
}
var ctor=dojo.lang.declare._makeConstructor();
var scp=(_36e?_36e.prototype:null);
if(scp){
scp.prototyping=true;
ctor.prototype=new _36e();
scp.prototyping=false;
}
ctor.superclass=scp;
ctor.mixins=_372;
for(var i=0,l=_372.length;i<l;i++){
dojo.lang.extend(ctor,_372[i].prototype);
}
ctor.prototype.initializer=null;
ctor.prototype.declaredClass=_36d;
if(dojo.lang.isArray(_370)){
dojo.lang.extend.apply(dojo.lang,[ctor].concat(_370));
}else{
dojo.lang.extend(ctor,(_370)||{});
}
dojo.lang.extend(ctor,dojo.lang.declare._common);
ctor.prototype.constructor=ctor;
ctor.prototype.initializer=(ctor.prototype.initializer)||(init)||(function(){
});
var _377=dojo.parseObjPath(_36d,null,true);
_377.obj[_377.prop]=ctor;
return ctor;
};
dojo.lang.declare._makeConstructor=function(){
return function(){
var self=this._getPropContext();
var s=self.constructor.superclass;
if((s)&&(s.constructor)){
if(s.constructor==arguments.callee){
this._inherited("constructor",arguments);
}else{
this._contextMethod(s,"constructor",arguments);
}
}
var ms=(self.constructor.mixins)||([]);
for(var i=0,m;(m=ms[i]);i++){
(((m.prototype)&&(m.prototype.initializer))||(m)).apply(this,arguments);
}
if((!this.prototyping)&&(self.initializer)){
self.initializer.apply(this,arguments);
}
};
};
dojo.lang.declare._common={_getPropContext:function(){
return (this.___proto||this);
},_contextMethod:function(_37d,_37e,args){
var _380,_381=this.___proto;
this.___proto=_37d;
try{
_380=_37d[_37e].apply(this,(args||[]));
}
catch(e){
throw e;
}
finally{
this.___proto=_381;
}
return _380;
},_inherited:function(prop,args){
var p=this._getPropContext();
do{
if((!p.constructor)||(!p.constructor.superclass)){
return;
}
p=p.constructor.superclass;
}while(!(prop in p));
return (dojo.lang.isFunction(p[prop])?this._contextMethod(p,prop,args):p[prop]);
},inherited:function(prop,args){
dojo.deprecated("'inherited' method is dangerous, do not up-call! 'inherited' is slated for removal in 0.5; name your super class (or use superclass property) instead.","0.5");
this._inherited(prop,args);
}};
dojo.declare=dojo.lang.declare;
dojo.provide("dojo.ns");
dojo.ns={namespaces:{},failed:{},loading:{},loaded:{},register:function(name,_388,_389,_38a){
if(!_38a||!this.namespaces[name]){
this.namespaces[name]=new dojo.ns.Ns(name,_388,_389);
}
},allow:function(name){
if(this.failed[name]){
return false;
}
if((djConfig.excludeNamespace)&&(dojo.lang.inArray(djConfig.excludeNamespace,name))){
return false;
}
return ((name==this.dojo)||(!djConfig.includeNamespace)||(dojo.lang.inArray(djConfig.includeNamespace,name)));
},get:function(name){
return this.namespaces[name];
},require:function(name){
var ns=this.namespaces[name];
if((ns)&&(this.loaded[name])){
return ns;
}
if(!this.allow(name)){
return false;
}
if(this.loading[name]){
dojo.debug("dojo.namespace.require: re-entrant request to load namespace \""+name+"\" must fail.");
return false;
}
var req=dojo.require;
this.loading[name]=true;
try{
if(name=="dojo"){
req("dojo.namespaces.dojo");
}else{
if(!dojo.hostenv.moduleHasPrefix(name)){
dojo.registerModulePath(name,"../"+name);
}
req([name,"manifest"].join("."),false,true);
}
if(!this.namespaces[name]){
this.failed[name]=true;
}
}
finally{
this.loading[name]=false;
}
return this.namespaces[name];
}};
dojo.ns.Ns=function(name,_391,_392){
this.name=name;
this.module=_391;
this.resolver=_392;
this._loaded=[];
this._failed=[];
};
dojo.ns.Ns.prototype.resolve=function(name,_394,_395){
if(!this.resolver||djConfig["skipAutoRequire"]){
return false;
}
var _396=this.resolver(name,_394);
if((_396)&&(!this._loaded[_396])&&(!this._failed[_396])){
var req=dojo.require;
req(_396,false,true);
if(dojo.hostenv.findModule(_396,false)){
this._loaded[_396]=true;
}else{
if(!_395){
dojo.raise("dojo.ns.Ns.resolve: module '"+_396+"' not found after loading via namespace '"+this.name+"'");
}
this._failed[_396]=true;
}
}
return Boolean(this._loaded[_396]);
};
dojo.registerNamespace=function(name,_399,_39a){
dojo.ns.register.apply(dojo.ns,arguments);
};
dojo.registerNamespaceResolver=function(name,_39c){
var n=dojo.ns.namespaces[name];
if(n){
n.resolver=_39c;
}
};
dojo.registerNamespaceManifest=function(_39e,path,name,_3a1,_3a2){
dojo.registerModulePath(name,path);
dojo.registerNamespace(name,_3a1,_3a2);
};
dojo.registerNamespace("dojo","dojo.widget");
dojo.provide("dojo.event.common");
dojo.event=new function(){
this._canTimeout=dojo.lang.isFunction(dj_global["setTimeout"])||dojo.lang.isAlien(dj_global["setTimeout"]);
function interpolateArgs(args,_3a4){
var dl=dojo.lang;
var ao={srcObj:dj_global,srcFunc:null,adviceObj:dj_global,adviceFunc:null,aroundObj:null,aroundFunc:null,adviceType:(args.length>2)?args[0]:"after",precedence:"last",once:false,delay:null,rate:0,adviceMsg:false,maxCalls:-1};
switch(args.length){
case 0:
return;
case 1:
return;
case 2:
ao.srcFunc=args[0];
ao.adviceFunc=args[1];
break;
case 3:
if((dl.isObject(args[0]))&&(dl.isString(args[1]))&&(dl.isString(args[2]))){
ao.adviceType="after";
ao.srcObj=args[0];
ao.srcFunc=args[1];
ao.adviceFunc=args[2];
}else{
if((dl.isString(args[1]))&&(dl.isString(args[2]))){
ao.srcFunc=args[1];
ao.adviceFunc=args[2];
}else{
if((dl.isObject(args[0]))&&(dl.isString(args[1]))&&(dl.isFunction(args[2]))){
ao.adviceType="after";
ao.srcObj=args[0];
ao.srcFunc=args[1];
var _3a7=dl.nameAnonFunc(args[2],ao.adviceObj,_3a4);
ao.adviceFunc=_3a7;
}else{
if((dl.isFunction(args[0]))&&(dl.isObject(args[1]))&&(dl.isString(args[2]))){
ao.adviceType="after";
ao.srcObj=dj_global;
var _3a7=dl.nameAnonFunc(args[0],ao.srcObj,_3a4);
ao.srcFunc=_3a7;
ao.adviceObj=args[1];
ao.adviceFunc=args[2];
}
}
}
}
break;
case 4:
if((dl.isObject(args[0]))&&(dl.isObject(args[2]))){
ao.adviceType="after";
ao.srcObj=args[0];
ao.srcFunc=args[1];
ao.adviceObj=args[2];
ao.adviceFunc=args[3];
}else{
if((dl.isString(args[0]))&&(dl.isString(args[1]))&&(dl.isObject(args[2]))){
ao.adviceType=args[0];
ao.srcObj=dj_global;
ao.srcFunc=args[1];
ao.adviceObj=args[2];
ao.adviceFunc=args[3];
}else{
if((dl.isString(args[0]))&&(dl.isFunction(args[1]))&&(dl.isObject(args[2]))){
ao.adviceType=args[0];
ao.srcObj=dj_global;
var _3a7=dl.nameAnonFunc(args[1],dj_global,_3a4);
ao.srcFunc=_3a7;
ao.adviceObj=args[2];
ao.adviceFunc=args[3];
}else{
if((dl.isString(args[0]))&&(dl.isObject(args[1]))&&(dl.isString(args[2]))&&(dl.isFunction(args[3]))){
ao.srcObj=args[1];
ao.srcFunc=args[2];
var _3a7=dl.nameAnonFunc(args[3],dj_global,_3a4);
ao.adviceObj=dj_global;
ao.adviceFunc=_3a7;
}else{
if(dl.isObject(args[1])){
ao.srcObj=args[1];
ao.srcFunc=args[2];
ao.adviceObj=dj_global;
ao.adviceFunc=args[3];
}else{
if(dl.isObject(args[2])){
ao.srcObj=dj_global;
ao.srcFunc=args[1];
ao.adviceObj=args[2];
ao.adviceFunc=args[3];
}else{
ao.srcObj=ao.adviceObj=ao.aroundObj=dj_global;
ao.srcFunc=args[1];
ao.adviceFunc=args[2];
ao.aroundFunc=args[3];
}
}
}
}
}
}
break;
case 6:
ao.srcObj=args[1];
ao.srcFunc=args[2];
ao.adviceObj=args[3];
ao.adviceFunc=args[4];
ao.aroundFunc=args[5];
ao.aroundObj=dj_global;
break;
default:
ao.srcObj=args[1];
ao.srcFunc=args[2];
ao.adviceObj=args[3];
ao.adviceFunc=args[4];
ao.aroundObj=args[5];
ao.aroundFunc=args[6];
ao.once=args[7];
ao.delay=args[8];
ao.rate=args[9];
ao.adviceMsg=args[10];
ao.maxCalls=(!isNaN(parseInt(args[11])))?args[11]:-1;
break;
}
if(dl.isFunction(ao.aroundFunc)){
var _3a7=dl.nameAnonFunc(ao.aroundFunc,ao.aroundObj,_3a4);
ao.aroundFunc=_3a7;
}
if(dl.isFunction(ao.srcFunc)){
ao.srcFunc=dl.getNameInObj(ao.srcObj,ao.srcFunc);
}
if(dl.isFunction(ao.adviceFunc)){
ao.adviceFunc=dl.getNameInObj(ao.adviceObj,ao.adviceFunc);
}
if((ao.aroundObj)&&(dl.isFunction(ao.aroundFunc))){
ao.aroundFunc=dl.getNameInObj(ao.aroundObj,ao.aroundFunc);
}
if(!ao.srcObj){
dojo.raise("bad srcObj for srcFunc: "+ao.srcFunc);
}
if(!ao.adviceObj){
dojo.raise("bad adviceObj for adviceFunc: "+ao.adviceFunc);
}
if(!ao.adviceFunc){
dojo.debug("bad adviceFunc for srcFunc: "+ao.srcFunc);
dojo.debugShallow(ao);
}
return ao;
}
this.connect=function(){
if(arguments.length==1){
var ao=arguments[0];
}else{
var ao=interpolateArgs(arguments,true);
}
if(dojo.lang.isString(ao.srcFunc)&&(ao.srcFunc.toLowerCase()=="onkey")){
if(dojo.render.html.ie){
ao.srcFunc="onkeydown";
this.connect(ao);
}
ao.srcFunc="onkeypress";
}
if(dojo.lang.isArray(ao.srcObj)&&ao.srcObj!=""){
var _3a9={};
for(var x in ao){
_3a9[x]=ao[x];
}
var mjps=[];
dojo.lang.forEach(ao.srcObj,function(src){
if((dojo.render.html.capable)&&(dojo.lang.isString(src))){
src=dojo.byId(src);
}
_3a9.srcObj=src;
mjps.push(dojo.event.connect.call(dojo.event,_3a9));
});
return mjps;
}
var mjp=dojo.event.MethodJoinPoint.getForMethod(ao.srcObj,ao.srcFunc);
if(ao.adviceFunc){
var mjp2=dojo.event.MethodJoinPoint.getForMethod(ao.adviceObj,ao.adviceFunc);
}
mjp.kwAddAdvice(ao);
return mjp;
};
this.log=function(a1,a2){
var _3b1;
if((arguments.length==1)&&(typeof a1=="object")){
_3b1=a1;
}else{
_3b1={srcObj:a1,srcFunc:a2};
}
_3b1.adviceFunc=function(){
var _3b2=[];
for(var x=0;x<arguments.length;x++){
_3b2.push(arguments[x]);
}
dojo.debug("("+_3b1.srcObj+")."+_3b1.srcFunc,":",_3b2.join(", "));
};
this.kwConnect(_3b1);
};
this.connectBefore=function(){
var args=["before"];
for(var i=0;i<arguments.length;i++){
args.push(arguments[i]);
}
return this.connect.apply(this,args);
};
this.connectAround=function(){
var args=["around"];
for(var i=0;i<arguments.length;i++){
args.push(arguments[i]);
}
return this.connect.apply(this,args);
};
this.connectOnce=function(){
var ao=interpolateArgs(arguments,true);
ao.once=true;
return this.connect(ao);
};
this.connectRunOnce=function(){
var ao=interpolateArgs(arguments,true);
ao.maxCalls=1;
return this.connect(ao);
};
this._kwConnectImpl=function(_3ba,_3bb){
var fn=(_3bb)?"disconnect":"connect";
if(typeof _3ba["srcFunc"]=="function"){
_3ba.srcObj=_3ba["srcObj"]||dj_global;
var _3bd=dojo.lang.nameAnonFunc(_3ba.srcFunc,_3ba.srcObj,true);
_3ba.srcFunc=_3bd;
}
if(typeof _3ba["adviceFunc"]=="function"){
_3ba.adviceObj=_3ba["adviceObj"]||dj_global;
var _3bd=dojo.lang.nameAnonFunc(_3ba.adviceFunc,_3ba.adviceObj,true);
_3ba.adviceFunc=_3bd;
}
_3ba.srcObj=_3ba["srcObj"]||dj_global;
_3ba.adviceObj=_3ba["adviceObj"]||_3ba["targetObj"]||dj_global;
_3ba.adviceFunc=_3ba["adviceFunc"]||_3ba["targetFunc"];
return dojo.event[fn](_3ba);
};
this.kwConnect=function(_3be){
return this._kwConnectImpl(_3be,false);
};
this.disconnect=function(){
if(arguments.length==1){
var ao=arguments[0];
}else{
var ao=interpolateArgs(arguments,true);
}
if(!ao.adviceFunc){
return;
}
if(dojo.lang.isString(ao.srcFunc)&&(ao.srcFunc.toLowerCase()=="onkey")){
if(dojo.render.html.ie){
ao.srcFunc="onkeydown";
this.disconnect(ao);
}
ao.srcFunc="onkeypress";
}
if(!ao.srcObj[ao.srcFunc]){
return null;
}
var mjp=dojo.event.MethodJoinPoint.getForMethod(ao.srcObj,ao.srcFunc,true);
mjp.removeAdvice(ao.adviceObj,ao.adviceFunc,ao.adviceType,ao.once);
return mjp;
};
this.kwDisconnect=function(_3c1){
return this._kwConnectImpl(_3c1,true);
};
};
dojo.event.MethodInvocation=function(_3c2,obj,args){
this.jp_=_3c2;
this.object=obj;
this.args=[];
for(var x=0;x<args.length;x++){
this.args[x]=args[x];
}
this.around_index=-1;
};
dojo.event.MethodInvocation.prototype.proceed=function(){
this.around_index++;
if(this.around_index>=this.jp_.around.length){
return this.jp_.object[this.jp_.methodname].apply(this.jp_.object,this.args);
}else{
var ti=this.jp_.around[this.around_index];
var mobj=ti[0]||dj_global;
var meth=ti[1];
return mobj[meth].call(mobj,this);
}
};
dojo.event.MethodJoinPoint=function(obj,_3ca){
this.object=obj||dj_global;
this.methodname=_3ca;
this.methodfunc=this.object[_3ca];
this.squelch=false;
};
dojo.event.MethodJoinPoint.getForMethod=function(obj,_3cc){
if(!obj){
obj=dj_global;
}
var ofn=obj[_3cc];
if(!ofn){
ofn=obj[_3cc]=function(){
};
if(!obj[_3cc]){
dojo.raise("Cannot set do-nothing method on that object "+_3cc);
}
}else{
if((typeof ofn!="function")&&(!dojo.lang.isFunction(ofn))&&(!dojo.lang.isAlien(ofn))){
return null;
}
}
var _3ce=_3cc+"$joinpoint";
var _3cf=_3cc+"$joinpoint$method";
var _3d0=obj[_3ce];
if(!_3d0){
var _3d1=false;
if(dojo.event["browser"]){
if((obj["attachEvent"])||(obj["nodeType"])||(obj["addEventListener"])){
_3d1=true;
dojo.event.browser.addClobberNodeAttrs(obj,[_3ce,_3cf,_3cc]);
}
}
var _3d2=ofn.length;
obj[_3cf]=ofn;
_3d0=obj[_3ce]=new dojo.event.MethodJoinPoint(obj,_3cf);
if(!_3d1){
obj[_3cc]=function(){
return _3d0.run.apply(_3d0,arguments);
};
}else{
obj[_3cc]=function(){
var args=[];
if(!arguments.length){
var evt=null;
try{
if(obj.ownerDocument){
evt=obj.ownerDocument.parentWindow.event;
}else{
if(obj.documentElement){
evt=obj.documentElement.ownerDocument.parentWindow.event;
}else{
if(obj.event){
evt=obj.event;
}else{
evt=window.event;
}
}
}
}
catch(e){
evt=window.event;
}
if(evt){
args.push(dojo.event.browser.fixEvent(evt,this));
}
}else{
for(var x=0;x<arguments.length;x++){
if((x==0)&&(dojo.event.browser.isEvent(arguments[x]))){
args.push(dojo.event.browser.fixEvent(arguments[x],this));
}else{
args.push(arguments[x]);
}
}
}
return _3d0.run.apply(_3d0,args);
};
}
obj[_3cc].__preJoinArity=_3d2;
}
return _3d0;
};
dojo.lang.extend(dojo.event.MethodJoinPoint,{squelch:false,unintercept:function(){
this.object[this.methodname]=this.methodfunc;
this.before=[];
this.after=[];
this.around=[];
},disconnect:dojo.lang.forward("unintercept"),run:function(){
var obj=this.object||dj_global;
var args=arguments;
var _3d8=[];
for(var x=0;x<args.length;x++){
_3d8[x]=args[x];
}
var _3da=function(marr){
if(!marr){
dojo.debug("Null argument to unrollAdvice()");
return;
}
var _3dc=marr[0]||dj_global;
var _3dd=marr[1];
if(!_3dc[_3dd]){
dojo.raise("function \""+_3dd+"\" does not exist on \""+_3dc+"\"");
}
var _3de=marr[2]||dj_global;
var _3df=marr[3];
var msg=marr[6];
var _3e1=marr[7];
if(_3e1>-1){
if(_3e1==0){
return;
}
marr[7]--;
}
var _3e2;
var to={args:[],jp_:this,object:obj,proceed:function(){
return _3dc[_3dd].apply(_3dc,to.args);
}};
to.args=_3d8;
var _3e4=parseInt(marr[4]);
var _3e5=((!isNaN(_3e4))&&(marr[4]!==null)&&(typeof marr[4]!="undefined"));
if(marr[5]){
var rate=parseInt(marr[5]);
var cur=new Date();
var _3e8=false;
if((marr["last"])&&((cur-marr.last)<=rate)){
if(dojo.event._canTimeout){
if(marr["delayTimer"]){
clearTimeout(marr.delayTimer);
}
var tod=parseInt(rate*2);
var mcpy=dojo.lang.shallowCopy(marr);
marr.delayTimer=setTimeout(function(){
mcpy[5]=0;
_3da(mcpy);
},tod);
}
return;
}else{
marr.last=cur;
}
}
if(_3df){
_3de[_3df].call(_3de,to);
}else{
if((_3e5)&&((dojo.render.html)||(dojo.render.svg))){
dj_global["setTimeout"](function(){
if(msg){
_3dc[_3dd].call(_3dc,to);
}else{
_3dc[_3dd].apply(_3dc,args);
}
},_3e4);
}else{
if(msg){
_3dc[_3dd].call(_3dc,to);
}else{
_3dc[_3dd].apply(_3dc,args);
}
}
}
};
var _3eb=function(){
if(this.squelch){
try{
return _3da.apply(this,arguments);
}
catch(e){
dojo.debug(e);
}
}else{
return _3da.apply(this,arguments);
}
};
if((this["before"])&&(this.before.length>0)){
dojo.lang.forEach(this.before.concat(new Array()),_3eb);
}
var _3ec;
try{
if((this["around"])&&(this.around.length>0)){
var mi=new dojo.event.MethodInvocation(this,obj,args);
_3ec=mi.proceed();
}else{
if(this.methodfunc){
_3ec=this.object[this.methodname].apply(this.object,args);
}
}
}
catch(e){
if(!this.squelch){
dojo.debug(e,"when calling",this.methodname,"on",this.object,"with arguments",args);
dojo.raise(e);
}
}
if((this["after"])&&(this.after.length>0)){
dojo.lang.forEach(this.after.concat(new Array()),_3eb);
}
return (this.methodfunc)?_3ec:null;
},getArr:function(kind){
var type="after";
if((typeof kind=="string")&&(kind.indexOf("before")!=-1)){
type="before";
}else{
if(kind=="around"){
type="around";
}
}
if(!this[type]){
this[type]=[];
}
return this[type];
},kwAddAdvice:function(args){
this.addAdvice(args["adviceObj"],args["adviceFunc"],args["aroundObj"],args["aroundFunc"],args["adviceType"],args["precedence"],args["once"],args["delay"],args["rate"],args["adviceMsg"],args["maxCalls"]);
},addAdvice:function(_3f1,_3f2,_3f3,_3f4,_3f5,_3f6,once,_3f8,rate,_3fa,_3fb){
var arr=this.getArr(_3f5);
if(!arr){
dojo.raise("bad this: "+this);
}
var ao=[_3f1,_3f2,_3f3,_3f4,_3f8,rate,_3fa,_3fb];
if(once){
if(this.hasAdvice(_3f1,_3f2,_3f5,arr)>=0){
return;
}
}
if(_3f6=="first"){
arr.unshift(ao);
}else{
arr.push(ao);
}
},hasAdvice:function(_3fe,_3ff,_400,arr){
if(!arr){
arr=this.getArr(_400);
}
var ind=-1;
for(var x=0;x<arr.length;x++){
var aao=(typeof _3ff=="object")?(new String(_3ff)).toString():_3ff;
var a1o=(typeof arr[x][1]=="object")?(new String(arr[x][1])).toString():arr[x][1];
if((arr[x][0]==_3fe)&&(a1o==aao)){
ind=x;
}
}
return ind;
},removeAdvice:function(_406,_407,_408,once){
var arr=this.getArr(_408);
var ind=this.hasAdvice(_406,_407,_408,arr);
if(ind==-1){
return false;
}
while(ind!=-1){
arr.splice(ind,1);
if(once){
break;
}
ind=this.hasAdvice(_406,_407,_408,arr);
}
return true;
}});
dojo.provide("dojo.event.topic");
dojo.event.topic=new function(){
this.topics={};
this.getTopic=function(_40c){
if(!this.topics[_40c]){
this.topics[_40c]=new this.TopicImpl(_40c);
}
return this.topics[_40c];
};
this.registerPublisher=function(_40d,obj,_40f){
var _40d=this.getTopic(_40d);
_40d.registerPublisher(obj,_40f);
};
this.subscribe=function(_410,obj,_412){
var _410=this.getTopic(_410);
_410.subscribe(obj,_412);
};
this.unsubscribe=function(_413,obj,_415){
var _413=this.getTopic(_413);
_413.unsubscribe(obj,_415);
};
this.destroy=function(_416){
this.getTopic(_416).destroy();
delete this.topics[_416];
};
this.publishApply=function(_417,args){
var _417=this.getTopic(_417);
_417.sendMessage.apply(_417,args);
};
this.publish=function(_419,_41a){
var _419=this.getTopic(_419);
var args=[];
for(var x=1;x<arguments.length;x++){
args.push(arguments[x]);
}
_419.sendMessage.apply(_419,args);
};
};
dojo.event.topic.TopicImpl=function(_41d){
this.topicName=_41d;
this.subscribe=function(_41e,_41f){
var tf=_41f||_41e;
var to=(!_41f)?dj_global:_41e;
return dojo.event.kwConnect({srcObj:this,srcFunc:"sendMessage",adviceObj:to,adviceFunc:tf});
};
this.unsubscribe=function(_422,_423){
var tf=(!_423)?_422:_423;
var to=(!_423)?null:_422;
return dojo.event.kwDisconnect({srcObj:this,srcFunc:"sendMessage",adviceObj:to,adviceFunc:tf});
};
this._getJoinPoint=function(){
return dojo.event.MethodJoinPoint.getForMethod(this,"sendMessage");
};
this.setSquelch=function(_426){
this._getJoinPoint().squelch=_426;
};
this.destroy=function(){
this._getJoinPoint().disconnect();
};
this.registerPublisher=function(_427,_428){
dojo.event.connect(_427,_428,this,"sendMessage");
};
this.sendMessage=function(_429){
};
};
dojo.provide("dojo.event.browser");
dojo._ie_clobber=new function(){
this.clobberNodes=[];
function nukeProp(node,prop){
try{
node[prop]=null;
}
catch(e){
}
try{
delete node[prop];
}
catch(e){
}
try{
node.removeAttribute(prop);
}
catch(e){
}
}
this.clobber=function(_42c){
var na;
var tna;
if(_42c){
tna=_42c.all||_42c.getElementsByTagName("*");
na=[_42c];
for(var x=0;x<tna.length;x++){
if(tna[x]["__doClobber__"]){
na.push(tna[x]);
}
}
}else{
try{
window.onload=null;
}
catch(e){
}
na=(this.clobberNodes.length)?this.clobberNodes:document.all;
}
tna=null;
var _430={};
for(var i=na.length-1;i>=0;i=i-1){
var el=na[i];
try{
if(el&&el["__clobberAttrs__"]){
for(var j=0;j<el.__clobberAttrs__.length;j++){
nukeProp(el,el.__clobberAttrs__[j]);
}
nukeProp(el,"__clobberAttrs__");
nukeProp(el,"__doClobber__");
}
}
catch(e){
}
}
na=null;
};
};
if(dojo.render.html.ie){
dojo.addOnUnload(function(){
dojo._ie_clobber.clobber();
try{
if((dojo["widget"])&&(dojo.widget["manager"])){
dojo.widget.manager.destroyAll();
}
}
catch(e){
}
if(dojo.widget){
for(var name in dojo.widget._templateCache){
if(dojo.widget._templateCache[name].node){
dojo.dom.destroyNode(dojo.widget._templateCache[name].node);
dojo.widget._templateCache[name].node=null;
delete dojo.widget._templateCache[name].node;
}
}
}
try{
window.onload=null;
}
catch(e){
}
try{
window.onunload=null;
}
catch(e){
}
dojo._ie_clobber.clobberNodes=[];
});
}
dojo.event.browser=new function(){
var _435=0;
this.normalizedEventName=function(_436){
switch(_436){
case "CheckboxStateChange":
case "DOMAttrModified":
case "DOMMenuItemActive":
case "DOMMenuItemInactive":
case "DOMMouseScroll":
case "DOMNodeInserted":
case "DOMNodeRemoved":
case "RadioStateChange":
return _436;
break;
default:
var lcn=_436.toLowerCase();
return (lcn.indexOf("on")==0)?lcn.substr(2):lcn;
break;
}
};
this.clean=function(node){
if(dojo.render.html.ie){
dojo._ie_clobber.clobber(node);
}
};
this.addClobberNode=function(node){
if(!dojo.render.html.ie){
return;
}
if(!node["__doClobber__"]){
node.__doClobber__=true;
dojo._ie_clobber.clobberNodes.push(node);
node.__clobberAttrs__=[];
}
};
this.addClobberNodeAttrs=function(node,_43b){
if(!dojo.render.html.ie){
return;
}
this.addClobberNode(node);
for(var x=0;x<_43b.length;x++){
node.__clobberAttrs__.push(_43b[x]);
}
};
this.removeListener=function(node,_43e,fp,_440){
if(!_440){
var _440=false;
}
_43e=dojo.event.browser.normalizedEventName(_43e);
if(_43e=="key"){
if(dojo.render.html.ie){
this.removeListener(node,"onkeydown",fp,_440);
}
_43e="keypress";
}
if(node.removeEventListener){
node.removeEventListener(_43e,fp,_440);
}
};
this.addListener=function(node,_442,fp,_444,_445){
if(!node){
return;
}
if(!_444){
var _444=false;
}
_442=dojo.event.browser.normalizedEventName(_442);
if(_442=="key"){
if(dojo.render.html.ie){
this.addListener(node,"onkeydown",fp,_444,_445);
}
_442="keypress";
}
if(!_445){
var _446=function(evt){
if(!evt){
evt=window.event;
}
var ret=fp(dojo.event.browser.fixEvent(evt,this));
if(_444){
dojo.event.browser.stopEvent(evt);
}
return ret;
};
}else{
_446=fp;
}
if(node.addEventListener){
node.addEventListener(_442,_446,_444);
return _446;
}else{
_442="on"+_442;
if(typeof node[_442]=="function"){
var _449=node[_442];
node[_442]=function(e){
_449(e);
return _446(e);
};
}else{
node[_442]=_446;
}
if(dojo.render.html.ie){
this.addClobberNodeAttrs(node,[_442]);
}
return _446;
}
};
this.isEvent=function(obj){
return (typeof obj!="undefined")&&(obj)&&(typeof Event!="undefined")&&(obj.eventPhase);
};
this.currentEvent=null;
this.callListener=function(_44c,_44d){
if(typeof _44c!="function"){
dojo.raise("listener not a function: "+_44c);
}
dojo.event.browser.currentEvent.currentTarget=_44d;
return _44c.call(_44d,dojo.event.browser.currentEvent);
};
this._stopPropagation=function(){
dojo.event.browser.currentEvent.cancelBubble=true;
};
this._preventDefault=function(){
dojo.event.browser.currentEvent.returnValue=false;
};
this.keys={KEY_BACKSPACE:8,KEY_TAB:9,KEY_CLEAR:12,KEY_ENTER:13,KEY_SHIFT:16,KEY_CTRL:17,KEY_ALT:18,KEY_PAUSE:19,KEY_CAPS_LOCK:20,KEY_ESCAPE:27,KEY_SPACE:32,KEY_PAGE_UP:33,KEY_PAGE_DOWN:34,KEY_END:35,KEY_HOME:36,KEY_LEFT_ARROW:37,KEY_UP_ARROW:38,KEY_RIGHT_ARROW:39,KEY_DOWN_ARROW:40,KEY_INSERT:45,KEY_DELETE:46,KEY_HELP:47,KEY_LEFT_WINDOW:91,KEY_RIGHT_WINDOW:92,KEY_SELECT:93,KEY_NUMPAD_0:96,KEY_NUMPAD_1:97,KEY_NUMPAD_2:98,KEY_NUMPAD_3:99,KEY_NUMPAD_4:100,KEY_NUMPAD_5:101,KEY_NUMPAD_6:102,KEY_NUMPAD_7:103,KEY_NUMPAD_8:104,KEY_NUMPAD_9:105,KEY_NUMPAD_MULTIPLY:106,KEY_NUMPAD_PLUS:107,KEY_NUMPAD_ENTER:108,KEY_NUMPAD_MINUS:109,KEY_NUMPAD_PERIOD:110,KEY_NUMPAD_DIVIDE:111,KEY_F1:112,KEY_F2:113,KEY_F3:114,KEY_F4:115,KEY_F5:116,KEY_F6:117,KEY_F7:118,KEY_F8:119,KEY_F9:120,KEY_F10:121,KEY_F11:122,KEY_F12:123,KEY_F13:124,KEY_F14:125,KEY_F15:126,KEY_NUM_LOCK:144,KEY_SCROLL_LOCK:145};
this.revKeys=[];
for(var key in this.keys){
this.revKeys[this.keys[key]]=key;
}
this.fixEvent=function(evt,_450){
if(!evt){
if(window["event"]){
evt=window.event;
}
}
if((evt["type"])&&(evt["type"].indexOf("key")==0)){
evt.keys=this.revKeys;
for(var key in this.keys){
evt[key]=this.keys[key];
}
if(evt["type"]=="keydown"&&dojo.render.html.ie){
switch(evt.keyCode){
case evt.KEY_SHIFT:
case evt.KEY_CTRL:
case evt.KEY_ALT:
case evt.KEY_CAPS_LOCK:
case evt.KEY_LEFT_WINDOW:
case evt.KEY_RIGHT_WINDOW:
case evt.KEY_SELECT:
case evt.KEY_NUM_LOCK:
case evt.KEY_SCROLL_LOCK:
case evt.KEY_NUMPAD_0:
case evt.KEY_NUMPAD_1:
case evt.KEY_NUMPAD_2:
case evt.KEY_NUMPAD_3:
case evt.KEY_NUMPAD_4:
case evt.KEY_NUMPAD_5:
case evt.KEY_NUMPAD_6:
case evt.KEY_NUMPAD_7:
case evt.KEY_NUMPAD_8:
case evt.KEY_NUMPAD_9:
case evt.KEY_NUMPAD_PERIOD:
break;
case evt.KEY_NUMPAD_MULTIPLY:
case evt.KEY_NUMPAD_PLUS:
case evt.KEY_NUMPAD_ENTER:
case evt.KEY_NUMPAD_MINUS:
case evt.KEY_NUMPAD_DIVIDE:
break;
case evt.KEY_PAUSE:
case evt.KEY_TAB:
case evt.KEY_BACKSPACE:
case evt.KEY_ENTER:
case evt.KEY_ESCAPE:
case evt.KEY_PAGE_UP:
case evt.KEY_PAGE_DOWN:
case evt.KEY_END:
case evt.KEY_HOME:
case evt.KEY_LEFT_ARROW:
case evt.KEY_UP_ARROW:
case evt.KEY_RIGHT_ARROW:
case evt.KEY_DOWN_ARROW:
case evt.KEY_INSERT:
case evt.KEY_DELETE:
case evt.KEY_F1:
case evt.KEY_F2:
case evt.KEY_F3:
case evt.KEY_F4:
case evt.KEY_F5:
case evt.KEY_F6:
case evt.KEY_F7:
case evt.KEY_F8:
case evt.KEY_F9:
case evt.KEY_F10:
case evt.KEY_F11:
case evt.KEY_F12:
case evt.KEY_F12:
case evt.KEY_F13:
case evt.KEY_F14:
case evt.KEY_F15:
case evt.KEY_CLEAR:
case evt.KEY_HELP:
evt.key=evt.keyCode;
break;
default:
if(evt.ctrlKey||evt.altKey){
var _452=evt.keyCode;
if(_452>=65&&_452<=90&&evt.shiftKey==false){
_452+=32;
}
if(_452>=1&&_452<=26&&evt.ctrlKey){
_452+=96;
}
evt.key=String.fromCharCode(_452);
}
}
}else{
if(evt["type"]=="keypress"){
if(dojo.render.html.opera){
if(evt.which==0){
evt.key=evt.keyCode;
}else{
if(evt.which>0){
switch(evt.which){
case evt.KEY_SHIFT:
case evt.KEY_CTRL:
case evt.KEY_ALT:
case evt.KEY_CAPS_LOCK:
case evt.KEY_NUM_LOCK:
case evt.KEY_SCROLL_LOCK:
break;
case evt.KEY_PAUSE:
case evt.KEY_TAB:
case evt.KEY_BACKSPACE:
case evt.KEY_ENTER:
case evt.KEY_ESCAPE:
evt.key=evt.which;
break;
default:
var _452=evt.which;
if((evt.ctrlKey||evt.altKey||evt.metaKey)&&(evt.which>=65&&evt.which<=90&&evt.shiftKey==false)){
_452+=32;
}
evt.key=String.fromCharCode(_452);
}
}
}
}else{
if(dojo.render.html.ie){
if(!evt.ctrlKey&&!evt.altKey&&evt.keyCode>=evt.KEY_SPACE){
evt.key=String.fromCharCode(evt.keyCode);
}
}else{
if(dojo.render.html.safari){
switch(evt.keyCode){
case 25:
evt.key=evt.KEY_TAB;
evt.shift=true;
break;
case 63232:
evt.key=evt.KEY_UP_ARROW;
break;
case 63233:
evt.key=evt.KEY_DOWN_ARROW;
break;
case 63234:
evt.key=evt.KEY_LEFT_ARROW;
break;
case 63235:
evt.key=evt.KEY_RIGHT_ARROW;
break;
case 63236:
evt.key=evt.KEY_F1;
break;
case 63237:
evt.key=evt.KEY_F2;
break;
case 63238:
evt.key=evt.KEY_F3;
break;
case 63239:
evt.key=evt.KEY_F4;
break;
case 63240:
evt.key=evt.KEY_F5;
break;
case 63241:
evt.key=evt.KEY_F6;
break;
case 63242:
evt.key=evt.KEY_F7;
break;
case 63243:
evt.key=evt.KEY_F8;
break;
case 63244:
evt.key=evt.KEY_F9;
break;
case 63245:
evt.key=evt.KEY_F10;
break;
case 63246:
evt.key=evt.KEY_F11;
break;
case 63247:
evt.key=evt.KEY_F12;
break;
case 63250:
evt.key=evt.KEY_PAUSE;
break;
case 63272:
evt.key=evt.KEY_DELETE;
break;
case 63273:
evt.key=evt.KEY_HOME;
break;
case 63275:
evt.key=evt.KEY_END;
break;
case 63276:
evt.key=evt.KEY_PAGE_UP;
break;
case 63277:
evt.key=evt.KEY_PAGE_DOWN;
break;
case 63302:
evt.key=evt.KEY_INSERT;
break;
case 63248:
case 63249:
case 63289:
break;
default:
evt.key=evt.charCode>=evt.KEY_SPACE?String.fromCharCode(evt.charCode):evt.keyCode;
}
}else{
evt.key=evt.charCode>0?String.fromCharCode(evt.charCode):evt.keyCode;
}
}
}
}
}
}
if(dojo.render.html.ie){
if(!evt.target){
evt.target=evt.srcElement;
}
if(!evt.currentTarget){
evt.currentTarget=(_450?_450:evt.srcElement);
}
if(!evt.layerX){
evt.layerX=evt.offsetX;
}
if(!evt.layerY){
evt.layerY=evt.offsetY;
}
var doc=(evt.srcElement&&evt.srcElement.ownerDocument)?evt.srcElement.ownerDocument:document;
var _454=((dojo.render.html.ie55)||(doc["compatMode"]=="BackCompat"))?doc.body:doc.documentElement;
if(!evt.pageX){
evt.pageX=evt.clientX+(_454.scrollLeft||0);
}
if(!evt.pageY){
evt.pageY=evt.clientY+(_454.scrollTop||0);
}
if(evt.type=="mouseover"){
evt.relatedTarget=evt.fromElement;
}
if(evt.type=="mouseout"){
evt.relatedTarget=evt.toElement;
}
this.currentEvent=evt;
evt.callListener=this.callListener;
evt.stopPropagation=this._stopPropagation;
evt.preventDefault=this._preventDefault;
}
return evt;
};
this.stopEvent=function(evt){
if(window.event){
evt.cancelBubble=true;
evt.returnValue=false;
}else{
evt.preventDefault();
evt.stopPropagation();
}
};
};
dojo.kwCompoundRequire({common:["dojo.event.common","dojo.event.topic"],browser:["dojo.event.browser"],dashboard:["dojo.event.browser"]});
dojo.provide("dojo.event.*");
dojo.provide("dojo.widget.Manager");
dojo.widget.manager=new function(){
this.widgets=[];
this.widgetIds=[];
this.topWidgets={};
var _456={};
var _457=[];
this.getUniqueId=function(_458){
var _459;
do{
_459=_458+"_"+(_456[_458]!=undefined?++_456[_458]:_456[_458]=0);
}while(this.getWidgetById(_459));
return _459;
};
this.add=function(_45a){
this.widgets.push(_45a);
if(!_45a.extraArgs["id"]){
_45a.extraArgs["id"]=_45a.extraArgs["ID"];
}
if(_45a.widgetId==""){
if(_45a["id"]){
_45a.widgetId=_45a["id"];
}else{
if(_45a.extraArgs["id"]){
_45a.widgetId=_45a.extraArgs["id"];
}else{
_45a.widgetId=this.getUniqueId(_45a.ns+"_"+_45a.widgetType);
}
}
}
if(this.widgetIds[_45a.widgetId]){
dojo.debug("widget ID collision on ID: "+_45a.widgetId);
}
this.widgetIds[_45a.widgetId]=_45a;
};
this.destroyAll=function(){
for(var x=this.widgets.length-1;x>=0;x--){
try{
this.widgets[x].destroy(true);
delete this.widgets[x];
}
catch(e){
}
}
};
this.remove=function(_45c){
if(dojo.lang.isNumber(_45c)){
var tw=this.widgets[_45c].widgetId;
delete this.topWidgets[tw];
delete this.widgetIds[tw];
this.widgets.splice(_45c,1);
}else{
this.removeById(_45c);
}
};
this.removeById=function(id){
if(!dojo.lang.isString(id)){
id=id["widgetId"];
if(!id){
dojo.debug("invalid widget or id passed to removeById");
return;
}
}
for(var i=0;i<this.widgets.length;i++){
if(this.widgets[i].widgetId==id){
this.remove(i);
break;
}
}
};
this.getWidgetById=function(id){
if(dojo.lang.isString(id)){
return this.widgetIds[id];
}
return id;
};
this.getWidgetsByType=function(type){
var lt=type.toLowerCase();
var _463=(type.indexOf(":")<0?function(x){
return x.widgetType.toLowerCase();
}:function(x){
return x.getNamespacedType();
});
var ret=[];
dojo.lang.forEach(this.widgets,function(x){
if(_463(x)==lt){
ret.push(x);
}
});
return ret;
};
this.getWidgetsByFilter=function(_468,_469){
var ret=[];
dojo.lang.every(this.widgets,function(x){
if(_468(x)){
ret.push(x);
if(_469){
return false;
}
}
return true;
});
return (_469?ret[0]:ret);
};
this.getAllWidgets=function(){
return this.widgets.concat();
};
this.getWidgetByNode=function(node){
var w=this.getAllWidgets();
node=dojo.byId(node);
for(var i=0;i<w.length;i++){
if(w[i].domNode==node){
return w[i];
}
}
return null;
};
this.byId=this.getWidgetById;
this.byType=this.getWidgetsByType;
this.byFilter=this.getWidgetsByFilter;
this.byNode=this.getWidgetByNode;
var _46f={};
var _470=["dojo.widget"];
for(var i=0;i<_470.length;i++){
_470[_470[i]]=true;
}
this.registerWidgetPackage=function(_472){
if(!_470[_472]){
_470[_472]=true;
_470.push(_472);
}
};
this.getWidgetPackageList=function(){
return dojo.lang.map(_470,function(elt){
return (elt!==true?elt:undefined);
});
};
this.getImplementation=function(_474,_475,_476,ns){
var impl=this.getImplementationName(_474,ns);
if(impl){
var ret=_475?new impl(_475):new impl();
return ret;
}
};
function buildPrefixCache(){
for(var _47a in dojo.render){
if(dojo.render[_47a]["capable"]===true){
var _47b=dojo.render[_47a].prefixes;
for(var i=0;i<_47b.length;i++){
_457.push(_47b[i].toLowerCase());
}
}
}
}
var _47d=function(_47e,_47f){
if(!_47f){
return null;
}
for(var i=0,l=_457.length,_482;i<=l;i++){
_482=(i<l?_47f[_457[i]]:_47f);
if(!_482){
continue;
}
for(var name in _482){
if(name.toLowerCase()==_47e){
return _482[name];
}
}
}
return null;
};
var _484=function(_485,_486){
var _487=dojo.evalObjPath(_486,false);
return (_487?_47d(_485,_487):null);
};
this.getImplementationName=function(_488,ns){
var _48a=_488.toLowerCase();
ns=ns||"dojo";
var imps=_46f[ns]||(_46f[ns]={});
var impl=imps[_48a];
if(impl){
return impl;
}
if(!_457.length){
buildPrefixCache();
}
var _48d=dojo.ns.get(ns);
if(!_48d){
dojo.ns.register(ns,ns+".widget");
_48d=dojo.ns.get(ns);
}
if(_48d){
_48d.resolve(_488);
}
impl=_484(_48a,_48d.module);
if(impl){
return (imps[_48a]=impl);
}
_48d=dojo.ns.require(ns);
if((_48d)&&(_48d.resolver)){
_48d.resolve(_488);
impl=_484(_48a,_48d.module);
if(impl){
return (imps[_48a]=impl);
}
}
dojo.deprecated("dojo.widget.Manager.getImplementationName","Could not locate widget implementation for \""+_488+"\" in \""+_48d.module+"\" registered to namespace \""+_48d.name+"\". "+"Developers must specify correct namespaces for all non-Dojo widgets","0.5");
for(var i=0;i<_470.length;i++){
impl=_484(_48a,_470[i]);
if(impl){
return (imps[_48a]=impl);
}
}
throw new Error("Could not locate widget implementation for \""+_488+"\" in \""+_48d.module+"\" registered to namespace \""+_48d.name+"\"");
};
this.resizing=false;
this.onWindowResized=function(){
if(this.resizing){
return;
}
try{
this.resizing=true;
for(var id in this.topWidgets){
var _490=this.topWidgets[id];
if(_490.checkSize){
_490.checkSize();
}
}
}
catch(e){
}
finally{
this.resizing=false;
}
};
if(typeof window!="undefined"){
dojo.addOnLoad(this,"onWindowResized");
dojo.event.connect(window,"onresize",this,"onWindowResized");
}
};
(function(){
var dw=dojo.widget;
var dwm=dw.manager;
var h=dojo.lang.curry(dojo.lang,"hitch",dwm);
var g=function(_495,_496){
dw[(_496||_495)]=h(_495);
};
g("add","addWidget");
g("destroyAll","destroyAllWidgets");
g("remove","removeWidget");
g("removeById","removeWidgetById");
g("getWidgetById");
g("getWidgetById","byId");
g("getWidgetsByType");
g("getWidgetsByFilter");
g("getWidgetsByType","byType");
g("getWidgetsByFilter","byFilter");
g("getWidgetByNode","byNode");
dw.all=function(n){
var _498=dwm.getAllWidgets.apply(dwm,arguments);
if(arguments.length>0){
return _498[n];
}
return _498;
};
g("registerWidgetPackage");
g("getImplementation","getWidgetImplementation");
g("getImplementationName","getWidgetImplementationName");
dw.widgets=dwm.widgets;
dw.widgetIds=dwm.widgetIds;
dw.root=dwm.root;
})();
dojo.provide("dojo.uri.Uri");
dojo.uri=new function(){
this.dojoUri=function(uri){
return new dojo.uri.Uri(dojo.hostenv.getBaseScriptUri(),uri);
};
this.moduleUri=function(_49a,uri){
var loc=dojo.hostenv.getModuleSymbols(_49a).join("/");
if(!loc){
return null;
}
if(loc.lastIndexOf("/")!=loc.length-1){
loc+="/";
}
var _49d=loc.indexOf(":");
var _49e=loc.indexOf("/");
if(loc.charAt(0)!="/"&&(_49d==-1||_49d>_49e)){
loc=dojo.hostenv.getBaseScriptUri()+loc;
}
return new dojo.uri.Uri(loc,uri);
};
this.Uri=function(){
var uri=arguments[0];
for(var i=1;i<arguments.length;i++){
if(!arguments[i]){
continue;
}
var _4a1=new dojo.uri.Uri(arguments[i].toString());
var _4a2=new dojo.uri.Uri(uri.toString());
if((_4a1.path=="")&&(_4a1.scheme==null)&&(_4a1.authority==null)&&(_4a1.query==null)){
if(_4a1.fragment!=null){
_4a2.fragment=_4a1.fragment;
}
_4a1=_4a2;
}else{
if(_4a1.scheme==null){
_4a1.scheme=_4a2.scheme;
if(_4a1.authority==null){
_4a1.authority=_4a2.authority;
if(_4a1.path.charAt(0)!="/"){
var path=_4a2.path.substring(0,_4a2.path.lastIndexOf("/")+1)+_4a1.path;
var segs=path.split("/");
for(var j=0;j<segs.length;j++){
if(segs[j]=="."){
if(j==segs.length-1){
segs[j]="";
}else{
segs.splice(j,1);
j--;
}
}else{
if(j>0&&!(j==1&&segs[0]=="")&&segs[j]==".."&&segs[j-1]!=".."){
if(j==segs.length-1){
segs.splice(j,1);
segs[j-1]="";
}else{
segs.splice(j-1,2);
j-=2;
}
}
}
}
_4a1.path=segs.join("/");
}
}
}
}
uri="";
if(_4a1.scheme!=null){
uri+=_4a1.scheme+":";
}
if(_4a1.authority!=null){
uri+="//"+_4a1.authority;
}
uri+=_4a1.path;
if(_4a1.query!=null){
uri+="?"+_4a1.query;
}
if(_4a1.fragment!=null){
uri+="#"+_4a1.fragment;
}
}
this.uri=uri.toString();
var _4a6="^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?$";
var r=this.uri.match(new RegExp(_4a6));
this.scheme=r[2]||(r[1]?"":null);
this.authority=r[4]||(r[3]?"":null);
this.path=r[5];
this.query=r[7]||(r[6]?"":null);
this.fragment=r[9]||(r[8]?"":null);
if(this.authority!=null){
_4a6="^((([^:]+:)?([^@]+))@)?([^:]*)(:([0-9]+))?$";
r=this.authority.match(new RegExp(_4a6));
this.user=r[3]||null;
this.password=r[4]||null;
this.host=r[5];
this.port=r[7]||null;
}
this.toString=function(){
return this.uri;
};
};
};
dojo.kwCompoundRequire({common:[["dojo.uri.Uri",false,false]]});
dojo.provide("dojo.uri.*");
dojo.provide("dojo.html.common");
dojo.lang.mixin(dojo.html,dojo.dom);
dojo.html.body=function(){
dojo.deprecated("dojo.html.body() moved to dojo.body()","0.5");
return dojo.body();
};
dojo.html.getEventTarget=function(evt){
if(!evt){
evt=dojo.global().event||{};
}
var t=(evt.srcElement?evt.srcElement:(evt.target?evt.target:null));
while((t)&&(t.nodeType!=1)){
t=t.parentNode;
}
return t;
};
dojo.html.getViewport=function(){
var _4aa=dojo.global();
var _4ab=dojo.doc();
var w=0;
var h=0;
if(dojo.render.html.mozilla){
w=_4ab.documentElement.clientWidth;
h=_4aa.innerHeight;
}else{
if(!dojo.render.html.opera&&_4aa.innerWidth){
w=_4aa.innerWidth;
h=_4aa.innerHeight;
}else{
if(!dojo.render.html.opera&&dojo.exists(_4ab,"documentElement.clientWidth")){
var w2=_4ab.documentElement.clientWidth;
if(!w||w2&&w2<w){
w=w2;
}
h=_4ab.documentElement.clientHeight;
}else{
if(dojo.body().clientWidth){
w=dojo.body().clientWidth;
h=dojo.body().clientHeight;
}
}
}
}
return {width:w,height:h};
};
dojo.html.getScroll=function(){
var _4af=dojo.global();
var _4b0=dojo.doc();
var top=_4af.pageYOffset||_4b0.documentElement.scrollTop||dojo.body().scrollTop||0;
var left=_4af.pageXOffset||_4b0.documentElement.scrollLeft||dojo.body().scrollLeft||0;
return {top:top,left:left,offset:{x:left,y:top}};
};
dojo.html.getParentByType=function(node,type){
var _4b5=dojo.doc();
var _4b6=dojo.byId(node);
type=type.toLowerCase();
while((_4b6)&&(_4b6.nodeName.toLowerCase()!=type)){
if(_4b6==(_4b5["body"]||_4b5["documentElement"])){
return null;
}
_4b6=_4b6.parentNode;
}
return _4b6;
};
dojo.html.getAttribute=function(node,attr){
node=dojo.byId(node);
if((!node)||(!node.getAttribute)){
return null;
}
var ta=typeof attr=="string"?attr:new String(attr);
var v=node.getAttribute(ta.toUpperCase());
if((v)&&(typeof v=="string")&&(v!="")){
return v;
}
if(v&&v.value){
return v.value;
}
if((node.getAttributeNode)&&(node.getAttributeNode(ta))){
return (node.getAttributeNode(ta)).value;
}else{
if(node.getAttribute(ta)){
return node.getAttribute(ta);
}else{
if(node.getAttribute(ta.toLowerCase())){
return node.getAttribute(ta.toLowerCase());
}
}
}
return null;
};
dojo.html.hasAttribute=function(node,attr){
return dojo.html.getAttribute(dojo.byId(node),attr)?true:false;
};
dojo.html.getCursorPosition=function(e){
e=e||dojo.global().event;
var _4be={x:0,y:0};
if(e.pageX||e.pageY){
_4be.x=e.pageX;
_4be.y=e.pageY;
}else{
var de=dojo.doc().documentElement;
var db=dojo.body();
_4be.x=e.clientX+((de||db)["scrollLeft"])-((de||db)["clientLeft"]);
_4be.y=e.clientY+((de||db)["scrollTop"])-((de||db)["clientTop"]);
}
return _4be;
};
dojo.html.isTag=function(node){
node=dojo.byId(node);
if(node&&node.tagName){
for(var i=1;i<arguments.length;i++){
if(node.tagName.toLowerCase()==String(arguments[i]).toLowerCase()){
return String(arguments[i]).toLowerCase();
}
}
}
return "";
};
if(dojo.render.html.ie&&!dojo.render.html.ie70){
if(window.location.href.substr(0,6).toLowerCase()!="https:"){
(function(){
var _4c3=dojo.doc().createElement("script");
_4c3.src="javascript:'dojo.html.createExternalElement=function(doc, tag){ return doc.createElement(tag); }'";
dojo.doc().getElementsByTagName("head")[0].appendChild(_4c3);
})();
}
}else{
dojo.html.createExternalElement=function(doc,tag){
return doc.createElement(tag);
};
}
dojo.html._callDeprecated=function(_4c6,_4c7,args,_4c9,_4ca){
dojo.deprecated("dojo.html."+_4c6,"replaced by dojo.html."+_4c7+"("+(_4c9?"node, {"+_4c9+": "+_4c9+"}":"")+")"+(_4ca?"."+_4ca:""),"0.5");
var _4cb=[];
if(_4c9){
var _4cc={};
_4cc[_4c9]=args[1];
_4cb.push(args[0]);
_4cb.push(_4cc);
}else{
_4cb=args;
}
var ret=dojo.html[_4c7].apply(dojo.html,args);
if(_4ca){
return ret[_4ca];
}else{
return ret;
}
};
dojo.html.getViewportWidth=function(){
return dojo.html._callDeprecated("getViewportWidth","getViewport",arguments,null,"width");
};
dojo.html.getViewportHeight=function(){
return dojo.html._callDeprecated("getViewportHeight","getViewport",arguments,null,"height");
};
dojo.html.getViewportSize=function(){
return dojo.html._callDeprecated("getViewportSize","getViewport",arguments);
};
dojo.html.getScrollTop=function(){
return dojo.html._callDeprecated("getScrollTop","getScroll",arguments,null,"top");
};
dojo.html.getScrollLeft=function(){
return dojo.html._callDeprecated("getScrollLeft","getScroll",arguments,null,"left");
};
dojo.html.getScrollOffset=function(){
return dojo.html._callDeprecated("getScrollOffset","getScroll",arguments,null,"offset");
};
dojo.provide("dojo.a11y");
dojo.a11y={imgPath:dojo.uri.moduleUri("dojo.widget","templates/images"),doAccessibleCheck:true,accessible:null,checkAccessible:function(){
if(this.accessible===null){
this.accessible=false;
if(this.doAccessibleCheck==true){
this.accessible=this.testAccessible();
}
}
return this.accessible;
},testAccessible:function(){
this.accessible=false;
if(dojo.render.html.ie||dojo.render.html.mozilla){
var div=document.createElement("div");
div.style.backgroundImage="url(\""+this.imgPath+"/tab_close.gif\")";
dojo.body().appendChild(div);
var _4cf=null;
if(window.getComputedStyle){
var _4d0=getComputedStyle(div,"");
_4cf=_4d0.getPropertyValue("background-image");
}else{
_4cf=div.currentStyle.backgroundImage;
}
var _4d1=false;
if(_4cf!=null&&(_4cf=="none"||_4cf=="url(invalid-url:)")){
this.accessible=true;
}
dojo.body().removeChild(div);
}
return this.accessible;
},setCheckAccessible:function(_4d2){
this.doAccessibleCheck=_4d2;
},setAccessibleMode:function(){
if(this.accessible===null){
if(this.checkAccessible()){
dojo.render.html.prefixes.unshift("a11y");
}
}
return this.accessible;
}};
dojo.provide("dojo.widget.Widget");
dojo.declare("dojo.widget.Widget",null,function(){
this.children=[];
this.extraArgs={};
},{parent:null,isTopLevel:false,disabled:false,isContainer:false,widgetId:"",widgetType:"Widget",ns:"dojo",getNamespacedType:function(){
return (this.ns?this.ns+":"+this.widgetType:this.widgetType).toLowerCase();
},toString:function(){
return "[Widget "+this.getNamespacedType()+", "+(this.widgetId||"NO ID")+"]";
},repr:function(){
return this.toString();
},enable:function(){
this.disabled=false;
},disable:function(){
this.disabled=true;
},onResized:function(){
this.notifyChildrenOfResize();
},notifyChildrenOfResize:function(){
for(var i=0;i<this.children.length;i++){
var _4d4=this.children[i];
if(_4d4.onResized){
_4d4.onResized();
}
}
},create:function(args,_4d6,_4d7,ns){
if(ns){
this.ns=ns;
}
this.satisfyPropertySets(args,_4d6,_4d7);
this.mixInProperties(args,_4d6,_4d7);
this.postMixInProperties(args,_4d6,_4d7);
dojo.widget.manager.add(this);
this.buildRendering(args,_4d6,_4d7);
this.initialize(args,_4d6,_4d7);
this.postInitialize(args,_4d6,_4d7);
this.postCreate(args,_4d6,_4d7);
return this;
},destroy:function(_4d9){
if(this.parent){
this.parent.removeChild(this);
}
this.destroyChildren();
this.uninitialize();
this.destroyRendering(_4d9);
dojo.widget.manager.removeById(this.widgetId);
},destroyChildren:function(){
var _4da;
var i=0;
while(this.children.length>i){
_4da=this.children[i];
if(_4da instanceof dojo.widget.Widget){
this.removeChild(_4da);
_4da.destroy();
continue;
}
i++;
}
},getChildrenOfType:function(type,_4dd){
var ret=[];
var _4df=dojo.lang.isFunction(type);
if(!_4df){
type=type.toLowerCase();
}
for(var x=0;x<this.children.length;x++){
if(_4df){
if(this.children[x] instanceof type){
ret.push(this.children[x]);
}
}else{
if(this.children[x].widgetType.toLowerCase()==type){
ret.push(this.children[x]);
}
}
if(_4dd){
ret=ret.concat(this.children[x].getChildrenOfType(type,_4dd));
}
}
return ret;
},getDescendants:function(){
var _4e1=[];
var _4e2=[this];
var elem;
while((elem=_4e2.pop())){
_4e1.push(elem);
if(elem.children){
dojo.lang.forEach(elem.children,function(elem){
_4e2.push(elem);
});
}
}
return _4e1;
},isFirstChild:function(){
return this===this.parent.children[0];
},isLastChild:function(){
return this===this.parent.children[this.parent.children.length-1];
},satisfyPropertySets:function(args){
return args;
},mixInProperties:function(args,frag){
if((args["fastMixIn"])||(frag["fastMixIn"])){
for(var x in args){
this[x]=args[x];
}
return;
}
var _4e9;
var _4ea=dojo.widget.lcArgsCache[this.widgetType];
if(_4ea==null){
_4ea={};
for(var y in this){
_4ea[((new String(y)).toLowerCase())]=y;
}
dojo.widget.lcArgsCache[this.widgetType]=_4ea;
}
var _4ec={};
for(var x in args){
if(!this[x]){
var y=_4ea[(new String(x)).toLowerCase()];
if(y){
args[y]=args[x];
x=y;
}
}
if(_4ec[x]){
continue;
}
_4ec[x]=true;
if((typeof this[x])!=(typeof _4e9)){
if(typeof args[x]!="string"){
this[x]=args[x];
}else{
if(dojo.lang.isString(this[x])){
this[x]=args[x];
}else{
if(dojo.lang.isNumber(this[x])){
this[x]=new Number(args[x]);
}else{
if(dojo.lang.isBoolean(this[x])){
this[x]=(args[x].toLowerCase()=="false")?false:true;
}else{
if(dojo.lang.isFunction(this[x])){
if(args[x].search(/[^\w\.]+/i)==-1){
this[x]=dojo.evalObjPath(args[x],false);
}else{
var tn=dojo.lang.nameAnonFunc(new Function(args[x]),this);
dojo.event.kwConnect({srcObj:this,srcFunc:x,adviceObj:this,adviceFunc:tn});
}
}else{
if(dojo.lang.isArray(this[x])){
this[x]=args[x].split(";");
}else{
if(this[x] instanceof Date){
this[x]=new Date(Number(args[x]));
}else{
if(typeof this[x]=="object"){
if(this[x] instanceof dojo.uri.Uri){
this[x]=dojo.uri.dojoUri(args[x]);
}else{
var _4ee=args[x].split(";");
for(var y=0;y<_4ee.length;y++){
var si=_4ee[y].indexOf(":");
if((si!=-1)&&(_4ee[y].length>si)){
this[x][_4ee[y].substr(0,si).replace(/^\s+|\s+$/g,"")]=_4ee[y].substr(si+1);
}
}
}
}else{
this[x]=args[x];
}
}
}
}
}
}
}
}
}else{
this.extraArgs[x.toLowerCase()]=args[x];
}
}
},postMixInProperties:function(args,frag,_4f2){
},initialize:function(args,frag,_4f5){
return false;
},postInitialize:function(args,frag,_4f8){
return false;
},postCreate:function(args,frag,_4fb){
return false;
},uninitialize:function(){
return false;
},buildRendering:function(args,frag,_4fe){
dojo.unimplemented("dojo.widget.Widget.buildRendering, on "+this.toString()+", ");
return false;
},destroyRendering:function(){
dojo.unimplemented("dojo.widget.Widget.destroyRendering");
return false;
},addedTo:function(_4ff){
},addChild:function(_500){
dojo.unimplemented("dojo.widget.Widget.addChild");
return false;
},removeChild:function(_501){
for(var x=0;x<this.children.length;x++){
if(this.children[x]===_501){
this.children.splice(x,1);
_501.parent=null;
break;
}
}
return _501;
},getPreviousSibling:function(){
var idx=this.getParentIndex();
if(idx<=0){
return null;
}
return this.parent.children[idx-1];
},getSiblings:function(){
return this.parent.children;
},getParentIndex:function(){
return dojo.lang.indexOf(this.parent.children,this,true);
},getNextSibling:function(){
var idx=this.getParentIndex();
if(idx==this.parent.children.length-1){
return null;
}
if(idx<0){
return null;
}
return this.parent.children[idx+1];
}});
dojo.widget.lcArgsCache={};
dojo.widget.tags={};
dojo.widget.tags.addParseTreeHandler=function(type){
dojo.deprecated("addParseTreeHandler",". ParseTreeHandlers are now reserved for components. Any unfiltered DojoML tag without a ParseTreeHandler is assumed to be a widget","0.5");
};
dojo.widget.tags["dojo:propertyset"]=function(_506,_507,_508){
var _509=_507.parseProperties(_506["dojo:propertyset"]);
};
dojo.widget.tags["dojo:connect"]=function(_50a,_50b,_50c){
var _50d=_50b.parseProperties(_50a["dojo:connect"]);
};
dojo.widget.buildWidgetFromParseTree=function(type,frag,_510,_511,_512,_513){
dojo.a11y.setAccessibleMode();
var _514=type.split(":");
_514=(_514.length==2)?_514[1]:type;
var _515=_513||_510.parseProperties(frag[frag["ns"]+":"+_514]);
var _516=dojo.widget.manager.getImplementation(_514,null,null,frag["ns"]);
if(!_516){
throw new Error("cannot find \""+type+"\" widget");
}else{
if(!_516.create){
throw new Error("\""+type+"\" widget object has no \"create\" method and does not appear to implement *Widget");
}
}
_515["dojoinsertionindex"]=_512;
var ret=_516.create(_515,frag,_511,frag["ns"]);
return ret;
};
dojo.widget.defineWidget=function(_518,_519,_51a,init,_51c){
if(dojo.lang.isString(arguments[3])){
dojo.widget._defineWidget(arguments[0],arguments[3],arguments[1],arguments[4],arguments[2]);
}else{
var args=[arguments[0]],p=3;
if(dojo.lang.isString(arguments[1])){
args.push(arguments[1],arguments[2]);
}else{
args.push("",arguments[1]);
p=2;
}
if(dojo.lang.isFunction(arguments[p])){
args.push(arguments[p],arguments[p+1]);
}else{
args.push(null,arguments[p]);
}
dojo.widget._defineWidget.apply(this,args);
}
};
dojo.widget.defineWidget.renderers="html|svg|vml";
dojo.widget._defineWidget=function(_51f,_520,_521,init,_523){
var _524=_51f.split(".");
var type=_524.pop();
var regx="\\.("+(_520?_520+"|":"")+dojo.widget.defineWidget.renderers+")\\.";
var r=_51f.search(new RegExp(regx));
_524=(r<0?_524.join("."):_51f.substr(0,r));
dojo.widget.manager.registerWidgetPackage(_524);
var pos=_524.indexOf(".");
var _529=(pos>-1)?_524.substring(0,pos):_524;
_523=(_523)||{};
_523.widgetType=type;
if((!init)&&(_523["classConstructor"])){
init=_523.classConstructor;
delete _523.classConstructor;
}
dojo.declare(_51f,_521,init,_523);
};
dojo.provide("dojo.widget.Parse");
dojo.widget.Parse=function(_52a){
this.propertySetsList=[];
this.fragment=_52a;
this.createComponents=function(frag,_52c){
var _52d=[];
var _52e=false;
try{
if(frag&&frag.tagName&&(frag!=frag.nodeRef)){
var _52f=dojo.widget.tags;
var tna=String(frag.tagName).split(";");
for(var x=0;x<tna.length;x++){
var ltn=tna[x].replace(/^\s+|\s+$/g,"").toLowerCase();
frag.tagName=ltn;
var ret;
if(_52f[ltn]){
_52e=true;
ret=_52f[ltn](frag,this,_52c,frag.index);
_52d.push(ret);
}else{
if(ltn.indexOf(":")==-1){
ltn="dojo:"+ltn;
}
ret=dojo.widget.buildWidgetFromParseTree(ltn,frag,this,_52c,frag.index);
if(ret){
_52e=true;
_52d.push(ret);
}
}
}
}
}
catch(e){
dojo.debug("dojo.widget.Parse: error:",e);
}
if(!_52e){
_52d=_52d.concat(this.createSubComponents(frag,_52c));
}
return _52d;
};
this.createSubComponents=function(_534,_535){
var frag,_537=[];
for(var item in _534){
frag=_534[item];
if(frag&&typeof frag=="object"&&(frag!=_534.nodeRef)&&(frag!=_534.tagName)&&(!dojo.dom.isNode(frag))){
_537=_537.concat(this.createComponents(frag,_535));
}
}
return _537;
};
this.parsePropertySets=function(_539){
return [];
};
this.parseProperties=function(_53a){
var _53b={};
for(var item in _53a){
if((_53a[item]==_53a.tagName)||(_53a[item]==_53a.nodeRef)){
}else{
var frag=_53a[item];
if(frag.tagName&&dojo.widget.tags[frag.tagName.toLowerCase()]){
}else{
if(frag[0]&&frag[0].value!=""&&frag[0].value!=null){
try{
if(item.toLowerCase()=="dataprovider"){
var _53e=this;
this.getDataProvider(_53e,frag[0].value);
_53b.dataProvider=this.dataProvider;
}
_53b[item]=frag[0].value;
var _53f=this.parseProperties(frag);
for(var _540 in _53f){
_53b[_540]=_53f[_540];
}
}
catch(e){
dojo.debug(e);
}
}
}
switch(item.toLowerCase()){
case "checked":
case "disabled":
if(typeof _53b[item]!="boolean"){
_53b[item]=true;
}
break;
}
}
}
return _53b;
};
this.getDataProvider=function(_541,_542){
dojo.io.bind({url:_542,load:function(type,_544){
if(type=="load"){
_541.dataProvider=_544;
}
},mimetype:"text/javascript",sync:true});
};
this.getPropertySetById=function(_545){
for(var x=0;x<this.propertySetsList.length;x++){
if(_545==this.propertySetsList[x]["id"][0].value){
return this.propertySetsList[x];
}
}
return "";
};
this.getPropertySetsByType=function(_547){
var _548=[];
for(var x=0;x<this.propertySetsList.length;x++){
var cpl=this.propertySetsList[x];
var cpcc=cpl.componentClass||cpl.componentType||null;
var _54c=this.propertySetsList[x]["id"][0].value;
if(cpcc&&(_54c==cpcc[0].value)){
_548.push(cpl);
}
}
return _548;
};
this.getPropertySets=function(_54d){
var ppl="dojo:propertyproviderlist";
var _54f=[];
var _550=_54d.tagName;
if(_54d[ppl]){
var _551=_54d[ppl].value.split(" ");
for(var _552 in _551){
if((_552.indexOf("..")==-1)&&(_552.indexOf("://")==-1)){
var _553=this.getPropertySetById(_552);
if(_553!=""){
_54f.push(_553);
}
}else{
}
}
}
return this.getPropertySetsByType(_550).concat(_54f);
};
this.createComponentFromScript=function(_554,_555,_556,ns){
_556.fastMixIn=true;
var ltn=(ns||"dojo")+":"+_555.toLowerCase();
if(dojo.widget.tags[ltn]){
return [dojo.widget.tags[ltn](_556,this,null,null,_556)];
}
return [dojo.widget.buildWidgetFromParseTree(ltn,_556,this,null,null,_556)];
};
};
dojo.widget._parser_collection={"dojo":new dojo.widget.Parse()};
dojo.widget.getParser=function(name){
if(!name){
name="dojo";
}
if(!this._parser_collection[name]){
this._parser_collection[name]=new dojo.widget.Parse();
}
return this._parser_collection[name];
};
dojo.widget.createWidget=function(name,_55b,_55c,_55d){
var _55e=false;
var _55f=(typeof name=="string");
if(_55f){
var pos=name.indexOf(":");
var ns=(pos>-1)?name.substring(0,pos):"dojo";
if(pos>-1){
name=name.substring(pos+1);
}
var _562=name.toLowerCase();
var _563=ns+":"+_562;
_55e=(dojo.byId(name)&&!dojo.widget.tags[_563]);
}
if((arguments.length==1)&&(_55e||!_55f)){
var xp=new dojo.xml.Parse();
var tn=_55e?dojo.byId(name):name;
return dojo.widget.getParser().createComponents(xp.parseElement(tn,null,true))[0];
}
function fromScript(_566,name,_568,ns){
_568[_563]={dojotype:[{value:_562}],nodeRef:_566,fastMixIn:true};
_568.ns=ns;
return dojo.widget.getParser().createComponentFromScript(_566,name,_568,ns);
}
_55b=_55b||{};
var _56a=false;
var tn=null;
var h=dojo.render.html.capable;
if(h){
tn=document.createElement("span");
}
if(!_55c){
_56a=true;
_55c=tn;
if(h){
dojo.body().appendChild(_55c);
}
}else{
if(_55d){
dojo.dom.insertAtPosition(tn,_55c,_55d);
}else{
tn=_55c;
}
}
var _56c=fromScript(tn,name.toLowerCase(),_55b,ns);
if((!_56c)||(!_56c[0])||(typeof _56c[0].widgetType=="undefined")){
throw new Error("createWidget: Creation of \""+name+"\" widget failed.");
}
try{
if(_56a&&_56c[0].domNode.parentNode){
_56c[0].domNode.parentNode.removeChild(_56c[0].domNode);
}
}
catch(e){
dojo.debug(e);
}
return _56c[0];
};
dojo.provide("dojo.html.style");
dojo.html.getClass=function(node){
node=dojo.byId(node);
if(!node){
return "";
}
var cs="";
if(node.className){
cs=node.className;
}else{
if(dojo.html.hasAttribute(node,"class")){
cs=dojo.html.getAttribute(node,"class");
}
}
return cs.replace(/^\s+|\s+$/g,"");
};
dojo.html.getClasses=function(node){
var c=dojo.html.getClass(node);
return (c=="")?[]:c.split(/\s+/g);
};
dojo.html.hasClass=function(node,_572){
return (new RegExp("(^|\\s+)"+_572+"(\\s+|$)")).test(dojo.html.getClass(node));
};
dojo.html.prependClass=function(node,_574){
_574+=" "+dojo.html.getClass(node);
return dojo.html.setClass(node,_574);
};
dojo.html.addClass=function(node,_576){
if(dojo.html.hasClass(node,_576)){
return false;
}
_576=(dojo.html.getClass(node)+" "+_576).replace(/^\s+|\s+$/g,"");
return dojo.html.setClass(node,_576);
};
dojo.html.setClass=function(node,_578){
node=dojo.byId(node);
var cs=new String(_578);
try{
if(typeof node.className=="string"){
node.className=cs;
}else{
if(node.setAttribute){
node.setAttribute("class",_578);
node.className=cs;
}else{
return false;
}
}
}
catch(e){
dojo.debug("dojo.html.setClass() failed",e);
}
return true;
};
dojo.html.removeClass=function(node,_57b,_57c){
try{
if(!_57c){
var _57d=dojo.html.getClass(node).replace(new RegExp("(^|\\s+)"+_57b+"(\\s+|$)"),"$1$2");
}else{
var _57d=dojo.html.getClass(node).replace(_57b,"");
}
dojo.html.setClass(node,_57d);
}
catch(e){
dojo.debug("dojo.html.removeClass() failed",e);
}
return true;
};
dojo.html.replaceClass=function(node,_57f,_580){
dojo.html.removeClass(node,_580);
dojo.html.addClass(node,_57f);
};
dojo.html.classMatchType={ContainsAll:0,ContainsAny:1,IsOnly:2};
dojo.html.getElementsByClass=function(_581,_582,_583,_584,_585){
_585=false;
var _586=dojo.doc();
_582=dojo.byId(_582)||_586;
var _587=_581.split(/\s+/g);
var _588=[];
if(_584!=1&&_584!=2){
_584=0;
}
var _589=new RegExp("(\\s|^)(("+_587.join(")|(")+"))(\\s|$)");
var _58a=_587.join(" ").length;
var _58b=[];
if(!_585&&_586.evaluate){
var _58c=".//"+(_583||"*")+"[contains(";
if(_584!=dojo.html.classMatchType.ContainsAny){
_58c+="concat(' ',@class,' '), ' "+_587.join(" ') and contains(concat(' ',@class,' '), ' ")+" ')";
if(_584==2){
_58c+=" and string-length(@class)="+_58a+"]";
}else{
_58c+="]";
}
}else{
_58c+="concat(' ',@class,' '), ' "+_587.join(" ') or contains(concat(' ',@class,' '), ' ")+" ')]";
}
var _58d=_586.evaluate(_58c,_582,null,XPathResult.ANY_TYPE,null);
var _58e=_58d.iterateNext();
while(_58e){
try{
_58b.push(_58e);
_58e=_58d.iterateNext();
}
catch(e){
break;
}
}
return _58b;
}else{
if(!_583){
_583="*";
}
_58b=_582.getElementsByTagName(_583);
var node,i=0;
outer:
while(node=_58b[i++]){
var _591=dojo.html.getClasses(node);
if(_591.length==0){
continue outer;
}
var _592=0;
for(var j=0;j<_591.length;j++){
if(_589.test(_591[j])){
if(_584==dojo.html.classMatchType.ContainsAny){
_588.push(node);
continue outer;
}else{
_592++;
}
}else{
if(_584==dojo.html.classMatchType.IsOnly){
continue outer;
}
}
}
if(_592==_587.length){
if((_584==dojo.html.classMatchType.IsOnly)&&(_592==_591.length)){
_588.push(node);
}else{
if(_584==dojo.html.classMatchType.ContainsAll){
_588.push(node);
}
}
}
}
return _588;
}
};
dojo.html.getElementsByClassName=dojo.html.getElementsByClass;
dojo.html.toCamelCase=function(_594){
var arr=_594.split("-"),cc=arr[0];
for(var i=1;i<arr.length;i++){
cc+=arr[i].charAt(0).toUpperCase()+arr[i].substring(1);
}
return cc;
};
dojo.html.toSelectorCase=function(_598){
return _598.replace(/([A-Z])/g,"-$1").toLowerCase();
};
if(dojo.render.html.ie){
dojo.html.getComputedStyle=function(node,_59a,_59b){
node=dojo.byId(node);
if(!node||!node.currentStyle){
return _59b;
}
return node.currentStyle[dojo.html.toCamelCase(_59a)];
};
dojo.html.getComputedStyles=function(node){
return node.currentStyle;
};
}else{
dojo.html.getComputedStyle=function(node,_59e,_59f){
node=dojo.byId(node);
if(!node||!node.style){
return _59f;
}
var s=document.defaultView.getComputedStyle(node,null);
return (s&&s[dojo.html.toCamelCase(_59e)])||"";
};
dojo.html.getComputedStyles=function(node){
return document.defaultView.getComputedStyle(node,null);
};
}
dojo.html.getStyleProperty=function(node,_5a3){
node=dojo.byId(node);
return (node&&node.style?node.style[dojo.html.toCamelCase(_5a3)]:undefined);
};
dojo.html.getStyle=function(node,_5a5){
var _5a6=dojo.html.getStyleProperty(node,_5a5);
return (_5a6?_5a6:dojo.html.getComputedStyle(node,_5a5));
};
dojo.html.setStyle=function(node,_5a8,_5a9){
node=dojo.byId(node);
if(node&&node.style){
var _5aa=dojo.html.toCamelCase(_5a8);
node.style[_5aa]=_5a9;
}
};
dojo.html.setStyleText=function(_5ab,text){
try{
_5ab.style.cssText=text;
}
catch(e){
_5ab.setAttribute("style",text);
}
};
dojo.html.copyStyle=function(_5ad,_5ae){
if(!_5ae.style.cssText){
_5ad.setAttribute("style",_5ae.getAttribute("style"));
}else{
_5ad.style.cssText=_5ae.style.cssText;
}
dojo.html.addClass(_5ad,dojo.html.getClass(_5ae));
};
dojo.html.getUnitValue=function(node,_5b0,_5b1){
var s=dojo.html.getComputedStyle(node,_5b0);
if((!s)||((s=="auto")&&(_5b1))){
return {value:0,units:"px"};
}
var _5b3=s.match(/(\-?[\d.]+)([a-z%]*)/i);
if(!_5b3){
return dojo.html.getUnitValue.bad;
}
return {value:Number(_5b3[1]),units:_5b3[2].toLowerCase()};
};
dojo.html.getUnitValue.bad={value:NaN,units:""};
if(dojo.render.html.ie){
dojo.html.toPixelValue=function(_5b4,_5b5){
if(!_5b5){
return 0;
}
if(_5b5.slice(-2)=="px"){
return parseFloat(_5b5);
}
var _5b6=0;
with(_5b4){
var _5b7=style.left;
var _5b8=runtimeStyle.left;
runtimeStyle.left=currentStyle.left;
try{
style.left=_5b5||0;
_5b6=style.pixelLeft;
style.left=_5b7;
runtimeStyle.left=_5b8;
}
catch(e){
}
}
return _5b6;
};
}else{
dojo.html.toPixelValue=function(_5b9,_5ba){
return (_5ba&&(_5ba.slice(-2)=="px")?parseFloat(_5ba):0);
};
}
dojo.html.getPixelValue=function(node,_5bc,_5bd){
return dojo.html.toPixelValue(node,dojo.html.getComputedStyle(node,_5bc));
};
dojo.html.setPositivePixelValue=function(node,_5bf,_5c0){
if(isNaN(_5c0)){
return false;
}
node.style[_5bf]=Math.max(0,_5c0)+"px";
return true;
};
dojo.html.styleSheet=null;
dojo.html.insertCssRule=function(_5c1,_5c2,_5c3){
if(!dojo.html.styleSheet){
if(document.createStyleSheet){
dojo.html.styleSheet=document.createStyleSheet();
}else{
if(document.styleSheets[0]){
dojo.html.styleSheet=document.styleSheets[0];
}else{
return null;
}
}
}
if(arguments.length<3){
if(dojo.html.styleSheet.cssRules){
_5c3=dojo.html.styleSheet.cssRules.length;
}else{
if(dojo.html.styleSheet.rules){
_5c3=dojo.html.styleSheet.rules.length;
}else{
return null;
}
}
}
if(dojo.html.styleSheet.insertRule){
var rule=_5c1+" { "+_5c2+" }";
return dojo.html.styleSheet.insertRule(rule,_5c3);
}else{
if(dojo.html.styleSheet.addRule){
return dojo.html.styleSheet.addRule(_5c1,_5c2,_5c3);
}else{
return null;
}
}
};
dojo.html.removeCssRule=function(_5c5){
if(!dojo.html.styleSheet){
dojo.debug("no stylesheet defined for removing rules");
return false;
}
if(dojo.render.html.ie){
if(!_5c5){
_5c5=dojo.html.styleSheet.rules.length;
dojo.html.styleSheet.removeRule(_5c5);
}
}else{
if(document.styleSheets[0]){
if(!_5c5){
_5c5=dojo.html.styleSheet.cssRules.length;
}
dojo.html.styleSheet.deleteRule(_5c5);
}
}
return true;
};
dojo.html._insertedCssFiles=[];
dojo.html.insertCssFile=function(URI,doc,_5c8,_5c9){
if(!URI){
return;
}
if(!doc){
doc=document;
}
var _5ca=dojo.hostenv.getText(URI,false,_5c9);
if(_5ca===null){
return;
}
_5ca=dojo.html.fixPathsInCssText(_5ca,URI);
if(_5c8){
var idx=-1,node,ent=dojo.html._insertedCssFiles;
for(var i=0;i<ent.length;i++){
if((ent[i].doc==doc)&&(ent[i].cssText==_5ca)){
idx=i;
node=ent[i].nodeRef;
break;
}
}
if(node){
var _5cf=doc.getElementsByTagName("style");
for(var i=0;i<_5cf.length;i++){
if(_5cf[i]==node){
return;
}
}
dojo.html._insertedCssFiles.shift(idx,1);
}
}
var _5d0=dojo.html.insertCssText(_5ca,doc);
dojo.html._insertedCssFiles.push({"doc":doc,"cssText":_5ca,"nodeRef":_5d0});
if(_5d0&&djConfig.isDebug){
_5d0.setAttribute("dbgHref",URI);
}
return _5d0;
};
dojo.html.insertCssText=function(_5d1,doc,URI){
if(!_5d1){
return;
}
if(!doc){
doc=document;
}
if(URI){
_5d1=dojo.html.fixPathsInCssText(_5d1,URI);
}
var _5d4=doc.createElement("style");
_5d4.setAttribute("type","text/css");
var head=doc.getElementsByTagName("head")[0];
if(!head){
dojo.debug("No head tag in document, aborting styles");
return;
}else{
head.appendChild(_5d4);
}
if(_5d4.styleSheet){
var _5d6=function(){
try{
_5d4.styleSheet.cssText=_5d1;
}
catch(e){
dojo.debug(e);
}
};
if(_5d4.styleSheet.disabled){
setTimeout(_5d6,10);
}else{
_5d6();
}
}else{
var _5d7=doc.createTextNode(_5d1);
_5d4.appendChild(_5d7);
}
return _5d4;
};
dojo.html.fixPathsInCssText=function(_5d8,URI){
if(!_5d8||!URI){
return;
}
var _5da,str="",url="",_5dd="[\\t\\s\\w\\(\\)\\/\\.\\\\'\"-:#=&?~]+";
var _5de=new RegExp("url\\(\\s*("+_5dd+")\\s*\\)");
var _5df=/(file|https?|ftps?):\/\//;
regexTrim=new RegExp("^[\\s]*(['\"]?)("+_5dd+")\\1[\\s]*?$");
if(dojo.render.html.ie55||dojo.render.html.ie60){
var _5e0=new RegExp("AlphaImageLoader\\((.*)src=['\"]("+_5dd+")['\"]");
while(_5da=_5e0.exec(_5d8)){
url=_5da[2].replace(regexTrim,"$2");
if(!_5df.exec(url)){
url=(new dojo.uri.Uri(URI,url).toString());
}
str+=_5d8.substring(0,_5da.index)+"AlphaImageLoader("+_5da[1]+"src='"+url+"'";
_5d8=_5d8.substr(_5da.index+_5da[0].length);
}
_5d8=str+_5d8;
str="";
}
while(_5da=_5de.exec(_5d8)){
url=_5da[1].replace(regexTrim,"$2");
if(!_5df.exec(url)){
url=(new dojo.uri.Uri(URI,url).toString());
}
str+=_5d8.substring(0,_5da.index)+"url("+url+")";
_5d8=_5d8.substr(_5da.index+_5da[0].length);
}
return str+_5d8;
};
dojo.html.setActiveStyleSheet=function(_5e1){
var i=0,a,els=dojo.doc().getElementsByTagName("link");
while(a=els[i++]){
if(a.getAttribute("rel").indexOf("style")!=-1&&a.getAttribute("title")){
a.disabled=true;
if(a.getAttribute("title")==_5e1){
a.disabled=false;
}
}
}
};
dojo.html.getActiveStyleSheet=function(){
var i=0,a,els=dojo.doc().getElementsByTagName("link");
while(a=els[i++]){
if(a.getAttribute("rel").indexOf("style")!=-1&&a.getAttribute("title")&&!a.disabled){
return a.getAttribute("title");
}
}
return null;
};
dojo.html.getPreferredStyleSheet=function(){
var i=0,a,els=dojo.doc().getElementsByTagName("link");
while(a=els[i++]){
if(a.getAttribute("rel").indexOf("style")!=-1&&a.getAttribute("rel").indexOf("alt")==-1&&a.getAttribute("title")){
return a.getAttribute("title");
}
}
return null;
};
dojo.html.applyBrowserClass=function(node){
var drh=dojo.render.html;
var _5ed={dj_ie:drh.ie,dj_ie55:drh.ie55,dj_ie6:drh.ie60,dj_ie7:drh.ie70,dj_iequirks:drh.ie&&drh.quirks,dj_opera:drh.opera,dj_opera8:drh.opera&&(Math.floor(dojo.render.version)==8),dj_opera9:drh.opera&&(Math.floor(dojo.render.version)==9),dj_khtml:drh.khtml,dj_safari:drh.safari,dj_gecko:drh.mozilla};
for(var p in _5ed){
if(_5ed[p]){
dojo.html.addClass(node,p);
}
}
};
dojo.provide("dojo.widget.DomWidget");
dojo.widget._cssFiles={};
dojo.widget._cssStrings={};
dojo.widget._templateCache={};
dojo.widget.defaultStrings={dojoRoot:dojo.hostenv.getBaseScriptUri(),dojoWidgetModuleUri:dojo.uri.moduleUri("dojo.widget"),baseScriptUri:dojo.hostenv.getBaseScriptUri()};
dojo.widget.fillFromTemplateCache=function(obj,_5f0,_5f1,_5f2){
var _5f3=_5f0||obj.templatePath;
var _5f4=dojo.widget._templateCache;
if(!_5f3&&!obj["widgetType"]){
do{
var _5f5="__dummyTemplate__"+dojo.widget._templateCache.dummyCount++;
}while(_5f4[_5f5]);
obj.widgetType=_5f5;
}
var wt=_5f3?_5f3.toString():obj.widgetType;
var ts=_5f4[wt];
if(!ts){
_5f4[wt]={"string":null,"node":null};
if(_5f2){
ts={};
}else{
ts=_5f4[wt];
}
}
if((!obj.templateString)&&(!_5f2)){
obj.templateString=_5f1||ts["string"];
}
if(obj.templateString){
obj.templateString=this._sanitizeTemplateString(obj.templateString);
}
if((!obj.templateNode)&&(!_5f2)){
obj.templateNode=ts["node"];
}
if((!obj.templateNode)&&(!obj.templateString)&&(_5f3)){
var _5f8=this._sanitizeTemplateString(dojo.hostenv.getText(_5f3));
obj.templateString=_5f8;
if(!_5f2){
_5f4[wt]["string"]=_5f8;
}
}
if((!ts["string"])&&(!_5f2)){
ts.string=obj.templateString;
}
};
dojo.widget._sanitizeTemplateString=function(_5f9){
if(_5f9){
_5f9=_5f9.replace(/^\s*<\?xml(\s)+version=[\'\"](\d)*.(\d)*[\'\"](\s)*\?>/im,"");
var _5fa=_5f9.match(/<body[^>]*>\s*([\s\S]+)\s*<\/body>/im);
if(_5fa){
_5f9=_5fa[1];
}
}else{
_5f9="";
}
return _5f9;
};
dojo.widget._templateCache.dummyCount=0;
dojo.widget.attachProperties=["dojoAttachPoint","id"];
dojo.widget.eventAttachProperty="dojoAttachEvent";
dojo.widget.onBuildProperty="dojoOnBuild";
dojo.widget.waiNames=["waiRole","waiState"];
dojo.widget.wai={waiRole:{name:"waiRole","namespace":"http://www.w3.org/TR/xhtml2",alias:"x2",prefix:"wairole:"},waiState:{name:"waiState","namespace":"http://www.w3.org/2005/07/aaa",alias:"aaa",prefix:""},setAttr:function(node,ns,attr,_5fe){
if(dojo.render.html.ie){
node.setAttribute(this[ns].alias+":"+attr,this[ns].prefix+_5fe);
}else{
node.setAttributeNS(this[ns]["namespace"],attr,this[ns].prefix+_5fe);
}
},getAttr:function(node,ns,attr){
if(dojo.render.html.ie){
return node.getAttribute(this[ns].alias+":"+attr);
}else{
return node.getAttributeNS(this[ns]["namespace"],attr);
}
},removeAttr:function(node,ns,attr){
var _605=true;
if(dojo.render.html.ie){
_605=node.removeAttribute(this[ns].alias+":"+attr);
}else{
node.removeAttributeNS(this[ns]["namespace"],attr);
}
return _605;
}};
dojo.widget.attachTemplateNodes=function(_606,_607,_608){
var _609=dojo.dom.ELEMENT_NODE;
function trim(str){
return str.replace(/^\s+|\s+$/g,"");
}
if(!_606){
_606=_607.domNode;
}
if(_606.nodeType!=_609){
return;
}
var _60b=_606.all||_606.getElementsByTagName("*");
var _60c=_607;
for(var x=-1;x<_60b.length;x++){
var _60e=(x==-1)?_606:_60b[x];
var _60f=[];
if(!_607.widgetsInTemplate||!_60e.getAttribute("dojoType")){
for(var y=0;y<this.attachProperties.length;y++){
var _611=_60e.getAttribute(this.attachProperties[y]);
if(_611){
_60f=_611.split(";");
for(var z=0;z<_60f.length;z++){
if(dojo.lang.isArray(_607[_60f[z]])){
_607[_60f[z]].push(_60e);
}else{
_607[_60f[z]]=_60e;
}
}
break;
}
}
var _613=_60e.getAttribute(this.eventAttachProperty);
if(_613){
var evts=_613.split(";");
for(var y=0;y<evts.length;y++){
if((!evts[y])||(!evts[y].length)){
continue;
}
var _615=null;
var tevt=trim(evts[y]);
if(evts[y].indexOf(":")>=0){
var _617=tevt.split(":");
tevt=trim(_617[0]);
_615=trim(_617[1]);
}
if(!_615){
_615=tevt;
}
var tf=function(){
var ntf=new String(_615);
return function(evt){
if(_60c[ntf]){
_60c[ntf](dojo.event.browser.fixEvent(evt,this));
}
};
}();
dojo.event.browser.addListener(_60e,tevt,tf,false,true);
}
}
for(var y=0;y<_608.length;y++){
var _61b=_60e.getAttribute(_608[y]);
if((_61b)&&(_61b.length)){
var _615=null;
var _61c=_608[y].substr(4);
_615=trim(_61b);
var _61d=[_615];
if(_615.indexOf(";")>=0){
_61d=dojo.lang.map(_615.split(";"),trim);
}
for(var z=0;z<_61d.length;z++){
if(!_61d[z].length){
continue;
}
var tf=function(){
var ntf=new String(_61d[z]);
return function(evt){
if(_60c[ntf]){
_60c[ntf](dojo.event.browser.fixEvent(evt,this));
}
};
}();
dojo.event.browser.addListener(_60e,_61c,tf,false,true);
}
}
}
}
var _620=_60e.getAttribute(this.templateProperty);
if(_620){
_607[_620]=_60e;
}
dojo.lang.forEach(dojo.widget.waiNames,function(name){
var wai=dojo.widget.wai[name];
var val=_60e.getAttribute(wai.name);
if(val){
if(val.indexOf("-")==-1){
dojo.widget.wai.setAttr(_60e,wai.name,"role",val);
}else{
var _624=val.split("-");
dojo.widget.wai.setAttr(_60e,wai.name,_624[0],_624[1]);
}
}
},this);
var _625=_60e.getAttribute(this.onBuildProperty);
if(_625){
eval("var node = baseNode; var widget = targetObj; "+_625);
}
}
};
dojo.widget.getDojoEventsFromStr=function(str){
var re=/(dojoOn([a-z]+)(\s?))=/gi;
var evts=str?str.match(re)||[]:[];
var ret=[];
var lem={};
for(var x=0;x<evts.length;x++){
if(evts[x].length<1){
continue;
}
var cm=evts[x].replace(/\s/,"");
cm=(cm.slice(0,cm.length-1));
if(!lem[cm]){
lem[cm]=true;
ret.push(cm);
}
}
return ret;
};
dojo.declare("dojo.widget.DomWidget",dojo.widget.Widget,function(){
if((arguments.length>0)&&(typeof arguments[0]=="object")){
this.create(arguments[0]);
}
},{templateNode:null,templateString:null,templateCssString:null,preventClobber:false,domNode:null,containerNode:null,widgetsInTemplate:false,addChild:function(_62d,_62e,pos,ref,_631){
if(!this.isContainer){
dojo.debug("dojo.widget.DomWidget.addChild() attempted on non-container widget");
return null;
}else{
if(_631==undefined){
_631=this.children.length;
}
this.addWidgetAsDirectChild(_62d,_62e,pos,ref,_631);
this.registerChild(_62d,_631);
}
return _62d;
},addWidgetAsDirectChild:function(_632,_633,pos,ref,_636){
if((!this.containerNode)&&(!_633)){
this.containerNode=this.domNode;
}
var cn=(_633)?_633:this.containerNode;
if(!pos){
pos="after";
}
if(!ref){
if(!cn){
cn=dojo.body();
}
ref=cn.lastChild;
}
if(!_636){
_636=0;
}
_632.domNode.setAttribute("dojoinsertionindex",_636);
if(!ref){
cn.appendChild(_632.domNode);
}else{
if(pos=="insertAtIndex"){
dojo.dom.insertAtIndex(_632.domNode,ref.parentNode,_636);
}else{
if((pos=="after")&&(ref===cn.lastChild)){
cn.appendChild(_632.domNode);
}else{
dojo.dom.insertAtPosition(_632.domNode,cn,pos);
}
}
}
},registerChild:function(_638,_639){
_638.dojoInsertionIndex=_639;
var idx=-1;
for(var i=0;i<this.children.length;i++){
if(this.children[i].dojoInsertionIndex<=_639){
idx=i;
}
}
this.children.splice(idx+1,0,_638);
_638.parent=this;
_638.addedTo(this,idx+1);
delete dojo.widget.manager.topWidgets[_638.widgetId];
},removeChild:function(_63c){
dojo.dom.removeNode(_63c.domNode);
return dojo.widget.DomWidget.superclass.removeChild.call(this,_63c);
},getFragNodeRef:function(frag){
if(!frag){
return null;
}
if(!frag[this.getNamespacedType()]){
dojo.raise("Error: no frag for widget type "+this.getNamespacedType()+", id "+this.widgetId+" (maybe a widget has set it's type incorrectly)");
}
return frag[this.getNamespacedType()]["nodeRef"];
},postInitialize:function(args,frag,_640){
var _641=this.getFragNodeRef(frag);
if(_640&&(_640.snarfChildDomOutput||!_641)){
_640.addWidgetAsDirectChild(this,"","insertAtIndex","",args["dojoinsertionindex"],_641);
}else{
if(_641){
if(this.domNode&&(this.domNode!==_641)){
this._sourceNodeRef=dojo.dom.replaceNode(_641,this.domNode);
}
}
}
if(_640){
_640.registerChild(this,args.dojoinsertionindex);
}else{
dojo.widget.manager.topWidgets[this.widgetId]=this;
}
if(this.widgetsInTemplate){
var _642=new dojo.xml.Parse();
var _643;
var _644=this.domNode.getElementsByTagName("*");
for(var i=0;i<_644.length;i++){
if(_644[i].getAttribute("dojoAttachPoint")=="subContainerWidget"){
_643=_644[i];
}
if(_644[i].getAttribute("dojoType")){
_644[i].setAttribute("isSubWidget",true);
}
}
if(this.isContainer&&!this.containerNode){
if(_643){
var src=this.getFragNodeRef(frag);
if(src){
dojo.dom.moveChildren(src,_643);
frag["dojoDontFollow"]=true;
}
}else{
dojo.debug("No subContainerWidget node can be found in template file for widget "+this);
}
}
var _647=_642.parseElement(this.domNode,null,true);
dojo.widget.getParser().createSubComponents(_647,this);
var _648=[];
var _649=[this];
var w;
while((w=_649.pop())){
for(var i=0;i<w.children.length;i++){
var _64b=w.children[i];
if(_64b._processedSubWidgets||!_64b.extraArgs["issubwidget"]){
continue;
}
_648.push(_64b);
if(_64b.isContainer){
_649.push(_64b);
}
}
}
for(var i=0;i<_648.length;i++){
var _64c=_648[i];
if(_64c._processedSubWidgets){
dojo.debug("This should not happen: widget._processedSubWidgets is already true!");
return;
}
_64c._processedSubWidgets=true;
if(_64c.extraArgs["dojoattachevent"]){
var evts=_64c.extraArgs["dojoattachevent"].split(";");
for(var j=0;j<evts.length;j++){
var _64f=null;
var tevt=dojo.string.trim(evts[j]);
if(tevt.indexOf(":")>=0){
var _651=tevt.split(":");
tevt=dojo.string.trim(_651[0]);
_64f=dojo.string.trim(_651[1]);
}
if(!_64f){
_64f=tevt;
}
if(dojo.lang.isFunction(_64c[tevt])){
dojo.event.kwConnect({srcObj:_64c,srcFunc:tevt,targetObj:this,targetFunc:_64f});
}else{
alert(tevt+" is not a function in widget "+_64c);
}
}
}
if(_64c.extraArgs["dojoattachpoint"]){
this[_64c.extraArgs["dojoattachpoint"]]=_64c;
}
}
}
if(this.isContainer&&!frag["dojoDontFollow"]){
dojo.widget.getParser().createSubComponents(frag,this);
}
},buildRendering:function(args,frag){
var ts=dojo.widget._templateCache[this.widgetType];
if(args["templatecsspath"]){
args["templateCssPath"]=args["templatecsspath"];
}
var _655=args["templateCssPath"]||this.templateCssPath;
if(_655&&!dojo.widget._cssFiles[_655.toString()]){
if((!this.templateCssString)&&(_655)){
this.templateCssString=dojo.hostenv.getText(_655);
this.templateCssPath=null;
}
dojo.widget._cssFiles[_655.toString()]=true;
}
if((this["templateCssString"])&&(!dojo.widget._cssStrings[this.templateCssString])){
dojo.html.insertCssText(this.templateCssString,null,_655);
dojo.widget._cssStrings[this.templateCssString]=true;
}
if((!this.preventClobber)&&((this.templatePath)||(this.templateNode)||((this["templateString"])&&(this.templateString.length))||((typeof ts!="undefined")&&((ts["string"])||(ts["node"]))))){
this.buildFromTemplate(args,frag);
}else{
this.domNode=this.getFragNodeRef(frag);
}
this.fillInTemplate(args,frag);
},buildFromTemplate:function(args,frag){
var _658=false;
if(args["templatepath"]){
args["templatePath"]=args["templatepath"];
}
dojo.widget.fillFromTemplateCache(this,args["templatePath"],null,_658);
var ts=dojo.widget._templateCache[this.templatePath?this.templatePath.toString():this.widgetType];
if((ts)&&(!_658)){
if(!this.templateString.length){
this.templateString=ts["string"];
}
if(!this.templateNode){
this.templateNode=ts["node"];
}
}
var _65a=false;
var node=null;
var tstr=this.templateString;
if((!this.templateNode)&&(this.templateString)){
_65a=this.templateString.match(/\$\{([^\}]+)\}/g);
if(_65a){
var hash=this.strings||{};
for(var key in dojo.widget.defaultStrings){
if(dojo.lang.isUndefined(hash[key])){
hash[key]=dojo.widget.defaultStrings[key];
}
}
for(var i=0;i<_65a.length;i++){
var key=_65a[i];
key=key.substring(2,key.length-1);
var kval=(key.substring(0,5)=="this.")?dojo.lang.getObjPathValue(key.substring(5),this):hash[key];
var _661;
if((kval)||(dojo.lang.isString(kval))){
_661=new String((dojo.lang.isFunction(kval))?kval.call(this,key,this.templateString):kval);
while(_661.indexOf("\"")>-1){
_661=_661.replace("\"","&quot;");
}
tstr=tstr.replace(_65a[i],_661);
}
}
}else{
this.templateNode=this.createNodesFromText(this.templateString,true)[0];
if(!_658){
ts.node=this.templateNode;
}
}
}
if((!this.templateNode)&&(!_65a)){
dojo.debug("DomWidget.buildFromTemplate: could not create template");
return false;
}else{
if(!_65a){
node=this.templateNode.cloneNode(true);
if(!node){
return false;
}
}else{
node=this.createNodesFromText(tstr,true)[0];
}
}
this.domNode=node;
this.attachTemplateNodes();
if(this.isContainer&&this.containerNode){
var src=this.getFragNodeRef(frag);
if(src){
dojo.dom.moveChildren(src,this.containerNode);
}
}
},attachTemplateNodes:function(_663,_664){
if(!_663){
_663=this.domNode;
}
if(!_664){
_664=this;
}
return dojo.widget.attachTemplateNodes(_663,_664,dojo.widget.getDojoEventsFromStr(this.templateString));
},fillInTemplate:function(){
},destroyRendering:function(){
try{
dojo.dom.destroyNode(this.domNode);
delete this.domNode;
}
catch(e){
}
if(this._sourceNodeRef){
try{
dojo.dom.destroyNode(this._sourceNodeRef);
}
catch(e){
}
}
},createNodesFromText:function(){
dojo.unimplemented("dojo.widget.DomWidget.createNodesFromText");
}});
dojo.provide("dojo.html.display");
dojo.html._toggle=function(node,_666,_667){
node=dojo.byId(node);
_667(node,!_666(node));
return _666(node);
};
dojo.html.show=function(node){
node=dojo.byId(node);
if(dojo.html.getStyleProperty(node,"display")=="none"){
dojo.html.setStyle(node,"display",(node.dojoDisplayCache||""));
node.dojoDisplayCache=undefined;
}
};
dojo.html.hide=function(node){
node=dojo.byId(node);
if(typeof node["dojoDisplayCache"]=="undefined"){
var d=dojo.html.getStyleProperty(node,"display");
if(d!="none"){
node.dojoDisplayCache=d;
}
}
dojo.html.setStyle(node,"display","none");
};
dojo.html.setShowing=function(node,_66c){
dojo.html[(_66c?"show":"hide")](node);
};
dojo.html.isShowing=function(node){
return (dojo.html.getStyleProperty(node,"display")!="none");
};
dojo.html.toggleShowing=function(node){
return dojo.html._toggle(node,dojo.html.isShowing,dojo.html.setShowing);
};
dojo.html.displayMap={tr:"",td:"",th:"",img:"inline",span:"inline",input:"inline",button:"inline"};
dojo.html.suggestDisplayByTagName=function(node){
node=dojo.byId(node);
if(node&&node.tagName){
var tag=node.tagName.toLowerCase();
return (tag in dojo.html.displayMap?dojo.html.displayMap[tag]:"block");
}
};
dojo.html.setDisplay=function(node,_672){
dojo.html.setStyle(node,"display",((_672 instanceof String||typeof _672=="string")?_672:(_672?dojo.html.suggestDisplayByTagName(node):"none")));
};
dojo.html.isDisplayed=function(node){
return (dojo.html.getComputedStyle(node,"display")!="none");
};
dojo.html.toggleDisplay=function(node){
return dojo.html._toggle(node,dojo.html.isDisplayed,dojo.html.setDisplay);
};
dojo.html.setVisibility=function(node,_676){
dojo.html.setStyle(node,"visibility",((_676 instanceof String||typeof _676=="string")?_676:(_676?"visible":"hidden")));
};
dojo.html.isVisible=function(node){
return (dojo.html.getComputedStyle(node,"visibility")!="hidden");
};
dojo.html.toggleVisibility=function(node){
return dojo.html._toggle(node,dojo.html.isVisible,dojo.html.setVisibility);
};
dojo.html.setOpacity=function(node,_67a,_67b){
node=dojo.byId(node);
var h=dojo.render.html;
if(!_67b){
if(_67a>=1){
if(h.ie){
dojo.html.clearOpacity(node);
return;
}else{
_67a=0.999999;
}
}else{
if(_67a<0){
_67a=0;
}
}
}
if(h.ie){
if(node.nodeName.toLowerCase()=="tr"){
var tds=node.getElementsByTagName("td");
for(var x=0;x<tds.length;x++){
tds[x].style.filter="Alpha(Opacity="+_67a*100+")";
}
}
node.style.filter="Alpha(Opacity="+_67a*100+")";
}else{
if(h.moz){
node.style.opacity=_67a;
node.style.MozOpacity=_67a;
}else{
if(h.safari){
node.style.opacity=_67a;
node.style.KhtmlOpacity=_67a;
}else{
node.style.opacity=_67a;
}
}
}
};
dojo.html.clearOpacity=function(node){
node=dojo.byId(node);
var ns=node.style;
var h=dojo.render.html;
if(h.ie){
try{
if(node.filters&&node.filters.alpha){
ns.filter="";
}
}
catch(e){
}
}else{
if(h.moz){
ns.opacity=1;
ns.MozOpacity=1;
}else{
if(h.safari){
ns.opacity=1;
ns.KhtmlOpacity=1;
}else{
ns.opacity=1;
}
}
}
};
dojo.html.getOpacity=function(node){
node=dojo.byId(node);
var h=dojo.render.html;
if(h.ie){
var opac=(node.filters&&node.filters.alpha&&typeof node.filters.alpha.opacity=="number"?node.filters.alpha.opacity:100)/100;
}else{
var opac=node.style.opacity||node.style.MozOpacity||node.style.KhtmlOpacity||1;
}
return opac>=0.999999?1:Number(opac);
};
dojo.provide("dojo.html.layout");
dojo.html.sumAncestorProperties=function(node,prop){
node=dojo.byId(node);
if(!node){
return 0;
}
var _687=0;
while(node){
if(dojo.html.getComputedStyle(node,"position")=="fixed"){
return 0;
}
var val=node[prop];
if(val){
_687+=val-0;
if(node==dojo.body()){
break;
}
}
node=node.parentNode;
}
return _687;
};
dojo.html.setStyleAttributes=function(node,_68a){
node=dojo.byId(node);
var _68b=_68a.replace(/(;)?\s*$/,"").split(";");
for(var i=0;i<_68b.length;i++){
var _68d=_68b[i].split(":");
var name=_68d[0].replace(/\s*$/,"").replace(/^\s*/,"").toLowerCase();
var _68f=_68d[1].replace(/\s*$/,"").replace(/^\s*/,"");
switch(name){
case "opacity":
dojo.html.setOpacity(node,_68f);
break;
case "content-height":
dojo.html.setContentBox(node,{height:_68f});
break;
case "content-width":
dojo.html.setContentBox(node,{width:_68f});
break;
case "outer-height":
dojo.html.setMarginBox(node,{height:_68f});
break;
case "outer-width":
dojo.html.setMarginBox(node,{width:_68f});
break;
default:
node.style[dojo.html.toCamelCase(name)]=_68f;
}
}
};
dojo.html.boxSizing={MARGIN_BOX:"margin-box",BORDER_BOX:"border-box",PADDING_BOX:"padding-box",CONTENT_BOX:"content-box"};
dojo.html.getAbsolutePosition=dojo.html.abs=function(node,_691,_692){
node=dojo.byId(node,node.ownerDocument);
var ret={x:0,y:0};
var bs=dojo.html.boxSizing;
if(!_692){
_692=bs.CONTENT_BOX;
}
var _695=2;
var _696;
switch(_692){
case bs.MARGIN_BOX:
_696=3;
break;
case bs.BORDER_BOX:
_696=2;
break;
case bs.PADDING_BOX:
default:
_696=1;
break;
case bs.CONTENT_BOX:
_696=0;
break;
}
var h=dojo.render.html;
var db=document["body"]||document["documentElement"];
if(h.ie){
with(node.getBoundingClientRect()){
ret.x=left-2;
ret.y=top-2;
}
}else{
if(document.getBoxObjectFor){
_695=1;
try{
var bo=document.getBoxObjectFor(node);
ret.x=bo.x-dojo.html.sumAncestorProperties(node,"scrollLeft");
ret.y=bo.y-dojo.html.sumAncestorProperties(node,"scrollTop");
}
catch(e){
}
}else{
if(node["offsetParent"]){
var _69a;
if((h.safari)&&(node.style.getPropertyValue("position")=="absolute")&&(node.parentNode==db)){
_69a=db;
}else{
_69a=db.parentNode;
}
if(node.parentNode!=db){
var nd=node;
if(dojo.render.html.opera){
nd=db;
}
ret.x-=dojo.html.sumAncestorProperties(nd,"scrollLeft");
ret.y-=dojo.html.sumAncestorProperties(nd,"scrollTop");
}
var _69c=node;
do{
var n=_69c["offsetLeft"];
if(!h.opera||n>0){
ret.x+=isNaN(n)?0:n;
}
var m=_69c["offsetTop"];
ret.y+=isNaN(m)?0:m;
_69c=_69c.offsetParent;
}while((_69c!=_69a)&&(_69c!=null));
}else{
if(node["x"]&&node["y"]){
ret.x+=isNaN(node.x)?0:node.x;
ret.y+=isNaN(node.y)?0:node.y;
}
}
}
}
if(_691){
var _69f=dojo.html.getScroll();
ret.y+=_69f.top;
ret.x+=_69f.left;
}
var _6a0=[dojo.html.getPaddingExtent,dojo.html.getBorderExtent,dojo.html.getMarginExtent];
if(_695>_696){
for(var i=_696;i<_695;++i){
ret.y+=_6a0[i](node,"top");
ret.x+=_6a0[i](node,"left");
}
}else{
if(_695<_696){
for(var i=_696;i>_695;--i){
ret.y-=_6a0[i-1](node,"top");
ret.x-=_6a0[i-1](node,"left");
}
}
}
ret.top=ret.y;
ret.left=ret.x;
return ret;
};
dojo.html.isPositionAbsolute=function(node){
return (dojo.html.getComputedStyle(node,"position")=="absolute");
};
dojo.html._sumPixelValues=function(node,_6a4,_6a5){
var _6a6=0;
for(var x=0;x<_6a4.length;x++){
_6a6+=dojo.html.getPixelValue(node,_6a4[x],_6a5);
}
return _6a6;
};
dojo.html.getMargin=function(node){
return {width:dojo.html._sumPixelValues(node,["margin-left","margin-right"],(dojo.html.getComputedStyle(node,"position")=="absolute")),height:dojo.html._sumPixelValues(node,["margin-top","margin-bottom"],(dojo.html.getComputedStyle(node,"position")=="absolute"))};
};
dojo.html.getBorder=function(node){
return {width:dojo.html.getBorderExtent(node,"left")+dojo.html.getBorderExtent(node,"right"),height:dojo.html.getBorderExtent(node,"top")+dojo.html.getBorderExtent(node,"bottom")};
};
dojo.html.getBorderExtent=function(node,side){
return (dojo.html.getStyle(node,"border-"+side+"-style")=="none"?0:dojo.html.getPixelValue(node,"border-"+side+"-width"));
};
dojo.html.getMarginExtent=function(node,side){
return dojo.html._sumPixelValues(node,["margin-"+side],dojo.html.isPositionAbsolute(node));
};
dojo.html.getPaddingExtent=function(node,side){
return dojo.html._sumPixelValues(node,["padding-"+side],true);
};
dojo.html.getPadding=function(node){
return {width:dojo.html._sumPixelValues(node,["padding-left","padding-right"],true),height:dojo.html._sumPixelValues(node,["padding-top","padding-bottom"],true)};
};
dojo.html.getPadBorder=function(node){
var pad=dojo.html.getPadding(node);
var _6b3=dojo.html.getBorder(node);
return {width:pad.width+_6b3.width,height:pad.height+_6b3.height};
};
dojo.html.getBoxSizing=function(node){
var h=dojo.render.html;
var bs=dojo.html.boxSizing;
if(((h.ie)||(h.opera))&&node.nodeName.toLowerCase()!="img"){
var cm=document["compatMode"];
if((cm=="BackCompat")||(cm=="QuirksMode")){
return bs.BORDER_BOX;
}else{
return bs.CONTENT_BOX;
}
}else{
if(arguments.length==0){
node=document.documentElement;
}
var _6b8;
if(!h.ie){
_6b8=dojo.html.getStyle(node,"-moz-box-sizing");
if(!_6b8){
_6b8=dojo.html.getStyle(node,"box-sizing");
}
}
return (_6b8?_6b8:bs.CONTENT_BOX);
}
};
dojo.html.isBorderBox=function(node){
return (dojo.html.getBoxSizing(node)==dojo.html.boxSizing.BORDER_BOX);
};
dojo.html.getBorderBox=function(node){
node=dojo.byId(node);
return {width:node.offsetWidth,height:node.offsetHeight};
};
dojo.html.getPaddingBox=function(node){
var box=dojo.html.getBorderBox(node);
var _6bd=dojo.html.getBorder(node);
return {width:box.width-_6bd.width,height:box.height-_6bd.height};
};
dojo.html.getContentBox=function(node){
node=dojo.byId(node);
var _6bf=dojo.html.getPadBorder(node);
return {width:node.offsetWidth-_6bf.width,height:node.offsetHeight-_6bf.height};
};
dojo.html.setContentBox=function(node,args){
node=dojo.byId(node);
var _6c2=0;
var _6c3=0;
var isbb=dojo.html.isBorderBox(node);
var _6c5=(isbb?dojo.html.getPadBorder(node):{width:0,height:0});
var ret={};
if(typeof args.width!="undefined"){
_6c2=args.width+_6c5.width;
ret.width=dojo.html.setPositivePixelValue(node,"width",_6c2);
}
if(typeof args.height!="undefined"){
_6c3=args.height+_6c5.height;
ret.height=dojo.html.setPositivePixelValue(node,"height",_6c3);
}
return ret;
};
dojo.html.getMarginBox=function(node){
var _6c8=dojo.html.getBorderBox(node);
var _6c9=dojo.html.getMargin(node);
return {width:_6c8.width+_6c9.width,height:_6c8.height+_6c9.height};
};
dojo.html.setMarginBox=function(node,args){
node=dojo.byId(node);
var _6cc=0;
var _6cd=0;
var isbb=dojo.html.isBorderBox(node);
var _6cf=(!isbb?dojo.html.getPadBorder(node):{width:0,height:0});
var _6d0=dojo.html.getMargin(node);
var ret={};
if(typeof args.width!="undefined"){
_6cc=args.width-_6cf.width;
_6cc-=_6d0.width;
ret.width=dojo.html.setPositivePixelValue(node,"width",_6cc);
}
if(typeof args.height!="undefined"){
_6cd=args.height-_6cf.height;
_6cd-=_6d0.height;
ret.height=dojo.html.setPositivePixelValue(node,"height",_6cd);
}
return ret;
};
dojo.html.getElementBox=function(node,type){
var bs=dojo.html.boxSizing;
switch(type){
case bs.MARGIN_BOX:
return dojo.html.getMarginBox(node);
case bs.BORDER_BOX:
return dojo.html.getBorderBox(node);
case bs.PADDING_BOX:
return dojo.html.getPaddingBox(node);
case bs.CONTENT_BOX:
default:
return dojo.html.getContentBox(node);
}
};
dojo.html.toCoordinateObject=dojo.html.toCoordinateArray=function(_6d5,_6d6,_6d7){
if(_6d5 instanceof Array||typeof _6d5=="array"){
dojo.deprecated("dojo.html.toCoordinateArray","use dojo.html.toCoordinateObject({left: , top: , width: , height: }) instead","0.5");
while(_6d5.length<4){
_6d5.push(0);
}
while(_6d5.length>4){
_6d5.pop();
}
var ret={left:_6d5[0],top:_6d5[1],width:_6d5[2],height:_6d5[3]};
}else{
if(!_6d5.nodeType&&!(_6d5 instanceof String||typeof _6d5=="string")&&("width" in _6d5||"height" in _6d5||"left" in _6d5||"x" in _6d5||"top" in _6d5||"y" in _6d5)){
var ret={left:_6d5.left||_6d5.x||0,top:_6d5.top||_6d5.y||0,width:_6d5.width||0,height:_6d5.height||0};
}else{
var node=dojo.byId(_6d5);
var pos=dojo.html.abs(node,_6d6,_6d7);
var _6db=dojo.html.getMarginBox(node);
var ret={left:pos.left,top:pos.top,width:_6db.width,height:_6db.height};
}
}
ret.x=ret.left;
ret.y=ret.top;
return ret;
};
dojo.html.setMarginBoxWidth=dojo.html.setOuterWidth=function(node,_6dd){
return dojo.html._callDeprecated("setMarginBoxWidth","setMarginBox",arguments,"width");
};
dojo.html.setMarginBoxHeight=dojo.html.setOuterHeight=function(){
return dojo.html._callDeprecated("setMarginBoxHeight","setMarginBox",arguments,"height");
};
dojo.html.getMarginBoxWidth=dojo.html.getOuterWidth=function(){
return dojo.html._callDeprecated("getMarginBoxWidth","getMarginBox",arguments,null,"width");
};
dojo.html.getMarginBoxHeight=dojo.html.getOuterHeight=function(){
return dojo.html._callDeprecated("getMarginBoxHeight","getMarginBox",arguments,null,"height");
};
dojo.html.getTotalOffset=function(node,type,_6e0){
return dojo.html._callDeprecated("getTotalOffset","getAbsolutePosition",arguments,null,type);
};
dojo.html.getAbsoluteX=function(node,_6e2){
return dojo.html._callDeprecated("getAbsoluteX","getAbsolutePosition",arguments,null,"x");
};
dojo.html.getAbsoluteY=function(node,_6e4){
return dojo.html._callDeprecated("getAbsoluteY","getAbsolutePosition",arguments,null,"y");
};
dojo.html.totalOffsetLeft=function(node,_6e6){
return dojo.html._callDeprecated("totalOffsetLeft","getAbsolutePosition",arguments,null,"left");
};
dojo.html.totalOffsetTop=function(node,_6e8){
return dojo.html._callDeprecated("totalOffsetTop","getAbsolutePosition",arguments,null,"top");
};
dojo.html.getMarginWidth=function(node){
return dojo.html._callDeprecated("getMarginWidth","getMargin",arguments,null,"width");
};
dojo.html.getMarginHeight=function(node){
return dojo.html._callDeprecated("getMarginHeight","getMargin",arguments,null,"height");
};
dojo.html.getBorderWidth=function(node){
return dojo.html._callDeprecated("getBorderWidth","getBorder",arguments,null,"width");
};
dojo.html.getBorderHeight=function(node){
return dojo.html._callDeprecated("getBorderHeight","getBorder",arguments,null,"height");
};
dojo.html.getPaddingWidth=function(node){
return dojo.html._callDeprecated("getPaddingWidth","getPadding",arguments,null,"width");
};
dojo.html.getPaddingHeight=function(node){
return dojo.html._callDeprecated("getPaddingHeight","getPadding",arguments,null,"height");
};
dojo.html.getPadBorderWidth=function(node){
return dojo.html._callDeprecated("getPadBorderWidth","getPadBorder",arguments,null,"width");
};
dojo.html.getPadBorderHeight=function(node){
return dojo.html._callDeprecated("getPadBorderHeight","getPadBorder",arguments,null,"height");
};
dojo.html.getBorderBoxWidth=dojo.html.getInnerWidth=function(){
return dojo.html._callDeprecated("getBorderBoxWidth","getBorderBox",arguments,null,"width");
};
dojo.html.getBorderBoxHeight=dojo.html.getInnerHeight=function(){
return dojo.html._callDeprecated("getBorderBoxHeight","getBorderBox",arguments,null,"height");
};
dojo.html.getContentBoxWidth=dojo.html.getContentWidth=function(){
return dojo.html._callDeprecated("getContentBoxWidth","getContentBox",arguments,null,"width");
};
dojo.html.getContentBoxHeight=dojo.html.getContentHeight=function(){
return dojo.html._callDeprecated("getContentBoxHeight","getContentBox",arguments,null,"height");
};
dojo.html.setContentBoxWidth=dojo.html.setContentWidth=function(node,_6f2){
return dojo.html._callDeprecated("setContentBoxWidth","setContentBox",arguments,"width");
};
dojo.html.setContentBoxHeight=dojo.html.setContentHeight=function(node,_6f4){
return dojo.html._callDeprecated("setContentBoxHeight","setContentBox",arguments,"height");
};
dojo.provide("dojo.html.util");
dojo.html.getElementWindow=function(_6f5){
return dojo.html.getDocumentWindow(_6f5.ownerDocument);
};
dojo.html.getDocumentWindow=function(doc){
if(dojo.render.html.safari&&!doc._parentWindow){
var fix=function(win){
win.document._parentWindow=win;
for(var i=0;i<win.frames.length;i++){
fix(win.frames[i]);
}
};
fix(window.top);
}
if(dojo.render.html.ie&&window!==document.parentWindow&&!doc._parentWindow){
doc.parentWindow.execScript("document._parentWindow = window;","Javascript");
var win=doc._parentWindow;
doc._parentWindow=null;
return win;
}
return doc._parentWindow||doc.parentWindow||doc.defaultView;
};
dojo.html.gravity=function(node,e){
node=dojo.byId(node);
var _6fd=dojo.html.getCursorPosition(e);
with(dojo.html){
var _6fe=getAbsolutePosition(node,true);
var bb=getBorderBox(node);
var _700=_6fe.x+(bb.width/2);
var _701=_6fe.y+(bb.height/2);
}
with(dojo.html.gravity){
return ((_6fd.x<_700?WEST:EAST)|(_6fd.y<_701?NORTH:SOUTH));
}
};
dojo.html.gravity.NORTH=1;
dojo.html.gravity.SOUTH=1<<1;
dojo.html.gravity.EAST=1<<2;
dojo.html.gravity.WEST=1<<3;
dojo.html.overElement=function(_702,e){
_702=dojo.byId(_702);
var _704=dojo.html.getCursorPosition(e);
var bb=dojo.html.getBorderBox(_702);
var _706=dojo.html.getAbsolutePosition(_702,true,dojo.html.boxSizing.BORDER_BOX);
var top=_706.y;
var _708=top+bb.height;
var left=_706.x;
var _70a=left+bb.width;
return (_704.x>=left&&_704.x<=_70a&&_704.y>=top&&_704.y<=_708);
};
dojo.html.renderedTextContent=function(node){
node=dojo.byId(node);
var _70c="";
if(node==null){
return _70c;
}
for(var i=0;i<node.childNodes.length;i++){
switch(node.childNodes[i].nodeType){
case 1:
case 5:
var _70e="unknown";
try{
_70e=dojo.html.getStyle(node.childNodes[i],"display");
}
catch(E){
}
switch(_70e){
case "block":
case "list-item":
case "run-in":
case "table":
case "table-row-group":
case "table-header-group":
case "table-footer-group":
case "table-row":
case "table-column-group":
case "table-column":
case "table-cell":
case "table-caption":
_70c+="\n";
_70c+=dojo.html.renderedTextContent(node.childNodes[i]);
_70c+="\n";
break;
case "none":
break;
default:
if(node.childNodes[i].tagName&&node.childNodes[i].tagName.toLowerCase()=="br"){
_70c+="\n";
}else{
_70c+=dojo.html.renderedTextContent(node.childNodes[i]);
}
break;
}
break;
case 3:
case 2:
case 4:
var text=node.childNodes[i].nodeValue;
var _710="unknown";
try{
_710=dojo.html.getStyle(node,"text-transform");
}
catch(E){
}
switch(_710){
case "capitalize":
var _711=text.split(" ");
for(var i=0;i<_711.length;i++){
_711[i]=_711[i].charAt(0).toUpperCase()+_711[i].substring(1);
}
text=_711.join(" ");
break;
case "uppercase":
text=text.toUpperCase();
break;
case "lowercase":
text=text.toLowerCase();
break;
default:
break;
}
switch(_710){
case "nowrap":
break;
case "pre-wrap":
break;
case "pre-line":
break;
case "pre":
break;
default:
text=text.replace(/\s+/," ");
if(/\s$/.test(_70c)){
text.replace(/^\s/,"");
}
break;
}
_70c+=text;
break;
default:
break;
}
}
return _70c;
};
dojo.html.createNodesFromText=function(txt,trim){
if(trim){
txt=txt.replace(/^\s+|\s+$/g,"");
}
var tn=dojo.doc().createElement("div");
tn.style.visibility="hidden";
dojo.body().appendChild(tn);
var _715="none";
if((/^<t[dh][\s\r\n>]/i).test(txt.replace(/^\s+/))){
txt="<table><tbody><tr>"+txt+"</tr></tbody></table>";
_715="cell";
}else{
if((/^<tr[\s\r\n>]/i).test(txt.replace(/^\s+/))){
txt="<table><tbody>"+txt+"</tbody></table>";
_715="row";
}else{
if((/^<(thead|tbody|tfoot)[\s\r\n>]/i).test(txt.replace(/^\s+/))){
txt="<table>"+txt+"</table>";
_715="section";
}
}
}
tn.innerHTML=txt;
if(tn["normalize"]){
tn.normalize();
}
var _716=null;
switch(_715){
case "cell":
_716=tn.getElementsByTagName("tr")[0];
break;
case "row":
_716=tn.getElementsByTagName("tbody")[0];
break;
case "section":
_716=tn.getElementsByTagName("table")[0];
break;
default:
_716=tn;
break;
}
var _717=[];
for(var x=0;x<_716.childNodes.length;x++){
_717.push(_716.childNodes[x].cloneNode(true));
}
tn.style.display="none";
dojo.html.destroyNode(tn);
return _717;
};
dojo.html.placeOnScreen=function(node,_71a,_71b,_71c,_71d,_71e,_71f){
if(_71a instanceof Array||typeof _71a=="array"){
_71f=_71e;
_71e=_71d;
_71d=_71c;
_71c=_71b;
_71b=_71a[1];
_71a=_71a[0];
}
if(_71e instanceof String||typeof _71e=="string"){
_71e=_71e.split(",");
}
if(!isNaN(_71c)){
_71c=[Number(_71c),Number(_71c)];
}else{
if(!(_71c instanceof Array||typeof _71c=="array")){
_71c=[0,0];
}
}
var _720=dojo.html.getScroll().offset;
var view=dojo.html.getViewport();
node=dojo.byId(node);
var _722=node.style.display;
node.style.display="";
var bb=dojo.html.getBorderBox(node);
var w=bb.width;
var h=bb.height;
node.style.display=_722;
if(!(_71e instanceof Array||typeof _71e=="array")){
_71e=["TL"];
}
var _726,_727,_728=Infinity,_729;
for(var _72a=0;_72a<_71e.length;++_72a){
var _72b=_71e[_72a];
var _72c=true;
var tryX=_71a-(_72b.charAt(1)=="L"?0:w)+_71c[0]*(_72b.charAt(1)=="L"?1:-1);
var tryY=_71b-(_72b.charAt(0)=="T"?0:h)+_71c[1]*(_72b.charAt(0)=="T"?1:-1);
if(_71d){
tryX-=_720.x;
tryY-=_720.y;
}
if(tryX<0){
tryX=0;
_72c=false;
}
if(tryY<0){
tryY=0;
_72c=false;
}
var x=tryX+w;
if(x>view.width){
x=view.width-w;
_72c=false;
}else{
x=tryX;
}
x=Math.max(_71c[0],x)+_720.x;
var y=tryY+h;
if(y>view.height){
y=view.height-h;
_72c=false;
}else{
y=tryY;
}
y=Math.max(_71c[1],y)+_720.y;
if(_72c){
_726=x;
_727=y;
_728=0;
_729=_72b;
break;
}else{
var dist=Math.pow(x-tryX-_720.x,2)+Math.pow(y-tryY-_720.y,2);
if(_728>dist){
_728=dist;
_726=x;
_727=y;
_729=_72b;
}
}
}
if(!_71f){
node.style.left=_726+"px";
node.style.top=_727+"px";
}
return {left:_726,top:_727,x:_726,y:_727,dist:_728,corner:_729};
};
dojo.html.placeOnScreenPoint=function(node,_733,_734,_735,_736){
dojo.deprecated("dojo.html.placeOnScreenPoint","use dojo.html.placeOnScreen() instead","0.5");
return dojo.html.placeOnScreen(node,_733,_734,_735,_736,["TL","TR","BL","BR"]);
};
dojo.html.placeOnScreenAroundElement=function(node,_738,_739,_73a,_73b,_73c){
var best,_73e=Infinity;
_738=dojo.byId(_738);
var _73f=_738.style.display;
_738.style.display="";
var mb=dojo.html.getElementBox(_738,_73a);
var _741=mb.width;
var _742=mb.height;
var _743=dojo.html.getAbsolutePosition(_738,true,_73a);
_738.style.display=_73f;
for(var _744 in _73b){
var pos,_746,_747;
var _748=_73b[_744];
_746=_743.x+(_744.charAt(1)=="L"?0:_741);
_747=_743.y+(_744.charAt(0)=="T"?0:_742);
pos=dojo.html.placeOnScreen(node,_746,_747,_739,true,_748,true);
if(pos.dist==0){
best=pos;
break;
}else{
if(_73e>pos.dist){
_73e=pos.dist;
best=pos;
}
}
}
if(!_73c){
node.style.left=best.left+"px";
node.style.top=best.top+"px";
}
return best;
};
dojo.html.scrollIntoView=function(node){
if(!node){
return;
}
if(dojo.render.html.ie){
if(dojo.html.getBorderBox(node.parentNode).height<=node.parentNode.scrollHeight){
node.scrollIntoView(false);
}
}else{
if(dojo.render.html.mozilla){
node.scrollIntoView(false);
}else{
var _74a=node.parentNode;
var _74b=_74a.scrollTop+dojo.html.getBorderBox(_74a).height;
var _74c=node.offsetTop+dojo.html.getMarginBox(node).height;
if(_74b<_74c){
_74a.scrollTop+=(_74c-_74b);
}else{
if(_74a.scrollTop>node.offsetTop){
_74a.scrollTop-=(_74a.scrollTop-node.offsetTop);
}
}
}
}
};
dojo.provide("dojo.gfx.color");
dojo.gfx.color.Color=function(r,g,b,a){
if(dojo.lang.isArray(r)){
this.r=r[0];
this.g=r[1];
this.b=r[2];
this.a=r[3]||1;
}else{
if(dojo.lang.isString(r)){
var rgb=dojo.gfx.color.extractRGB(r);
this.r=rgb[0];
this.g=rgb[1];
this.b=rgb[2];
this.a=g||1;
}else{
if(r instanceof dojo.gfx.color.Color){
this.r=r.r;
this.b=r.b;
this.g=r.g;
this.a=r.a;
}else{
this.r=r;
this.g=g;
this.b=b;
this.a=a;
}
}
}
};
dojo.gfx.color.Color.fromArray=function(arr){
return new dojo.gfx.color.Color(arr[0],arr[1],arr[2],arr[3]);
};
dojo.extend(dojo.gfx.color.Color,{toRgb:function(_753){
if(_753){
return this.toRgba();
}else{
return [this.r,this.g,this.b];
}
},toRgba:function(){
return [this.r,this.g,this.b,this.a];
},toHex:function(){
return dojo.gfx.color.rgb2hex(this.toRgb());
},toCss:function(){
return "rgb("+this.toRgb().join()+")";
},toString:function(){
return this.toHex();
},blend:function(_754,_755){
var rgb=null;
if(dojo.lang.isArray(_754)){
rgb=_754;
}else{
if(_754 instanceof dojo.gfx.color.Color){
rgb=_754.toRgb();
}else{
rgb=new dojo.gfx.color.Color(_754).toRgb();
}
}
return dojo.gfx.color.blend(this.toRgb(),rgb,_755);
}});
dojo.gfx.color.named={white:[255,255,255],black:[0,0,0],red:[255,0,0],green:[0,255,0],lime:[0,255,0],blue:[0,0,255],navy:[0,0,128],gray:[128,128,128],silver:[192,192,192]};
dojo.gfx.color.blend=function(a,b,_759){
if(typeof a=="string"){
return dojo.gfx.color.blendHex(a,b,_759);
}
if(!_759){
_759=0;
}
_759=Math.min(Math.max(-1,_759),1);
_759=((_759+1)/2);
var c=[];
for(var x=0;x<3;x++){
c[x]=parseInt(b[x]+((a[x]-b[x])*_759));
}
return c;
};
dojo.gfx.color.blendHex=function(a,b,_75e){
return dojo.gfx.color.rgb2hex(dojo.gfx.color.blend(dojo.gfx.color.hex2rgb(a),dojo.gfx.color.hex2rgb(b),_75e));
};
dojo.gfx.color.extractRGB=function(_75f){
var hex="0123456789abcdef";
_75f=_75f.toLowerCase();
if(_75f.indexOf("rgb")==0){
var _761=_75f.match(/rgba*\((\d+), *(\d+), *(\d+)/i);
var ret=_761.splice(1,3);
return ret;
}else{
var _763=dojo.gfx.color.hex2rgb(_75f);
if(_763){
return _763;
}else{
return dojo.gfx.color.named[_75f]||[255,255,255];
}
}
};
dojo.gfx.color.hex2rgb=function(hex){
var _765="0123456789ABCDEF";
var rgb=new Array(3);
if(hex.indexOf("#")==0){
hex=hex.substring(1);
}
hex=hex.toUpperCase();
if(hex.replace(new RegExp("["+_765+"]","g"),"")!=""){
return null;
}
if(hex.length==3){
rgb[0]=hex.charAt(0)+hex.charAt(0);
rgb[1]=hex.charAt(1)+hex.charAt(1);
rgb[2]=hex.charAt(2)+hex.charAt(2);
}else{
rgb[0]=hex.substring(0,2);
rgb[1]=hex.substring(2,4);
rgb[2]=hex.substring(4);
}
for(var i=0;i<rgb.length;i++){
rgb[i]=_765.indexOf(rgb[i].charAt(0))*16+_765.indexOf(rgb[i].charAt(1));
}
return rgb;
};
dojo.gfx.color.rgb2hex=function(r,g,b){
if(dojo.lang.isArray(r)){
g=r[1]||0;
b=r[2]||0;
r=r[0]||0;
}
var ret=dojo.lang.map([r,g,b],function(x){
x=new Number(x);
var s=x.toString(16);
while(s.length<2){
s="0"+s;
}
return s;
});
ret.unshift("#");
return ret.join("");
};
dojo.provide("dojo.lfx.Animation");
dojo.lfx.Line=function(_76e,end){
this.start=_76e;
this.end=end;
if(dojo.lang.isArray(_76e)){
var diff=[];
dojo.lang.forEach(this.start,function(s,i){
diff[i]=this.end[i]-s;
},this);
this.getValue=function(n){
var res=[];
dojo.lang.forEach(this.start,function(s,i){
res[i]=(diff[i]*n)+s;
},this);
return res;
};
}else{
var diff=end-_76e;
this.getValue=function(n){
return (diff*n)+this.start;
};
}
};
if((dojo.render.html.khtml)&&(!dojo.render.html.safari)){
dojo.lfx.easeDefault=function(n){
return (parseFloat("0.5")+((Math.sin((n+parseFloat("1.5"))*Math.PI))/2));
};
}else{
dojo.lfx.easeDefault=function(n){
return (0.5+((Math.sin((n+1.5)*Math.PI))/2));
};
}
dojo.lfx.easeIn=function(n){
return Math.pow(n,3);
};
dojo.lfx.easeOut=function(n){
return (1-Math.pow(1-n,3));
};
dojo.lfx.easeInOut=function(n){
return ((3*Math.pow(n,2))-(2*Math.pow(n,3)));
};
dojo.lfx.IAnimation=function(){
};
dojo.lang.extend(dojo.lfx.IAnimation,{curve:null,duration:1000,easing:null,repeatCount:0,rate:10,handler:null,beforeBegin:null,onBegin:null,onAnimate:null,onEnd:null,onPlay:null,onPause:null,onStop:null,play:null,pause:null,stop:null,connect:function(evt,_77e,_77f){
if(!_77f){
_77f=_77e;
_77e=this;
}
_77f=dojo.lang.hitch(_77e,_77f);
var _780=this[evt]||function(){
};
this[evt]=function(){
var ret=_780.apply(this,arguments);
_77f.apply(this,arguments);
return ret;
};
return this;
},fire:function(evt,args){
if(this[evt]){
this[evt].apply(this,(args||[]));
}
return this;
},repeat:function(_784){
this.repeatCount=_784;
return this;
},_active:false,_paused:false});
dojo.lfx.Animation=function(_785,_786,_787,_788,_789,rate){
dojo.lfx.IAnimation.call(this);
if(dojo.lang.isNumber(_785)||(!_785&&_786.getValue)){
rate=_789;
_789=_788;
_788=_787;
_787=_786;
_786=_785;
_785=null;
}else{
if(_785.getValue||dojo.lang.isArray(_785)){
rate=_788;
_789=_787;
_788=_786;
_787=_785;
_786=null;
_785=null;
}
}
if(dojo.lang.isArray(_787)){
this.curve=new dojo.lfx.Line(_787[0],_787[1]);
}else{
this.curve=_787;
}
if(_786!=null&&_786>0){
this.duration=_786;
}
if(_789){
this.repeatCount=_789;
}
if(rate){
this.rate=rate;
}
if(_785){
dojo.lang.forEach(["handler","beforeBegin","onBegin","onEnd","onPlay","onStop","onAnimate"],function(item){
if(_785[item]){
this.connect(item,_785[item]);
}
},this);
}
if(_788&&dojo.lang.isFunction(_788)){
this.easing=_788;
}
};
dojo.inherits(dojo.lfx.Animation,dojo.lfx.IAnimation);
dojo.lang.extend(dojo.lfx.Animation,{_startTime:null,_endTime:null,_timer:null,_percent:0,_startRepeatCount:0,play:function(_78c,_78d){
if(_78d){
clearTimeout(this._timer);
this._active=false;
this._paused=false;
this._percent=0;
}else{
if(this._active&&!this._paused){
return this;
}
}
this.fire("handler",["beforeBegin"]);
this.fire("beforeBegin");
if(_78c>0){
setTimeout(dojo.lang.hitch(this,function(){
this.play(null,_78d);
}),_78c);
return this;
}
this._startTime=new Date().valueOf();
if(this._paused){
this._startTime-=(this.duration*this._percent/100);
}
this._endTime=this._startTime+this.duration;
this._active=true;
this._paused=false;
var step=this._percent/100;
var _78f=this.curve.getValue(step);
if(this._percent==0){
if(!this._startRepeatCount){
this._startRepeatCount=this.repeatCount;
}
this.fire("handler",["begin",_78f]);
this.fire("onBegin",[_78f]);
}
this.fire("handler",["play",_78f]);
this.fire("onPlay",[_78f]);
this._cycle();
return this;
},pause:function(){
clearTimeout(this._timer);
if(!this._active){
return this;
}
this._paused=true;
var _790=this.curve.getValue(this._percent/100);
this.fire("handler",["pause",_790]);
this.fire("onPause",[_790]);
return this;
},gotoPercent:function(pct,_792){
clearTimeout(this._timer);
this._active=true;
this._paused=true;
this._percent=pct;
if(_792){
this.play();
}
return this;
},stop:function(_793){
clearTimeout(this._timer);
var step=this._percent/100;
if(_793){
step=1;
}
var _795=this.curve.getValue(step);
this.fire("handler",["stop",_795]);
this.fire("onStop",[_795]);
this._active=false;
this._paused=false;
return this;
},status:function(){
if(this._active){
return this._paused?"paused":"playing";
}else{
return "stopped";
}
return this;
},_cycle:function(){
clearTimeout(this._timer);
if(this._active){
var curr=new Date().valueOf();
var step=(curr-this._startTime)/(this._endTime-this._startTime);
if(step>=1){
step=1;
this._percent=100;
}else{
this._percent=step*100;
}
if((this.easing)&&(dojo.lang.isFunction(this.easing))){
step=this.easing(step);
}
var _798=this.curve.getValue(step);
this.fire("handler",["animate",_798]);
this.fire("onAnimate",[_798]);
if(step<1){
this._timer=setTimeout(dojo.lang.hitch(this,"_cycle"),this.rate);
}else{
this._active=false;
this.fire("handler",["end"]);
this.fire("onEnd");
if(this.repeatCount>0){
this.repeatCount--;
this.play(null,true);
}else{
if(this.repeatCount==-1){
this.play(null,true);
}else{
if(this._startRepeatCount){
this.repeatCount=this._startRepeatCount;
this._startRepeatCount=0;
}
}
}
}
}
return this;
}});
dojo.lfx.Combine=function(_799){
dojo.lfx.IAnimation.call(this);
this._anims=[];
this._animsEnded=0;
var _79a=arguments;
if(_79a.length==1&&(dojo.lang.isArray(_79a[0])||dojo.lang.isArrayLike(_79a[0]))){
_79a=_79a[0];
}
dojo.lang.forEach(_79a,function(anim){
this._anims.push(anim);
anim.connect("onEnd",dojo.lang.hitch(this,"_onAnimsEnded"));
},this);
};
dojo.inherits(dojo.lfx.Combine,dojo.lfx.IAnimation);
dojo.lang.extend(dojo.lfx.Combine,{_animsEnded:0,play:function(_79c,_79d){
if(!this._anims.length){
return this;
}
this.fire("beforeBegin");
if(_79c>0){
setTimeout(dojo.lang.hitch(this,function(){
this.play(null,_79d);
}),_79c);
return this;
}
if(_79d||this._anims[0].percent==0){
this.fire("onBegin");
}
this.fire("onPlay");
this._animsCall("play",null,_79d);
return this;
},pause:function(){
this.fire("onPause");
this._animsCall("pause");
return this;
},stop:function(_79e){
this.fire("onStop");
this._animsCall("stop",_79e);
return this;
},_onAnimsEnded:function(){
this._animsEnded++;
if(this._animsEnded>=this._anims.length){
this.fire("onEnd");
}
return this;
},_animsCall:function(_79f){
var args=[];
if(arguments.length>1){
for(var i=1;i<arguments.length;i++){
args.push(arguments[i]);
}
}
var _7a2=this;
dojo.lang.forEach(this._anims,function(anim){
anim[_79f](args);
},_7a2);
return this;
}});
dojo.lfx.Chain=function(_7a4){
dojo.lfx.IAnimation.call(this);
this._anims=[];
this._currAnim=-1;
var _7a5=arguments;
if(_7a5.length==1&&(dojo.lang.isArray(_7a5[0])||dojo.lang.isArrayLike(_7a5[0]))){
_7a5=_7a5[0];
}
var _7a6=this;
dojo.lang.forEach(_7a5,function(anim,i,_7a9){
this._anims.push(anim);
if(i<_7a9.length-1){
anim.connect("onEnd",dojo.lang.hitch(this,"_playNext"));
}else{
anim.connect("onEnd",dojo.lang.hitch(this,function(){
this.fire("onEnd");
}));
}
},this);
};
dojo.inherits(dojo.lfx.Chain,dojo.lfx.IAnimation);
dojo.lang.extend(dojo.lfx.Chain,{_currAnim:-1,play:function(_7aa,_7ab){
if(!this._anims.length){
return this;
}
if(_7ab||!this._anims[this._currAnim]){
this._currAnim=0;
}
var _7ac=this._anims[this._currAnim];
this.fire("beforeBegin");
if(_7aa>0){
setTimeout(dojo.lang.hitch(this,function(){
this.play(null,_7ab);
}),_7aa);
return this;
}
if(_7ac){
if(this._currAnim==0){
this.fire("handler",["begin",this._currAnim]);
this.fire("onBegin",[this._currAnim]);
}
this.fire("onPlay",[this._currAnim]);
_7ac.play(null,_7ab);
}
return this;
},pause:function(){
if(this._anims[this._currAnim]){
this._anims[this._currAnim].pause();
this.fire("onPause",[this._currAnim]);
}
return this;
},playPause:function(){
if(this._anims.length==0){
return this;
}
if(this._currAnim==-1){
this._currAnim=0;
}
var _7ad=this._anims[this._currAnim];
if(_7ad){
if(!_7ad._active||_7ad._paused){
this.play();
}else{
this.pause();
}
}
return this;
},stop:function(){
var _7ae=this._anims[this._currAnim];
if(_7ae){
_7ae.stop();
this.fire("onStop",[this._currAnim]);
}
return _7ae;
},_playNext:function(){
if(this._currAnim==-1||this._anims.length==0){
return this;
}
this._currAnim++;
if(this._anims[this._currAnim]){
this._anims[this._currAnim].play(null,true);
}
return this;
}});
dojo.lfx.combine=function(_7af){
var _7b0=arguments;
if(dojo.lang.isArray(arguments[0])){
_7b0=arguments[0];
}
if(_7b0.length==1){
return _7b0[0];
}
return new dojo.lfx.Combine(_7b0);
};
dojo.lfx.chain=function(_7b1){
var _7b2=arguments;
if(dojo.lang.isArray(arguments[0])){
_7b2=arguments[0];
}
if(_7b2.length==1){
return _7b2[0];
}
return new dojo.lfx.Chain(_7b2);
};
dojo.provide("dojo.html.color");
dojo.html.getBackgroundColor=function(node){
node=dojo.byId(node);
var _7b4;
do{
_7b4=dojo.html.getStyle(node,"background-color");
if(_7b4.toLowerCase()=="rgba(0, 0, 0, 0)"){
_7b4="transparent";
}
if(node==document.getElementsByTagName("body")[0]){
node=null;
break;
}
node=node.parentNode;
}while(node&&dojo.lang.inArray(["transparent",""],_7b4));
if(_7b4=="transparent"){
_7b4=[255,255,255,0];
}else{
_7b4=dojo.gfx.color.extractRGB(_7b4);
}
return _7b4;
};
dojo.provide("dojo.lfx.html");
dojo.lfx.html._byId=function(_7b5){
if(!_7b5){
return [];
}
if(dojo.lang.isArrayLike(_7b5)){
if(!_7b5.alreadyChecked){
var n=[];
dojo.lang.forEach(_7b5,function(node){
n.push(dojo.byId(node));
});
n.alreadyChecked=true;
return n;
}else{
return _7b5;
}
}else{
var n=[];
n.push(dojo.byId(_7b5));
n.alreadyChecked=true;
return n;
}
};
dojo.lfx.html.propertyAnimation=function(_7b8,_7b9,_7ba,_7bb,_7bc){
_7b8=dojo.lfx.html._byId(_7b8);
var _7bd={"propertyMap":_7b9,"nodes":_7b8,"duration":_7ba,"easing":_7bb||dojo.lfx.easeDefault};
var _7be=function(args){
if(args.nodes.length==1){
var pm=args.propertyMap;
if(!dojo.lang.isArray(args.propertyMap)){
var parr=[];
for(var _7c2 in pm){
pm[_7c2].property=_7c2;
parr.push(pm[_7c2]);
}
pm=args.propertyMap=parr;
}
dojo.lang.forEach(pm,function(prop){
if(dj_undef("start",prop)){
if(prop.property!="opacity"){
prop.start=parseInt(dojo.html.getComputedStyle(args.nodes[0],prop.property));
}else{
prop.start=dojo.html.getOpacity(args.nodes[0]);
}
}
});
}
};
var _7c4=function(_7c5){
var _7c6=[];
dojo.lang.forEach(_7c5,function(c){
_7c6.push(Math.round(c));
});
return _7c6;
};
var _7c8=function(n,_7ca){
n=dojo.byId(n);
if(!n||!n.style){
return;
}
for(var s in _7ca){
try{
if(s=="opacity"){
dojo.html.setOpacity(n,_7ca[s]);
}else{
n.style[s]=_7ca[s];
}
}
catch(e){
dojo.debug(e);
}
}
};
var _7cc=function(_7cd){
this._properties=_7cd;
this.diffs=new Array(_7cd.length);
dojo.lang.forEach(_7cd,function(prop,i){
if(dojo.lang.isFunction(prop.start)){
prop.start=prop.start(prop,i);
}
if(dojo.lang.isFunction(prop.end)){
prop.end=prop.end(prop,i);
}
if(dojo.lang.isArray(prop.start)){
this.diffs[i]=null;
}else{
if(prop.start instanceof dojo.gfx.color.Color){
prop.startRgb=prop.start.toRgb();
prop.endRgb=prop.end.toRgb();
}else{
this.diffs[i]=prop.end-prop.start;
}
}
},this);
this.getValue=function(n){
var ret={};
dojo.lang.forEach(this._properties,function(prop,i){
var _7d4=null;
if(dojo.lang.isArray(prop.start)){
}else{
if(prop.start instanceof dojo.gfx.color.Color){
_7d4=(prop.units||"rgb")+"(";
for(var j=0;j<prop.startRgb.length;j++){
_7d4+=Math.round(((prop.endRgb[j]-prop.startRgb[j])*n)+prop.startRgb[j])+(j<prop.startRgb.length-1?",":"");
}
_7d4+=")";
}else{
_7d4=((this.diffs[i])*n)+prop.start+(prop.property!="opacity"?prop.units||"px":"");
}
}
ret[dojo.html.toCamelCase(prop.property)]=_7d4;
},this);
return ret;
};
};
var anim=new dojo.lfx.Animation({beforeBegin:function(){
_7be(_7bd);
anim.curve=new _7cc(_7bd.propertyMap);
},onAnimate:function(_7d7){
dojo.lang.forEach(_7bd.nodes,function(node){
_7c8(node,_7d7);
});
}},_7bd.duration,null,_7bd.easing);
if(_7bc){
for(var x in _7bc){
if(dojo.lang.isFunction(_7bc[x])){
anim.connect(x,anim,_7bc[x]);
}
}
}
return anim;
};
dojo.lfx.html._makeFadeable=function(_7da){
var _7db=function(node){
if(dojo.render.html.ie){
if((node.style.zoom.length==0)&&(dojo.html.getStyle(node,"zoom")=="normal")){
node.style.zoom="1";
}
if((node.style.width.length==0)&&(dojo.html.getStyle(node,"width")=="auto")){
node.style.width="auto";
}
}
};
if(dojo.lang.isArrayLike(_7da)){
dojo.lang.forEach(_7da,_7db);
}else{
_7db(_7da);
}
};
dojo.lfx.html.fade=function(_7dd,_7de,_7df,_7e0,_7e1){
_7dd=dojo.lfx.html._byId(_7dd);
var _7e2={property:"opacity"};
if(!dj_undef("start",_7de)){
_7e2.start=_7de.start;
}else{
_7e2.start=function(){
return dojo.html.getOpacity(_7dd[0]);
};
}
if(!dj_undef("end",_7de)){
_7e2.end=_7de.end;
}else{
dojo.raise("dojo.lfx.html.fade needs an end value");
}
var anim=dojo.lfx.propertyAnimation(_7dd,[_7e2],_7df,_7e0);
anim.connect("beforeBegin",function(){
dojo.lfx.html._makeFadeable(_7dd);
});
if(_7e1){
anim.connect("onEnd",function(){
_7e1(_7dd,anim);
});
}
return anim;
};
dojo.lfx.html.fadeIn=function(_7e4,_7e5,_7e6,_7e7){
return dojo.lfx.html.fade(_7e4,{end:1},_7e5,_7e6,_7e7);
};
dojo.lfx.html.fadeOut=function(_7e8,_7e9,_7ea,_7eb){
return dojo.lfx.html.fade(_7e8,{end:0},_7e9,_7ea,_7eb);
};
dojo.lfx.html.fadeShow=function(_7ec,_7ed,_7ee,_7ef){
_7ec=dojo.lfx.html._byId(_7ec);
dojo.lang.forEach(_7ec,function(node){
dojo.html.setOpacity(node,0);
});
var anim=dojo.lfx.html.fadeIn(_7ec,_7ed,_7ee,_7ef);
anim.connect("beforeBegin",function(){
if(dojo.lang.isArrayLike(_7ec)){
dojo.lang.forEach(_7ec,dojo.html.show);
}else{
dojo.html.show(_7ec);
}
});
return anim;
};
dojo.lfx.html.fadeHide=function(_7f2,_7f3,_7f4,_7f5){
var anim=dojo.lfx.html.fadeOut(_7f2,_7f3,_7f4,function(){
if(dojo.lang.isArrayLike(_7f2)){
dojo.lang.forEach(_7f2,dojo.html.hide);
}else{
dojo.html.hide(_7f2);
}
if(_7f5){
_7f5(_7f2,anim);
}
});
return anim;
};
dojo.lfx.html.wipeIn=function(_7f7,_7f8,_7f9,_7fa){
_7f7=dojo.lfx.html._byId(_7f7);
var _7fb=[];
dojo.lang.forEach(_7f7,function(node){
var _7fd={};
var _7fe,_7ff,_800;
with(node.style){
_7fe=top;
_7ff=left;
_800=position;
top="-9999px";
left="-9999px";
position="absolute";
display="";
}
var _801=dojo.html.getBorderBox(node).height;
with(node.style){
top=_7fe;
left=_7ff;
position=_800;
display="none";
}
var anim=dojo.lfx.propertyAnimation(node,{"height":{start:1,end:function(){
return _801;
}}},_7f8,_7f9);
anim.connect("beforeBegin",function(){
_7fd.overflow=node.style.overflow;
_7fd.height=node.style.height;
with(node.style){
overflow="hidden";
height="1px";
}
dojo.html.show(node);
});
anim.connect("onEnd",function(){
with(node.style){
overflow=_7fd.overflow;
height=_7fd.height;
}
if(_7fa){
_7fa(node,anim);
}
});
_7fb.push(anim);
});
return dojo.lfx.combine(_7fb);
};
dojo.lfx.html.wipeOut=function(_803,_804,_805,_806){
_803=dojo.lfx.html._byId(_803);
var _807=[];
dojo.lang.forEach(_803,function(node){
var _809={};
var anim=dojo.lfx.propertyAnimation(node,{"height":{start:function(){
return dojo.html.getContentBox(node).height;
},end:1}},_804,_805,{"beforeBegin":function(){
_809.overflow=node.style.overflow;
_809.height=node.style.height;
with(node.style){
overflow="hidden";
}
dojo.html.show(node);
},"onEnd":function(){
dojo.html.hide(node);
with(node.style){
overflow=_809.overflow;
height=_809.height;
}
if(_806){
_806(node,anim);
}
}});
_807.push(anim);
});
return dojo.lfx.combine(_807);
};
dojo.lfx.html.slideTo=function(_80b,_80c,_80d,_80e,_80f){
_80b=dojo.lfx.html._byId(_80b);
var _810=[];
var _811=dojo.html.getComputedStyle;
if(dojo.lang.isArray(_80c)){
dojo.deprecated("dojo.lfx.html.slideTo(node, array)","use dojo.lfx.html.slideTo(node, {top: value, left: value});","0.5");
_80c={top:_80c[0],left:_80c[1]};
}
dojo.lang.forEach(_80b,function(node){
var top=null;
var left=null;
var init=(function(){
var _816=node;
return function(){
var pos=_811(_816,"position");
top=(pos=="absolute"?node.offsetTop:parseInt(_811(node,"top"))||0);
left=(pos=="absolute"?node.offsetLeft:parseInt(_811(node,"left"))||0);
if(!dojo.lang.inArray(["absolute","relative"],pos)){
var ret=dojo.html.abs(_816,true);
dojo.html.setStyleAttributes(_816,"position:absolute;top:"+ret.y+"px;left:"+ret.x+"px;");
top=ret.y;
left=ret.x;
}
};
})();
init();
var anim=dojo.lfx.propertyAnimation(node,{"top":{start:top,end:(_80c.top||0)},"left":{start:left,end:(_80c.left||0)}},_80d,_80e,{"beforeBegin":init});
if(_80f){
anim.connect("onEnd",function(){
_80f(_80b,anim);
});
}
_810.push(anim);
});
return dojo.lfx.combine(_810);
};
dojo.lfx.html.slideBy=function(_81a,_81b,_81c,_81d,_81e){
_81a=dojo.lfx.html._byId(_81a);
var _81f=[];
var _820=dojo.html.getComputedStyle;
if(dojo.lang.isArray(_81b)){
dojo.deprecated("dojo.lfx.html.slideBy(node, array)","use dojo.lfx.html.slideBy(node, {top: value, left: value});","0.5");
_81b={top:_81b[0],left:_81b[1]};
}
dojo.lang.forEach(_81a,function(node){
var top=null;
var left=null;
var init=(function(){
var _825=node;
return function(){
var pos=_820(_825,"position");
top=(pos=="absolute"?node.offsetTop:parseInt(_820(node,"top"))||0);
left=(pos=="absolute"?node.offsetLeft:parseInt(_820(node,"left"))||0);
if(!dojo.lang.inArray(["absolute","relative"],pos)){
var ret=dojo.html.abs(_825,true);
dojo.html.setStyleAttributes(_825,"position:absolute;top:"+ret.y+"px;left:"+ret.x+"px;");
top=ret.y;
left=ret.x;
}
};
})();
init();
var anim=dojo.lfx.propertyAnimation(node,{"top":{start:top,end:top+(_81b.top||0)},"left":{start:left,end:left+(_81b.left||0)}},_81c,_81d).connect("beforeBegin",init);
if(_81e){
anim.connect("onEnd",function(){
_81e(_81a,anim);
});
}
_81f.push(anim);
});
return dojo.lfx.combine(_81f);
};
dojo.lfx.html.explode=function(_829,_82a,_82b,_82c,_82d){
var h=dojo.html;
_829=dojo.byId(_829);
_82a=dojo.byId(_82a);
var _82f=h.toCoordinateObject(_829,true);
var _830=document.createElement("div");
h.copyStyle(_830,_82a);
if(_82a.explodeClassName){
_830.className=_82a.explodeClassName;
}
with(_830.style){
position="absolute";
display="none";
var _831=h.getStyle(_829,"background-color");
backgroundColor=_831?_831.toLowerCase():"transparent";
backgroundColor=(backgroundColor=="transparent")?"rgb(221, 221, 221)":backgroundColor;
}
dojo.body().appendChild(_830);
with(_82a.style){
visibility="hidden";
display="block";
}
var _832=h.toCoordinateObject(_82a,true);
with(_82a.style){
display="none";
visibility="visible";
}
var _833={opacity:{start:0.5,end:1}};
dojo.lang.forEach(["height","width","top","left"],function(type){
_833[type]={start:_82f[type],end:_832[type]};
});
var anim=new dojo.lfx.propertyAnimation(_830,_833,_82b,_82c,{"beforeBegin":function(){
h.setDisplay(_830,"block");
},"onEnd":function(){
h.setDisplay(_82a,"block");
_830.parentNode.removeChild(_830);
}});
if(_82d){
anim.connect("onEnd",function(){
_82d(_82a,anim);
});
}
return anim;
};
dojo.lfx.html.implode=function(_836,end,_838,_839,_83a){
var h=dojo.html;
_836=dojo.byId(_836);
end=dojo.byId(end);
var _83c=dojo.html.toCoordinateObject(_836,true);
var _83d=dojo.html.toCoordinateObject(end,true);
var _83e=document.createElement("div");
dojo.html.copyStyle(_83e,_836);
if(_836.explodeClassName){
_83e.className=_836.explodeClassName;
}
dojo.html.setOpacity(_83e,0.3);
with(_83e.style){
position="absolute";
display="none";
backgroundColor=h.getStyle(_836,"background-color").toLowerCase();
}
dojo.body().appendChild(_83e);
var _83f={opacity:{start:1,end:0.5}};
dojo.lang.forEach(["height","width","top","left"],function(type){
_83f[type]={start:_83c[type],end:_83d[type]};
});
var anim=new dojo.lfx.propertyAnimation(_83e,_83f,_838,_839,{"beforeBegin":function(){
dojo.html.hide(_836);
dojo.html.show(_83e);
},"onEnd":function(){
_83e.parentNode.removeChild(_83e);
}});
if(_83a){
anim.connect("onEnd",function(){
_83a(_836,anim);
});
}
return anim;
};
dojo.lfx.html.highlight=function(_842,_843,_844,_845,_846){
_842=dojo.lfx.html._byId(_842);
var _847=[];
dojo.lang.forEach(_842,function(node){
var _849=dojo.html.getBackgroundColor(node);
var bg=dojo.html.getStyle(node,"background-color").toLowerCase();
var _84b=dojo.html.getStyle(node,"background-image");
var _84c=(bg=="transparent"||bg=="rgba(0, 0, 0, 0)");
while(_849.length>3){
_849.pop();
}
var rgb=new dojo.gfx.color.Color(_843);
var _84e=new dojo.gfx.color.Color(_849);
var anim=dojo.lfx.propertyAnimation(node,{"background-color":{start:rgb,end:_84e}},_844,_845,{"beforeBegin":function(){
if(_84b){
node.style.backgroundImage="none";
}
node.style.backgroundColor="rgb("+rgb.toRgb().join(",")+")";
},"onEnd":function(){
if(_84b){
node.style.backgroundImage=_84b;
}
if(_84c){
node.style.backgroundColor="transparent";
}
if(_846){
_846(node,anim);
}
}});
_847.push(anim);
});
return dojo.lfx.combine(_847);
};
dojo.lfx.html.unhighlight=function(_850,_851,_852,_853,_854){
_850=dojo.lfx.html._byId(_850);
var _855=[];
dojo.lang.forEach(_850,function(node){
var _857=new dojo.gfx.color.Color(dojo.html.getBackgroundColor(node));
var rgb=new dojo.gfx.color.Color(_851);
var _859=dojo.html.getStyle(node,"background-image");
var anim=dojo.lfx.propertyAnimation(node,{"background-color":{start:_857,end:rgb}},_852,_853,{"beforeBegin":function(){
if(_859){
node.style.backgroundImage="none";
}
node.style.backgroundColor="rgb("+_857.toRgb().join(",")+")";
},"onEnd":function(){
if(_854){
_854(node,anim);
}
}});
_855.push(anim);
});
return dojo.lfx.combine(_855);
};
dojo.lang.mixin(dojo.lfx,dojo.lfx.html);
dojo.kwCompoundRequire({browser:["dojo.lfx.html"],dashboard:["dojo.lfx.html"]});
dojo.provide("dojo.lfx.*");
dojo.provide("dojo.lfx.toggle");
dojo.lfx.toggle.plain={show:function(node,_85c,_85d,_85e){
dojo.html.show(node);
if(dojo.lang.isFunction(_85e)){
_85e();
}
},hide:function(node,_860,_861,_862){
dojo.html.hide(node);
if(dojo.lang.isFunction(_862)){
_862();
}
}};
dojo.lfx.toggle.fade={show:function(node,_864,_865,_866){
dojo.lfx.fadeShow(node,_864,_865,_866).play();
},hide:function(node,_868,_869,_86a){
dojo.lfx.fadeHide(node,_868,_869,_86a).play();
}};
dojo.lfx.toggle.wipe={show:function(node,_86c,_86d,_86e){
dojo.lfx.wipeIn(node,_86c,_86d,_86e).play();
},hide:function(node,_870,_871,_872){
dojo.lfx.wipeOut(node,_870,_871,_872).play();
}};
dojo.lfx.toggle.explode={show:function(node,_874,_875,_876,_877){
dojo.lfx.explode(_877||{x:0,y:0,width:0,height:0},node,_874,_875,_876).play();
},hide:function(node,_879,_87a,_87b,_87c){
dojo.lfx.implode(node,_87c||{x:0,y:0,width:0,height:0},_879,_87a,_87b).play();
}};
dojo.provide("dojo.widget.HtmlWidget");
dojo.declare("dojo.widget.HtmlWidget",dojo.widget.DomWidget,{templateCssPath:null,templatePath:null,lang:"",toggle:"plain",toggleDuration:150,initialize:function(args,frag){
},postMixInProperties:function(args,frag){
if(this.lang===""){
this.lang=null;
}
this.toggleObj=dojo.lfx.toggle[this.toggle.toLowerCase()]||dojo.lfx.toggle.plain;
},createNodesFromText:function(txt,wrap){
return dojo.html.createNodesFromText(txt,wrap);
},destroyRendering:function(_883){
try{
if(this.bgIframe){
this.bgIframe.remove();
delete this.bgIframe;
}
if(!_883&&this.domNode){
dojo.event.browser.clean(this.domNode);
}
dojo.widget.HtmlWidget.superclass.destroyRendering.call(this);
}
catch(e){
}
},isShowing:function(){
return dojo.html.isShowing(this.domNode);
},toggleShowing:function(){
if(this.isShowing()){
this.hide();
}else{
this.show();
}
},show:function(){
if(this.isShowing()){
return;
}
this.animationInProgress=true;
this.toggleObj.show(this.domNode,this.toggleDuration,null,dojo.lang.hitch(this,this.onShow),this.explodeSrc);
},onShow:function(){
this.animationInProgress=false;
this.checkSize();
},hide:function(){
if(!this.isShowing()){
return;
}
this.animationInProgress=true;
this.toggleObj.hide(this.domNode,this.toggleDuration,null,dojo.lang.hitch(this,this.onHide),this.explodeSrc);
},onHide:function(){
this.animationInProgress=false;
},_isResized:function(w,h){
if(!this.isShowing()){
return false;
}
var wh=dojo.html.getMarginBox(this.domNode);
var _887=w||wh.width;
var _888=h||wh.height;
if(this.width==_887&&this.height==_888){
return false;
}
this.width=_887;
this.height=_888;
return true;
},checkSize:function(){
if(!this._isResized()){
return;
}
this.onResized();
},resizeTo:function(w,h){
dojo.html.setMarginBox(this.domNode,{width:w,height:h});
if(this.isShowing()){
this.onResized();
}
},resizeSoon:function(){
if(this.isShowing()){
dojo.lang.setTimeout(this,this.onResized,0);
}
},onResized:function(){
dojo.lang.forEach(this.children,function(_88b){
if(_88b.checkSize){
_88b.checkSize();
}
});
}});
dojo.kwCompoundRequire({common:["dojo.xml.Parse","dojo.widget.Widget","dojo.widget.Parse","dojo.widget.Manager"],browser:["dojo.widget.DomWidget","dojo.widget.HtmlWidget"],dashboard:["dojo.widget.DomWidget","dojo.widget.HtmlWidget"],svg:["dojo.widget.SvgWidget"],rhino:["dojo.widget.SwtWidget"]});
dojo.provide("dojo.widget.*");
dojo.kwCompoundRequire({common:["dojo.html.common","dojo.html.style"]});
dojo.provide("dojo.html.*");
dojo.provide("dojo.html.selection");
dojo.html.selectionType={NONE:0,TEXT:1,CONTROL:2};
dojo.html.clearSelection=function(){
var _88c=dojo.global();
var _88d=dojo.doc();
try{
if(_88c["getSelection"]){
if(dojo.render.html.safari){
_88c.getSelection().collapse();
}else{
_88c.getSelection().removeAllRanges();
}
}else{
if(_88d.selection){
if(_88d.selection.empty){
_88d.selection.empty();
}else{
if(_88d.selection.clear){
_88d.selection.clear();
}
}
}
}
return true;
}
catch(e){
dojo.debug(e);
return false;
}
};
dojo.html.disableSelection=function(_88e){
_88e=dojo.byId(_88e)||dojo.body();
var h=dojo.render.html;
if(h.mozilla){
_88e.style.MozUserSelect="none";
}else{
if(h.safari){
_88e.style.KhtmlUserSelect="none";
}else{
if(h.ie){
_88e.unselectable="on";
}else{
return false;
}
}
}
return true;
};
dojo.html.enableSelection=function(_890){
_890=dojo.byId(_890)||dojo.body();
var h=dojo.render.html;
if(h.mozilla){
_890.style.MozUserSelect="";
}else{
if(h.safari){
_890.style.KhtmlUserSelect="";
}else{
if(h.ie){
_890.unselectable="off";
}else{
return false;
}
}
}
return true;
};
dojo.html.selectElement=function(_892){
dojo.deprecated("dojo.html.selectElement","replaced by dojo.html.selection.selectElementChildren",0.5);
};
dojo.html.selectInputText=function(_893){
var _894=dojo.global();
var _895=dojo.doc();
_893=dojo.byId(_893);
if(_895["selection"]&&dojo.body()["createTextRange"]){
var _896=_893.createTextRange();
_896.moveStart("character",0);
_896.moveEnd("character",_893.value.length);
_896.select();
}else{
if(_894["getSelection"]){
var _897=_894.getSelection();
_893.setSelectionRange(0,_893.value.length);
}
}
_893.focus();
};
dojo.html.isSelectionCollapsed=function(){
dojo.deprecated("dojo.html.isSelectionCollapsed","replaced by dojo.html.selection.isCollapsed",0.5);
return dojo.html.selection.isCollapsed();
};
dojo.lang.mixin(dojo.html.selection,{getType:function(){
if(dojo.doc()["selection"]){
return dojo.html.selectionType[dojo.doc().selection.type.toUpperCase()];
}else{
var _898=dojo.html.selectionType.TEXT;
var oSel;
try{
oSel=dojo.global().getSelection();
}
catch(e){
}
if(oSel&&oSel.rangeCount==1){
var _89a=oSel.getRangeAt(0);
if(_89a.startContainer==_89a.endContainer&&(_89a.endOffset-_89a.startOffset)==1&&_89a.startContainer.nodeType!=dojo.dom.TEXT_NODE){
_898=dojo.html.selectionType.CONTROL;
}
}
return _898;
}
},isCollapsed:function(){
var _89b=dojo.global();
var _89c=dojo.doc();
if(_89c["selection"]){
return _89c.selection.createRange().text=="";
}else{
if(_89b["getSelection"]){
var _89d=_89b.getSelection();
if(dojo.lang.isString(_89d)){
return _89d=="";
}else{
return _89d.isCollapsed||_89d.toString()=="";
}
}
}
},getSelectedElement:function(){
if(dojo.html.selection.getType()==dojo.html.selectionType.CONTROL){
if(dojo.doc()["selection"]){
var _89e=dojo.doc().selection.createRange();
if(_89e&&_89e.item){
return dojo.doc().selection.createRange().item(0);
}
}else{
var _89f=dojo.global().getSelection();
return _89f.anchorNode.childNodes[_89f.anchorOffset];
}
}
},getParentElement:function(){
if(dojo.html.selection.getType()==dojo.html.selectionType.CONTROL){
var p=dojo.html.selection.getSelectedElement();
if(p){
return p.parentNode;
}
}else{
if(dojo.doc()["selection"]){
return dojo.doc().selection.createRange().parentElement();
}else{
var _8a1=dojo.global().getSelection();
if(_8a1){
var node=_8a1.anchorNode;
while(node&&node.nodeType!=dojo.dom.ELEMENT_NODE){
node=node.parentNode;
}
return node;
}
}
}
},getSelectedText:function(){
if(dojo.doc()["selection"]){
if(dojo.html.selection.getType()==dojo.html.selectionType.CONTROL){
return null;
}
return dojo.doc().selection.createRange().text;
}else{
var _8a3=dojo.global().getSelection();
if(_8a3){
return _8a3.toString();
}
}
},getSelectedHtml:function(){
if(dojo.doc()["selection"]){
if(dojo.html.selection.getType()==dojo.html.selectionType.CONTROL){
return null;
}
return dojo.doc().selection.createRange().htmlText;
}else{
var _8a4=dojo.global().getSelection();
if(_8a4&&_8a4.rangeCount){
var frag=_8a4.getRangeAt(0).cloneContents();
var div=document.createElement("div");
div.appendChild(frag);
return div.innerHTML;
}
return null;
}
},hasAncestorElement:function(_8a7){
return (dojo.html.selection.getAncestorElement.apply(this,arguments)!=null);
},getAncestorElement:function(_8a8){
var node=dojo.html.selection.getSelectedElement()||dojo.html.selection.getParentElement();
while(node){
if(dojo.html.selection.isTag(node,arguments).length>0){
return node;
}
node=node.parentNode;
}
return null;
},isTag:function(node,tags){
if(node&&node.tagName){
for(var i=0;i<tags.length;i++){
if(node.tagName.toLowerCase()==String(tags[i]).toLowerCase()){
return String(tags[i]).toLowerCase();
}
}
}
return "";
},selectElement:function(_8ad){
var _8ae=dojo.global();
var _8af=dojo.doc();
_8ad=dojo.byId(_8ad);
if(_8af.selection&&dojo.body().createTextRange){
try{
var _8b0=dojo.body().createControlRange();
_8b0.addElement(_8ad);
_8b0.select();
}
catch(e){
dojo.html.selection.selectElementChildren(_8ad);
}
}else{
if(_8ae["getSelection"]){
var _8b1=_8ae.getSelection();
if(_8b1["removeAllRanges"]){
var _8b0=_8af.createRange();
_8b0.selectNode(_8ad);
_8b1.removeAllRanges();
_8b1.addRange(_8b0);
}
}
}
},selectElementChildren:function(_8b2){
var _8b3=dojo.global();
var _8b4=dojo.doc();
_8b2=dojo.byId(_8b2);
if(_8b4.selection&&dojo.body().createTextRange){
var _8b5=dojo.body().createTextRange();
_8b5.moveToElementText(_8b2);
_8b5.select();
}else{
if(_8b3["getSelection"]){
var _8b6=_8b3.getSelection();
if(_8b6["setBaseAndExtent"]){
_8b6.setBaseAndExtent(_8b2,0,_8b2,_8b2.innerText.length-1);
}else{
if(_8b6["selectAllChildren"]){
_8b6.selectAllChildren(_8b2);
}
}
}
}
},getBookmark:function(){
var _8b7;
var _8b8=dojo.doc();
if(_8b8["selection"]){
var _8b9=_8b8.selection.createRange();
_8b7=_8b9.getBookmark();
}else{
var _8ba;
try{
_8ba=dojo.global().getSelection();
}
catch(e){
}
if(_8ba){
var _8b9=_8ba.getRangeAt(0);
_8b7=_8b9.cloneRange();
}else{
dojo.debug("No idea how to store the current selection for this browser!");
}
}
return _8b7;
},moveToBookmark:function(_8bb){
var _8bc=dojo.doc();
if(_8bc["selection"]){
var _8bd=_8bc.selection.createRange();
_8bd.moveToBookmark(_8bb);
_8bd.select();
}else{
var _8be;
try{
_8be=dojo.global().getSelection();
}
catch(e){
}
if(_8be&&_8be["removeAllRanges"]){
_8be.removeAllRanges();
_8be.addRange(_8bb);
}else{
dojo.debug("No idea how to restore selection for this browser!");
}
}
},collapse:function(_8bf){
if(dojo.global()["getSelection"]){
var _8c0=dojo.global().getSelection();
if(_8c0.removeAllRanges){
if(_8bf){
_8c0.collapseToStart();
}else{
_8c0.collapseToEnd();
}
}else{
dojo.global().getSelection().collapse(_8bf);
}
}else{
if(dojo.doc().selection){
var _8c1=dojo.doc().selection.createRange();
_8c1.collapse(_8bf);
_8c1.select();
}
}
},remove:function(){
if(dojo.doc().selection){
var _8c2=dojo.doc().selection;
if(_8c2.type.toUpperCase()!="NONE"){
_8c2.clear();
}
return _8c2;
}else{
var _8c2=dojo.global().getSelection();
for(var i=0;i<_8c2.rangeCount;i++){
_8c2.getRangeAt(i).deleteContents();
}
return _8c2;
}
}});
dojo.provide("dojo.Deferred");
dojo.Deferred=function(_8c4){
this.chain=[];
this.id=this._nextId();
this.fired=-1;
this.paused=0;
this.results=[null,null];
this.canceller=_8c4;
this.silentlyCancelled=false;
};
dojo.lang.extend(dojo.Deferred,{getFunctionFromArgs:function(){
var a=arguments;
if((a[0])&&(!a[1])){
if(dojo.lang.isFunction(a[0])){
return a[0];
}else{
if(dojo.lang.isString(a[0])){
return dj_global[a[0]];
}
}
}else{
if((a[0])&&(a[1])){
return dojo.lang.hitch(a[0],a[1]);
}
}
return null;
},makeCalled:function(){
var _8c6=new dojo.Deferred();
_8c6.callback();
return _8c6;
},repr:function(){
var _8c7;
if(this.fired==-1){
_8c7="unfired";
}else{
if(this.fired==0){
_8c7="success";
}else{
_8c7="error";
}
}
return "Deferred("+this.id+", "+_8c7+")";
},toString:dojo.lang.forward("repr"),_nextId:(function(){
var n=1;
return function(){
return n++;
};
})(),cancel:function(){
if(this.fired==-1){
if(this.canceller){
this.canceller(this);
}else{
this.silentlyCancelled=true;
}
if(this.fired==-1){
this.errback(new Error(this.repr()));
}
}else{
if((this.fired==0)&&(this.results[0] instanceof dojo.Deferred)){
this.results[0].cancel();
}
}
},_pause:function(){
this.paused++;
},_unpause:function(){
this.paused--;
if((this.paused==0)&&(this.fired>=0)){
this._fire();
}
},_continue:function(res){
this._resback(res);
this._unpause();
},_resback:function(res){
this.fired=((res instanceof Error)?1:0);
this.results[this.fired]=res;
this._fire();
},_check:function(){
if(this.fired!=-1){
if(!this.silentlyCancelled){
dojo.raise("already called!");
}
this.silentlyCancelled=false;
return;
}
},callback:function(res){
this._check();
this._resback(res);
},errback:function(res){
this._check();
if(!(res instanceof Error)){
res=new Error(res);
}
this._resback(res);
},addBoth:function(cb,cbfn){
var _8cf=this.getFunctionFromArgs(cb,cbfn);
if(arguments.length>2){
_8cf=dojo.lang.curryArguments(null,_8cf,arguments,2);
}
return this.addCallbacks(_8cf,_8cf);
},addCallback:function(cb,cbfn){
var _8d2=this.getFunctionFromArgs(cb,cbfn);
if(arguments.length>2){
_8d2=dojo.lang.curryArguments(null,_8d2,arguments,2);
}
return this.addCallbacks(_8d2,null);
},addErrback:function(cb,cbfn){
var _8d5=this.getFunctionFromArgs(cb,cbfn);
if(arguments.length>2){
_8d5=dojo.lang.curryArguments(null,_8d5,arguments,2);
}
return this.addCallbacks(null,_8d5);
return this.addCallbacks(null,cbfn);
},addCallbacks:function(cb,eb){
this.chain.push([cb,eb]);
if(this.fired>=0){
this._fire();
}
return this;
},_fire:function(){
var _8d8=this.chain;
var _8d9=this.fired;
var res=this.results[_8d9];
var self=this;
var cb=null;
while(_8d8.length>0&&this.paused==0){
var pair=_8d8.shift();
var f=pair[_8d9];
if(f==null){
continue;
}
try{
res=f(res);
_8d9=((res instanceof Error)?1:0);
if(res instanceof dojo.Deferred){
cb=function(res){
self._continue(res);
};
this._pause();
}
}
catch(err){
_8d9=1;
res=err;
}
}
this.fired=_8d9;
this.results[_8d9]=res;
if((cb)&&(this.paused)){
res.addBoth(cb);
}
}});
dojo.provide("dojo.widget.RichText");
if(!djConfig["useXDomain"]||djConfig["allowXdRichTextSave"]){
if(dojo.hostenv.post_load_){
(function(){
var _8e0=dojo.doc().createElement("textarea");
_8e0.id="dojo.widget.RichText.savedContent";
_8e0.style="display:none;position:absolute;top:-100px;left:-100px;height:3px;width:3px;overflow:hidden;";
dojo.body().appendChild(_8e0);
})();
}else{
try{
dojo.doc().write("<textarea id=\"dojo.widget.RichText.savedContent\" "+"style=\"display:none;position:absolute;top:-100px;left:-100px;height:3px;width:3px;overflow:hidden;\"></textarea>");
}
catch(e){
}
}
}
dojo.widget.defineWidget("dojo.widget.RichText",dojo.widget.HtmlWidget,function(){
this.contentPreFilters=[];
this.contentPostFilters=[];
this.contentDomPreFilters=[];
this.contentDomPostFilters=[];
this.editingAreaStyleSheets=[];
if(dojo.render.html.moz){
this.contentPreFilters.push(this._fixContentForMoz);
}
this._keyHandlers={};
if(dojo.Deferred){
this.onLoadDeferred=new dojo.Deferred();
}
},{inheritWidth:false,focusOnLoad:false,saveName:"",styleSheets:"",_content:"",height:"",minHeight:"1em",isClosed:true,isLoaded:false,useActiveX:false,relativeImageUrls:false,_SEPARATOR:"@@**%%__RICHTEXTBOUNDRY__%%**@@",onLoadDeferred:null,fillInTemplate:function(){
dojo.event.topic.publish("dojo.widget.RichText::init",this);
this.open();
dojo.event.connect(this,"onKeyPressed",this,"afterKeyPress");
dojo.event.connect(this,"onKeyPress",this,"keyPress");
dojo.event.connect(this,"onKeyDown",this,"keyDown");
dojo.event.connect(this,"onKeyUp",this,"keyUp");
this.setupDefaultShortcuts();
},setupDefaultShortcuts:function(){
var ctrl=this.KEY_CTRL;
var exec=function(cmd,arg){
return arguments.length==1?function(){
this.execCommand(cmd);
}:function(){
this.execCommand(cmd,arg);
};
};
this.addKeyHandler("b",ctrl,exec("bold"));
this.addKeyHandler("i",ctrl,exec("italic"));
this.addKeyHandler("u",ctrl,exec("underline"));
this.addKeyHandler("a",ctrl,exec("selectall"));
this.addKeyHandler("s",ctrl,function(){
this.save(true);
});
this.addKeyHandler("1",ctrl,exec("formatblock","h1"));
this.addKeyHandler("2",ctrl,exec("formatblock","h2"));
this.addKeyHandler("3",ctrl,exec("formatblock","h3"));
this.addKeyHandler("4",ctrl,exec("formatblock","h4"));
this.addKeyHandler("\\",ctrl,exec("insertunorderedlist"));
if(!dojo.render.html.ie){
this.addKeyHandler("Z",ctrl,exec("redo"));
}
},events:["onBlur","onFocus","onKeyPress","onKeyDown","onKeyUp","onClick"],open:function(_8e5){
if(this.onLoadDeferred.fired>=0){
this.onLoadDeferred=new dojo.Deferred();
}
var h=dojo.render.html;
if(!this.isClosed){
this.close();
}
dojo.event.topic.publish("dojo.widget.RichText::open",this);
this._content="";
if((arguments.length==1)&&(_8e5["nodeName"])){
this.domNode=_8e5;
}
if((this.domNode["nodeName"])&&(this.domNode.nodeName.toLowerCase()=="textarea")){
this.textarea=this.domNode;
var html=this._preFilterContent(this.textarea.value);
this.domNode=dojo.doc().createElement("div");
dojo.html.copyStyle(this.domNode,this.textarea);
var _8e8=dojo.lang.hitch(this,function(){
with(this.textarea.style){
display="block";
position="absolute";
left=top="-1000px";
if(h.ie){
this.__overflow=overflow;
overflow="hidden";
}
}
});
if(h.ie){
setTimeout(_8e8,10);
}else{
_8e8();
}
if(!h.safari){
dojo.html.insertBefore(this.domNode,this.textarea);
}
if(this.textarea.form){
dojo.event.connect("before",this.textarea.form,"onsubmit",dojo.lang.hitch(this,function(){
this.textarea.value=this.getEditorContent();
}));
}
var _8e9=this;
dojo.event.connect(this,"postCreate",function(){
dojo.html.insertAfter(_8e9.textarea,_8e9.domNode);
});
}else{
var html=this._preFilterContent(dojo.string.trim(this.domNode.innerHTML));
}
if(html==""){
html="&nbsp;";
}
var _8ea=dojo.html.getContentBox(this.domNode);
this._oldHeight=_8ea.height;
this._oldWidth=_8ea.width;
this._firstChildContributingMargin=this._getContributingMargin(this.domNode,"top");
this._lastChildContributingMargin=this._getContributingMargin(this.domNode,"bottom");
this.savedContent=html;
this.domNode.innerHTML="";
this.editingArea=dojo.doc().createElement("div");
this.domNode.appendChild(this.editingArea);
if((this.domNode["nodeName"])&&(this.domNode.nodeName=="LI")){
this.domNode.innerHTML=" <br>";
}
if(this.saveName!=""&&(!djConfig["useXDomain"]||djConfig["allowXdRichTextSave"])){
var _8eb=dojo.doc().getElementById("dojo.widget.RichText.savedContent");
if(_8eb.value!=""){
var _8ec=_8eb.value.split(this._SEPARATOR);
for(var i=0;i<_8ec.length;i++){
var data=_8ec[i].split(":");
if(data[0]==this.saveName){
html=data[1];
_8ec.splice(i,1);
break;
}
}
}
dojo.event.connect("before",window,"onunload",this,"_saveContent");
}
if(h.ie70&&this.useActiveX){
dojo.debug("activeX in ie70 is not currently supported, useActiveX is ignored for now.");
this.useActiveX=false;
}
if(this.useActiveX&&h.ie){
var self=this;
setTimeout(function(){
self._drawObject(html);
},0);
}else{
if(h.ie||this._safariIsLeopard()||h.opera){
this.iframe=dojo.doc().createElement("iframe");
this.iframe.src="javascript:void(0)";
this.editorObject=this.iframe;
with(this.iframe.style){
border="0";
width="100%";
}
this.iframe.frameBorder=0;
this.editingArea.appendChild(this.iframe);
this.window=this.iframe.contentWindow;
this.document=this.window.document;
this.document.open();
this.document.write("<html><head><style>body{margin:0;padding:0;border:0;overflow:hidden;}</style></head><body><div></div></body></html>");
this.document.close();
this.editNode=this.document.body.firstChild;
this.editNode.contentEditable=true;
with(this.iframe.style){
if(h.ie70){
if(this.height){
height=this.height;
}
if(this.minHeight){
minHeight=this.minHeight;
}
}else{
height=this.height?this.height:this.minHeight;
}
}
var _8f0=["p","pre","address","h1","h2","h3","h4","h5","h6","ol","div","ul"];
var _8f1="";
for(var i in _8f0){
if(_8f0[i].charAt(1)!="l"){
_8f1+="<"+_8f0[i]+"><span>content</span></"+_8f0[i]+">";
}else{
_8f1+="<"+_8f0[i]+"><li>content</li></"+_8f0[i]+">";
}
}
with(this.editNode.style){
position="absolute";
left="-2000px";
top="-2000px";
}
this.editNode.innerHTML=_8f1;
var node=this.editNode.firstChild;
while(node){
dojo.withGlobal(this.window,"selectElement",dojo.html.selection,[node.firstChild]);
var _8f3=node.tagName.toLowerCase();
this._local2NativeFormatNames[_8f3]=this.queryCommandValue("formatblock");
this._native2LocalFormatNames[this._local2NativeFormatNames[_8f3]]=_8f3;
node=node.nextSibling;
}
with(this.editNode.style){
position="";
left="";
top="";
}
this.editNode.innerHTML=html;
if(this.height){
this.document.body.style.overflowY="scroll";
}
dojo.lang.forEach(this.events,function(e){
dojo.event.connect(this.editNode,e.toLowerCase(),this,e);
},this);
this.onLoad();
}else{
this._drawIframe(html);
this.editorObject=this.iframe;
}
}
if(this.domNode.nodeName=="LI"){
this.domNode.lastChild.style.marginTop="-1.2em";
}
dojo.html.addClass(this.domNode,"RichTextEditable");
this.isClosed=false;
},_hasCollapseableMargin:function(_8f5,side){
if(dojo.html.getPixelValue(_8f5,"border-"+side+"-width",false)){
return false;
}else{
if(dojo.html.getPixelValue(_8f5,"padding-"+side,false)){
return false;
}else{
return true;
}
}
},_getContributingMargin:function(_8f7,_8f8){
if(_8f8=="top"){
var _8f9="previousSibling";
var _8fa="nextSibling";
var _8fb="firstChild";
var _8fc="margin-top";
var _8fd="margin-bottom";
}else{
var _8f9="nextSibling";
var _8fa="previousSibling";
var _8fb="lastChild";
var _8fc="margin-bottom";
var _8fd="margin-top";
}
var _8fe=dojo.html.getPixelValue(_8f7,_8fc,false);
function isSignificantNode(_8ff){
return !(_8ff.nodeType==3&&dojo.string.isBlank(_8ff.data))&&dojo.html.getStyle(_8ff,"display")!="none"&&!dojo.html.isPositionAbsolute(_8ff);
}
var _900=0;
var _901=_8f7[_8fb];
while(_901){
while((!isSignificantNode(_901))&&_901[_8fa]){
_901=_901[_8fa];
}
_900=Math.max(_900,dojo.html.getPixelValue(_901,_8fc,false));
if(!this._hasCollapseableMargin(_901,_8f8)){
break;
}
_901=_901[_8fb];
}
if(!this._hasCollapseableMargin(_8f7,_8f8)){
return parseInt(_900);
}
var _902=0;
var _903=_8f7[_8f9];
while(_903){
if(isSignificantNode(_903)){
_902=dojo.html.getPixelValue(_903,_8fd,false);
break;
}
_903=_903[_8f9];
}
if(!_903){
_902=dojo.html.getPixelValue(_8f7.parentNode,_8fc,false);
}
if(_900>_8fe){
return parseInt(Math.max((_900-_8fe)-_902,0));
}else{
return 0;
}
},_drawIframe:function(html){
var _905=Boolean(dojo.render.html.moz&&(typeof window.XML=="undefined"));
if(!this.iframe){
var _906=(new dojo.uri.Uri(dojo.doc().location)).host;
this.iframe=dojo.doc().createElement("iframe");
with(this.iframe){
style.border="none";
style.lineHeight="0";
style.verticalAlign="bottom";
scrolling=this.height?"auto":"no";
}
}
if(djConfig["useXDomain"]&&!djConfig["dojoRichTextFrameUrl"]){
dojo.debug("dojo.widget.RichText: When using cross-domain Dojo builds,"+" please save src/widget/templates/richtextframe.html to your domain and set djConfig.dojoRichTextFrameUrl"+" to the path on your domain to richtextframe.html");
}
this.iframe.src=(djConfig["dojoRichTextFrameUrl"]||dojo.uri.moduleUri("dojo.widget","templates/richtextframe.html"))+((dojo.doc().domain!=_906)?("#"+dojo.doc().domain):"");
this.iframe.width=this.inheritWidth?this._oldWidth:"100%";
if(this.height){
this.iframe.style.height=this.height;
}else{
var _907=this._oldHeight;
if(this._hasCollapseableMargin(this.domNode,"top")){
_907+=this._firstChildContributingMargin;
}
if(this._hasCollapseableMargin(this.domNode,"bottom")){
_907+=this._lastChildContributingMargin;
}
this.iframe.height=_907;
}
var _908=dojo.doc().createElement("div");
_908.innerHTML=html;
this.editingArea.appendChild(_908);
if(this.relativeImageUrls){
var imgs=_908.getElementsByTagName("img");
for(var i=0;i<imgs.length;i++){
imgs[i].src=(new dojo.uri.Uri(dojo.global().location,imgs[i].src)).toString();
}
html=_908.innerHTML;
}
var _90b=dojo.html.firstElement(_908);
var _90c=dojo.html.lastElement(_908);
if(_90b){
_90b.style.marginTop=this._firstChildContributingMargin+"px";
}
if(_90c){
_90c.style.marginBottom=this._lastChildContributingMargin+"px";
}
this.editingArea.appendChild(this.iframe);
if(dojo.render.html.safari){
this.iframe.src=this.iframe.src;
}
var _90d=false;
var _90e=dojo.lang.hitch(this,function(){
if(!_90d){
_90d=true;
}else{
return;
}
if(!this.editNode){
if(this.iframe.contentWindow){
this.window=this.iframe.contentWindow;
this.document=this.iframe.contentWindow.document;
}else{
if(this.iframe.contentDocument){
this.window=this.iframe.contentDocument.window;
this.document=this.iframe.contentDocument;
}
}
var _90f=(function(_910){
return function(_911){
return dojo.html.getStyle(_910,_911);
};
})(this.domNode);
var font=_90f("font-weight")+" "+_90f("font-size")+" "+_90f("font-family");
var _913="1.0";
var _914=dojo.html.getUnitValue(this.domNode,"line-height");
if(_914.value&&_914.units==""){
_913=_914.value;
}
dojo.html.insertCssText("body,html{background:transparent;padding:0;margin:0;}"+"body{top:0;left:0;right:0;"+(((this.height)||(dojo.render.html.opera))?"":"position:fixed;")+"font:"+font+";"+"min-height:"+this.minHeight+";"+"line-height:"+_913+"}"+"p{margin: 1em 0 !important;}"+"body > *:first-child{padding-top:0 !important;margin-top:"+this._firstChildContributingMargin+"px !important;}"+"body > *:last-child{padding-bottom:0 !important;margin-bottom:"+this._lastChildContributingMargin+"px !important;}"+"li > ul:-moz-first-node, li > ol:-moz-first-node{padding-top:1.2em;}\n"+"li{min-height:1.2em;}"+"",this.document);
dojo.html.removeNode(_908);
this.document.body.innerHTML=html;
if(_905||dojo.render.html.safari){
this.document.designMode="on";
}
this.onLoad();
}else{
dojo.html.removeNode(_908);
this.editNode.innerHTML=html;
this.onDisplayChanged();
}
});
if(this.editNode){
_90e();
}else{
if(dojo.render.html.moz){
this.iframe.onload=function(){
setTimeout(_90e,250);
};
}else{
this.iframe.onload=_90e;
}
}
},_applyEditingAreaStyleSheets:function(){
var _915=[];
if(this.styleSheets){
_915=this.styleSheets.split(";");
this.styleSheets="";
}
_915=_915.concat(this.editingAreaStyleSheets);
this.editingAreaStyleSheets=[];
if(_915.length>0){
for(var i=0;i<_915.length;i++){
var url=_915[i];
if(url){
this.addStyleSheet(dojo.uri.dojoUri(url));
}
}
}
},addStyleSheet:function(uri){
var url=uri.toString();
if(dojo.lang.find(this.editingAreaStyleSheets,url)>-1){
dojo.debug("dojo.widget.RichText.addStyleSheet: Style sheet "+url+" is already applied to the editing area!");
return;
}
if(url.charAt(0)=="."||(url.charAt(0)!="/"&&!uri.host)){
url=(new dojo.uri.Uri(dojo.global().location,url)).toString();
}
this.editingAreaStyleSheets.push(url);
if(this.document.createStyleSheet){
this.document.createStyleSheet(url);
}else{
var head=this.document.getElementsByTagName("head")[0];
var _91b=this.document.createElement("link");
with(_91b){
rel="stylesheet";
type="text/css";
href=url;
}
head.appendChild(_91b);
}
},removeStyleSheet:function(uri){
var url=uri.toString();
if(url.charAt(0)=="."||(url.charAt(0)!="/"&&!uri.host)){
url=(new dojo.uri.Uri(dojo.global().location,url)).toString();
}
var _91e=dojo.lang.find(this.editingAreaStyleSheets,url);
if(_91e==-1){
dojo.debug("dojo.widget.RichText.removeStyleSheet: Style sheet "+url+" is not applied to the editing area so it can not be removed!");
return;
}
delete this.editingAreaStyleSheets[_91e];
var _91f=this.document.getElementsByTagName("link");
for(var i=0;i<_91f.length;i++){
if(_91f[i].href==url){
if(dojo.render.html.ie){
_91f[i].href="";
}
dojo.html.removeNode(_91f[i]);
break;
}
}
},_drawObject:function(html){
this.object=dojo.html.createExternalElement(dojo.doc(),"object");
with(this.object){
classid="clsid:2D360201-FFF5-11D1-8D03-00A0C959BC0A";
width=this.inheritWidth?this._oldWidth:"100%";
style.height=this.height?this.height:(this._oldHeight+"px");
Scrollbars=this.height?true:false;
Appearance=this._activeX.appearance.flat;
}
this.editorObject=this.object;
this.editingArea.appendChild(this.object);
this.object.attachEvent("DocumentComplete",dojo.lang.hitch(this,"onLoad"));
dojo.lang.forEach(this.events,function(e){
this.object.attachEvent(e.toLowerCase(),dojo.lang.hitch(this,e));
},this);
this.object.DocumentHTML="<!doctype HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">"+"<html><title></title>"+"<style type=\"text/css\">"+"\tbody,html { padding: 0; margin: 0; }"+(this.height?"":"\tbody,  { overflow: hidden; }")+"</style>"+"<body><div>"+html+"<div></body></html>";
this._cacheLocalBlockFormatNames();
},_local2NativeFormatNames:{},_native2LocalFormatNames:{},_cacheLocalBlockFormatNames:function(){
if(!this._native2LocalFormatNames["p"]){
var obj=this.object;
var _924=false;
if(!obj){
try{
obj=dojo.html.createExternalElement(dojo.doc(),"object");
obj.classid="clsid:2D360201-FFF5-11D1-8D03-00A0C959BC0A";
dojo.body().appendChild(obj);
obj.DocumentHTML="<html><head></head><body></body></html>";
}
catch(e){
_924=true;
}
}
try{
var _925=new ActiveXObject("DEGetBlockFmtNamesParam.DEGetBlockFmtNamesParam");
obj.ExecCommand(this._activeX.command["getblockformatnames"],0,_925);
var _926=new VBArray(_925.Names);
var _927=_926.toArray();
var _928=["p","pre","address","h1","h2","h3","h4","h5","h6","ol","ul","","","","","div"];
for(var i=0;i<_928.length;++i){
if(_928[i].length>0){
this._local2NativeFormatNames[_927[i]]=_928[i];
this._native2LocalFormatNames[_928[i]]=_927[i];
}
}
}
catch(e){
_924=true;
}
if(obj&&!this.object){
dojo.body().removeChild(obj);
}
}
return !_924;
},_isResized:function(){
return false;
},onLoad:function(e){
this.isLoaded=true;
if(this.object){
this.document=this.object.DOM;
this.window=this.document.parentWindow;
this.editNode=this.document.body.firstChild;
this.editingArea.style.height=this.height?this.height:this.minHeight;
if(!this.height){
this.connect(this,"onDisplayChanged","_updateHeight");
}
this.window._frameElement=this.object;
}else{
if(this.iframe&&!dojo.render.html.ie){
this.editNode=this.document.body;
if(!this.height){
this.connect(this,"onDisplayChanged","_updateHeight");
}
try{
this.document.execCommand("useCSS",false,true);
this.document.execCommand("styleWithCSS",false,false);
}
catch(e2){
}
if(dojo.render.html.safari){
this.connect(this.editNode,"onblur","onBlur");
this.connect(this.editNode,"onfocus","onFocus");
this.connect(this.editNode,"onclick","onFocus");
this.interval=setInterval(dojo.lang.hitch(this,"onDisplayChanged"),750);
}else{
if(dojo.render.html.mozilla||dojo.render.html.opera){
var doc=this.document;
var _92c=dojo.event.browser.addListener;
var self=this;
dojo.lang.forEach(this.events,function(e){
var l=_92c(self.document,e.substr(2).toLowerCase(),dojo.lang.hitch(self,e));
if(e=="onBlur"){
var _930={unBlur:function(e){
dojo.event.browser.removeListener(doc,"blur",l);
}};
dojo.event.connect("before",self,"close",_930,"unBlur");
}
});
}
}
}else{
if(dojo.render.html.ie){
if(!this.height){
this.connect(this,"onDisplayChanged","_updateHeight");
}
this.editNode.style.zoom=1;
}
}
}
this._applyEditingAreaStyleSheets();
if(this.focusOnLoad){
this.focus();
}
this.onDisplayChanged(e);
if(this.onLoadDeferred){
this.onLoadDeferred.callback(true);
}
},onKeyDown:function(e){
if((!e)&&(this.object)){
e=dojo.event.browser.fixEvent(this.window.event);
}
if((dojo.render.html.ie)&&(e.keyCode==e.KEY_TAB)){
e.preventDefault();
e.stopPropagation();
this.execCommand((e.shiftKey?"outdent":"indent"));
}else{
if(dojo.render.html.ie){
if((65<=e.keyCode)&&(e.keyCode<=90)){
e.charCode=e.keyCode;
this.onKeyPress(e);
}
}
}
},onKeyUp:function(e){
return;
},KEY_CTRL:1,onKeyPress:function(e){
if((!e)&&(this.object)){
e=dojo.event.browser.fixEvent(this.window.event);
}
var _935=e.ctrlKey?this.KEY_CTRL:0;
if(this._keyHandlers[e.key]){
var _936=this._keyHandlers[e.key],i=0,_938;
while(_938=_936[i++]){
if(_935==_938.modifiers){
e.preventDefault();
_938.handler.call(this);
break;
}
}
}
dojo.lang.setTimeout(this,this.onKeyPressed,1,e);
},addKeyHandler:function(key,_93a,_93b){
if(!(this._keyHandlers[key] instanceof Array)){
this._keyHandlers[key]=[];
}
this._keyHandlers[key].push({modifiers:_93a||0,handler:_93b});
},onKeyPressed:function(e){
this.onDisplayChanged();
},onClick:function(e){
this.onDisplayChanged(e);
},onBlur:function(e){
},_initialFocus:true,onFocus:function(e){
if((dojo.render.html.mozilla)&&(this._initialFocus)){
this._initialFocus=false;
if(dojo.string.trim(this.editNode.innerHTML)=="&nbsp;"){
this.placeCursorAtStart();
}
}
},blur:function(){
if(this.iframe){
this.window.blur();
}else{
if(this.object){
this.document.body.blur();
}else{
if(this.editNode){
this.editNode.blur();
}
}
}
},focus:function(){
if(this.iframe&&!dojo.render.html.ie){
this.window.focus();
}else{
if(this.object){
this.document.focus();
}else{
if(this.editNode&&this.editNode.focus){
this.editNode.focus();
}else{
dojo.debug("Have no idea how to focus into the editor!");
}
}
}
},onDisplayChanged:function(e){
},_activeX:{command:{bold:5000,italic:5023,underline:5048,justifycenter:5024,justifyleft:5025,justifyright:5026,cut:5003,copy:5002,paste:5032,"delete":5004,undo:5049,redo:5033,removeformat:5034,selectall:5035,unlink:5050,indent:5018,outdent:5031,insertorderedlist:5030,insertunorderedlist:5051,inserttable:5022,insertcell:5019,insertcol:5020,insertrow:5021,deletecells:5005,deletecols:5006,deleterows:5007,mergecells:5029,splitcell:5047,setblockformat:5043,getblockformat:5011,getblockformatnames:5012,setfontname:5044,getfontname:5013,setfontsize:5045,getfontsize:5014,setbackcolor:5042,getbackcolor:5010,setforecolor:5046,getforecolor:5015,findtext:5008,font:5009,hyperlink:5016,image:5017,lockelement:5027,makeabsolute:5028,sendbackward:5036,bringforward:5037,sendbelowtext:5038,bringabovetext:5039,sendtoback:5040,bringtofront:5041,properties:5052},ui:{"default":0,prompt:1,noprompt:2},status:{notsupported:0,disabled:1,enabled:3,latched:7,ninched:11},appearance:{flat:0,inset:1},state:{unchecked:0,checked:1,gray:2}},_normalizeCommand:function(cmd){
var drh=dojo.render.html;
var _943=cmd.toLowerCase();
if(_943=="formatblock"){
if(drh.safari){
_943="heading";
}
}else{
if(this.object){
switch(_943){
case "createlink":
_943="hyperlink";
break;
case "insertimage":
_943="image";
break;
}
}else{
if(_943=="hilitecolor"&&!drh.mozilla){
_943="backcolor";
}
}
}
return _943;
},_safariIsLeopard:function(){
var _944=false;
if(dojo.render.html.safari){
var tmp=dojo.render.html.UA.split("AppleWebKit/")[1];
var ver=parseFloat(tmp.split(" ")[0]);
if(ver>=420){
_944=true;
}
}
return _944;
},queryCommandAvailable:function(_947){
var ie=1;
var _949=1<<1;
var _94a=1<<2;
var _94b=1<<3;
var _94c=1<<4;
var _94d=this._safariIsLeopard();
function isSupportedBy(_94e){
return {ie:Boolean(_94e&ie),mozilla:Boolean(_94e&_949),safari:Boolean(_94e&_94a),safari420:Boolean(_94e&_94c),opera:Boolean(_94e&_94b)};
}
var _94f=null;
switch(_947.toLowerCase()){
case "bold":
case "italic":
case "underline":
case "subscript":
case "superscript":
case "fontname":
case "fontsize":
case "forecolor":
case "hilitecolor":
case "justifycenter":
case "justifyfull":
case "justifyleft":
case "justifyright":
case "delete":
case "selectall":
_94f=isSupportedBy(_949|ie|_94a|_94b);
break;
case "createlink":
case "unlink":
case "removeformat":
case "inserthorizontalrule":
case "insertimage":
case "insertorderedlist":
case "insertunorderedlist":
case "indent":
case "outdent":
case "formatblock":
case "inserthtml":
case "undo":
case "redo":
case "strikethrough":
_94f=isSupportedBy(_949|ie|_94b|_94c);
break;
case "blockdirltr":
case "blockdirrtl":
case "dirltr":
case "dirrtl":
case "inlinedirltr":
case "inlinedirrtl":
_94f=isSupportedBy(ie);
break;
case "cut":
case "copy":
case "paste":
_94f=isSupportedBy(ie|_949|_94c);
break;
case "inserttable":
_94f=isSupportedBy(_949|(this.object?ie:0));
break;
case "insertcell":
case "insertcol":
case "insertrow":
case "deletecells":
case "deletecols":
case "deleterows":
case "mergecells":
case "splitcell":
_94f=isSupportedBy(this.object?ie:0);
break;
default:
return false;
}
return (dojo.render.html.ie&&_94f.ie)||(dojo.render.html.mozilla&&_94f.mozilla)||(dojo.render.html.safari&&_94f.safari)||(_94d&&_94f.safari420)||(dojo.render.html.opera&&_94f.opera);
},execCommand:function(_950,_951){
var _952;
this.focus();
_950=this._normalizeCommand(_950);
if(_951!=undefined){
if(_950=="heading"){
throw new Error("unimplemented");
}else{
if(_950=="formatblock"){
if(this.object){
_951=this._native2LocalFormatNames[_951];
}else{
if(dojo.render.html.ie){
_951="<"+_951+">";
}
}
}
}
}
if(this.object){
switch(_950){
case "hilitecolor":
_950="setbackcolor";
break;
case "forecolor":
case "backcolor":
case "fontsize":
case "fontname":
_950="set"+_950;
break;
case "formatblock":
_950="setblockformat";
}
if(_950=="strikethrough"){
_950="inserthtml";
var _953=this.document.selection.createRange();
if(!_953.htmlText){
return;
}
_951=_953.htmlText.strike();
}else{
if(_950=="inserthorizontalrule"){
_950="inserthtml";
_951="<hr>";
}
}
if(_950=="inserthtml"){
var _953=this.document.selection.createRange();
if(this.document.selection.type.toUpperCase()=="CONTROL"){
for(var i=0;i<_953.length;i++){
_953.item(i).outerHTML=_951;
}
}else{
_953.pasteHTML(_951);
_953.select();
}
_952=true;
}else{
if(arguments.length==1){
_952=this.object.ExecCommand(this._activeX.command[_950],this._activeX.ui.noprompt);
}else{
_952=this.object.ExecCommand(this._activeX.command[_950],this._activeX.ui.noprompt,_951);
}
}
}else{
if(_950=="inserthtml"){
if(dojo.render.html.ie){
var _955=this.document.selection.createRange();
_955.pasteHTML(_951);
_955.select();
return true;
}else{
return this.document.execCommand(_950,false,_951);
}
}else{
if((_950=="unlink")&&(this.queryCommandEnabled("unlink"))&&(dojo.render.html.mozilla)){
var _956=this.window.getSelection();
var _957=_956.getRangeAt(0);
var _958=_957.startContainer;
var _959=_957.startOffset;
var _95a=_957.endContainer;
var _95b=_957.endOffset;
var a=dojo.withGlobal(this.window,"getAncestorElement",dojo.html.selection,["a"]);
dojo.withGlobal(this.window,"selectElement",dojo.html.selection,[a]);
_952=this.document.execCommand("unlink",false,null);
var _957=this.document.createRange();
_957.setStart(_958,_959);
_957.setEnd(_95a,_95b);
_956.removeAllRanges();
_956.addRange(_957);
return _952;
}else{
if((_950=="hilitecolor")&&(dojo.render.html.mozilla)){
this.document.execCommand("useCSS",false,false);
_952=this.document.execCommand(_950,false,_951);
this.document.execCommand("useCSS",false,true);
}else{
if((dojo.render.html.ie)&&((_950=="backcolor")||(_950=="forecolor"))){
_951=arguments.length>1?_951:null;
_952=this.document.execCommand(_950,false,_951);
}else{
_951=arguments.length>1?_951:null;
if(_951||_950!="createlink"){
_952=this.document.execCommand(_950,false,_951);
}
}
}
}
}
}
this.onDisplayChanged();
return _952;
},queryCommandEnabled:function(_95d){
_95d=this._normalizeCommand(_95d);
if(this.object){
switch(_95d){
case "hilitecolor":
_95d="setbackcolor";
break;
case "forecolor":
case "backcolor":
case "fontsize":
case "fontname":
_95d="set"+_95d;
break;
case "formatblock":
_95d="setblockformat";
break;
case "strikethrough":
_95d="bold";
break;
case "inserthorizontalrule":
return true;
}
if(typeof this._activeX.command[_95d]=="undefined"){
return false;
}
var _95e=this.object.QueryStatus(this._activeX.command[_95d]);
return ((_95e!=this._activeX.status.notsupported)&&(_95e!=this._activeX.status.disabled));
}else{
if(dojo.render.html.mozilla){
if(_95d=="unlink"){
return dojo.withGlobal(this.window,"hasAncestorElement",dojo.html.selection,["a"]);
}else{
if(_95d=="inserttable"){
return true;
}
}
}
var elem=(dojo.render.html.ie)?this.document.selection.createRange():this.document;
return elem.queryCommandEnabled(_95d);
}
},queryCommandState:function(_960){
_960=this._normalizeCommand(_960);
if(this.object){
if(_960=="forecolor"){
_960="setforecolor";
}else{
if(_960=="backcolor"){
_960="setbackcolor";
}else{
if(_960=="strikethrough"){
return dojo.withGlobal(this.window,"hasAncestorElement",dojo.html.selection,["strike"]);
}else{
if(_960=="inserthorizontalrule"){
return false;
}
}
}
}
if(typeof this._activeX.command[_960]=="undefined"){
return null;
}
var _961=this.object.QueryStatus(this._activeX.command[_960]);
return ((_961==this._activeX.status.latched)||(_961==this._activeX.status.ninched));
}else{
return this.document.queryCommandState(_960);
}
},queryCommandValue:function(_962){
_962=this._normalizeCommand(_962);
if(this.object){
switch(_962){
case "forecolor":
case "backcolor":
case "fontsize":
case "fontname":
_962="get"+_962;
return this.object.execCommand(this._activeX.command[_962],this._activeX.ui.noprompt);
case "formatblock":
var _963=this.object.execCommand(this._activeX.command["getblockformat"],this._activeX.ui.noprompt);
if(_963){
return this._local2NativeFormatNames[_963];
}
}
}else{
if(dojo.render.html.ie&&_962=="formatblock"){
return this._local2NativeFormatNames[this.document.queryCommandValue(_962)]||this.document.queryCommandValue(_962);
}
return this.document.queryCommandValue(_962);
}
},placeCursorAtStart:function(){
this.focus();
if(dojo.render.html.moz&&this.editNode.firstChild&&this.editNode.firstChild.nodeType!=dojo.dom.TEXT_NODE){
dojo.withGlobal(this.window,"selectElementChildren",dojo.html.selection,[this.editNode.firstChild]);
}else{
dojo.withGlobal(this.window,"selectElementChildren",dojo.html.selection,[this.editNode]);
}
dojo.withGlobal(this.window,"collapse",dojo.html.selection,[true]);
},placeCursorAtEnd:function(){
this.focus();
if(dojo.render.html.moz&&this.editNode.lastChild&&this.editNode.lastChild.nodeType!=dojo.dom.TEXT_NODE){
dojo.withGlobal(this.window,"selectElementChildren",dojo.html.selection,[this.editNode.lastChild]);
}else{
dojo.withGlobal(this.window,"selectElementChildren",dojo.html.selection,[this.editNode]);
}
dojo.withGlobal(this.window,"collapse",dojo.html.selection,[false]);
},replaceEditorContent:function(html){
html=this._preFilterContent(html);
if(this.isClosed){
this.domNode.innerHTML=html;
}else{
if(this.window&&this.window.getSelection&&!dojo.render.html.moz){
this.editNode.innerHTML=html;
}else{
if((this.window&&this.window.getSelection)||(this.document&&this.document.selection)){
this.execCommand("selectall");
if(dojo.render.html.moz&&!html){
html="&nbsp;";
}
this.execCommand("inserthtml",html);
}
}
}
},_preFilterContent:function(html){
var ec=html;
dojo.lang.forEach(this.contentPreFilters,function(ef){
ec=ef(ec);
});
if(this.contentDomPreFilters.length>0){
var dom=dojo.doc().createElement("div");
dom.style.display="none";
dojo.body().appendChild(dom);
dom.innerHTML=ec;
dojo.lang.forEach(this.contentDomPreFilters,function(ef){
dom=ef(dom);
});
ec=dom.innerHTML;
dojo.body().removeChild(dom);
}
return ec;
},_postFilterContent:function(html){
var ec=html;
if(this.contentDomPostFilters.length>0){
var dom=this.document.createElement("div");
dom.innerHTML=ec;
dojo.lang.forEach(this.contentDomPostFilters,function(ef){
dom=ef(dom);
});
ec=dom.innerHTML;
}
dojo.lang.forEach(this.contentPostFilters,function(ef){
ec=ef(ec);
});
return ec;
},_lastHeight:0,_updateHeight:function(){
if(!this.isLoaded){
return;
}
if(this.height){
return;
}
var _96f=dojo.html.getBorderBox(this.editNode).height;
if(!_96f){
_96f=dojo.html.getBorderBox(this.document.body).height;
}
if(_96f==0){
dojo.debug("Can not figure out the height of the editing area!");
return;
}
this._lastHeight=_96f;
this.editorObject.style.height=this._lastHeight+"px";
this.window.scrollTo(0,0);
},_saveContent:function(e){
var _971=dojo.doc().getElementById("dojo.widget.RichText.savedContent");
_971.value+=this._SEPARATOR+this.saveName+":"+this.getEditorContent();
},getEditorContent:function(){
var ec="";
try{
ec=(this._content.length>0)?this._content:this.editNode.innerHTML;
if(dojo.string.trim(ec)=="&nbsp;"){
ec="";
}
}
catch(e){
}
if(dojo.render.html.ie&&!this.object){
var re=new RegExp("(?:<p>&nbsp;</p>[\n\r]*)+$","i");
ec=ec.replace(re,"");
}
ec=this._postFilterContent(ec);
if(this.relativeImageUrls){
var _974=dojo.global().location.protocol+"//"+dojo.global().location.host;
var _975=dojo.global().location.pathname;
if(_975.match(/\/$/)){
}else{
var _976=_975.split("/");
if(_976.length){
_976.pop();
}
_975=_976.join("/")+"/";
}
var _977=new RegExp("(<img[^>]* src=[\"'])("+_974+"("+_975+")?)","ig");
ec=ec.replace(_977,"$1");
}
return ec;
},close:function(save,_979){
if(this.isClosed){
return false;
}
if(arguments.length==0){
save=true;
}
this._content=this._postFilterContent(this.editNode.innerHTML);
var _97a=(this.savedContent!=this._content);
if(this.interval){
clearInterval(this.interval);
}
if(dojo.render.html.ie&&!this.object){
dojo.event.browser.clean(this.editNode);
}
if(this.iframe){
delete this.iframe;
}
if(this.textarea){
with(this.textarea.style){
position="";
left=top="";
if(dojo.render.html.ie){
overflow=this.__overflow;
this.__overflow=null;
}
}
if(save){
this.textarea.value=this._content;
}else{
this.textarea.value=this.savedContent;
}
dojo.html.removeNode(this.domNode);
this.domNode=this.textarea;
}else{
if(save){
if(dojo.render.html.moz){
var nc=dojo.doc().createElement("span");
this.domNode.appendChild(nc);
nc.innerHTML=this.editNode.innerHTML;
}else{
this.domNode.innerHTML=this._content;
}
}else{
this.domNode.innerHTML=this.savedContent;
}
}
dojo.html.removeClass(this.domNode,"RichTextEditable");
this.isClosed=true;
this.isLoaded=false;
delete this.editNode;
if(this.window._frameElement){
this.window._frameElement=null;
}
this.window=null;
this.document=null;
this.object=null;
this.editingArea=null;
this.editorObject=null;
return _97a;
},destroyRendering:function(){
},destroy:function(){
this.destroyRendering();
if(!this.isClosed){
this.close(false);
}
dojo.widget.RichText.superclass.destroy.call(this);
},connect:function(_97c,_97d,_97e){
dojo.event.connect(_97c,_97d,this,_97e);
},disconnect:function(_97f,_980,_981){
dojo.event.disconnect(_97f,_980,this,_981);
},disconnectAllWithRoot:function(_982){
dojo.deprecated("disconnectAllWithRoot","is deprecated. No need to disconnect manually","0.5");
},_fixContentForMoz:function(html){
html=html.replace(/<strong([ \>])/gi,"<b$1");
html=html.replace(/<\/strong>/gi,"</b>");
html=html.replace(/<em([ \>])/gi,"<i$1");
html=html.replace(/<\/em>/gi,"</i>");
return html;
}});
dojo.provide("dojo.lang.type");
dojo.lang.whatAmI=function(_984){
dojo.deprecated("dojo.lang.whatAmI","use dojo.lang.getType instead","0.5");
return dojo.lang.getType(_984);
};
dojo.lang.whatAmI.custom={};
dojo.lang.getType=function(_985){
try{
if(dojo.lang.isArray(_985)){
return "array";
}
if(dojo.lang.isFunction(_985)){
return "function";
}
if(dojo.lang.isString(_985)){
return "string";
}
if(dojo.lang.isNumber(_985)){
return "number";
}
if(dojo.lang.isBoolean(_985)){
return "boolean";
}
if(dojo.lang.isAlien(_985)){
return "alien";
}
if(dojo.lang.isUndefined(_985)){
return "undefined";
}
for(var name in dojo.lang.whatAmI.custom){
if(dojo.lang.whatAmI.custom[name](_985)){
return name;
}
}
if(dojo.lang.isObject(_985)){
return "object";
}
}
catch(e){
}
return "unknown";
};
dojo.lang.isNumeric=function(_987){
return (!isNaN(_987)&&isFinite(_987)&&(_987!=null)&&!dojo.lang.isBoolean(_987)&&!dojo.lang.isArray(_987)&&!/^\s*$/.test(_987));
};
dojo.lang.isBuiltIn=function(_988){
return (dojo.lang.isArray(_988)||dojo.lang.isFunction(_988)||dojo.lang.isString(_988)||dojo.lang.isNumber(_988)||dojo.lang.isBoolean(_988)||(_988==null)||(_988 instanceof Error)||(typeof _988=="error"));
};
dojo.lang.isPureObject=function(_989){
return ((_989!=null)&&dojo.lang.isObject(_989)&&_989.constructor==Object);
};
dojo.lang.isOfType=function(_98a,type,_98c){
var _98d=false;
if(_98c){
_98d=_98c["optional"];
}
if(_98d&&((_98a===null)||dojo.lang.isUndefined(_98a))){
return true;
}
if(dojo.lang.isArray(type)){
var _98e=type;
for(var i in _98e){
var _990=_98e[i];
if(dojo.lang.isOfType(_98a,_990)){
return true;
}
}
return false;
}else{
if(dojo.lang.isString(type)){
type=type.toLowerCase();
}
switch(type){
case Array:
case "array":
return dojo.lang.isArray(_98a);
case Function:
case "function":
return dojo.lang.isFunction(_98a);
case String:
case "string":
return dojo.lang.isString(_98a);
case Number:
case "number":
return dojo.lang.isNumber(_98a);
case "numeric":
return dojo.lang.isNumeric(_98a);
case Boolean:
case "boolean":
return dojo.lang.isBoolean(_98a);
case Object:
case "object":
return dojo.lang.isObject(_98a);
case "pureobject":
return dojo.lang.isPureObject(_98a);
case "builtin":
return dojo.lang.isBuiltIn(_98a);
case "alien":
return dojo.lang.isAlien(_98a);
case "undefined":
return dojo.lang.isUndefined(_98a);
case null:
case "null":
return (_98a===null);
case "optional":
dojo.deprecated("dojo.lang.isOfType(value, [type, \"optional\"])","use dojo.lang.isOfType(value, type, {optional: true} ) instead","0.5");
return ((_98a===null)||dojo.lang.isUndefined(_98a));
default:
if(dojo.lang.isFunction(type)){
return (_98a instanceof type);
}else{
dojo.raise("dojo.lang.isOfType() was passed an invalid type");
}
}
}
dojo.raise("If we get here, it means a bug was introduced above.");
};
dojo.lang.getObject=function(str){
var _992=str.split("."),i=0,obj=dj_global;
do{
obj=obj[_992[i++]];
}while(i<_992.length&&obj);
return (obj!=dj_global)?obj:null;
};
dojo.lang.doesObjectExist=function(str){
var _996=str.split("."),i=0,obj=dj_global;
do{
obj=obj[_996[i++]];
}while(i<_996.length&&obj);
return (obj&&obj!=dj_global);
};
dojo.provide("dojo.lang.assert");
dojo.lang.assert=function(_999,_99a){
if(!_999){
var _99b="An assert statement failed.\n"+"The method dojo.lang.assert() was called with a 'false' value.\n";
if(_99a){
_99b+="Here's the assert message:\n"+_99a+"\n";
}
throw new Error(_99b);
}
};
dojo.lang.assertType=function(_99c,type,_99e){
if(dojo.lang.isString(_99e)){
dojo.deprecated("dojo.lang.assertType(value, type, \"message\")","use dojo.lang.assertType(value, type) instead","0.5");
}
if(!dojo.lang.isOfType(_99c,type,_99e)){
if(!dojo.lang.assertType._errorMessage){
dojo.lang.assertType._errorMessage="Type mismatch: dojo.lang.assertType() failed.";
}
dojo.lang.assert(false,dojo.lang.assertType._errorMessage);
}
};
dojo.lang.assertValidKeywords=function(_99f,_9a0,_9a1){
var key;
if(!_9a1){
if(!dojo.lang.assertValidKeywords._errorMessage){
dojo.lang.assertValidKeywords._errorMessage="In dojo.lang.assertValidKeywords(), found invalid keyword:";
}
_9a1=dojo.lang.assertValidKeywords._errorMessage;
}
if(dojo.lang.isArray(_9a0)){
for(key in _99f){
if(!dojo.lang.inArray(_9a0,key)){
dojo.lang.assert(false,_9a1+" "+key);
}
}
}else{
for(key in _99f){
if(!(key in _9a0)){
dojo.lang.assert(false,_9a1+" "+key);
}
}
}
};
dojo.provide("dojo.AdapterRegistry");
dojo.AdapterRegistry=function(_9a3){
this.pairs=[];
this.returnWrappers=_9a3||false;
};
dojo.lang.extend(dojo.AdapterRegistry,{register:function(name,_9a5,wrap,_9a7,_9a8){
var type=(_9a8)?"unshift":"push";
this.pairs[type]([name,_9a5,wrap,_9a7]);
},match:function(){
for(var i=0;i<this.pairs.length;i++){
var pair=this.pairs[i];
if(pair[1].apply(this,arguments)){
if((pair[3])||(this.returnWrappers)){
return pair[2];
}else{
return pair[2].apply(this,arguments);
}
}
}
throw new Error("No match found");
},unregister:function(name){
for(var i=0;i<this.pairs.length;i++){
var pair=this.pairs[i];
if(pair[0]==name){
this.pairs.splice(i,1);
return true;
}
}
return false;
}});
dojo.provide("dojo.lang.repr");
dojo.lang.reprRegistry=new dojo.AdapterRegistry();
dojo.lang.registerRepr=function(name,_9b0,wrap,_9b2){
dojo.lang.reprRegistry.register(name,_9b0,wrap,_9b2);
};
dojo.lang.repr=function(obj){
if(typeof (obj)=="undefined"){
return "undefined";
}else{
if(obj===null){
return "null";
}
}
try{
if(typeof (obj["__repr__"])=="function"){
return obj["__repr__"]();
}else{
if((typeof (obj["repr"])=="function")&&(obj.repr!=arguments.callee)){
return obj["repr"]();
}
}
return dojo.lang.reprRegistry.match(obj);
}
catch(e){
if(typeof (obj.NAME)=="string"&&(obj.toString==Function.prototype.toString||obj.toString==Object.prototype.toString)){
return obj.NAME;
}
}
if(typeof (obj)=="function"){
obj=(obj+"").replace(/^\s+/,"");
var idx=obj.indexOf("{");
if(idx!=-1){
obj=obj.substr(0,idx)+"{...}";
}
}
return obj+"";
};
dojo.lang.reprArrayLike=function(arr){
try{
var na=dojo.lang.map(arr,dojo.lang.repr);
return "["+na.join(", ")+"]";
}
catch(e){
}
};
(function(){
var m=dojo.lang;
m.registerRepr("arrayLike",m.isArrayLike,m.reprArrayLike);
m.registerRepr("string",m.isString,m.reprString);
m.registerRepr("numbers",m.isNumber,m.reprNumber);
m.registerRepr("boolean",m.isBoolean,m.reprNumber);
})();
dojo.kwCompoundRequire({common:["dojo.lang.common","dojo.lang.assert","dojo.lang.array","dojo.lang.type","dojo.lang.func","dojo.lang.extras","dojo.lang.repr","dojo.lang.declare"]});
dojo.provide("dojo.lang.*");
dojo.provide("dojo.html.iframe");
dojo.html.iframeContentWindow=function(_9b8){
var win=dojo.html.getDocumentWindow(dojo.html.iframeContentDocument(_9b8))||dojo.html.iframeContentDocument(_9b8).__parent__||(_9b8.name&&document.frames[_9b8.name])||null;
return win;
};
dojo.html.iframeContentDocument=function(_9ba){
var doc=_9ba.contentDocument||((_9ba.contentWindow)&&(_9ba.contentWindow.document))||((_9ba.name)&&(document.frames[_9ba.name])&&(document.frames[_9ba.name].document))||null;
return doc;
};
dojo.html.BackgroundIframe=function(node){
if(dojo.render.html.ie55||dojo.render.html.ie60){
var html="<iframe src='javascript:false'"+" style='position: absolute; left: 0px; top: 0px; width: 100%; height: 100%;"+"z-index: -1; filter:Alpha(Opacity=\"0\");' "+">";
this.iframe=dojo.doc().createElement(html);
this.iframe.tabIndex=-1;
if(node){
node.appendChild(this.iframe);
this.domNode=node;
}else{
dojo.body().appendChild(this.iframe);
this.iframe.style.display="none";
}
}
};
dojo.lang.extend(dojo.html.BackgroundIframe,{iframe:null,onResized:function(){
if(this.iframe&&this.domNode&&this.domNode.parentNode){
var _9be=dojo.html.getMarginBox(this.domNode);
if(_9be.width==0||_9be.height==0){
dojo.lang.setTimeout(this,this.onResized,100);
return;
}
this.iframe.style.width=_9be.width+"px";
this.iframe.style.height=_9be.height+"px";
}
},size:function(node){
if(!this.iframe){
return;
}
var _9c0=dojo.html.toCoordinateObject(node,true,dojo.html.boxSizing.BORDER_BOX);
with(this.iframe.style){
width=_9c0.width+"px";
height=_9c0.height+"px";
left=_9c0.left+"px";
top=_9c0.top+"px";
}
},setZIndex:function(node){
if(!this.iframe){
return;
}
if(dojo.dom.isNode(node)){
this.iframe.style.zIndex=dojo.html.getStyle(node,"z-index")-1;
}else{
if(!isNaN(node)){
this.iframe.style.zIndex=node;
}
}
},show:function(){
if(this.iframe){
this.iframe.style.display="block";
}
},hide:function(){
if(this.iframe){
this.iframe.style.display="none";
}
},remove:function(){
if(this.iframe){
dojo.html.removeNode(this.iframe,true);
delete this.iframe;
this.iframe=null;
}
}});
dojo.provide("dojo.widget.PopupContainer");
dojo.declare("dojo.widget.PopupContainerBase",null,function(){
this.queueOnAnimationFinish=[];
},{isShowingNow:false,currentSubpopup:null,beginZIndex:1000,parentPopup:null,parent:null,popupIndex:0,aroundBox:dojo.html.boxSizing.BORDER_BOX,openedForWindow:null,processKey:function(evt){
return false;
},applyPopupBasicStyle:function(){
with(this.domNode.style){
display="none";
position="absolute";
}
},aboutToShow:function(){
},open:function(x,y,_9c5,_9c6,_9c7,_9c8){
if(this.isShowingNow){
return;
}
if(this.animationInProgress){
this.queueOnAnimationFinish.push(this.open,arguments);
return;
}
this.aboutToShow();
var _9c9=false,node,_9cb;
if(typeof x=="object"){
node=x;
_9cb=_9c6;
_9c6=_9c5;
_9c5=y;
_9c9=true;
}
this.parent=_9c5;
dojo.body().appendChild(this.domNode);
_9c6=_9c6||_9c5["domNode"]||[];
var _9cc=null;
this.isTopLevel=true;
while(_9c5){
if(_9c5!==this&&(_9c5.setOpenedSubpopup!=undefined&&_9c5.applyPopupBasicStyle!=undefined)){
_9cc=_9c5;
this.isTopLevel=false;
_9cc.setOpenedSubpopup(this);
break;
}
_9c5=_9c5.parent;
}
this.parentPopup=_9cc;
this.popupIndex=_9cc?_9cc.popupIndex+1:1;
if(this.isTopLevel){
var _9cd=dojo.html.isNode(_9c6)?_9c6:null;
dojo.widget.PopupManager.opened(this,_9cd);
}
if(this.isTopLevel&&!dojo.withGlobal(this.openedForWindow||dojo.global(),dojo.html.selection.isCollapsed)){
this._bookmark=dojo.withGlobal(this.openedForWindow||dojo.global(),dojo.html.selection.getBookmark);
}else{
this._bookmark=null;
}
if(_9c6 instanceof Array){
_9c6={left:_9c6[0],top:_9c6[1],width:0,height:0};
}
with(this.domNode.style){
display="";
zIndex=this.beginZIndex+this.popupIndex;
}
if(_9c9){
this.move(node,_9c8,_9cb);
}else{
this.move(x,y,_9c8,_9c7);
}
this.domNode.style.display="none";
this.explodeSrc=_9c6;
this.show();
this.isShowingNow=true;
},move:function(x,y,_9d0,_9d1){
var _9d2=(typeof x=="object");
if(_9d2){
var _9d3=_9d0;
var node=x;
_9d0=y;
if(!_9d3){
_9d3={"BL":"TL","TL":"BL"};
}
dojo.html.placeOnScreenAroundElement(this.domNode,node,_9d0,this.aroundBox,_9d3);
}else{
if(!_9d1){
_9d1="TL,TR,BL,BR";
}
dojo.html.placeOnScreen(this.domNode,x,y,_9d0,true,_9d1);
}
},close:function(_9d5){
if(_9d5){
this.domNode.style.display="none";
}
if(this.animationInProgress){
this.queueOnAnimationFinish.push(this.close,[]);
return;
}
this.closeSubpopup(_9d5);
this.hide();
if(this.bgIframe){
this.bgIframe.hide();
this.bgIframe.size({left:0,top:0,width:0,height:0});
}
if(this.isTopLevel){
dojo.widget.PopupManager.closed(this);
}
this.isShowingNow=false;
if(this.parent){
setTimeout(dojo.lang.hitch(this,function(){
try{
if(this.parent["focus"]){
this.parent.focus();
}else{
this.parent.domNode.focus();
}
}
catch(e){
dojo.debug("No idea how to focus to parent",e);
}
}),10);
}
if(this._bookmark&&dojo.withGlobal(this.openedForWindow||dojo.global(),dojo.html.selection.isCollapsed)){
if(this.openedForWindow){
this.openedForWindow.focus();
}
try{
dojo.withGlobal(this.openedForWindow||dojo.global(),"moveToBookmark",dojo.html.selection,[this._bookmark]);
}
catch(e){
}
}
this._bookmark=null;
},closeAll:function(_9d6){
if(this.parentPopup){
this.parentPopup.closeAll(_9d6);
}else{
this.close(_9d6);
}
},setOpenedSubpopup:function(_9d7){
this.currentSubpopup=_9d7;
},closeSubpopup:function(_9d8){
if(this.currentSubpopup==null){
return;
}
this.currentSubpopup.close(_9d8);
this.currentSubpopup=null;
},onShow:function(){
dojo.widget.PopupContainer.superclass.onShow.apply(this,arguments);
this.openedSize={w:this.domNode.style.width,h:this.domNode.style.height};
if(dojo.render.html.ie){
if(!this.bgIframe){
this.bgIframe=new dojo.html.BackgroundIframe();
this.bgIframe.setZIndex(this.domNode);
}
this.bgIframe.size(this.domNode);
this.bgIframe.show();
}
this.processQueue();
},processQueue:function(){
if(!this.queueOnAnimationFinish.length){
return;
}
var func=this.queueOnAnimationFinish.shift();
var args=this.queueOnAnimationFinish.shift();
func.apply(this,args);
},onHide:function(){
dojo.widget.HtmlWidget.prototype.onHide.call(this);
if(this.openedSize){
with(this.domNode.style){
width=this.openedSize.w;
height=this.openedSize.h;
}
}
this.processQueue();
}});
dojo.widget.defineWidget("dojo.widget.PopupContainer",[dojo.widget.HtmlWidget,dojo.widget.PopupContainerBase],{isContainer:true,fillInTemplate:function(){
this.applyPopupBasicStyle();
dojo.widget.PopupContainer.superclass.fillInTemplate.apply(this,arguments);
}});
dojo.widget.PopupManager=new function(){
this.currentMenu=null;
this.currentButton=null;
this.currentFocusMenu=null;
this.focusNode=null;
this.registeredWindows=[];
this.registerWin=function(win){
if(!win.__PopupManagerRegistered){
dojo.event.connect(win.document,"onmousedown",this,"onClick");
dojo.event.connect(win,"onscroll",this,"onClick");
dojo.event.connect(win.document,"onkey",this,"onKey");
win.__PopupManagerRegistered=true;
this.registeredWindows.push(win);
}
};
this.registerAllWindows=function(_9dc){
if(!_9dc){
_9dc=dojo.html.getDocumentWindow(window.top&&window.top.document||window.document);
}
this.registerWin(_9dc);
for(var i=0;i<_9dc.frames.length;i++){
try{
var win=dojo.html.getDocumentWindow(_9dc.frames[i].document);
if(win){
this.registerAllWindows(win);
}
}
catch(e){
}
}
};
this.unRegisterWin=function(win){
if(win.__PopupManagerRegistered){
dojo.event.disconnect(win.document,"onmousedown",this,"onClick");
dojo.event.disconnect(win,"onscroll",this,"onClick");
dojo.event.disconnect(win.document,"onkey",this,"onKey");
win.__PopupManagerRegistered=false;
}
};
this.unRegisterAllWindows=function(){
for(var i=0;i<this.registeredWindows.length;++i){
this.unRegisterWin(this.registeredWindows[i]);
}
this.registeredWindows=[];
};
dojo.addOnLoad(this,"registerAllWindows");
dojo.addOnUnload(this,"unRegisterAllWindows");
this.closed=function(menu){
if(this.currentMenu==menu){
this.currentMenu=null;
this.currentButton=null;
this.currentFocusMenu=null;
}
};
this.opened=function(menu,_9e3){
if(menu==this.currentMenu){
return;
}
if(this.currentMenu){
this.currentMenu.close();
}
this.currentMenu=menu;
this.currentFocusMenu=menu;
this.currentButton=_9e3;
};
this.setFocusedMenu=function(menu){
this.currentFocusMenu=menu;
};
this.onKey=function(e){
if(!e.key){
return;
}
if(!this.currentMenu||!this.currentMenu.isShowingNow){
return;
}
var m=this.currentFocusMenu;
while(m){
if(m.processKey(e)){
e.preventDefault();
e.stopPropagation();
break;
}
m=m.parentPopup||m.parentMenu;
}
},this.onClick=function(e){
if(!this.currentMenu){
return;
}
var _9e8=dojo.html.getScroll().offset;
var m=this.currentMenu;
while(m){
if(dojo.html.overElement(m.domNode,e)||dojo.html.isDescendantOf(e.target,m.domNode)){
return;
}
m=m.currentSubpopup;
}
if(this.currentButton&&dojo.html.overElement(this.currentButton,e)){
return;
}
this.currentMenu.closeAll(true);
};
};
dojo.provide("dojo.widget.ColorPalette");
dojo.widget.defineWidget("dojo.widget.ColorPalette",dojo.widget.HtmlWidget,{palette:"7x10",_palettes:{"7x10":[["fff","fcc","fc9","ff9","ffc","9f9","9ff","cff","ccf","fcf"],["ccc","f66","f96","ff6","ff3","6f9","3ff","6ff","99f","f9f"],["c0c0c0","f00","f90","fc6","ff0","3f3","6cc","3cf","66c","c6c"],["999","c00","f60","fc3","fc0","3c0","0cc","36f","63f","c3c"],["666","900","c60","c93","990","090","399","33f","60c","939"],["333","600","930","963","660","060","366","009","339","636"],["000","300","630","633","330","030","033","006","309","303"]],"3x4":[["ffffff","00ff00","008000","0000ff"],["c0c0c0","ffff00","ff00ff","000080"],["808080","ff0000","800080","000000"]]},buildRendering:function(){
this.domNode=document.createElement("table");
dojo.html.disableSelection(this.domNode);
dojo.event.connect(this.domNode,"onmousedown",function(e){
e.preventDefault();
});
with(this.domNode){
cellPadding="0";
cellSpacing="1";
border="1";
style.backgroundColor="white";
}
var _9eb=this._palettes[this.palette];
for(var i=0;i<_9eb.length;i++){
var tr=this.domNode.insertRow(-1);
for(var j=0;j<_9eb[i].length;j++){
if(_9eb[i][j].length==3){
_9eb[i][j]=_9eb[i][j].replace(/(.)(.)(.)/,"$1$1$2$2$3$3");
}
var td=tr.insertCell(-1);
with(td.style){
backgroundColor="#"+_9eb[i][j];
border="1px solid gray";
width=height="15px";
fontSize="1px";
}
td.color="#"+_9eb[i][j];
td.onmouseover=function(e){
this.style.borderColor="white";
};
td.onmouseout=function(e){
this.style.borderColor="gray";
};
dojo.event.connect(td,"onmousedown",this,"onClick");
td.innerHTML="&nbsp;";
}
}
},onClick:function(e){
this.onColorSelect(e.currentTarget.color);
e.currentTarget.style.borderColor="gray";
},onColorSelect:function(_9f3){
}});
dojo.provide("dojo.widget.ContentPane");
dojo.widget.defineWidget("dojo.widget.ContentPane",dojo.widget.HtmlWidget,function(){
this._styleNodes=[];
this._onLoadStack=[];
this._onUnloadStack=[];
this._callOnUnload=false;
this._ioBindObj;
this.scriptScope;
this.bindArgs={};
},{isContainer:true,adjustPaths:true,href:"",extractContent:true,parseContent:true,cacheContent:true,preload:false,refreshOnShow:false,handler:"",executeScripts:false,scriptSeparation:true,loadingMessage:"Loading...",isLoaded:false,postCreate:function(args,frag,_9f6){
if(this.handler!==""){
this.setHandler(this.handler);
}
if(this.isShowing()||this.preload){
this.loadContents();
}
},show:function(){
if(this.refreshOnShow){
this.refresh();
}else{
this.loadContents();
}
dojo.widget.ContentPane.superclass.show.call(this);
},refresh:function(){
this.isLoaded=false;
this.loadContents();
},loadContents:function(){
if(this.isLoaded){
return;
}
if(dojo.lang.isFunction(this.handler)){
this._runHandler();
}else{
if(this.href!=""){
this._downloadExternalContent(this.href,this.cacheContent&&!this.refreshOnShow);
}
}
},setUrl:function(url){
this.href=url;
this.isLoaded=false;
if(this.preload||this.isShowing()){
this.loadContents();
}
},abort:function(){
var bind=this._ioBindObj;
if(!bind||!bind.abort){
return;
}
bind.abort();
delete this._ioBindObj;
},_downloadExternalContent:function(url,_9fa){
this.abort();
this._handleDefaults(this.loadingMessage,"onDownloadStart");
var self=this;
this._ioBindObj=dojo.io.bind(this._cacheSetting({url:url,mimetype:"text/html",handler:function(type,data,xhr){
delete self._ioBindObj;
if(type=="load"){
self.onDownloadEnd.call(self,url,data);
}else{
var e={responseText:xhr.responseText,status:xhr.status,statusText:xhr.statusText,responseHeaders:xhr.getAllResponseHeaders(),text:"Error loading '"+url+"' ("+xhr.status+" "+xhr.statusText+")"};
self._handleDefaults.call(self,e,"onDownloadError");
self.onLoad();
}
}},_9fa));
},_cacheSetting:function(_a00,_a01){
for(var x in this.bindArgs){
if(dojo.lang.isUndefined(_a00[x])){
_a00[x]=this.bindArgs[x];
}
}
if(dojo.lang.isUndefined(_a00.useCache)){
_a00.useCache=_a01;
}
if(dojo.lang.isUndefined(_a00.preventCache)){
_a00.preventCache=!_a01;
}
if(dojo.lang.isUndefined(_a00.mimetype)){
_a00.mimetype="text/html";
}
return _a00;
},onLoad:function(e){
this._runStack("_onLoadStack");
this.isLoaded=true;
},onUnLoad:function(e){
dojo.deprecated(this.widgetType+".onUnLoad, use .onUnload (lowercased load)",0.5);
},onUnload:function(e){
this._runStack("_onUnloadStack");
delete this.scriptScope;
if(this.onUnLoad!==dojo.widget.ContentPane.prototype.onUnLoad){
this.onUnLoad.apply(this,arguments);
}
},_runStack:function(_a06){
var st=this[_a06];
var err="";
var _a09=this.scriptScope||window;
for(var i=0;i<st.length;i++){
try{
st[i].call(_a09);
}
catch(e){
err+="\n"+st[i]+" failed: "+e.description;
}
}
this[_a06]=[];
if(err.length){
var name=(_a06=="_onLoadStack")?"addOnLoad":"addOnUnLoad";
this._handleDefaults(name+" failure\n "+err,"onExecError","debug");
}
},addOnLoad:function(obj,func){
this._pushOnStack(this._onLoadStack,obj,func);
},addOnUnload:function(obj,func){
this._pushOnStack(this._onUnloadStack,obj,func);
},addOnUnLoad:function(){
dojo.deprecated(this.widgetType+".addOnUnLoad, use addOnUnload instead. (lowercased Load)",0.5);
this.addOnUnload.apply(this,arguments);
},_pushOnStack:function(_a10,obj,func){
if(typeof func=="undefined"){
_a10.push(obj);
}else{
_a10.push(function(){
obj[func]();
});
}
},destroy:function(){
this.onUnload();
dojo.widget.ContentPane.superclass.destroy.call(this);
},onExecError:function(e){
},onContentError:function(e){
},onDownloadError:function(e){
},onDownloadStart:function(e){
},onDownloadEnd:function(url,data){
data=this.splitAndFixPaths(data,url);
this.setContent(data);
},_handleDefaults:function(e,_a1a,_a1b){
if(!_a1a){
_a1a="onContentError";
}
if(dojo.lang.isString(e)){
e={text:e};
}
if(!e.text){
e.text=e.toString();
}
e.toString=function(){
return this.text;
};
if(typeof e.returnValue!="boolean"){
e.returnValue=true;
}
if(typeof e.preventDefault!="function"){
e.preventDefault=function(){
this.returnValue=false;
};
}
this[_a1a](e);
if(e.returnValue){
switch(_a1b){
case true:
case "alert":
alert(e.toString());
break;
case "debug":
dojo.debug(e.toString());
break;
default:
if(this._callOnUnload){
this.onUnload();
}
this._callOnUnload=false;
if(arguments.callee._loopStop){
dojo.debug(e.toString());
}else{
arguments.callee._loopStop=true;
this._setContent(e.toString());
}
}
}
arguments.callee._loopStop=false;
},splitAndFixPaths:function(s,url){
var _a1e=[],_a1f=[],tmp=[];
var _a21=[],_a22=[],attr=[],_a24=[];
var str="",path="",fix="",_a28="",tag="",_a2a="";
if(!url){
url="./";
}
if(s){
var _a2b=/<title[^>]*>([\s\S]*?)<\/title>/i;
while(_a21=_a2b.exec(s)){
_a1e.push(_a21[1]);
s=s.substring(0,_a21.index)+s.substr(_a21.index+_a21[0].length);
}
if(this.adjustPaths){
var _a2c=/<[a-z][a-z0-9]*[^>]*\s(?:(?:src|href|style)=[^>])+[^>]*>/i;
var _a2d=/\s(src|href|style)=(['"]?)([\w()\[\]\/.,\\'"-:;#=&?\s@]+?)\2/i;
var _a2e=/^(?:[#]|(?:(?:https?|ftps?|file|javascript|mailto|news):))/;
while(tag=_a2c.exec(s)){
str+=s.substring(0,tag.index);
s=s.substring((tag.index+tag[0].length),s.length);
tag=tag[0];
_a28="";
while(attr=_a2d.exec(tag)){
path="";
_a2a=attr[3];
switch(attr[1].toLowerCase()){
case "src":
case "href":
if(_a2e.exec(_a2a)){
path=_a2a;
}else{
path=(new dojo.uri.Uri(url,_a2a).toString());
}
break;
case "style":
path=dojo.html.fixPathsInCssText(_a2a,url);
break;
default:
path=_a2a;
}
fix=" "+attr[1]+"="+attr[2]+path+attr[2];
_a28+=tag.substring(0,attr.index)+fix;
tag=tag.substring((attr.index+attr[0].length),tag.length);
}
str+=_a28+tag;
}
s=str+s;
}
_a2b=/(?:<(style)[^>]*>([\s\S]*?)<\/style>|<link ([^>]*rel=['"]?stylesheet['"]?[^>]*)>)/i;
while(_a21=_a2b.exec(s)){
if(_a21[1]&&_a21[1].toLowerCase()=="style"){
_a24.push(dojo.html.fixPathsInCssText(_a21[2],url));
}else{
if(attr=_a21[3].match(/href=(['"]?)([^'">]*)\1/i)){
_a24.push({path:attr[2]});
}
}
s=s.substring(0,_a21.index)+s.substr(_a21.index+_a21[0].length);
}
var _a2b=/<script([^>]*)>([\s\S]*?)<\/script>/i;
var _a2f=/src=(['"]?)([^"']*)\1/i;
var _a30=/.*(\bdojo\b\.js(?:\.uncompressed\.js)?)$/;
var _a31=/(?:var )?\bdjConfig\b(?:[\s]*=[\s]*\{[^}]+\}|\.[\w]*[\s]*=[\s]*[^;\n]*)?;?|dojo\.hostenv\.writeIncludes\(\s*\);?/g;
var _a32=/dojo\.(?:(?:require(?:After)?(?:If)?)|(?:widget\.(?:manager\.)?registerWidgetPackage)|(?:(?:hostenv\.)?setModulePrefix|registerModulePath)|defineNamespace)\((['"]).*?\1\)\s*;?/;
while(_a21=_a2b.exec(s)){
if(this.executeScripts&&_a21[1]){
if(attr=_a2f.exec(_a21[1])){
if(_a30.exec(attr[2])){
dojo.debug("Security note! inhibit:"+attr[2]+" from  being loaded again.");
}else{
_a1f.push({path:attr[2]});
}
}
}
if(_a21[2]){
var sc=_a21[2].replace(_a31,"");
if(!sc){
continue;
}
while(tmp=_a32.exec(sc)){
_a22.push(tmp[0]);
sc=sc.substring(0,tmp.index)+sc.substr(tmp.index+tmp[0].length);
}
if(this.executeScripts){
_a1f.push(sc);
}
}
s=s.substr(0,_a21.index)+s.substr(_a21.index+_a21[0].length);
}
if(this.extractContent){
_a21=s.match(/<body[^>]*>\s*([\s\S]+)\s*<\/body>/im);
if(_a21){
s=_a21[1];
}
}
if(this.executeScripts&&this.scriptSeparation){
var _a2b=/(<[a-zA-Z][a-zA-Z0-9]*\s[^>]*?\S=)((['"])[^>]*scriptScope[^>]*>)/;
var _a34=/([\s'";:\(])scriptScope(.*)/;
str="";
while(tag=_a2b.exec(s)){
tmp=((tag[3]=="'")?"\"":"'");
fix="";
str+=s.substring(0,tag.index)+tag[1];
while(attr=_a34.exec(tag[2])){
tag[2]=tag[2].substring(0,attr.index)+attr[1]+"dojo.widget.byId("+tmp+this.widgetId+tmp+").scriptScope"+attr[2];
}
str+=tag[2];
s=s.substr(tag.index+tag[0].length);
}
s=str+s;
}
}
return {"xml":s,"styles":_a24,"titles":_a1e,"requires":_a22,"scripts":_a1f,"url":url};
},_setContent:function(cont){
this.destroyChildren();
for(var i=0;i<this._styleNodes.length;i++){
if(this._styleNodes[i]&&this._styleNodes[i].parentNode){
this._styleNodes[i].parentNode.removeChild(this._styleNodes[i]);
}
}
this._styleNodes=[];
try{
var node=this.containerNode||this.domNode;
while(node.firstChild){
dojo.html.destroyNode(node.firstChild);
}
if(typeof cont!="string"){
node.appendChild(cont);
}else{
node.innerHTML=cont;
}
}
catch(e){
e.text="Couldn't load content:"+e.description;
this._handleDefaults(e,"onContentError");
}
},setContent:function(data){
this.abort();
if(this._callOnUnload){
this.onUnload();
}
this._callOnUnload=true;
if(!data||dojo.html.isNode(data)){
this._setContent(data);
this.onResized();
this.onLoad();
}else{
if(typeof data.xml!="string"){
this.href="";
data=this.splitAndFixPaths(data);
}
this._setContent(data.xml);
for(var i=0;i<data.styles.length;i++){
if(data.styles[i].path){
this._styleNodes.push(dojo.html.insertCssFile(data.styles[i].path,dojo.doc(),false,true));
}else{
this._styleNodes.push(dojo.html.insertCssText(data.styles[i]));
}
}
if(this.parseContent){
for(var i=0;i<data.requires.length;i++){
try{
eval(data.requires[i]);
}
catch(e){
e.text="ContentPane: error in package loading calls, "+(e.description||e);
this._handleDefaults(e,"onContentError","debug");
}
}
}
var _a3a=this;
function asyncParse(){
if(_a3a.executeScripts){
_a3a._executeScripts(data.scripts);
}
if(_a3a.parseContent){
var node=_a3a.containerNode||_a3a.domNode;
var _a3c=new dojo.xml.Parse();
var frag=_a3c.parseElement(node,null,true);
dojo.widget.getParser().createSubComponents(frag,_a3a);
}
_a3a.onResized();
_a3a.onLoad();
}
if(dojo.hostenv.isXDomain&&data.requires.length){
dojo.addOnLoad(asyncParse);
}else{
asyncParse();
}
}
},setHandler:function(_a3e){
var fcn=dojo.lang.isFunction(_a3e)?_a3e:window[_a3e];
if(!dojo.lang.isFunction(fcn)){
this._handleDefaults("Unable to set handler, '"+_a3e+"' not a function.","onExecError",true);
return;
}
this.handler=function(){
return fcn.apply(this,arguments);
};
},_runHandler:function(){
var ret=true;
if(dojo.lang.isFunction(this.handler)){
this.handler(this,this.domNode);
ret=false;
}
this.onLoad();
return ret;
},_executeScripts:function(_a41){
var self=this;
var tmp="",code="";
for(var i=0;i<_a41.length;i++){
if(_a41[i].path){
dojo.io.bind(this._cacheSetting({"url":_a41[i].path,"load":function(type,_a47){
dojo.lang.hitch(self,tmp=";"+_a47);
},"error":function(type,_a49){
_a49.text=type+" downloading remote script";
self._handleDefaults.call(self,_a49,"onExecError","debug");
},"mimetype":"text/plain","sync":true},this.cacheContent));
code+=tmp;
}else{
code+=_a41[i];
}
}
try{
if(this.scriptSeparation){
delete this.scriptScope;
this.scriptScope=new (new Function("_container_",code+"; return this;"))(self);
}else{
var djg=dojo.global();
if(djg.execScript){
djg.execScript(code);
}else{
var djd=dojo.doc();
var sc=djd.createElement("script");
sc.appendChild(djd.createTextNode(code));
(this.containerNode||this.domNode).appendChild(sc);
}
}
}
catch(e){
e.text="Error running scripts from content:\n"+e.description;
this._handleDefaults(e,"onExecError","debug");
}
}});
dojo.provide("dojo.widget.Editor2Toolbar");
dojo.lang.declare("dojo.widget.HandlerManager",null,function(){
this._registeredHandlers=[];
},{registerHandler:function(obj,func){
if(arguments.length==2){
this._registeredHandlers.push(function(){
return obj[func].apply(obj,arguments);
});
}else{
this._registeredHandlers.push(obj);
}
},removeHandler:function(func){
for(var i=0;i<this._registeredHandlers.length;i++){
if(func===this._registeredHandlers[i]){
delete this._registeredHandlers[i];
return;
}
}
dojo.debug("HandlerManager handler "+func+" is not registered, can not remove.");
},destroy:function(){
for(var i=0;i<this._registeredHandlers.length;i++){
delete this._registeredHandlers[i];
}
}});
dojo.widget.Editor2ToolbarItemManager=new dojo.widget.HandlerManager;
dojo.lang.mixin(dojo.widget.Editor2ToolbarItemManager,{getToolbarItem:function(name){
var item;
name=name.toLowerCase();
for(var i=0;i<this._registeredHandlers.length;i++){
item=this._registeredHandlers[i](name);
if(item){
return item;
}
}
switch(name){
case "bold":
case "copy":
case "cut":
case "delete":
case "indent":
case "inserthorizontalrule":
case "insertorderedlist":
case "insertunorderedlist":
case "italic":
case "justifycenter":
case "justifyfull":
case "justifyleft":
case "justifyright":
case "outdent":
case "paste":
case "redo":
case "removeformat":
case "selectall":
case "strikethrough":
case "subscript":
case "superscript":
case "underline":
case "undo":
case "unlink":
case "createlink":
case "insertimage":
case "htmltoggle":
item=new dojo.widget.Editor2ToolbarButton(name);
break;
case "forecolor":
case "hilitecolor":
item=new dojo.widget.Editor2ToolbarColorPaletteButton(name);
break;
case "plainformatblock":
item=new dojo.widget.Editor2ToolbarFormatBlockPlainSelect("formatblock");
break;
case "formatblock":
item=new dojo.widget.Editor2ToolbarFormatBlockSelect("formatblock");
break;
case "fontsize":
item=new dojo.widget.Editor2ToolbarFontSizeSelect("fontsize");
break;
case "fontname":
item=new dojo.widget.Editor2ToolbarFontNameSelect("fontname");
break;
case "inserttable":
case "insertcell":
case "insertcol":
case "insertrow":
case "deletecells":
case "deletecols":
case "deleterows":
case "mergecells":
case "splitcell":
dojo.debug(name+" is implemented in dojo.widget.Editor2Plugin.TableOperation, please require it first.");
break;
case "inserthtml":
case "blockdirltr":
case "blockdirrtl":
case "dirltr":
case "dirrtl":
case "inlinedirltr":
case "inlinedirrtl":
dojo.debug("Not yet implemented toolbar item: "+name);
break;
default:
dojo.debug("dojo.widget.Editor2ToolbarItemManager.getToolbarItem: Unknown toolbar item: "+name);
}
return item;
}});
dojo.addOnUnload(dojo.widget.Editor2ToolbarItemManager,"destroy");
dojo.declare("dojo.widget.Editor2ToolbarButton",null,function(name){
this._name=name;
},{create:function(node,_a57,_a58){
this._domNode=node;
var cmd=_a57.parent.getCommand(this._name);
if(cmd){
this._domNode.title=cmd.getText();
}
this.disableSelection(this._domNode);
this._parentToolbar=_a57;
dojo.event.connect(this._domNode,"onclick",this,"onClick");
if(!_a58){
dojo.event.connect(this._domNode,"onmouseover",this,"onMouseOver");
dojo.event.connect(this._domNode,"onmouseout",this,"onMouseOut");
}
},disableSelection:function(_a5a){
dojo.html.disableSelection(_a5a);
var _a5b=_a5a.all||_a5a.getElementsByTagName("*");
for(var x=0;x<_a5b.length;x++){
dojo.html.disableSelection(_a5b[x]);
}
},onMouseOver:function(){
var _a5d=dojo.widget.Editor2Manager.getCurrentInstance();
if(_a5d){
var _a5e=_a5d.getCommand(this._name);
if(_a5e&&_a5e.getState()!=dojo.widget.Editor2Manager.commandState.Disabled){
this.highlightToolbarItem();
}
}
},onMouseOut:function(){
this.unhighlightToolbarItem();
},destroy:function(){
this._domNode=null;
this._parentToolbar=null;
},onClick:function(e){
if(this._domNode&&!this._domNode.disabled&&this._parentToolbar.checkAvailability()){
e.preventDefault();
e.stopPropagation();
var _a60=dojo.widget.Editor2Manager.getCurrentInstance();
if(_a60){
var _a61=_a60.getCommand(this._name);
if(_a61){
_a61.execute();
}
}
}
},refreshState:function(){
var _a62=dojo.widget.Editor2Manager.getCurrentInstance();
var em=dojo.widget.Editor2Manager;
if(_a62){
var _a64=_a62.getCommand(this._name);
if(_a64){
var _a65=_a64.getState();
if(_a65!=this._lastState){
switch(_a65){
case em.commandState.Latched:
this.latchToolbarItem();
break;
case em.commandState.Enabled:
this.enableToolbarItem();
break;
case em.commandState.Disabled:
default:
this.disableToolbarItem();
}
this._lastState=_a65;
}
}
}
return em.commandState.Enabled;
},latchToolbarItem:function(){
this._domNode.disabled=false;
this.removeToolbarItemStyle(this._domNode);
dojo.html.addClass(this._domNode,this._parentToolbar.ToolbarLatchedItemStyle);
},enableToolbarItem:function(){
this._domNode.disabled=false;
this.removeToolbarItemStyle(this._domNode);
dojo.html.addClass(this._domNode,this._parentToolbar.ToolbarEnabledItemStyle);
},disableToolbarItem:function(){
this._domNode.disabled=true;
this.removeToolbarItemStyle(this._domNode);
dojo.html.addClass(this._domNode,this._parentToolbar.ToolbarDisabledItemStyle);
},highlightToolbarItem:function(){
dojo.html.addClass(this._domNode,this._parentToolbar.ToolbarHighlightedItemStyle);
},unhighlightToolbarItem:function(){
dojo.html.removeClass(this._domNode,this._parentToolbar.ToolbarHighlightedItemStyle);
},removeToolbarItemStyle:function(){
dojo.html.removeClass(this._domNode,this._parentToolbar.ToolbarEnabledItemStyle);
dojo.html.removeClass(this._domNode,this._parentToolbar.ToolbarLatchedItemStyle);
dojo.html.removeClass(this._domNode,this._parentToolbar.ToolbarDisabledItemStyle);
this.unhighlightToolbarItem();
}});
dojo.declare("dojo.widget.Editor2ToolbarDropDownButton",dojo.widget.Editor2ToolbarButton,{onClick:function(){
if(this._domNode&&!this._domNode.disabled&&this._parentToolbar.checkAvailability()){
if(!this._dropdown){
this._dropdown=dojo.widget.createWidget("PopupContainer",{});
this._domNode.appendChild(this._dropdown.domNode);
}
if(this._dropdown.isShowingNow){
this._dropdown.close();
}else{
this.onDropDownShown();
this._dropdown.open(this._domNode,null,this._domNode);
}
}
},destroy:function(){
this.onDropDownDestroy();
if(this._dropdown){
this._dropdown.destroy();
}
dojo.widget.Editor2ToolbarDropDownButton.superclass.destroy.call(this);
},onDropDownShown:function(){
},onDropDownDestroy:function(){
}});
dojo.declare("dojo.widget.Editor2ToolbarColorPaletteButton",dojo.widget.Editor2ToolbarDropDownButton,{onDropDownShown:function(){
if(!this._colorpalette){
this._colorpalette=dojo.widget.createWidget("ColorPalette",{});
this._dropdown.addChild(this._colorpalette);
this.disableSelection(this._dropdown.domNode);
this.disableSelection(this._colorpalette.domNode);
dojo.event.connect(this._colorpalette,"onColorSelect",this,"setColor");
dojo.event.connect(this._dropdown,"open",this,"latchToolbarItem");
dojo.event.connect(this._dropdown,"close",this,"enableToolbarItem");
}
},setColor:function(_a66){
this._dropdown.close();
var _a67=dojo.widget.Editor2Manager.getCurrentInstance();
if(_a67){
var _a68=_a67.getCommand(this._name);
if(_a68){
_a68.execute(_a66);
}
}
}});
dojo.declare("dojo.widget.Editor2ToolbarFormatBlockPlainSelect",dojo.widget.Editor2ToolbarButton,{create:function(node,_a6a){
this._domNode=node;
this._parentToolbar=_a6a;
this._domNode=node;
this.disableSelection(this._domNode);
dojo.event.connect(this._domNode,"onchange",this,"onChange");
},destroy:function(){
this._domNode=null;
},onChange:function(){
if(this._parentToolbar.checkAvailability()){
var sv=this._domNode.value.toLowerCase();
var _a6c=dojo.widget.Editor2Manager.getCurrentInstance();
if(_a6c){
var _a6d=_a6c.getCommand(this._name);
if(_a6d){
_a6d.execute(sv);
}
}
}
},refreshState:function(){
if(this._domNode){
dojo.widget.Editor2ToolbarFormatBlockPlainSelect.superclass.refreshState.call(this);
var _a6e=dojo.widget.Editor2Manager.getCurrentInstance();
if(_a6e){
var _a6f=_a6e.getCommand(this._name);
if(_a6f){
var _a70=_a6f.getValue();
if(!_a70){
_a70="";
}
dojo.lang.forEach(this._domNode.options,function(item){
if(item.value.toLowerCase()==_a70.toLowerCase()){
item.selected=true;
}
});
}
}
}
}});
dojo.declare("dojo.widget.Editor2ToolbarComboItem",dojo.widget.Editor2ToolbarDropDownButton,{href:null,create:function(node,_a73){
dojo.widget.Editor2ToolbarComboItem.superclass.create.apply(this,arguments);
if(!this._contentPane){
this._contentPane=dojo.widget.createWidget("ContentPane",{preload:"true"});
this._contentPane.addOnLoad(this,"setup");
this._contentPane.setUrl(this.href);
}
},onMouseOver:function(e){
if(this._lastState!=dojo.widget.Editor2Manager.commandState.Disabled){
dojo.html.addClass(e.currentTarget,this._parentToolbar.ToolbarHighlightedSelectStyle);
}
},onMouseOut:function(e){
dojo.html.removeClass(e.currentTarget,this._parentToolbar.ToolbarHighlightedSelectStyle);
},onDropDownShown:function(){
if(!this._dropdown.__addedContentPage){
this._dropdown.addChild(this._contentPane);
this._dropdown.__addedContentPage=true;
}
},setup:function(){
},onChange:function(e){
if(this._parentToolbar.checkAvailability()){
var name=e.currentTarget.getAttribute("dropDownItemName");
var _a78=dojo.widget.Editor2Manager.getCurrentInstance();
if(_a78){
var _a79=_a78.getCommand(this._name);
if(_a79){
_a79.execute(name);
}
}
}
this._dropdown.close();
},onMouseOverItem:function(e){
dojo.html.addClass(e.currentTarget,this._parentToolbar.ToolbarHighlightedSelectItemStyle);
},onMouseOutItem:function(e){
dojo.html.removeClass(e.currentTarget,this._parentToolbar.ToolbarHighlightedSelectItemStyle);
}});
dojo.declare("dojo.widget.Editor2ToolbarFormatBlockSelect",dojo.widget.Editor2ToolbarComboItem,{href:dojo.uri.moduleUri("dojo.widget","templates/Editor2/EditorToolbar_FormatBlock.html"),setup:function(){
dojo.widget.Editor2ToolbarFormatBlockSelect.superclass.setup.call(this);
var _a7c=this._contentPane.domNode.all||this._contentPane.domNode.getElementsByTagName("*");
this._blockNames={};
this._blockDisplayNames={};
for(var x=0;x<_a7c.length;x++){
var node=_a7c[x];
dojo.html.disableSelection(node);
var name=node.getAttribute("dropDownItemName");
if(name){
this._blockNames[name]=node;
var _a80=node.getElementsByTagName(name);
this._blockDisplayNames[name]=_a80[_a80.length-1].innerHTML;
}
}
for(var name in this._blockNames){
dojo.event.connect(this._blockNames[name],"onclick",this,"onChange");
dojo.event.connect(this._blockNames[name],"onmouseover",this,"onMouseOverItem");
dojo.event.connect(this._blockNames[name],"onmouseout",this,"onMouseOutItem");
}
},onDropDownDestroy:function(){
if(this._blockNames){
for(var name in this._blockNames){
delete this._blockNames[name];
delete this._blockDisplayNames[name];
}
}
},refreshState:function(){
dojo.widget.Editor2ToolbarFormatBlockSelect.superclass.refreshState.call(this);
if(this._lastState!=dojo.widget.Editor2Manager.commandState.Disabled){
var _a82=dojo.widget.Editor2Manager.getCurrentInstance();
if(_a82){
var _a83=_a82.getCommand(this._name);
if(_a83){
var _a84=_a83.getValue();
if(_a84==this._lastSelectedFormat&&this._blockDisplayNames){
return this._lastState;
}
this._lastSelectedFormat=_a84;
var _a85=this._domNode.getElementsByTagName("label")[0];
var _a86=false;
if(this._blockDisplayNames){
for(var name in this._blockDisplayNames){
if(name==_a84){
_a85.innerHTML=this._blockDisplayNames[name];
_a86=true;
break;
}
}
if(!_a86){
_a85.innerHTML="&nbsp;";
}
}
}
}
}
return this._lastState;
}});
dojo.declare("dojo.widget.Editor2ToolbarFontSizeSelect",dojo.widget.Editor2ToolbarComboItem,{href:dojo.uri.moduleUri("dojo.widget","templates/Editor2/EditorToolbar_FontSize.html"),setup:function(){
dojo.widget.Editor2ToolbarFormatBlockSelect.superclass.setup.call(this);
var _a88=this._contentPane.domNode.all||this._contentPane.domNode.getElementsByTagName("*");
this._fontsizes={};
this._fontSizeDisplayNames={};
for(var x=0;x<_a88.length;x++){
var node=_a88[x];
dojo.html.disableSelection(node);
var name=node.getAttribute("dropDownItemName");
if(name){
this._fontsizes[name]=node;
this._fontSizeDisplayNames[name]=node.getElementsByTagName("font")[0].innerHTML;
}
}
for(var name in this._fontsizes){
dojo.event.connect(this._fontsizes[name],"onclick",this,"onChange");
dojo.event.connect(this._fontsizes[name],"onmouseover",this,"onMouseOverItem");
dojo.event.connect(this._fontsizes[name],"onmouseout",this,"onMouseOutItem");
}
},onDropDownDestroy:function(){
if(this._fontsizes){
for(var name in this._fontsizes){
delete this._fontsizes[name];
delete this._fontSizeDisplayNames[name];
}
}
},refreshState:function(){
dojo.widget.Editor2ToolbarFormatBlockSelect.superclass.refreshState.call(this);
if(this._lastState!=dojo.widget.Editor2Manager.commandState.Disabled){
var _a8d=dojo.widget.Editor2Manager.getCurrentInstance();
if(_a8d){
var _a8e=_a8d.getCommand(this._name);
if(_a8e){
var size=_a8e.getValue();
if(size==this._lastSelectedSize&&this._fontSizeDisplayNames){
return this._lastState;
}
this._lastSelectedSize=size;
var _a90=this._domNode.getElementsByTagName("label")[0];
var _a91=false;
if(this._fontSizeDisplayNames){
for(var name in this._fontSizeDisplayNames){
if(name==size){
_a90.innerHTML=this._fontSizeDisplayNames[name];
_a91=true;
break;
}
}
if(!_a91){
_a90.innerHTML="&nbsp;";
}
}
}
}
}
return this._lastState;
}});
dojo.declare("dojo.widget.Editor2ToolbarFontNameSelect",dojo.widget.Editor2ToolbarFontSizeSelect,{href:dojo.uri.moduleUri("dojo.widget","templates/Editor2/EditorToolbar_FontName.html")});
dojo.widget.defineWidget("dojo.widget.Editor2Toolbar",dojo.widget.HtmlWidget,function(){
dojo.event.connect(this,"fillInTemplate",dojo.lang.hitch(this,function(){
if(dojo.render.html.ie){
this.domNode.style.zoom=1;
}
}));
},{templateString:"<div dojoAttachPoint=\"domNode\" class=\"EditorToolbarDomNode\" unselectable=\"on\">\n\t<table cellpadding=\"3\" cellspacing=\"0\" border=\"0\">\n\t\t<!--\n\t\t\tour toolbar should look something like:\n\n\t\t\t+=======+=======+=======+=============================================+\n\t\t\t| w   w | style | copy  | bo | it | un | le | ce | ri |\n\t\t\t| w w w | style |=======|==============|==============|\n\t\t\t|  w w  | style | paste |  undo | redo | change style |\n\t\t\t+=======+=======+=======+=============================================+\n\t\t-->\n\t\t<tbody>\n\t\t\t<tr valign=\"top\">\n\t\t\t\t<td rowspan=\"2\">\n\t\t\t\t\t<div class=\"bigIcon\" dojoAttachPoint=\"wikiWordButton\"\n\t\t\t\t\t\tdojoOnClick=\"wikiWordClick; buttonClick;\">\n\t\t\t\t\t\t<span style=\"font-size: 30px; margin-left: 5px;\">\n\t\t\t\t\t\t\tW\n\t\t\t\t\t\t</span>\n\t\t\t\t\t</div>\n\t\t\t\t</td>\n\t\t\t\t<td rowspan=\"2\">\n\t\t\t\t\t<div class=\"bigIcon\" dojoAttachPoint=\"styleDropdownButton\"\n\t\t\t\t\t\tdojoOnClick=\"styleDropdownClick; buttonClick;\">\n\t\t\t\t\t\t<span unselectable=\"on\"\n\t\t\t\t\t\t\tstyle=\"font-size: 30px; margin-left: 5px;\">\n\t\t\t\t\t\t\tS\n\t\t\t\t\t\t</span>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class=\"StyleDropdownContainer\" style=\"display: none;\"\n\t\t\t\t\t\tdojoAttachPoint=\"styleDropdownContainer\">\n\t\t\t\t\t\t<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\"\n\t\t\t\t\t\t\theight=\"100%\" width=\"100%\">\n\t\t\t\t\t\t\t<tr valign=\"top\">\n\t\t\t\t\t\t\t\t<td rowspan=\"2\">\n\t\t\t\t\t\t\t\t\t<div style=\"height: 245px; overflow: auto;\">\n\t\t\t\t\t\t\t\t\t\t<div class=\"headingContainer\"\n\t\t\t\t\t\t\t\t\t\t\tunselectable=\"on\"\n\t\t\t\t\t\t\t\t\t\t\tdojoOnClick=\"normalTextClick\">normal</div>\n\t\t\t\t\t\t\t\t\t\t<h1 class=\"headingContainer\"\n\t\t\t\t\t\t\t\t\t\t\tunselectable=\"on\"\n\t\t\t\t\t\t\t\t\t\t\tdojoOnClick=\"h1TextClick\">Heading 1</h1>\n\t\t\t\t\t\t\t\t\t\t<h2 class=\"headingContainer\"\n\t\t\t\t\t\t\t\t\t\t\tunselectable=\"on\"\n\t\t\t\t\t\t\t\t\t\t\tdojoOnClick=\"h2TextClick\">Heading 2</h2>\n\t\t\t\t\t\t\t\t\t\t<h3 class=\"headingContainer\"\n\t\t\t\t\t\t\t\t\t\t\tunselectable=\"on\"\n\t\t\t\t\t\t\t\t\t\t\tdojoOnClick=\"h3TextClick\">Heading 3</h3>\n\t\t\t\t\t\t\t\t\t\t<h4 class=\"headingContainer\"\n\t\t\t\t\t\t\t\t\t\t\tunselectable=\"on\"\n\t\t\t\t\t\t\t\t\t\t\tdojoOnClick=\"h4TextClick\">Heading 4</h4>\n\t\t\t\t\t\t\t\t\t\t<div class=\"headingContainer\"\n\t\t\t\t\t\t\t\t\t\t\tunselectable=\"on\"\n\t\t\t\t\t\t\t\t\t\t\tdojoOnClick=\"blahTextClick\">blah</div>\n\t\t\t\t\t\t\t\t\t\t<div class=\"headingContainer\"\n\t\t\t\t\t\t\t\t\t\t\tunselectable=\"on\"\n\t\t\t\t\t\t\t\t\t\t\tdojoOnClick=\"blahTextClick\">blah</div>\n\t\t\t\t\t\t\t\t\t\t<div class=\"headingContainer\"\n\t\t\t\t\t\t\t\t\t\t\tunselectable=\"on\"\n\t\t\t\t\t\t\t\t\t\t\tdojoOnClick=\"blahTextClick\">blah</div>\n\t\t\t\t\t\t\t\t\t\t<div class=\"headingContainer\">blah</div>\n\t\t\t\t\t\t\t\t\t\t<div class=\"headingContainer\">blah</div>\n\t\t\t\t\t\t\t\t\t\t<div class=\"headingContainer\">blah</div>\n\t\t\t\t\t\t\t\t\t\t<div class=\"headingContainer\">blah</div>\n\t\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t\t<!--\n\t\t\t\t\t\t\t\t<td>\n\t\t\t\t\t\t\t\t\t<span class=\"iconContainer\" dojoOnClick=\"buttonClick;\">\n\t\t\t\t\t\t\t\t\t\t<span class=\"icon justifyleft\" \n\t\t\t\t\t\t\t\t\t\t\tstyle=\"float: left;\">&nbsp;</span>\n\t\t\t\t\t\t\t\t\t</span>\n\t\t\t\t\t\t\t\t\t<span class=\"iconContainer\" dojoOnClick=\"buttonClick;\">\n\t\t\t\t\t\t\t\t\t\t<span class=\"icon justifycenter\" \n\t\t\t\t\t\t\t\t\t\t\tstyle=\"float: left;\">&nbsp;</span>\n\t\t\t\t\t\t\t\t\t</span>\n\t\t\t\t\t\t\t\t\t<span class=\"iconContainer\" dojoOnClick=\"buttonClick;\">\n\t\t\t\t\t\t\t\t\t\t<span class=\"icon justifyright\" \n\t\t\t\t\t\t\t\t\t\t\tstyle=\"float: left;\">&nbsp;</span>\n\t\t\t\t\t\t\t\t\t</span>\n\t\t\t\t\t\t\t\t\t<span class=\"iconContainer\" dojoOnClick=\"buttonClick;\">\n\t\t\t\t\t\t\t\t\t\t<span class=\"icon justifyfull\" \n\t\t\t\t\t\t\t\t\t\t\tstyle=\"float: left;\">&nbsp;</span>\n\t\t\t\t\t\t\t\t\t</span>\n\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t\t-->\n\t\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t\t<tr valign=\"top\">\n\t\t\t\t\t\t\t\t<td>\n\t\t\t\t\t\t\t\t\tthud\n\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t</table>\n\t\t\t\t\t</div>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<!-- copy -->\n\t\t\t\t\t<span class=\"iconContainer\" dojoAttachPoint=\"copyButton\"\n\t\t\t\t\t\tunselectable=\"on\"\n\t\t\t\t\t\tdojoOnClick=\"copyClick; buttonClick;\">\n\t\t\t\t\t\t<span class=\"icon copy\" \n\t\t\t\t\t\t\tunselectable=\"on\"\n\t\t\t\t\t\t\tstyle=\"float: left;\">&nbsp;</span> copy\n\t\t\t\t\t</span>\n\t\t\t\t\t<!-- \"droppable\" options -->\n\t\t\t\t\t<span class=\"iconContainer\" dojoAttachPoint=\"boldButton\"\n\t\t\t\t\t\tunselectable=\"on\"\n\t\t\t\t\t\tdojoOnClick=\"boldClick; buttonClick;\">\n\t\t\t\t\t\t<span class=\"icon bold\" unselectable=\"on\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t\t<span class=\"iconContainer\" dojoAttachPoint=\"italicButton\"\n\t\t\t\t\t\tdojoOnClick=\"italicClick; buttonClick;\">\n\t\t\t\t\t\t<span class=\"icon italic\" unselectable=\"on\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t\t<span class=\"iconContainer\" dojoAttachPoint=\"underlineButton\"\n\t\t\t\t\t\tdojoOnClick=\"underlineClick; buttonClick;\">\n\t\t\t\t\t\t<span class=\"icon underline\" unselectable=\"on\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t\t<span class=\"iconContainer\" dojoAttachPoint=\"leftButton\"\n\t\t\t\t\t\tdojoOnClick=\"leftClick; buttonClick;\">\n\t\t\t\t\t\t<span class=\"icon justifyleft\" unselectable=\"on\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t\t<span class=\"iconContainer\" dojoAttachPoint=\"fullButton\"\n\t\t\t\t\t\tdojoOnClick=\"fullClick; buttonClick;\">\n\t\t\t\t\t\t<span class=\"icon justifyfull\" unselectable=\"on\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t\t<span class=\"iconContainer\" dojoAttachPoint=\"rightButton\"\n\t\t\t\t\t\tdojoOnClick=\"rightClick; buttonClick;\">\n\t\t\t\t\t\t<span class=\"icon justifyright\" unselectable=\"on\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td>\n\t\t\t\t\t<!-- paste -->\n\t\t\t\t\t<span class=\"iconContainer\" dojoAttachPoint=\"pasteButton\"\n\t\t\t\t\t\tdojoOnClick=\"pasteClick; buttonClick;\" unselectable=\"on\">\n\t\t\t\t\t\t<span class=\"icon paste\" style=\"float: left;\" unselectable=\"on\">&nbsp;</span> paste\n\t\t\t\t\t</span>\n\t\t\t\t\t<!-- \"droppable\" options -->\n\t\t\t\t\t<span class=\"iconContainer\" dojoAttachPoint=\"undoButton\"\n\t\t\t\t\t\tdojoOnClick=\"undoClick; buttonClick;\" unselectable=\"on\">\n\t\t\t\t\t\t<span class=\"icon undo\" style=\"float: left;\" unselectable=\"on\">&nbsp;</span> undo\n\t\t\t\t\t</span>\n\t\t\t\t\t<span class=\"iconContainer\" dojoAttachPoint=\"redoButton\"\n\t\t\t\t\t\tdojoOnClick=\"redoClick; buttonClick;\" unselectable=\"on\">\n\t\t\t\t\t\t<span class=\"icon redo\" style=\"float: left;\" unselectable=\"on\">&nbsp;</span> redo\n\t\t\t\t\t</span>\n\t\t\t\t</td>\t\n\t\t\t</tr>\n\t\t</tbody>\n\t</table>\n</div>\n",templateCssString:".StyleDropdownContainer {\n\tposition: absolute;\n\tz-index: 1000;\n\toverflow: auto;\n\tcursor: default;\n\twidth: 250px;\n\theight: 250px;\n\tbackground-color: white;\n\tborder: 1px solid black;\n}\n\n.ColorDropdownContainer {\n\tposition: absolute;\n\tz-index: 1000;\n\toverflow: auto;\n\tcursor: default;\n\twidth: 250px;\n\theight: 150px;\n\tbackground-color: white;\n\tborder: 1px solid black;\n}\n\n.EditorToolbarDomNode {\n\tbackground-image: url(buttons/bg-fade.png);\n\tbackground-repeat: repeat-x;\n\tbackground-position: 0px -50px;\n}\n\n.EditorToolbarSmallBg {\n\tbackground-image: url(images/toolbar-bg.gif);\n\tbackground-repeat: repeat-x;\n\tbackground-position: 0px 0px;\n}\n\n/*\nbody {\n\tbackground:url(images/blank.gif) fixed;\n}*/\n\n.IEFixedToolbar {\n\tposition:absolute;\n\t/* top:0; */\n\ttop: expression(eval((document.documentElement||document.body).scrollTop));\n}\n\ndiv.bigIcon {\n\twidth: 40px;\n\theight: 40px; \n\t/* background-color: white; */\n\t/* border: 1px solid #a6a7a3; */\n\tfont-family: Verdana, Trebuchet, Tahoma, Arial;\n}\n\n.iconContainer {\n\tfont-family: Verdana, Trebuchet, Tahoma, Arial;\n\tfont-size: 13px;\n\tfloat: left;\n\theight: 18px;\n\tdisplay: block;\n\t/* background-color: white; */\n\tcursor: pointer;\n\tpadding: 1px 4px 1px 1px; /* almost the same as a transparent border */\n\tborder: 0px;\n}\n\n.dojoE2TBIcon {\n\tdisplay: block;\n\ttext-align: center;\n\tmin-width: 18px;\n\twidth: 18px;\n\theight: 18px;\n\t/* background-color: #a6a7a3; */\n\tbackground-repeat: no-repeat;\n\tbackground-image: url(buttons/aggregate.gif);\n}\n\n\n.dojoE2TBIcon[class~=dojoE2TBIcon] {\n}\n\n.ToolbarButtonLatched {\n    border: #316ac5 1px solid; !important;\n    padding: 0px 3px 0px 0px; !important; /* make room for border */\n    background-color: #c1d2ee;\n}\n\n.ToolbarButtonHighlighted {\n    border: #316ac5 1px solid; !important;\n    padding: 0px 3px 0px 0px; !important; /* make room for border */\n    background-color: #dff1ff;\n}\n\n.ToolbarButtonDisabled{\n    filter: gray() alpha(opacity=30); /* IE */\n    opacity: 0.30; /* Safari, Opera and Mozilla */\n}\n\n.headingContainer {\n\twidth: 150px;\n\theight: 30px;\n\tmargin: 0px;\n\t/* padding-left: 5px; */\n\toverflow: hidden;\n\tline-height: 25px;\n\tborder-bottom: 1px solid black;\n\tborder-top: 1px solid white;\n}\n\n.EditorToolbarDomNode select {\n\tfont-size: 14px;\n}\n \n.dojoE2TBIcon_Sep { width: 5px; min-width: 5px; max-width: 5px; background-position: 0px 0px}\n.dojoE2TBIcon_Backcolor { background-position: -18px 0px}\n.dojoE2TBIcon_Bold { background-position: -36px 0px}\n.dojoE2TBIcon_Cancel { background-position: -54px 0px}\n.dojoE2TBIcon_Copy { background-position: -72px 0px}\n.dojoE2TBIcon_Link { background-position: -90px 0px}\n.dojoE2TBIcon_Cut { background-position: -108px 0px}\n.dojoE2TBIcon_Delete { background-position: -126px 0px}\n.dojoE2TBIcon_TextColor { background-position: -144px 0px}\n.dojoE2TBIcon_BackgroundColor { background-position: -162px 0px}\n.dojoE2TBIcon_Indent { background-position: -180px 0px}\n.dojoE2TBIcon_HorizontalLine { background-position: -198px 0px}\n.dojoE2TBIcon_Image { background-position: -216px 0px}\n.dojoE2TBIcon_NumberedList { background-position: -234px 0px}\n.dojoE2TBIcon_Table { background-position: -252px 0px}\n.dojoE2TBIcon_BulletedList { background-position: -270px 0px}\n.dojoE2TBIcon_Italic { background-position: -288px 0px}\n.dojoE2TBIcon_CenterJustify { background-position: -306px 0px}\n.dojoE2TBIcon_BlockJustify { background-position: -324px 0px}\n.dojoE2TBIcon_LeftJustify { background-position: -342px 0px}\n.dojoE2TBIcon_RightJustify { background-position: -360px 0px}\n.dojoE2TBIcon_left_to_right { background-position: -378px 0px}\n.dojoE2TBIcon_list_bullet_indent { background-position: -396px 0px}\n.dojoE2TBIcon_list_bullet_outdent { background-position: -414px 0px}\n.dojoE2TBIcon_list_num_indent { background-position: -432px 0px}\n.dojoE2TBIcon_list_num_outdent { background-position: -450px 0px}\n.dojoE2TBIcon_Outdent { background-position: -468px 0px}\n.dojoE2TBIcon_Paste { background-position: -486px 0px}\n.dojoE2TBIcon_Redo { background-position: -504px 0px}\ndojoE2TBIcon_RemoveFormat { background-position: -522px 0px}\n.dojoE2TBIcon_right_to_left { background-position: -540px 0px}\n.dojoE2TBIcon_Save { background-position: -558px 0px}\n.dojoE2TBIcon_Space { background-position: -576px 0px}\n.dojoE2TBIcon_StrikeThrough { background-position: -594px 0px}\n.dojoE2TBIcon_Subscript { background-position: -612px 0px}\n.dojoE2TBIcon_Superscript { background-position: -630px 0px}\n.dojoE2TBIcon_Underline { background-position: -648px 0px}\n.dojoE2TBIcon_Undo { background-position: -666px 0px}\n.dojoE2TBIcon_WikiWord { background-position: -684px 0px}\n\n",templateCssPath:dojo.uri.moduleUri("dojo.widget","templates/EditorToolbar.css"),ToolbarLatchedItemStyle:"ToolbarButtonLatched",ToolbarEnabledItemStyle:"ToolbarButtonEnabled",ToolbarDisabledItemStyle:"ToolbarButtonDisabled",ToolbarHighlightedItemStyle:"ToolbarButtonHighlighted",ToolbarHighlightedSelectStyle:"ToolbarSelectHighlighted",ToolbarHighlightedSelectItemStyle:"ToolbarSelectHighlightedItem",postCreate:function(){
var _a93=dojo.html.getElementsByClass("dojoEditorToolbarItem",this.domNode);
this.items={};
for(var x=0;x<_a93.length;x++){
var node=_a93[x];
var _a96=node.getAttribute("dojoETItemName");
if(_a96){
var item=dojo.widget.Editor2ToolbarItemManager.getToolbarItem(_a96);
if(item){
item.create(node,this);
this.items[_a96.toLowerCase()]=item;
}else{
node.style.display="none";
}
}
}
},update:function(){
for(var cmd in this.items){
this.items[cmd].refreshState();
}
},shareGroup:"",checkAvailability:function(){
if(!this.shareGroup){
this.parent.focus();
return true;
}
var _a99=dojo.widget.Editor2Manager.getCurrentInstance();
if(this.shareGroup==_a99.toolbarGroup){
return true;
}
return false;
},destroy:function(){
for(var it in this.items){
this.items[it].destroy();
delete this.items[it];
}
dojo.widget.Editor2Toolbar.superclass.destroy.call(this);
}});
dojo.provide("dojo.uri.cache");
dojo.uri.cache={_cache:{},set:function(uri,_a9c){
this._cache[uri.toString()]=_a9c;
return uri;
},remove:function(uri){
delete this._cache[uri.toString()];
},get:function(uri){
var key=uri.toString();
var _aa0=this._cache[key];
if(!_aa0){
_aa0=dojo.hostenv.getText(key);
if(_aa0){
this._cache[key]=_aa0;
}
}
return _aa0;
},allow:function(uri){
return uri;
}};
dojo.provide("dojo.lfx.shadow");
dojo.lfx.shadow=function(node){
this.shadowPng=dojo.uri.moduleUri("dojo.html","images/shadow");
this.shadowThickness=8;
this.shadowOffset=15;
this.init(node);
};
dojo.extend(dojo.lfx.shadow,{init:function(node){
this.node=node;
this.pieces={};
var x1=-1*this.shadowThickness;
var y0=this.shadowOffset;
var y1=this.shadowOffset+this.shadowThickness;
this._makePiece("tl","top",y0,"left",x1);
this._makePiece("l","top",y1,"left",x1,"scale");
this._makePiece("tr","top",y0,"left",0);
this._makePiece("r","top",y1,"left",0,"scale");
this._makePiece("bl","top",0,"left",x1);
this._makePiece("b","top",0,"left",0,"crop");
this._makePiece("br","top",0,"left",0);
},_makePiece:function(name,_aa8,_aa9,_aaa,_aab,_aac){
var img;
var url=this.shadowPng+name.toUpperCase()+".png";
if(dojo.render.html.ie55||dojo.render.html.ie60){
img=dojo.doc().createElement("div");
img.style.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+url+"'"+(_aac?", sizingMethod='"+_aac+"'":"")+")";
}else{
img=dojo.doc().createElement("img");
img.src=url;
}
img.style.position="absolute";
img.style[_aa8]=_aa9+"px";
img.style[_aaa]=_aab+"px";
img.style.width=this.shadowThickness+"px";
img.style.height=this.shadowThickness+"px";
this.pieces[name]=img;
this.node.appendChild(img);
},size:function(_aaf,_ab0){
var _ab1=_ab0-(this.shadowOffset+this.shadowThickness+1);
if(_ab1<0){
_ab1=0;
}
if(_ab0<1){
_ab0=1;
}
if(_aaf<1){
_aaf=1;
}
with(this.pieces){
l.style.height=_ab1+"px";
r.style.height=_ab1+"px";
b.style.width=(_aaf-1)+"px";
bl.style.top=(_ab0-1)+"px";
b.style.top=(_ab0-1)+"px";
br.style.top=(_ab0-1)+"px";
tr.style.left=(_aaf-1)+"px";
r.style.left=(_aaf-1)+"px";
br.style.left=(_aaf-1)+"px";
}
}});
dojo.provide("dojo.widget.html.layout");
dojo.widget.html.layout=function(_ab2,_ab3,_ab4){
dojo.html.addClass(_ab2,"dojoLayoutContainer");
_ab3=dojo.lang.filter(_ab3,function(_ab5,idx){
_ab5.idx=idx;
return dojo.lang.inArray(["top","bottom","left","right","client","flood"],_ab5.layoutAlign);
});
if(_ab4&&_ab4!="none"){
var rank=function(_ab8){
switch(_ab8.layoutAlign){
case "flood":
return 1;
case "left":
case "right":
return (_ab4=="left-right")?2:3;
case "top":
case "bottom":
return (_ab4=="left-right")?3:2;
default:
return 4;
}
};
_ab3.sort(function(a,b){
return (rank(a)-rank(b))||(a.idx-b.idx);
});
}
var f={top:dojo.html.getPixelValue(_ab2,"padding-top",true),left:dojo.html.getPixelValue(_ab2,"padding-left",true)};
dojo.lang.mixin(f,dojo.html.getContentBox(_ab2));
dojo.lang.forEach(_ab3,function(_abc){
var elm=_abc.domNode;
var pos=_abc.layoutAlign;
with(elm.style){
left=f.left+"px";
top=f.top+"px";
bottom="auto";
right="auto";
}
dojo.html.addClass(elm,"dojoAlign"+dojo.string.capitalize(pos));
if((pos=="top")||(pos=="bottom")){
dojo.html.setMarginBox(elm,{width:f.width});
var h=dojo.html.getMarginBox(elm).height;
f.height-=h;
if(pos=="top"){
f.top+=h;
}else{
elm.style.top=f.top+f.height+"px";
}
if(_abc.onResized){
_abc.onResized();
}
}else{
if(pos=="left"||pos=="right"){
var w=dojo.html.getMarginBox(elm).width;
if(_abc.resizeTo){
_abc.resizeTo(w,f.height);
}else{
dojo.html.setMarginBox(elm,{width:w,height:f.height});
}
f.width-=w;
if(pos=="left"){
f.left+=w;
}else{
elm.style.left=f.left+f.width+"px";
}
}else{
if(pos=="flood"||pos=="client"){
if(_abc.resizeTo){
_abc.resizeTo(f.width,f.height);
}else{
dojo.html.setMarginBox(elm,{width:f.width,height:f.height});
}
}
}
}
});
};
dojo.html.insertCssText(".dojoLayoutContainer{ position: relative; display: block; overflow: hidden; }\n"+"body .dojoAlignTop, body .dojoAlignBottom, body .dojoAlignLeft, body .dojoAlignRight { position: absolute; overflow: hidden; }\n"+"body .dojoAlignClient { position: absolute }\n"+".dojoAlignClient { overflow: auto; }\n");
dojo.provide("dojo.dnd.DragAndDrop");
dojo.declare("dojo.dnd.DragSource",null,{type:"",onDragEnd:function(evt){
},onDragStart:function(evt){
},onSelected:function(evt){
},unregister:function(){
dojo.dnd.dragManager.unregisterDragSource(this);
},reregister:function(){
dojo.dnd.dragManager.registerDragSource(this);
}});
dojo.declare("dojo.dnd.DragObject",null,{type:"",register:function(){
var dm=dojo.dnd.dragManager;
if(dm["registerDragObject"]){
dm.registerDragObject(this);
}
},onDragStart:function(evt){
},onDragMove:function(evt){
},onDragOver:function(evt){
},onDragOut:function(evt){
},onDragEnd:function(evt){
},onDragLeave:dojo.lang.forward("onDragOut"),onDragEnter:dojo.lang.forward("onDragOver"),ondragout:dojo.lang.forward("onDragOut"),ondragover:dojo.lang.forward("onDragOver")});
dojo.declare("dojo.dnd.DropTarget",null,{acceptsType:function(type){
if(!dojo.lang.inArray(this.acceptedTypes,"*")){
if(!dojo.lang.inArray(this.acceptedTypes,type)){
return false;
}
}
return true;
},accepts:function(_acb){
if(!dojo.lang.inArray(this.acceptedTypes,"*")){
for(var i=0;i<_acb.length;i++){
if(!dojo.lang.inArray(this.acceptedTypes,_acb[i].type)){
return false;
}
}
}
return true;
},unregister:function(){
dojo.dnd.dragManager.unregisterDropTarget(this);
},onDragOver:function(evt){
},onDragOut:function(evt){
},onDragMove:function(evt){
},onDropStart:function(evt){
},onDrop:function(evt){
},onDropEnd:function(){
}},function(){
this.acceptedTypes=[];
});
dojo.dnd.DragEvent=function(){
this.dragSource=null;
this.dragObject=null;
this.target=null;
this.eventStatus="success";
};
dojo.declare("dojo.dnd.DragManager",null,{selectedSources:[],dragObjects:[],dragSources:[],registerDragSource:function(_ad2){
},dropTargets:[],registerDropTarget:function(_ad3){
},lastDragTarget:null,currentDragTarget:null,onKeyDown:function(){
},onMouseOut:function(){
},onMouseMove:function(){
},onMouseUp:function(){
}});
dojo.provide("dojo.dnd.HtmlDragManager");
dojo.declare("dojo.dnd.HtmlDragManager",dojo.dnd.DragManager,{disabled:false,nestedTargets:false,mouseDownTimer:null,dsCounter:0,dsPrefix:"dojoDragSource",dropTargetDimensions:[],currentDropTarget:null,previousDropTarget:null,_dragTriggered:false,selectedSources:[],dragObjects:[],dragSources:[],dropTargets:[],currentX:null,currentY:null,lastX:null,lastY:null,mouseDownX:null,mouseDownY:null,threshold:7,dropAcceptable:false,cancelEvent:function(e){
e.stopPropagation();
e.preventDefault();
},registerDragSource:function(ds){
if(ds["domNode"]){
var dp=this.dsPrefix;
var _ad7=dp+"Idx_"+(this.dsCounter++);
ds.dragSourceId=_ad7;
this.dragSources[_ad7]=ds;
ds.domNode.setAttribute(dp,_ad7);
if(dojo.render.html.ie){
dojo.event.browser.addListener(ds.domNode,"ondragstart",this.cancelEvent);
}
}
},unregisterDragSource:function(ds){
if(ds["domNode"]){
var dp=this.dsPrefix;
var _ada=ds.dragSourceId;
delete ds.dragSourceId;
delete this.dragSources[_ada];
ds.domNode.setAttribute(dp,null);
if(dojo.render.html.ie){
dojo.event.browser.removeListener(ds.domNode,"ondragstart",this.cancelEvent);
}
}
},registerDropTarget:function(dt){
this.dropTargets.push(dt);
},unregisterDropTarget:function(dt){
var _add=dojo.lang.find(this.dropTargets,dt,true);
if(_add>=0){
this.dropTargets.splice(_add,1);
}
},getDragSource:function(e){
var tn=e.target;
if(tn===dojo.body()){
return;
}
var ta=dojo.html.getAttribute(tn,this.dsPrefix);
while((!ta)&&(tn)){
tn=tn.parentNode;
if((!tn)||(tn===dojo.body())){
return;
}
ta=dojo.html.getAttribute(tn,this.dsPrefix);
}
return this.dragSources[ta];
},onKeyDown:function(e){
},onMouseDown:function(e){
if(this.disabled){
return;
}
if(dojo.render.html.ie){
if(e.button!=1){
return;
}
}else{
if(e.which!=1){
return;
}
}
var _ae3=e.target.nodeType==dojo.html.TEXT_NODE?e.target.parentNode:e.target;
if(dojo.html.isTag(_ae3,"button","textarea","input","select","option")){
return;
}
var ds=this.getDragSource(e);
if(!ds){
return;
}
if(!dojo.lang.inArray(this.selectedSources,ds)){
this.selectedSources.push(ds);
ds.onSelected();
}
this.mouseDownX=e.pageX;
this.mouseDownY=e.pageY;
e.preventDefault();
dojo.event.connect(document,"onmousemove",this,"onMouseMove");
},onMouseUp:function(e,_ae6){
if(this.selectedSources.length==0){
return;
}
this.mouseDownX=null;
this.mouseDownY=null;
this._dragTriggered=false;
e.dragSource=this.dragSource;
if((!e.shiftKey)&&(!e.ctrlKey)){
if(this.currentDropTarget){
this.currentDropTarget.onDropStart();
}
dojo.lang.forEach(this.dragObjects,function(_ae7){
var ret=null;
if(!_ae7){
return;
}
if(this.currentDropTarget){
e.dragObject=_ae7;
var ce=this.currentDropTarget.domNode.childNodes;
if(ce.length>0){
e.dropTarget=ce[0];
while(e.dropTarget==_ae7.domNode){
e.dropTarget=e.dropTarget.nextSibling;
}
}else{
e.dropTarget=this.currentDropTarget.domNode;
}
if(this.dropAcceptable){
ret=this.currentDropTarget.onDrop(e);
}else{
this.currentDropTarget.onDragOut(e);
}
}
e.dragStatus=this.dropAcceptable&&ret?"dropSuccess":"dropFailure";
dojo.lang.delayThese([function(){
try{
_ae7.dragSource.onDragEnd(e);
}
catch(err){
var _aea={};
for(var i in e){
if(i=="type"){
_aea.type="mouseup";
continue;
}
_aea[i]=e[i];
}
_ae7.dragSource.onDragEnd(_aea);
}
},function(){
_ae7.onDragEnd(e);
}]);
},this);
this.selectedSources=[];
this.dragObjects=[];
this.dragSource=null;
if(this.currentDropTarget){
this.currentDropTarget.onDropEnd();
}
}else{
}
dojo.event.disconnect(document,"onmousemove",this,"onMouseMove");
this.currentDropTarget=null;
},onScroll:function(){
for(var i=0;i<this.dragObjects.length;i++){
if(this.dragObjects[i].updateDragOffset){
this.dragObjects[i].updateDragOffset();
}
}
if(this.dragObjects.length){
this.cacheTargetLocations();
}
},_dragStartDistance:function(x,y){
if((!this.mouseDownX)||(!this.mouseDownX)){
return;
}
var dx=Math.abs(x-this.mouseDownX);
var dx2=dx*dx;
var dy=Math.abs(y-this.mouseDownY);
var dy2=dy*dy;
return parseInt(Math.sqrt(dx2+dy2),10);
},cacheTargetLocations:function(){
dojo.profile.start("cacheTargetLocations");
this.dropTargetDimensions=[];
dojo.lang.forEach(this.dropTargets,function(_af3){
var tn=_af3.domNode;
if(!tn||!_af3.accepts([this.dragSource])){
return;
}
var abs=dojo.html.getAbsolutePosition(tn,true);
var bb=dojo.html.getBorderBox(tn);
this.dropTargetDimensions.push([[abs.x,abs.y],[abs.x+bb.width,abs.y+bb.height],_af3]);
},this);
dojo.profile.end("cacheTargetLocations");
},onMouseMove:function(e){
if((dojo.render.html.ie)&&(e.button!=1)){
this.currentDropTarget=null;
this.onMouseUp(e,true);
return;
}
if((this.selectedSources.length)&&(!this.dragObjects.length)){
var dx;
var dy;
if(!this._dragTriggered){
this._dragTriggered=(this._dragStartDistance(e.pageX,e.pageY)>this.threshold);
if(!this._dragTriggered){
return;
}
dx=e.pageX-this.mouseDownX;
dy=e.pageY-this.mouseDownY;
}
this.dragSource=this.selectedSources[0];
dojo.lang.forEach(this.selectedSources,function(_afa){
if(!_afa){
return;
}
var tdo=_afa.onDragStart(e);
if(tdo){
tdo.onDragStart(e);
tdo.dragOffset.y+=dy;
tdo.dragOffset.x+=dx;
tdo.dragSource=_afa;
this.dragObjects.push(tdo);
}
},this);
this.previousDropTarget=null;
this.cacheTargetLocations();
}
dojo.lang.forEach(this.dragObjects,function(_afc){
if(_afc){
_afc.onDragMove(e);
}
});
if(this.currentDropTarget){
var c=dojo.html.toCoordinateObject(this.currentDropTarget.domNode,true);
var dtp=[[c.x,c.y],[c.x+c.width,c.y+c.height]];
}
if((!this.nestedTargets)&&(dtp)&&(this.isInsideBox(e,dtp))){
if(this.dropAcceptable){
this.currentDropTarget.onDragMove(e,this.dragObjects);
}
}else{
var _aff=this.findBestTarget(e);
if(_aff.target===null){
if(this.currentDropTarget){
this.currentDropTarget.onDragOut(e);
this.previousDropTarget=this.currentDropTarget;
this.currentDropTarget=null;
}
this.dropAcceptable=false;
return;
}
if(this.currentDropTarget!==_aff.target){
if(this.currentDropTarget){
this.previousDropTarget=this.currentDropTarget;
this.currentDropTarget.onDragOut(e);
}
this.currentDropTarget=_aff.target;
e.dragObjects=this.dragObjects;
this.dropAcceptable=this.currentDropTarget.onDragOver(e);
}else{
if(this.dropAcceptable){
this.currentDropTarget.onDragMove(e,this.dragObjects);
}
}
}
},findBestTarget:function(e){
var _b01=this;
var _b02=new Object();
_b02.target=null;
_b02.points=null;
dojo.lang.every(this.dropTargetDimensions,function(_b03){
if(!_b01.isInsideBox(e,_b03)){
return true;
}
_b02.target=_b03[2];
_b02.points=_b03;
return Boolean(_b01.nestedTargets);
});
return _b02;
},isInsideBox:function(e,_b05){
if((e.pageX>_b05[0][0])&&(e.pageX<_b05[1][0])&&(e.pageY>_b05[0][1])&&(e.pageY<_b05[1][1])){
return true;
}
return false;
},onMouseOver:function(e){
},onMouseOut:function(e){
}});
dojo.dnd.dragManager=new dojo.dnd.HtmlDragManager();
(function(){
var d=document;
var dm=dojo.dnd.dragManager;
dojo.event.connect(d,"onkeydown",dm,"onKeyDown");
dojo.event.connect(d,"onmouseover",dm,"onMouseOver");
dojo.event.connect(d,"onmouseout",dm,"onMouseOut");
dojo.event.connect(d,"onmousedown",dm,"onMouseDown");
dojo.event.connect(d,"onmouseup",dm,"onMouseUp");
dojo.event.connect(window,"onscroll",dm,"onScroll");
})();
dojo.provide("dojo.dnd.HtmlDragAndDrop");
dojo.declare("dojo.dnd.HtmlDragSource",dojo.dnd.DragSource,{dragClass:"",onDragStart:function(){
var _b0a=new dojo.dnd.HtmlDragObject(this.dragObject,this.type);
if(this.dragClass){
_b0a.dragClass=this.dragClass;
}
if(this.constrainToContainer){
_b0a.constrainTo(this.constrainingContainer||this.domNode.parentNode);
}
return _b0a;
},setDragHandle:function(node){
node=dojo.byId(node);
dojo.dnd.dragManager.unregisterDragSource(this);
this.domNode=node;
dojo.dnd.dragManager.registerDragSource(this);
},setDragTarget:function(node){
this.dragObject=node;
},constrainTo:function(_b0d){
this.constrainToContainer=true;
if(_b0d){
this.constrainingContainer=_b0d;
}
},onSelected:function(){
for(var i=0;i<this.dragObjects.length;i++){
dojo.dnd.dragManager.selectedSources.push(new dojo.dnd.HtmlDragSource(this.dragObjects[i]));
}
},addDragObjects:function(el){
for(var i=0;i<arguments.length;i++){
this.dragObjects.push(dojo.byId(arguments[i]));
}
}},function(node,type){
node=dojo.byId(node);
this.dragObjects=[];
this.constrainToContainer=false;
if(node){
this.domNode=node;
this.dragObject=node;
this.type=(type)||(this.domNode.nodeName.toLowerCase());
dojo.dnd.DragSource.prototype.reregister.call(this);
}
});
dojo.declare("dojo.dnd.HtmlDragObject",dojo.dnd.DragObject,{dragClass:"",opacity:0.5,createIframe:true,disableX:false,disableY:false,createDragNode:function(){
var node=this.domNode.cloneNode(true);
if(this.dragClass){
dojo.html.addClass(node,this.dragClass);
}
if(this.opacity<1){
dojo.html.setOpacity(node,this.opacity);
}
var ltn=node.tagName.toLowerCase();
var isTr=(ltn=="tr");
if((isTr)||(ltn=="tbody")){
var doc=this.domNode.ownerDocument;
var _b17=doc.createElement("table");
if(isTr){
var _b18=doc.createElement("tbody");
_b17.appendChild(_b18);
_b18.appendChild(node);
}else{
_b17.appendChild(node);
}
var _b19=((isTr)?this.domNode:this.domNode.firstChild);
var _b1a=((isTr)?node:node.firstChild);
var _b1b=_b19.childNodes;
var _b1c=_b1a.childNodes;
for(var i=0;i<_b1b.length;i++){
if((_b1c[i])&&(_b1c[i].style)){
_b1c[i].style.width=dojo.html.getContentBox(_b1b[i]).width+"px";
}
}
node=_b17;
}
if((dojo.render.html.ie55||dojo.render.html.ie60)&&this.createIframe){
with(node.style){
top="0px";
left="0px";
}
var _b1e=document.createElement("div");
_b1e.appendChild(node);
this.bgIframe=new dojo.html.BackgroundIframe(_b1e);
_b1e.appendChild(this.bgIframe.iframe);
node=_b1e;
}
node.style.zIndex=999;
return node;
},onDragStart:function(e){
dojo.html.clearSelection();
this.scrollOffset=dojo.html.getScroll().offset;
this.dragStartPosition=dojo.html.getAbsolutePosition(this.domNode,true);
this.dragOffset={y:this.dragStartPosition.y-e.pageY,x:this.dragStartPosition.x-e.pageX};
this.dragClone=this.createDragNode();
this.containingBlockPosition=this.domNode.offsetParent?dojo.html.getAbsolutePosition(this.domNode.offsetParent,true):{x:0,y:0};
if(this.constrainToContainer){
this.constraints=this.getConstraints();
}
with(this.dragClone.style){
position="absolute";
top=this.dragOffset.y+e.pageY+"px";
left=this.dragOffset.x+e.pageX+"px";
}
dojo.body().appendChild(this.dragClone);
dojo.event.topic.publish("dragStart",{source:this});
},getConstraints:function(){
if(this.constrainingContainer.nodeName.toLowerCase()=="body"){
var _b20=dojo.html.getViewport();
var _b21=_b20.width;
var _b22=_b20.height;
var _b23=dojo.html.getScroll().offset;
var x=_b23.x;
var y=_b23.y;
}else{
var _b26=dojo.html.getContentBox(this.constrainingContainer);
_b21=_b26.width;
_b22=_b26.height;
x=this.containingBlockPosition.x+dojo.html.getPixelValue(this.constrainingContainer,"padding-left",true)+dojo.html.getBorderExtent(this.constrainingContainer,"left");
y=this.containingBlockPosition.y+dojo.html.getPixelValue(this.constrainingContainer,"padding-top",true)+dojo.html.getBorderExtent(this.constrainingContainer,"top");
}
var mb=dojo.html.getMarginBox(this.domNode);
return {minX:x,minY:y,maxX:x+_b21-mb.width,maxY:y+_b22-mb.height};
},updateDragOffset:function(){
var _b28=dojo.html.getScroll().offset;
if(_b28.y!=this.scrollOffset.y){
var diff=_b28.y-this.scrollOffset.y;
this.dragOffset.y+=diff;
this.scrollOffset.y=_b28.y;
}
if(_b28.x!=this.scrollOffset.x){
var diff=_b28.x-this.scrollOffset.x;
this.dragOffset.x+=diff;
this.scrollOffset.x=_b28.x;
}
},onDragMove:function(e){
this.updateDragOffset();
var x=this.dragOffset.x+e.pageX;
var y=this.dragOffset.y+e.pageY;
if(this.constrainToContainer){
if(x<this.constraints.minX){
x=this.constraints.minX;
}
if(y<this.constraints.minY){
y=this.constraints.minY;
}
if(x>this.constraints.maxX){
x=this.constraints.maxX;
}
if(y>this.constraints.maxY){
y=this.constraints.maxY;
}
}
this.setAbsolutePosition(x,y);
dojo.event.topic.publish("dragMove",{source:this});
},setAbsolutePosition:function(x,y){
if(!this.disableY){
this.dragClone.style.top=y+"px";
}
if(!this.disableX){
this.dragClone.style.left=x+"px";
}
},onDragEnd:function(e){
switch(e.dragStatus){
case "dropSuccess":
dojo.html.removeNode(this.dragClone);
this.dragClone=null;
break;
case "dropFailure":
var _b30=dojo.html.getAbsolutePosition(this.dragClone,true);
var _b31={left:this.dragStartPosition.x+1,top:this.dragStartPosition.y+1};
var anim=dojo.lfx.slideTo(this.dragClone,_b31,300);
var _b33=this;
dojo.event.connect(anim,"onEnd",function(e){
dojo.html.removeNode(_b33.dragClone);
_b33.dragClone=null;
});
anim.play();
break;
}
dojo.event.topic.publish("dragEnd",{source:this});
},constrainTo:function(_b35){
this.constrainToContainer=true;
if(_b35){
this.constrainingContainer=_b35;
}else{
this.constrainingContainer=this.domNode.parentNode;
}
}},function(node,type){
this.domNode=dojo.byId(node);
this.type=type;
this.constrainToContainer=false;
this.dragSource=null;
dojo.dnd.DragObject.prototype.register.call(this);
});
dojo.declare("dojo.dnd.HtmlDropTarget",dojo.dnd.DropTarget,{vertical:false,onDragOver:function(e){
if(!this.accepts(e.dragObjects)){
return false;
}
this.childBoxes=[];
for(var i=0,_b3a;i<this.domNode.childNodes.length;i++){
_b3a=this.domNode.childNodes[i];
if(_b3a.nodeType!=dojo.html.ELEMENT_NODE){
continue;
}
var pos=dojo.html.getAbsolutePosition(_b3a,true);
var _b3c=dojo.html.getBorderBox(_b3a);
this.childBoxes.push({top:pos.y,bottom:pos.y+_b3c.height,left:pos.x,right:pos.x+_b3c.width,height:_b3c.height,width:_b3c.width,node:_b3a});
}
return true;
},_getNodeUnderMouse:function(e){
for(var i=0,_b3f;i<this.childBoxes.length;i++){
with(this.childBoxes[i]){
if(e.pageX>=left&&e.pageX<=right&&e.pageY>=top&&e.pageY<=bottom){
return i;
}
}
}
return -1;
},createDropIndicator:function(){
this.dropIndicator=document.createElement("div");
with(this.dropIndicator.style){
position="absolute";
zIndex=999;
if(this.vertical){
borderLeftWidth="1px";
borderLeftColor="black";
borderLeftStyle="solid";
height=dojo.html.getBorderBox(this.domNode).height+"px";
top=dojo.html.getAbsolutePosition(this.domNode,true).y+"px";
}else{
borderTopWidth="1px";
borderTopColor="black";
borderTopStyle="solid";
width=dojo.html.getBorderBox(this.domNode).width+"px";
left=dojo.html.getAbsolutePosition(this.domNode,true).x+"px";
}
}
},onDragMove:function(e,_b41){
var i=this._getNodeUnderMouse(e);
if(!this.dropIndicator){
this.createDropIndicator();
}
var _b43=this.vertical?dojo.html.gravity.WEST:dojo.html.gravity.NORTH;
var hide=false;
if(i<0){
if(this.childBoxes.length){
var _b45=(dojo.html.gravity(this.childBoxes[0].node,e)&_b43);
if(_b45){
hide=true;
}
}else{
var _b45=true;
}
}else{
var _b46=this.childBoxes[i];
var _b45=(dojo.html.gravity(_b46.node,e)&_b43);
if(_b46.node===_b41[0].dragSource.domNode){
hide=true;
}else{
var _b47=_b45?(i>0?this.childBoxes[i-1]:_b46):(i<this.childBoxes.length-1?this.childBoxes[i+1]:_b46);
if(_b47.node===_b41[0].dragSource.domNode){
hide=true;
}
}
}
if(hide){
this.dropIndicator.style.display="none";
return;
}else{
this.dropIndicator.style.display="";
}
this.placeIndicator(e,_b41,i,_b45);
if(!dojo.html.hasParent(this.dropIndicator)){
dojo.body().appendChild(this.dropIndicator);
}
},placeIndicator:function(e,_b49,_b4a,_b4b){
var _b4c=this.vertical?"left":"top";
var _b4d;
if(_b4a<0){
if(this.childBoxes.length){
_b4d=_b4b?this.childBoxes[0]:this.childBoxes[this.childBoxes.length-1];
}else{
this.dropIndicator.style[_b4c]=dojo.html.getAbsolutePosition(this.domNode,true)[this.vertical?"x":"y"]+"px";
}
}else{
_b4d=this.childBoxes[_b4a];
}
if(_b4d){
this.dropIndicator.style[_b4c]=(_b4b?_b4d[_b4c]:_b4d[this.vertical?"right":"bottom"])+"px";
if(this.vertical){
this.dropIndicator.style.height=_b4d.height+"px";
this.dropIndicator.style.top=_b4d.top+"px";
}else{
this.dropIndicator.style.width=_b4d.width+"px";
this.dropIndicator.style.left=_b4d.left+"px";
}
}
},onDragOut:function(e){
if(this.dropIndicator){
dojo.html.removeNode(this.dropIndicator);
delete this.dropIndicator;
}
},onDrop:function(e){
this.onDragOut(e);
var i=this._getNodeUnderMouse(e);
var _b51=this.vertical?dojo.html.gravity.WEST:dojo.html.gravity.NORTH;
if(i<0){
if(this.childBoxes.length){
if(dojo.html.gravity(this.childBoxes[0].node,e)&_b51){
return this.insert(e,this.childBoxes[0].node,"before");
}else{
return this.insert(e,this.childBoxes[this.childBoxes.length-1].node,"after");
}
}
return this.insert(e,this.domNode,"append");
}
var _b52=this.childBoxes[i];
if(dojo.html.gravity(_b52.node,e)&_b51){
return this.insert(e,_b52.node,"before");
}else{
return this.insert(e,_b52.node,"after");
}
},insert:function(e,_b54,_b55){
var node=e.dragObject.domNode;
if(_b55=="before"){
return dojo.html.insertBefore(node,_b54);
}else{
if(_b55=="after"){
return dojo.html.insertAfter(node,_b54);
}else{
if(_b55=="append"){
_b54.appendChild(node);
return true;
}
}
}
return false;
}},function(node,_b58){
if(arguments.length==0){
return;
}
this.domNode=dojo.byId(node);
dojo.dnd.DropTarget.call(this);
if(_b58&&dojo.lang.isString(_b58)){
_b58=[_b58];
}
this.acceptedTypes=_b58||[];
dojo.dnd.dragManager.registerDropTarget(this);
});
dojo.kwCompoundRequire({common:["dojo.dnd.DragAndDrop"],browser:["dojo.dnd.HtmlDragAndDrop"],dashboard:["dojo.dnd.HtmlDragAndDrop"]});
dojo.provide("dojo.dnd.*");
dojo.provide("dojo.dnd.HtmlDragMove");
dojo.declare("dojo.dnd.HtmlDragMoveSource",dojo.dnd.HtmlDragSource,{onDragStart:function(){
var _b59=new dojo.dnd.HtmlDragMoveObject(this.dragObject,this.type);
if(this.constrainToContainer){
_b59.constrainTo(this.constrainingContainer);
}
return _b59;
},onSelected:function(){
for(var i=0;i<this.dragObjects.length;i++){
dojo.dnd.dragManager.selectedSources.push(new dojo.dnd.HtmlDragMoveSource(this.dragObjects[i]));
}
}});
dojo.declare("dojo.dnd.HtmlDragMoveObject",dojo.dnd.HtmlDragObject,{onDragStart:function(e){
dojo.html.clearSelection();
this.dragClone=this.domNode;
if(dojo.html.getComputedStyle(this.domNode,"position")!="absolute"){
this.domNode.style.position="relative";
}
var left=parseInt(dojo.html.getComputedStyle(this.domNode,"left"));
var top=parseInt(dojo.html.getComputedStyle(this.domNode,"top"));
this.dragStartPosition={x:isNaN(left)?0:left,y:isNaN(top)?0:top};
this.scrollOffset=dojo.html.getScroll().offset;
this.dragOffset={y:this.dragStartPosition.y-e.pageY,x:this.dragStartPosition.x-e.pageX};
this.containingBlockPosition={x:0,y:0};
if(this.constrainToContainer){
this.constraints=this.getConstraints();
}
dojo.event.connect(this.domNode,"onclick",this,"_squelchOnClick");
},onDragEnd:function(e){
},setAbsolutePosition:function(x,y){
if(!this.disableY){
this.domNode.style.top=y+"px";
}
if(!this.disableX){
this.domNode.style.left=x+"px";
}
},_squelchOnClick:function(e){
dojo.event.browser.stopEvent(e);
dojo.event.disconnect(this.domNode,"onclick",this,"_squelchOnClick");
}});
dojo.provide("dojo.widget.Dialog");
dojo.declare("dojo.widget.ModalDialogBase",null,{isContainer:true,focusElement:"",bgColor:"black",bgOpacity:0.4,followScroll:true,closeOnBackgroundClick:false,trapTabs:function(e){
if(e.target==this.tabStartOuter){
if(this._fromTrap){
this.tabStart.focus();
this._fromTrap=false;
}else{
this._fromTrap=true;
this.tabEnd.focus();
}
}else{
if(e.target==this.tabStart){
if(this._fromTrap){
this._fromTrap=false;
}else{
this._fromTrap=true;
this.tabEnd.focus();
}
}else{
if(e.target==this.tabEndOuter){
if(this._fromTrap){
this.tabEnd.focus();
this._fromTrap=false;
}else{
this._fromTrap=true;
this.tabStart.focus();
}
}else{
if(e.target==this.tabEnd){
if(this._fromTrap){
this._fromTrap=false;
}else{
this._fromTrap=true;
this.tabStart.focus();
}
}
}
}
}
},clearTrap:function(e){
var _b64=this;
setTimeout(function(){
_b64._fromTrap=false;
},100);
},postCreate:function(){
with(this.domNode.style){
position="absolute";
zIndex=999;
display="none";
overflow="visible";
}
var b=dojo.body();
b.appendChild(this.domNode);
this.bg=document.createElement("div");
this.bg.className="dialogUnderlay";
with(this.bg.style){
position="absolute";
left=top="0px";
zIndex=998;
display="none";
}
b.appendChild(this.bg);
this.setBackgroundColor(this.bgColor);
this.bgIframe=new dojo.html.BackgroundIframe();
if(this.bgIframe.iframe){
with(this.bgIframe.iframe.style){
position="absolute";
left=top="0px";
zIndex=90;
display="none";
}
}
if(this.closeOnBackgroundClick){
dojo.event.kwConnect({srcObj:this.bg,srcFunc:"onclick",adviceObj:this,adviceFunc:"onBackgroundClick",once:true});
}
},uninitialize:function(){
this.bgIframe.remove();
dojo.html.removeNode(this.bg,true);
},setBackgroundColor:function(_b66){
if(arguments.length>=3){
_b66=new dojo.gfx.color.Color(arguments[0],arguments[1],arguments[2]);
}else{
_b66=new dojo.gfx.color.Color(_b66);
}
this.bg.style.backgroundColor=_b66.toString();
return this.bgColor=_b66;
},setBackgroundOpacity:function(op){
if(arguments.length==0){
op=this.bgOpacity;
}
dojo.html.setOpacity(this.bg,op);
try{
this.bgOpacity=dojo.html.getOpacity(this.bg);
}
catch(e){
this.bgOpacity=op;
}
return this.bgOpacity;
},_sizeBackground:function(){
if(this.bgOpacity>0){
var _b68=dojo.html.getViewport();
var h=_b68.height;
var w=_b68.width;
with(this.bg.style){
width=w+"px";
height=h+"px";
}
var _b6b=dojo.html.getScroll().offset;
this.bg.style.top=_b6b.y+"px";
this.bg.style.left=_b6b.x+"px";
var _b68=dojo.html.getViewport();
if(_b68.width!=w){
this.bg.style.width=_b68.width+"px";
}
if(_b68.height!=h){
this.bg.style.height=_b68.height+"px";
}
}
this.bgIframe.size(this.bg);
},_showBackground:function(){
if(this.bgOpacity>0){
this.bg.style.display="block";
}
if(this.bgIframe.iframe){
this.bgIframe.iframe.style.display="block";
}
},placeModalDialog:function(){
var _b6c=dojo.html.getScroll().offset;
var _b6d=dojo.html.getViewport();
var mb;
if(this.isShowing()){
mb=dojo.html.getMarginBox(this.domNode);
}else{
dojo.html.setVisibility(this.domNode,false);
dojo.html.show(this.domNode);
mb=dojo.html.getMarginBox(this.domNode);
dojo.html.hide(this.domNode);
dojo.html.setVisibility(this.domNode,true);
}
var x=_b6c.x+(_b6d.width-mb.width)/2;
var y=_b6c.y+(_b6d.height-mb.height)/2;
with(this.domNode.style){
left=x+"px";
top=y+"px";
}
},_onKey:function(evt){
if(evt.key){
var node=evt.target;
while(node!=null){
if(node==this.domNode){
return;
}
node=node.parentNode;
}
if(evt.key!=evt.KEY_TAB){
dojo.event.browser.stopEvent(evt);
}else{
if(!dojo.render.html.opera){
try{
this.tabStart.focus();
}
catch(e){
}
}
}
}
},showModalDialog:function(){
if(this.followScroll&&!this._scrollConnected){
this._scrollConnected=true;
dojo.event.connect(window,"onscroll",this,"_onScroll");
}
dojo.event.connect(document.documentElement,"onkey",this,"_onKey");
this.placeModalDialog();
this.setBackgroundOpacity();
this._sizeBackground();
this._showBackground();
this._fromTrap=true;
setTimeout(dojo.lang.hitch(this,function(){
try{
this.tabStart.focus();
}
catch(e){
}
}),50);
},hideModalDialog:function(){
if(this.focusElement){
dojo.byId(this.focusElement).focus();
dojo.byId(this.focusElement).blur();
}
this.bg.style.display="none";
this.bg.style.width=this.bg.style.height="1px";
if(this.bgIframe.iframe){
this.bgIframe.iframe.style.display="none";
}
dojo.event.disconnect(document.documentElement,"onkey",this,"_onKey");
if(this._scrollConnected){
this._scrollConnected=false;
dojo.event.disconnect(window,"onscroll",this,"_onScroll");
}
},_onScroll:function(){
var _b73=dojo.html.getScroll().offset;
this.bg.style.top=_b73.y+"px";
this.bg.style.left=_b73.x+"px";
this.placeModalDialog();
},checkSize:function(){
if(this.isShowing()){
this._sizeBackground();
this.placeModalDialog();
this.onResized();
}
},onBackgroundClick:function(){
if(this.lifetime-this.timeRemaining>=this.blockDuration){
return;
}
this.hide();
}});
dojo.widget.defineWidget("dojo.widget.Dialog",[dojo.widget.ContentPane,dojo.widget.ModalDialogBase],{templateString:"<div id=\"${this.widgetId}\" class=\"dojoDialog\" dojoattachpoint=\"wrapper\">\n\t<span dojoattachpoint=\"tabStartOuter\" dojoonfocus=\"trapTabs\" dojoonblur=\"clearTrap\"\ttabindex=\"0\"></span>\n\t<span dojoattachpoint=\"tabStart\" dojoonfocus=\"trapTabs\" dojoonblur=\"clearTrap\" tabindex=\"0\"></span>\n\t<div dojoattachpoint=\"containerNode\" style=\"position: relative; z-index: 2;\"></div>\n\t<span dojoattachpoint=\"tabEnd\" dojoonfocus=\"trapTabs\" dojoonblur=\"clearTrap\" tabindex=\"0\"></span>\n\t<span dojoattachpoint=\"tabEndOuter\" dojoonfocus=\"trapTabs\" dojoonblur=\"clearTrap\" tabindex=\"0\"></span>\n</div>\n",blockDuration:0,lifetime:0,closeNode:"",postMixInProperties:function(){
dojo.widget.Dialog.superclass.postMixInProperties.apply(this,arguments);
if(this.closeNode){
this.setCloseControl(this.closeNode);
}
},postCreate:function(){
dojo.widget.Dialog.superclass.postCreate.apply(this,arguments);
dojo.widget.ModalDialogBase.prototype.postCreate.apply(this,arguments);
},show:function(){
if(this.lifetime){
this.timeRemaining=this.lifetime;
if(this.timerNode){
this.timerNode.innerHTML=Math.ceil(this.timeRemaining/1000);
}
if(this.blockDuration&&this.closeNode){
if(this.lifetime>this.blockDuration){
this.closeNode.style.visibility="hidden";
}else{
this.closeNode.style.display="none";
}
}
if(this.timer){
clearInterval(this.timer);
}
this.timer=setInterval(dojo.lang.hitch(this,"_onTick"),100);
}
this.showModalDialog();
dojo.widget.Dialog.superclass.show.call(this);
},onLoad:function(){
this.placeModalDialog();
dojo.widget.Dialog.superclass.onLoad.call(this);
},fillInTemplate:function(){
},hide:function(){
this.hideModalDialog();
dojo.widget.Dialog.superclass.hide.call(this);
if(this.timer){
clearInterval(this.timer);
}
},setTimerNode:function(node){
this.timerNode=node;
},setCloseControl:function(node){
this.closeNode=dojo.byId(node);
dojo.event.connect(this.closeNode,"onclick",this,"hide");
},setShowControl:function(node){
node=dojo.byId(node);
dojo.event.connect(node,"onclick",this,"show");
},_onTick:function(){
if(this.timer){
this.timeRemaining-=100;
if(this.lifetime-this.timeRemaining>=this.blockDuration){
if(this.closeNode){
this.closeNode.style.visibility="visible";
}
}
if(!this.timeRemaining){
clearInterval(this.timer);
this.hide();
}else{
if(this.timerNode){
this.timerNode.innerHTML=Math.ceil(this.timeRemaining/1000);
}
}
}
}});
dojo.provide("dojo.widget.ResizeHandle");
dojo.widget.defineWidget("dojo.widget.ResizeHandle",dojo.widget.HtmlWidget,{targetElmId:"",templateCssString:".dojoHtmlResizeHandle {\n\tfloat: right;\n\tposition: absolute;\n\tright: 2px;\n\tbottom: 2px;\n\twidth: 13px;\n\theight: 13px;\n\tz-index: 20;\n\tcursor: nw-resize;\n\tbackground-image: url(grabCorner.gif);\n\tline-height: 0px;\n}\n",templateCssPath:dojo.uri.moduleUri("dojo.widget","templates/ResizeHandle.css"),templateString:"<div class=\"dojoHtmlResizeHandle\"><div></div></div>",postCreate:function(){
dojo.event.connect(this.domNode,"onmousedown",this,"_beginSizing");
},_beginSizing:function(e){
if(this._isSizing){
return false;
}
this.targetWidget=dojo.widget.byId(this.targetElmId);
this.targetDomNode=this.targetWidget?this.targetWidget.domNode:dojo.byId(this.targetElmId);
if(!this.targetDomNode){
return;
}
this._isSizing=true;
this.startPoint={"x":e.clientX,"y":e.clientY};
var mb=dojo.html.getMarginBox(this.targetDomNode);
this.startSize={"w":mb.width,"h":mb.height};
dojo.event.kwConnect({srcObj:dojo.body(),srcFunc:"onmousemove",targetObj:this,targetFunc:"_changeSizing",rate:25});
dojo.event.connect(dojo.body(),"onmouseup",this,"_endSizing");
e.preventDefault();
},_changeSizing:function(e){
try{
if(!e.clientX||!e.clientY){
return;
}
}
catch(e){
return;
}
var dx=this.startPoint.x-e.clientX;
var dy=this.startPoint.y-e.clientY;
var newW=this.startSize.w-dx;
var newH=this.startSize.h-dy;
if(this.minSize){
var mb=dojo.html.getMarginBox(this.targetDomNode);
if(newW<this.minSize.w){
newW=mb.width;
}
if(newH<this.minSize.h){
newH=mb.height;
}
}
if(this.targetWidget){
this.targetWidget.resizeTo(newW,newH);
}else{
dojo.html.setMarginBox(this.targetDomNode,{width:newW,height:newH});
}
e.preventDefault();
},_endSizing:function(e){
dojo.event.disconnect(dojo.body(),"onmousemove",this,"_changeSizing");
dojo.event.disconnect(dojo.body(),"onmouseup",this,"_endSizing");
this._isSizing=false;
}});
dojo.provide("dojo.widget.FloatingPane");
dojo.declare("dojo.widget.FloatingPaneBase",null,{title:"",iconSrc:"",hasShadow:false,constrainToContainer:false,taskBarId:"",resizable:true,titleBarDisplay:true,windowState:"normal",displayCloseAction:false,displayMinimizeAction:false,displayMaximizeAction:false,_max_taskBarConnectAttempts:5,_taskBarConnectAttempts:0,templateString:"<div id=\"${this.widgetId}\" dojoAttachEvent=\"onMouseDown\" class=\"dojoFloatingPane\">\n\t<div dojoAttachPoint=\"titleBar\" class=\"dojoFloatingPaneTitleBar\"  style=\"display:none\">\n\t  \t<img dojoAttachPoint=\"titleBarIcon\"  class=\"dojoFloatingPaneTitleBarIcon\">\n\t\t<div dojoAttachPoint=\"closeAction\" dojoAttachEvent=\"onClick:closeWindow\"\n   \t  \t\tclass=\"dojoFloatingPaneCloseIcon\"></div>\n\t\t<div dojoAttachPoint=\"restoreAction\" dojoAttachEvent=\"onClick:restoreWindow\"\n   \t  \t\tclass=\"dojoFloatingPaneRestoreIcon\"></div>\n\t\t<div dojoAttachPoint=\"maximizeAction\" dojoAttachEvent=\"onClick:maximizeWindow\"\n   \t  \t\tclass=\"dojoFloatingPaneMaximizeIcon\"></div>\n\t\t<div dojoAttachPoint=\"minimizeAction\" dojoAttachEvent=\"onClick:minimizeWindow\"\n   \t  \t\tclass=\"dojoFloatingPaneMinimizeIcon\"></div>\n\t  \t<div dojoAttachPoint=\"titleBarText\" class=\"dojoFloatingPaneTitleText\">${this.title}</div>\n\t</div>\n\n\t<div id=\"${this.widgetId}_container\" dojoAttachPoint=\"containerNode\" class=\"dojoFloatingPaneClient\"></div>\n\n\t<div dojoAttachPoint=\"resizeBar\" class=\"dojoFloatingPaneResizebar\" style=\"display:none\"></div>\n</div>\n",templateCssString:"\n/********** Outer Window ***************/\n\n.dojoFloatingPane {\n\t/* essential css */\n\tposition: absolute;\n\toverflow: visible;\t\t/* so drop shadow is displayed */\n\tz-index: 10;\n\n\t/* styling css */\n\tborder: 1px solid;\n\tborder-color: ThreeDHighlight ThreeDShadow ThreeDShadow ThreeDHighlight;\n\tbackground-color: ThreeDFace;\n}\n\n\n/********** Title Bar ****************/\n\n.dojoFloatingPaneTitleBar {\n\tvertical-align: top;\n\tmargin: 2px 2px 2px 2px;\n\tz-index: 10;\n\tbackground-color: #7596c6;\n\tcursor: default;\n\toverflow: hidden;\n\tborder-color: ThreeDHighlight ThreeDShadow ThreeDShadow ThreeDHighlight;\n\tvertical-align: middle;\n}\n\n.dojoFloatingPaneTitleText {\n\tfloat: left;\n\tpadding: 2px 4px 2px 2px;\n\twhite-space: nowrap;\n\tcolor: CaptionText;\n\tfont: small-caption;\n}\n\n.dojoTitleBarIcon {\n\tfloat: left;\n\theight: 22px;\n\twidth: 22px;\n\tvertical-align: middle;\n\tmargin-right: 5px;\n\tmargin-left: 5px;\n}\n\n.dojoFloatingPaneActions{\n\tfloat: right;\n\tposition: absolute;\n\tright: 2px;\n\ttop: 2px;\n\tvertical-align: middle;\n}\n\n\n.dojoFloatingPaneActionItem {\n\tvertical-align: middle;\n\tmargin-right: 1px;\n\theight: 22px;\n\twidth: 22px;\n}\n\n\n.dojoFloatingPaneTitleBarIcon {\n\t/* essential css */\n\tfloat: left;\n\n\t/* styling css */\n\tmargin-left: 2px;\n\tmargin-right: 4px;\n\theight: 22px;\n}\n\n/* minimize/maximize icons are specified by CSS only */\n.dojoFloatingPaneMinimizeIcon,\n.dojoFloatingPaneMaximizeIcon,\n.dojoFloatingPaneRestoreIcon,\n.dojoFloatingPaneCloseIcon {\n\tvertical-align: middle;\n\theight: 22px;\n\twidth: 22px;\n\tfloat: right;\n}\n.dojoFloatingPaneMinimizeIcon {\n\tbackground-image: url(images/floatingPaneMinimize.gif);\n}\n.dojoFloatingPaneMaximizeIcon {\n\tbackground-image: url(images/floatingPaneMaximize.gif);\n}\n.dojoFloatingPaneRestoreIcon {\n\tbackground-image: url(images/floatingPaneRestore.gif);\n}\n.dojoFloatingPaneCloseIcon {\n\tbackground-image: url(images/floatingPaneClose.gif);\n}\n\n/* bar at bottom of window that holds resize handle */\n.dojoFloatingPaneResizebar {\n\tz-index: 10;\n\theight: 13px;\n\tbackground-color: ThreeDFace;\n}\n\n/************* Client Area ***************/\n\n.dojoFloatingPaneClient {\n\tposition: relative;\n\tz-index: 10;\n\tborder: 1px solid;\n\tborder-color: ThreeDShadow ThreeDHighlight ThreeDHighlight ThreeDShadow;\n\tmargin: 2px;\n\tbackground-color: ThreeDFace;\n\tpadding: 8px;\n\tfont-family: Verdana, Helvetica, Garamond, sans-serif;\n\tfont-size: 12px;\n\toverflow: auto;\n}\n\n",templateCssPath:dojo.uri.moduleUri("dojo.widget","templates/FloatingPane.css"),fillInFloatingPaneTemplate:function(args,frag){
var _b82=this.getFragNodeRef(frag);
dojo.html.copyStyle(this.domNode,_b82);
dojo.body().appendChild(this.domNode);
if(!this.isShowing()){
this.windowState="minimized";
}
if(this.iconSrc==""){
dojo.html.removeNode(this.titleBarIcon);
}else{
this.titleBarIcon.src=this.iconSrc.toString();
}
if(this.titleBarDisplay){
this.titleBar.style.display="";
dojo.html.disableSelection(this.titleBar);
this.titleBarIcon.style.display=(this.iconSrc==""?"none":"");
this.minimizeAction.style.display=(this.displayMinimizeAction?"":"none");
this.maximizeAction.style.display=(this.displayMaximizeAction&&this.windowState!="maximized"?"":"none");
this.restoreAction.style.display=(this.displayMaximizeAction&&this.windowState=="maximized"?"":"none");
this.closeAction.style.display=(this.displayCloseAction?"":"none");
this.drag=new dojo.dnd.HtmlDragMoveSource(this.domNode);
if(this.constrainToContainer){
this.drag.constrainTo();
}
this.drag.setDragHandle(this.titleBar);
var self=this;
dojo.event.topic.subscribe("dragMove",function(info){
if(info.source.domNode==self.domNode){
dojo.event.topic.publish("floatingPaneMove",{source:self});
}
});
}
if(this.resizable){
this.resizeBar.style.display="";
this.resizeHandle=dojo.widget.createWidget("ResizeHandle",{targetElmId:this.widgetId,id:this.widgetId+"_resize"});
this.resizeBar.appendChild(this.resizeHandle.domNode);
}
if(this.hasShadow){
this.shadow=new dojo.lfx.shadow(this.domNode);
}
this.bgIframe=new dojo.html.BackgroundIframe(this.domNode);
if(this.taskBarId){
this._taskBarSetup();
}
dojo.body().removeChild(this.domNode);
},postCreate:function(){
if(dojo.hostenv.post_load_){
this._setInitialWindowState();
}else{
dojo.addOnLoad(this,"_setInitialWindowState");
}
},maximizeWindow:function(evt){
var mb=dojo.html.getMarginBox(this.domNode);
this.previous={width:mb.width||this.width,height:mb.height||this.height,left:this.domNode.style.left,top:this.domNode.style.top,bottom:this.domNode.style.bottom,right:this.domNode.style.right};
if(this.domNode.parentNode.style.overflow.toLowerCase()!="hidden"){
this.parentPrevious={overflow:this.domNode.parentNode.style.overflow};
dojo.debug(this.domNode.parentNode.style.overflow);
this.domNode.parentNode.style.overflow="hidden";
}
this.domNode.style.left=dojo.html.getPixelValue(this.domNode.parentNode,"padding-left",true)+"px";
this.domNode.style.top=dojo.html.getPixelValue(this.domNode.parentNode,"padding-top",true)+"px";
if((this.domNode.parentNode.nodeName.toLowerCase()=="body")){
var _b87=dojo.html.getViewport();
var _b88=dojo.html.getPadding(dojo.body());
this.resizeTo(_b87.width-_b88.width,_b87.height-_b88.height);
}else{
var _b89=dojo.html.getContentBox(this.domNode.parentNode);
this.resizeTo(_b89.width,_b89.height);
}
this.maximizeAction.style.display="none";
this.restoreAction.style.display="";
if(this.resizeHandle){
this.resizeHandle.domNode.style.display="none";
}
this.drag.setDragHandle(null);
this.windowState="maximized";
},minimizeWindow:function(evt){
this.hide();
for(var attr in this.parentPrevious){
this.domNode.parentNode.style[attr]=this.parentPrevious[attr];
}
this.lastWindowState=this.windowState;
this.windowState="minimized";
},restoreWindow:function(evt){
if(this.windowState=="minimized"){
this.show();
if(this.lastWindowState=="maximized"){
this.domNode.parentNode.style.overflow="hidden";
this.windowState="maximized";
}else{
this.windowState="normal";
}
}else{
if(this.windowState=="maximized"){
for(var attr in this.previous){
this.domNode.style[attr]=this.previous[attr];
}
for(var attr in this.parentPrevious){
this.domNode.parentNode.style[attr]=this.parentPrevious[attr];
}
this.resizeTo(this.previous.width,this.previous.height);
this.previous=null;
this.parentPrevious=null;
this.restoreAction.style.display="none";
this.maximizeAction.style.display=this.displayMaximizeAction?"":"none";
if(this.resizeHandle){
this.resizeHandle.domNode.style.display="";
}
this.drag.setDragHandle(this.titleBar);
this.windowState="normal";
}else{
}
}
},toggleDisplay:function(){
if(this.windowState=="minimized"){
this.restoreWindow();
}else{
this.minimizeWindow();
}
},closeWindow:function(evt){
dojo.html.removeNode(this.domNode);
this.destroy();
},onMouseDown:function(evt){
this.bringToTop();
},bringToTop:function(){
var _b90=dojo.widget.manager.getWidgetsByType(this.widgetType);
var _b91=[];
for(var x=0;x<_b90.length;x++){
if(this.widgetId!=_b90[x].widgetId){
_b91.push(_b90[x]);
}
}
_b91.sort(function(a,b){
return a.domNode.style.zIndex-b.domNode.style.zIndex;
});
_b91.push(this);
var _b95=100;
for(x=0;x<_b91.length;x++){
_b91[x].domNode.style.zIndex=_b95+x*2;
}
},_setInitialWindowState:function(){
if(this.isShowing()){
this.width=-1;
var mb=dojo.html.getMarginBox(this.domNode);
this.resizeTo(mb.width,mb.height);
}
if(this.windowState=="maximized"){
this.maximizeWindow();
this.show();
return;
}
if(this.windowState=="normal"){
this.show();
return;
}
if(this.windowState=="minimized"){
this.hide();
return;
}
this.windowState="minimized";
},_taskBarSetup:function(){
var _b97=dojo.widget.getWidgetById(this.taskBarId);
if(!_b97){
if(this._taskBarConnectAttempts<this._max_taskBarConnectAttempts){
dojo.lang.setTimeout(this,this._taskBarSetup,50);
this._taskBarConnectAttempts++;
}else{
dojo.debug("Unable to connect to the taskBar");
}
return;
}
_b97.addChild(this);
},showFloatingPane:function(){
this.bringToTop();
},onFloatingPaneShow:function(){
var mb=dojo.html.getMarginBox(this.domNode);
this.resizeTo(mb.width,mb.height);
},resizeTo:function(_b99,_b9a){
dojo.html.setMarginBox(this.domNode,{width:_b99,height:_b9a});
dojo.widget.html.layout(this.domNode,[{domNode:this.titleBar,layoutAlign:"top"},{domNode:this.resizeBar,layoutAlign:"bottom"},{domNode:this.containerNode,layoutAlign:"client"}]);
dojo.widget.html.layout(this.containerNode,this.children,"top-bottom");
this.bgIframe.onResized();
if(this.shadow){
this.shadow.size(_b99,_b9a);
}
this.onResized();
},checkSize:function(){
},destroyFloatingPane:function(){
if(this.resizeHandle){
this.resizeHandle.destroy();
this.resizeHandle=null;
}
}});
dojo.widget.defineWidget("dojo.widget.FloatingPane",[dojo.widget.ContentPane,dojo.widget.FloatingPaneBase],{fillInTemplate:function(args,frag){
this.fillInFloatingPaneTemplate(args,frag);
dojo.widget.FloatingPane.superclass.fillInTemplate.call(this,args,frag);
},postCreate:function(){
dojo.widget.FloatingPaneBase.prototype.postCreate.apply(this,arguments);
dojo.widget.FloatingPane.superclass.postCreate.apply(this,arguments);
},show:function(){
dojo.widget.FloatingPane.superclass.show.apply(this,arguments);
this.showFloatingPane();
},onShow:function(){
dojo.widget.FloatingPane.superclass.onShow.call(this);
this.onFloatingPaneShow();
},destroy:function(){
this.destroyFloatingPane();
dojo.widget.FloatingPane.superclass.destroy.apply(this,arguments);
}});
dojo.widget.defineWidget("dojo.widget.ModalFloatingPane",[dojo.widget.FloatingPane,dojo.widget.ModalDialogBase],{windowState:"minimized",displayCloseAction:true,postCreate:function(){
dojo.widget.ModalDialogBase.prototype.postCreate.call(this);
dojo.widget.ModalFloatingPane.superclass.postCreate.call(this);
},show:function(){
this.showModalDialog();
dojo.widget.ModalFloatingPane.superclass.show.apply(this,arguments);
this.bg.style.zIndex=this.domNode.style.zIndex-1;
},hide:function(){
this.hideModalDialog();
dojo.widget.ModalFloatingPane.superclass.hide.apply(this,arguments);
},closeWindow:function(){
this.hide();
dojo.widget.ModalFloatingPane.superclass.closeWindow.apply(this,arguments);
}});
dojo.provide("dojo.widget.Editor2Plugin.AlwaysShowToolbar");
dojo.event.topic.subscribe("dojo.widget.Editor2::onLoad",function(_b9d){
if(_b9d.toolbarAlwaysVisible){
var p=new dojo.widget.Editor2Plugin.AlwaysShowToolbar(_b9d);
}
});
dojo.declare("dojo.widget.Editor2Plugin.AlwaysShowToolbar",null,function(_b9f){
this.editor=_b9f;
this.editor.registerLoadedPlugin(this);
this.setup();
},{_scrollSetUp:false,_fixEnabled:false,_scrollThreshold:false,_handleScroll:true,setup:function(){
var tdn=this.editor.toolbarWidget;
if(!tdn.tbBgIframe){
tdn.tbBgIframe=new dojo.html.BackgroundIframe(tdn.domNode);
tdn.tbBgIframe.onResized();
}
this.scrollInterval=setInterval(dojo.lang.hitch(this,"globalOnScrollHandler"),100);
dojo.event.connect("before",this.editor.toolbarWidget,"destroy",this,"destroy");
},globalOnScrollHandler:function(){
var isIE=dojo.render.html.ie;
if(!this._handleScroll){
return;
}
var dh=dojo.html;
var tdn=this.editor.toolbarWidget.domNode;
var db=dojo.body();
if(!this._scrollSetUp){
this._scrollSetUp=true;
var _ba5=dh.getMarginBox(this.editor.domNode).width;
this._scrollThreshold=dh.abs(tdn,true).y;
if((isIE)&&(db)&&(dh.getStyle(db,"background-image")=="none")){
with(db.style){
backgroundImage="url("+dojo.uri.moduleUri("dojo.widget","templates/images/blank.gif")+")";
backgroundAttachment="fixed";
}
}
}
var _ba6=(window["pageYOffset"])?window["pageYOffset"]:(document["documentElement"]||document["body"]).scrollTop;
if(_ba6>this._scrollThreshold){
if(!this._fixEnabled){
var _ba7=dojo.html.getMarginBox(tdn);
this.editor.editorObject.style.marginTop=_ba7.height+"px";
if(isIE){
tdn.style.left=dojo.html.abs(tdn,dojo.html.boxSizing.MARGIN_BOX).x;
if(tdn.previousSibling){
this._IEOriginalPos=["after",tdn.previousSibling];
}else{
if(tdn.nextSibling){
this._IEOriginalPos=["before",tdn.nextSibling];
}else{
this._IEOriginalPos=["",tdn.parentNode];
}
}
dojo.body().appendChild(tdn);
dojo.html.addClass(tdn,"IEFixedToolbar");
}else{
with(tdn.style){
position="fixed";
top="0px";
}
}
tdn.style.width=_ba7.width+"px";
tdn.style.zIndex=1000;
this._fixEnabled=true;
}
if(!dojo.render.html.safari){
var _ba8=(this.height)?parseInt(this.editor.height):this.editor._lastHeight;
if(_ba6>(this._scrollThreshold+_ba8)){
tdn.style.display="none";
}else{
tdn.style.display="";
}
}
}else{
if(this._fixEnabled){
(this.editor.object||this.editor.iframe).style.marginTop=null;
with(tdn.style){
position="";
top="";
zIndex="";
display="";
}
if(isIE){
tdn.style.left="";
dojo.html.removeClass(tdn,"IEFixedToolbar");
if(this._IEOriginalPos){
dojo.html.insertAtPosition(tdn,this._IEOriginalPos[1],this._IEOriginalPos[0]);
this._IEOriginalPos=null;
}else{
dojo.html.insertBefore(tdn,this.editor.object||this.editor.iframe);
}
}
tdn.style.width="";
this._fixEnabled=false;
}
}
},destroy:function(){
this._IEOriginalPos=null;
this._handleScroll=false;
clearInterval(this.scrollInterval);
this.editor.unregisterLoadedPlugin(this);
if(dojo.render.html.ie){
dojo.html.removeClass(this.editor.toolbarWidget.domNode,"IEFixedToolbar");
}
}});
dojo.provide("dojo.widget.Editor2");
dojo.widget.Editor2Manager=new dojo.widget.HandlerManager;
dojo.lang.mixin(dojo.widget.Editor2Manager,{_currentInstance:null,commandState:{Disabled:0,Latched:1,Enabled:2},getCurrentInstance:function(){
return this._currentInstance;
},setCurrentInstance:function(inst){
this._currentInstance=inst;
},getCommand:function(_baa,name){
var _bac;
name=name.toLowerCase();
for(var i=0;i<this._registeredHandlers.length;i++){
_bac=this._registeredHandlers[i](_baa,name);
if(_bac){
return _bac;
}
}
switch(name){
case "htmltoggle":
_bac=new dojo.widget.Editor2BrowserCommand(_baa,name);
break;
case "formatblock":
_bac=new dojo.widget.Editor2FormatBlockCommand(_baa,name);
break;
case "anchor":
_bac=new dojo.widget.Editor2Command(_baa,name);
break;
case "createlink":
_bac=new dojo.widget.Editor2DialogCommand(_baa,name,{contentFile:"dojo.widget.Editor2Plugin.CreateLinkDialog",contentClass:"Editor2CreateLinkDialog",title:"Insert/Edit Link",width:"300px",height:"200px"});
break;
case "insertimage":
_bac=new dojo.widget.Editor2DialogCommand(_baa,name,{contentFile:"dojo.widget.Editor2Plugin.InsertImageDialog",contentClass:"Editor2InsertImageDialog",title:"Insert/Edit Image",width:"400px",height:"270px"});
break;
default:
var _bae=this.getCurrentInstance();
if((_bae&&_bae.queryCommandAvailable(name))||(!_bae&&dojo.widget.Editor2.prototype.queryCommandAvailable(name))){
_bac=new dojo.widget.Editor2BrowserCommand(_baa,name);
}else{
dojo.debug("dojo.widget.Editor2Manager.getCommand: Unknown command "+name);
return;
}
}
return _bac;
},destroy:function(){
this._currentInstance=null;
dojo.widget.HandlerManager.prototype.destroy.call(this);
}});
dojo.addOnUnload(dojo.widget.Editor2Manager,"destroy");
dojo.lang.declare("dojo.widget.Editor2Command",null,function(_baf,name){
this._editor=_baf;
this._updateTime=0;
this._name=name;
},{_text:"Unknown",execute:function(para){
dojo.unimplemented("dojo.widget.Editor2Command.execute");
},getText:function(){
return this._text;
},getState:function(){
return dojo.widget.Editor2Manager.commandState.Enabled;
},destroy:function(){
}});
dojo.widget.Editor2BrowserCommandNames={"bold":"Bold","copy":"Copy","cut":"Cut","Delete":"Delete","indent":"Indent","inserthorizontalrule":"Horizental Rule","insertorderedlist":"Numbered List","insertunorderedlist":"Bullet List","italic":"Italic","justifycenter":"Align Center","justifyfull":"Justify","justifyleft":"Align Left","justifyright":"Align Right","outdent":"Outdent","paste":"Paste","redo":"Redo","removeformat":"Remove Format","selectall":"Select All","strikethrough":"Strikethrough","subscript":"Subscript","superscript":"Superscript","underline":"Underline","undo":"Undo","unlink":"Remove Link","createlink":"Create Link","insertimage":"Insert Image","htmltoggle":"HTML Source","forecolor":"Foreground Color","hilitecolor":"Background Color","plainformatblock":"Paragraph Style","formatblock":"Paragraph Style","fontsize":"Font Size","fontname":"Font Name"};
dojo.lang.declare("dojo.widget.Editor2BrowserCommand",dojo.widget.Editor2Command,function(_bb2,name){
var text=dojo.widget.Editor2BrowserCommandNames[name.toLowerCase()];
if(text){
this._text=text;
}
},{execute:function(para){
this._editor.execCommand(this._name,para);
},getState:function(){
if(this._editor._lastStateTimestamp>this._updateTime||this._state==undefined){
this._updateTime=this._editor._lastStateTimestamp;
try{
if(this._editor.queryCommandEnabled(this._name)){
if(this._editor.queryCommandState(this._name)){
this._state=dojo.widget.Editor2Manager.commandState.Latched;
}else{
this._state=dojo.widget.Editor2Manager.commandState.Enabled;
}
}else{
this._state=dojo.widget.Editor2Manager.commandState.Disabled;
}
}
catch(e){
this._state=dojo.widget.Editor2Manager.commandState.Enabled;
}
}
return this._state;
},getValue:function(){
try{
return this._editor.queryCommandValue(this._name);
}
catch(e){
}
}});
dojo.lang.declare("dojo.widget.Editor2FormatBlockCommand",dojo.widget.Editor2BrowserCommand,{});
dojo.widget.defineWidget("dojo.widget.Editor2Dialog",[dojo.widget.HtmlWidget,dojo.widget.FloatingPaneBase,dojo.widget.ModalDialogBase],{templateString:"<div id=\"${this.widgetId}\" class=\"dojoFloatingPane\">\n\t<span dojoattachpoint=\"tabStartOuter\" dojoonfocus=\"trapTabs\" dojoonblur=\"clearTrap\"\ttabindex=\"0\"></span>\n\t<span dojoattachpoint=\"tabStart\" dojoonfocus=\"trapTabs\" dojoonblur=\"clearTrap\" tabindex=\"0\"></span>\n\t<div dojoAttachPoint=\"titleBar\" class=\"dojoFloatingPaneTitleBar\"  style=\"display:none\">\n\t  \t<img dojoAttachPoint=\"titleBarIcon\"  class=\"dojoFloatingPaneTitleBarIcon\">\n\t\t<div dojoAttachPoint=\"closeAction\" dojoAttachEvent=\"onClick:hide\"\n   \t  \t\tclass=\"dojoFloatingPaneCloseIcon\"></div>\n\t\t<div dojoAttachPoint=\"restoreAction\" dojoAttachEvent=\"onClick:restoreWindow\"\n   \t  \t\tclass=\"dojoFloatingPaneRestoreIcon\"></div>\n\t\t<div dojoAttachPoint=\"maximizeAction\" dojoAttachEvent=\"onClick:maximizeWindow\"\n   \t  \t\tclass=\"dojoFloatingPaneMaximizeIcon\"></div>\n\t\t<div dojoAttachPoint=\"minimizeAction\" dojoAttachEvent=\"onClick:minimizeWindow\"\n   \t  \t\tclass=\"dojoFloatingPaneMinimizeIcon\"></div>\n\t  \t<div dojoAttachPoint=\"titleBarText\" class=\"dojoFloatingPaneTitleText\">${this.title}</div>\n\t</div>\n\n\t<div id=\"${this.widgetId}_container\" dojoAttachPoint=\"containerNode\" class=\"dojoFloatingPaneClient\"></div>\n\t<span dojoattachpoint=\"tabEnd\" dojoonfocus=\"trapTabs\" dojoonblur=\"clearTrap\" tabindex=\"0\"></span>\n\t<span dojoattachpoint=\"tabEndOuter\" dojoonfocus=\"trapTabs\" dojoonblur=\"clearTrap\" tabindex=\"0\"></span>\n\t<div dojoAttachPoint=\"resizeBar\" class=\"dojoFloatingPaneResizebar\" style=\"display:none\"></div>\n</div>\n",modal:true,width:"",height:"",windowState:"minimized",displayCloseAction:true,contentFile:"",contentClass:"",fillInTemplate:function(args,frag){
this.fillInFloatingPaneTemplate(args,frag);
dojo.widget.Editor2Dialog.superclass.fillInTemplate.call(this,args,frag);
},postCreate:function(){
if(this.contentFile){
dojo.require(this.contentFile);
}
if(this.modal){
dojo.widget.ModalDialogBase.prototype.postCreate.call(this);
}else{
with(this.domNode.style){
zIndex=999;
display="none";
}
}
dojo.widget.FloatingPaneBase.prototype.postCreate.apply(this,arguments);
dojo.widget.Editor2Dialog.superclass.postCreate.call(this);
if(this.width&&this.height){
with(this.domNode.style){
width=this.width;
height=this.height;
}
}
},createContent:function(){
if(!this.contentWidget&&this.contentClass){
this.contentWidget=dojo.widget.createWidget(this.contentClass);
this.addChild(this.contentWidget);
}
},show:function(){
if(!this.contentWidget){
dojo.widget.Editor2Dialog.superclass.show.apply(this,arguments);
this.createContent();
dojo.widget.Editor2Dialog.superclass.hide.call(this);
}
if(!this.contentWidget||!this.contentWidget.loadContent()){
return;
}
this.showFloatingPane();
dojo.widget.Editor2Dialog.superclass.show.apply(this,arguments);
if(this.modal){
this.showModalDialog();
}
if(this.modal){
this.bg.style.zIndex=this.domNode.style.zIndex-1;
}
},onShow:function(){
dojo.widget.Editor2Dialog.superclass.onShow.call(this);
this.onFloatingPaneShow();
},closeWindow:function(){
this.hide();
dojo.widget.Editor2Dialog.superclass.closeWindow.apply(this,arguments);
},hide:function(){
if(this.modal){
this.hideModalDialog();
}
dojo.widget.Editor2Dialog.superclass.hide.call(this);
},checkSize:function(){
if(this.isShowing()){
if(this.modal){
this._sizeBackground();
}
this.placeModalDialog();
this.onResized();
}
}});
dojo.widget.defineWidget("dojo.widget.Editor2DialogContent",dojo.widget.HtmlWidget,{widgetsInTemplate:true,loadContent:function(){
return true;
},cancel:function(){
this.parent.hide();
}});
dojo.lang.declare("dojo.widget.Editor2DialogCommand",dojo.widget.Editor2BrowserCommand,function(_bb8,name,_bba){
this.dialogParas=_bba;
},{execute:function(){
if(!this.dialog){
if(!this.dialogParas.contentFile||!this.dialogParas.contentClass){
alert("contentFile and contentClass should be set for dojo.widget.Editor2DialogCommand.dialogParas!");
return;
}
this.dialog=dojo.widget.createWidget("Editor2Dialog",this.dialogParas);
dojo.body().appendChild(this.dialog.domNode);
dojo.event.connect(this,"destroy",this.dialog,"destroy");
}
this.dialog.show();
},getText:function(){
return this.dialogParas.title||dojo.widget.Editor2DialogCommand.superclass.getText.call(this);
}});
dojo.widget.Editor2ToolbarGroups={};
dojo.widget.defineWidget("dojo.widget.Editor2",dojo.widget.RichText,function(){
this._loadedCommands={};
},{toolbarAlwaysVisible:false,toolbarWidget:null,scrollInterval:null,toolbarTemplatePath:dojo.uri.cache.set(dojo.uri.moduleUri("dojo.widget","templates/EditorToolbarOneline.html"),"<div class=\"EditorToolbarDomNode EditorToolbarSmallBg\">\n\t<table cellpadding=\"1\" cellspacing=\"0\" border=\"0\">\n\t\t<tbody>\n\t\t\t<tr valign=\"top\" align=\"left\">\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"htmltoggle\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon\" \n\t\t\t\t\t\tstyle=\"background-image: none; width: 30px;\" >&lt;h&gt;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"copy\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Copy\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"paste\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Paste\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"undo\">\n\t\t\t\t\t\t<!-- FIXME: should we have the text \"undo\" here? -->\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Undo\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"redo\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Redo\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td isSpacer=\"true\">\n\t\t\t\t\t<span class=\"iconContainer\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Sep\"\tstyle=\"width: 5px; min-width: 5px;\"></span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"createlink\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Link\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"insertimage\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Image\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"inserthorizontalrule\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_HorizontalLine \">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"bold\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Bold\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"italic\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Italic\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"underline\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Underline\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"strikethrough\">\n\t\t\t\t\t\t<span \n\t\t\t\t\t\t\tclass=\"dojoE2TBIcon dojoE2TBIcon_StrikeThrough\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td isSpacer=\"true\">\n\t\t\t\t\t<span class=\"iconContainer\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Sep\" \n\t\t\t\t\t\t\tstyle=\"width: 5px; min-width: 5px;\"></span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"insertunorderedlist\">\n\t\t\t\t\t\t<span \n\t\t\t\t\t\t\tclass=\"dojoE2TBIcon dojoE2TBIcon_BulletedList\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"insertorderedlist\">\n\t\t\t\t\t\t<span \n\t\t\t\t\t\t\tclass=\"dojoE2TBIcon dojoE2TBIcon_NumberedList\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td isSpacer=\"true\">\n\t\t\t\t\t<span class=\"iconContainer\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Sep\" style=\"width: 5px; min-width: 5px;\"></span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"indent\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Indent\" \n\t\t\t\t\t\t\tunselectable=\"on\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"outdent\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Outdent\" \n\t\t\t\t\t\t\tunselectable=\"on\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td isSpacer=\"true\">\n\t\t\t\t\t<span class=\"iconContainer\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Sep\" style=\"width: 5px; min-width: 5px;\"></span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"forecolor\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_TextColor\" \n\t\t\t\t\t\t\tunselectable=\"on\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"hilitecolor\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_BackgroundColor\" \n\t\t\t\t\t\t\tunselectable=\"on\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td isSpacer=\"true\">\n\t\t\t\t\t<span class=\"iconContainer\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Sep\" style=\"width: 5px; min-width: 5px;\"></span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"justifyleft\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_LeftJustify\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"justifycenter\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_CenterJustify\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"justifyright\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_RightJustify\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\n\t\t\t\t<td>\n\t\t\t\t\t<span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"justifyfull\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_BlockJustify\">&nbsp;</span>\n\t\t\t\t\t</span>\n\t\t\t\t</td>\t\n\t\t\t\t<td>\n\t\t\t\t\t<select class=\"dojoEditorToolbarItem\" dojoETItemName=\"plainformatblock\">\n\t\t\t\t\t\t<!-- FIXME: using \"p\" here inserts a paragraph in most cases! -->\n\t\t\t\t\t\t<option value=\"\">-- format --</option>\n\t\t\t\t\t\t<option value=\"p\">Normal</option>\n\t\t\t\t\t\t<option value=\"pre\">Fixed Font</option>\n\t\t\t\t\t\t<option value=\"h1\">Main Heading</option>\n\t\t\t\t\t\t<option value=\"h2\">Section Heading</option>\n\t\t\t\t\t\t<option value=\"h3\">Sub-Heading</option>\n\t\t\t\t\t\t<!-- <option value=\"blockquote\">Block Quote</option> -->\n\t\t\t\t\t</select>\n\t\t\t\t</td>\n\t\t\t\t<td><!-- uncomment to enable save button -->\n\t\t\t\t\t<!-- save -->\n\t\t\t\t\t<!--span class=\"iconContainer dojoEditorToolbarItem\" dojoETItemName=\"save\">\n\t\t\t\t\t\t<span class=\"dojoE2TBIcon dojoE2TBIcon_Save\">&nbsp;</span>\n\t\t\t\t\t</span-->\n\t\t\t\t</td>\n\t\t\t\t<td width=\"*\">&nbsp;</td>\n\t\t\t</tr>\n\t\t</tbody>\n\t</table>\n</div>\n"),toolbarTemplateCssPath:null,toolbarPlaceHolder:"",_inSourceMode:false,_htmlEditNode:null,toolbarGroup:"",shareToolbar:false,contextMenuGroupSet:"",editorOnLoad:function(){
dojo.event.topic.publish("dojo.widget.Editor2::preLoadingToolbar",this);
if(this.toolbarAlwaysVisible){
}
if(this.toolbarWidget){
this.toolbarWidget.show();
dojo.html.insertBefore(this.toolbarWidget.domNode,this.domNode.firstChild);
}else{
if(this.shareToolbar){
dojo.deprecated("Editor2:shareToolbar is deprecated in favor of toolbarGroup","0.5");
this.toolbarGroup="defaultDojoToolbarGroup";
}
if(this.toolbarGroup){
if(dojo.widget.Editor2ToolbarGroups[this.toolbarGroup]){
this.toolbarWidget=dojo.widget.Editor2ToolbarGroups[this.toolbarGroup];
}
}
if(!this.toolbarWidget){
var _bbb={shareGroup:this.toolbarGroup,parent:this};
_bbb.templateString=dojo.uri.cache.get(this.toolbarTemplatePath);
if(this.toolbarTemplateCssPath){
_bbb.templateCssPath=this.toolbarTemplateCssPath;
_bbb.templateCssString=dojo.uri.cache.get(this.toolbarTemplateCssPath);
}
if(this.toolbarPlaceHolder){
this.toolbarWidget=dojo.widget.createWidget("Editor2Toolbar",_bbb,dojo.byId(this.toolbarPlaceHolder),"after");
}else{
this.toolbarWidget=dojo.widget.createWidget("Editor2Toolbar",_bbb,this.domNode.firstChild,"before");
}
if(this.toolbarGroup){
dojo.widget.Editor2ToolbarGroups[this.toolbarGroup]=this.toolbarWidget;
}
dojo.event.connect(this,"close",this.toolbarWidget,"hide");
this.toolbarLoaded();
}
}
dojo.event.topic.registerPublisher("Editor2.clobberFocus",this,"clobberFocus");
dojo.event.topic.subscribe("Editor2.clobberFocus",this,"setBlur");
dojo.event.topic.publish("dojo.widget.Editor2::onLoad",this);
},toolbarLoaded:function(){
},registerLoadedPlugin:function(obj){
if(!this.loadedPlugins){
this.loadedPlugins=[];
}
this.loadedPlugins.push(obj);
},unregisterLoadedPlugin:function(obj){
for(var i in this.loadedPlugins){
if(this.loadedPlugins[i]===obj){
delete this.loadedPlugins[i];
return;
}
}
dojo.debug("dojo.widget.Editor2.unregisterLoadedPlugin: unknow plugin object: "+obj);
},execCommand:function(_bbf,_bc0){
switch(_bbf.toLowerCase()){
case "htmltoggle":
this.toggleHtmlEditing();
break;
default:
dojo.widget.Editor2.superclass.execCommand.apply(this,arguments);
}
},queryCommandEnabled:function(_bc1,_bc2){
switch(_bc1.toLowerCase()){
case "htmltoggle":
return true;
default:
if(this._inSourceMode){
return false;
}
return dojo.widget.Editor2.superclass.queryCommandEnabled.apply(this,arguments);
}
},queryCommandState:function(_bc3,_bc4){
switch(_bc3.toLowerCase()){
case "htmltoggle":
return this._inSourceMode;
default:
return dojo.widget.Editor2.superclass.queryCommandState.apply(this,arguments);
}
},onClick:function(e){
dojo.widget.Editor2.superclass.onClick.call(this,e);
if(dojo.widget.PopupManager){
if(!e){
e=this.window.event;
}
dojo.widget.PopupManager.onClick(e);
}
},clobberFocus:function(){
},toggleHtmlEditing:function(){
if(this===dojo.widget.Editor2Manager.getCurrentInstance()){
if(!this._inSourceMode){
var html=this.getEditorContent();
this._inSourceMode=true;
if(!this._htmlEditNode){
this._htmlEditNode=dojo.doc().createElement("textarea");
dojo.html.insertAfter(this._htmlEditNode,this.editorObject);
}
this._htmlEditNode.style.display="";
this._htmlEditNode.style.width="100%";
this._htmlEditNode.style.height=dojo.html.getBorderBox(this.editNode).height+"px";
this._htmlEditNode.value=html;
with(this.editorObject.style){
position="absolute";
left="-2000px";
top="-2000px";
}
}else{
this._inSourceMode=false;
this._htmlEditNode.blur();
with(this.editorObject.style){
position="";
left="";
top="";
}
var html=this._htmlEditNode.value;
dojo.lang.setTimeout(this,"replaceEditorContent",1,html);
this._htmlEditNode.style.display="none";
this.focus();
}
this.onDisplayChanged(null,true);
}
},setFocus:function(){
if(dojo.widget.Editor2Manager.getCurrentInstance()===this){
return;
}
this.clobberFocus();
dojo.widget.Editor2Manager.setCurrentInstance(this);
},setBlur:function(){
},saveSelection:function(){
this._bookmark=null;
this._bookmark=dojo.withGlobal(this.window,dojo.html.selection.getBookmark);
},restoreSelection:function(){
if(this._bookmark){
this.focus();
dojo.withGlobal(this.window,"moveToBookmark",dojo.html.selection,[this._bookmark]);
this._bookmark=null;
}else{
dojo.debug("restoreSelection: no saved selection is found!");
}
},_updateToolbarLastRan:null,_updateToolbarTimer:null,_updateToolbarFrequency:500,updateToolbar:function(_bc7){
if((!this.isLoaded)||(!this.toolbarWidget)){
return;
}
var diff=new Date()-this._updateToolbarLastRan;
if((!_bc7)&&(this._updateToolbarLastRan)&&((diff<this._updateToolbarFrequency))){
clearTimeout(this._updateToolbarTimer);
var _bc9=this;
this._updateToolbarTimer=setTimeout(function(){
_bc9.updateToolbar();
},this._updateToolbarFrequency/2);
return;
}else{
this._updateToolbarLastRan=new Date();
}
if(dojo.widget.Editor2Manager.getCurrentInstance()!==this){
return;
}
this.toolbarWidget.update();
},destroy:function(_bca){
this._htmlEditNode=null;
dojo.event.disconnect(this,"close",this.toolbarWidget,"hide");
if(!_bca){
this.toolbarWidget.destroy();
}
dojo.widget.Editor2.superclass.destroy.call(this);
},_lastStateTimestamp:0,onDisplayChanged:function(e,_bcc){
this._lastStateTimestamp=(new Date()).getTime();
dojo.widget.Editor2.superclass.onDisplayChanged.call(this,e);
this.updateToolbar(_bcc);
},onLoad:function(){
try{
dojo.widget.Editor2.superclass.onLoad.call(this);
}
catch(e){
dojo.debug(e);
}
this.editorOnLoad();
},onFocus:function(){
dojo.widget.Editor2.superclass.onFocus.call(this);
this.setFocus();
},getEditorContent:function(){
if(this._inSourceMode){
return this._htmlEditNode.value;
}
return dojo.widget.Editor2.superclass.getEditorContent.call(this);
},replaceEditorContent:function(html){
if(this._inSourceMode){
this._htmlEditNode.value=html;
return;
}
dojo.widget.Editor2.superclass.replaceEditorContent.apply(this,arguments);
},getCommand:function(name){
if(this._loadedCommands[name]){
return this._loadedCommands[name];
}
var cmd=dojo.widget.Editor2Manager.getCommand(this,name);
this._loadedCommands[name]=cmd;
return cmd;
},shortcuts:[["bold"],["italic"],["underline"],["selectall","a"],["insertunorderedlist","\\"]],setupDefaultShortcuts:function(){
var exec=function(cmd){
return function(){
cmd.execute();
};
};
var self=this;
dojo.lang.forEach(this.shortcuts,function(item){
var cmd=self.getCommand(item[0]);
if(cmd){
self.addKeyHandler(item[1]?item[1]:item[0].charAt(0),item[2]==undefined?self.KEY_CTRL:item[2],exec(cmd));
}
});
}});
