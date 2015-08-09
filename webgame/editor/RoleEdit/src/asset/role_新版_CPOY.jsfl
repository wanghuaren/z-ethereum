//fl.createDocument();
//var doc=fl.getDocumentDOM();
//doc.frameRate=10;
//isNew的值为true 表示是8方向
//isNew的值为flase 表示是5方向
//var isNew=false;
//var actNum=13;
//var lib=doc.library;
var folderURL=fl.browseForFolderURL("select","打开要导入图片的文件夹");
var files=FLfile.listFolder(folderURL);
var num;
var file;
var libFolderURL;
var item;
var items;
var docArray=new Object();
var signName=prompt("输入资源编号","");
var t_count=0;
for each(file in files){
	if(file.split(".")[1]=="png"){
		var doc;
		var fPoint=file.indexOf("F");
		var currName=file.substr(0,fPoint);
		if(docArray[currName]==null){
			fl.createDocument();
			doc=fl.getDocumentDOM();
			doc.frameRate=10;
			docArray[currName]=doc;
		}else{
			doc=docArray[currName];
		}
		var lib=doc.library
		libFolderURL=currName+"/"+file.substr(fPoint,2);
		lib.newFolder(libFolderURL);
		doc.importFile(folderURL+"/"+file,true);
		lib.selectItem(file);
		item=lib.getSelectedItems()[0];
		lib.moveToFolder(libFolderURL,"",true);
		setLinkage(item,signName+"_"+file.replace(".png",""));
	}else{
		//xml=new XML(FLfile.read(folderURL+"/"+file));
		FLfile.copy(folderURL+"/"+file,folderURL+"/"+signName+"xml.xml");
	}
}
function setLinkage(slectedItem,link){
	item.linkageExportForAS=true;
	item.linkageExportInFirstFrame=true;
	item.linkageIdentifier=link;
}
var fileName;
for (var docName in docArray){
	fileName=docName;
	if(docName=="D1")
		fileName="";
	fl.saveDocument(docArray[docName],folderURL+"/"+"Res_"+signName+fileName+".fla");
	docArray[docName].exportSWF(folderURL+"/"+signName+fileName+".swf");
	docArray[docName].close();
}
function trace(v){
	fl.trace(v);
}
//==============================
/*lib.addNewItem("movie clip","me");
lib.selectItem("me");
item=lib.getSelectedItems()[0];
setLinkage(item,"me");
var timeline=item.timeline;
var frame;
timeline.addNewLayer("图层 2","normal",false);
timeline.addNewLayer("图层 3","normal",false);
timeline.setSelectedLayers(0);
num=0;
while(num<8*actNum){
	timeline.insertBlankKeyframe(num);
	frame=timeline.layers[0].frames[num];
	frame.actionScript="stop();";
	num++;
}
timeline.removeFrames(num);
timeline.setSelectedLayers(1);
num=0;
while(num<8*actNum){
	timeline.insertBlankKeyframe(num);
	frame=timeline.layers[1].frames[num];
	frame.name="D"+(Math.floor(num/8)+1)+"F"+((num%8)+1);
	num++;
}
timeline.removeFrames(num);
timeline.setSelectedLayers(2);
num=0;
while(num<8*actNum){
	timeline.insertBlankKeyframe(num);
	var d=Math.floor(num/8)+1;
	var f=(num%8)+1;
	num++;
}
timeline.removeFrames(num);

addDirect();

function addDirect(){
	var act=0,direct=0,n=0;
	var itemNew;
	var itemTimeline;
	for each(itemInfo in xml.file){
		var fPoint=Number(itemInfo.@name.indexOf("F"));
		if("D"+act+"F"+direct!=itemInfo.@name.substring(0,fPoint+2)){
			if(itemNew!=null){
				addToTimeline(itemNew,act,direct,0);
				if(!isNew){
					if(direct==2){
						addToTimeline(itemNew,act,direct+6,1);
					}else if(direct==3){
						addToTimeline(itemNew,act,direct+4,1);
					}else if(direct==4){
						addToTimeline(itemNew,act,direct+2,1);
					}
				}
			}
			if(itemInfo.@name!="null"){
				if(itemTimeline!=null) itemTimeline.removeFrames(n);
				act=Number(itemInfo.@name.substring(1,fPoint));
				direct=Number(itemInfo.@name.substring(fPoint+1,fPoint+2));
				lib.addNewItem("movie clip","D"+act+"/F"+direct+"/D"+act+"F"+direct);
				lib.selectItem("D"+act+"/F"+direct+"/D"+act+"F"+direct);
				itemNew=lib.getSelectedItems()[0];
				n=1;
			}
		}else{
			n++;
		}
		if(itemInfo.@name!="null"){
			lib.selectItem("D"+act+"/F"+direct+"/"+itemInfo.@name+".png");
			item=lib.getSelectedItems()[0];
			lib.editItem(itemNew.name);
			lib.addItemToDocument({x:0,y:0},item.name);
			var element=itemNew.timeline.layers[0].frames[n-1].elements[0];
			var xy=itemInfo.@name.split("_")
			element.x=Number(xy[1]);
			element.y=Number(xy[2]);
			itemTimeline=itemNew.timeline;
			itemTimeline.insertBlankKeyframe(n);
		}
	}
	if(itemTimeline!=null) itemTimeline.removeFrames(n);
}
fl.saveDocumentAs(doc);
var no;
function addToTimeline(oneItem,a,d,trans){
	no=(a-1)*8+(d-1);
	lib.editItem("me");
	timeline.setSelectedFrames(no,no+1);
	lib.addItemToDocument({x:0,y:0},oneItem.name);
	if(trans==1){
		doc.scaleSelection(-1,1);
	}
	lib.selectItem(oneItem.name);
	doc.align("left", true);
	doc.align("top", true);
}*/