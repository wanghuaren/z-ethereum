while(true){
	var signName=prompt("(输入exit退出)资源的新编号是:","");
	if(signName=="exit"){
		break;
	}
	var folderURL=fl.browseForFolderURL("select","打开要改名文件的FLA文件夹");
	var folderes1=FLfile.listFolder(folderURL);
	for each(folder1 in folderes1){
		if(folder1.indexOf(".fla")>=0){
			var doc=fl.openDocument(folderURL+"/"+folder1);
			var items=doc.library.items
			for each(var item in items){
				if(item.name.indexOf(".png")>=0){
					doc.library.selectItem(item.name);
					setLinkage(item,signName+"_"+item.linkageClassName.substring(item.linkageClassName.indexOf("_D")+1));
				}
			}
			var fName=doc.name.replace(doc.name.substring(doc.name.indexOf("_")+1,doc.name.lastIndexOf("D")<0?doc.name.lastIndexOf("."):doc.name.lastIndexOf("D")),signName);
			fl.saveDocument(doc,folderURL+"/"+fName);
			doc.exportSWF(folderURL+"/"+fName.replace("Res_","").replace(".fla","")+".swf");
			doc.close();
		}
	}
}
function setLinkage(slectedItem,link){
	slectedItem.linkageExportForAS=true;
	slectedItem.linkageExportInFirstFrame=true;
	slectedItem.linkageClassName=link;
}

function trace(v){
	fl.trace(v);
}