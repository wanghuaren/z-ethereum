package ui.view.view4.yunying
{
	import common.config.xmlres.server.*;
	
	import flash.display.DisplayObject;
	
	import netc.Data;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.king.SkinByWin;
	
	import world.FileManager;
	import world.model.file.BeingFilePath;

	public class HuoDongZhengHeZuoQi
	{
		
		public static var horseid:int;		
		
		private static var _jinjie_level_Index:int = 1;
		
		/**
		 * 
		 */ 
		private static var skinZuoQi:SkinByWin;
		
		public static function show(horseid_:int,mc:DisplayObject):void
		{
			//
			horseid = horseid_;
		
			//var showM:Pub_Sitzup_ShowResModel;			
		
			//
			//showM=XmlManager.localres.SitzupShowXml.getS1(horseid,
					
			//	_jinjie_level_Index * 10 + 1);
			
			
			//var s1_Show:int=showM.s1_show;
			
			
			//var path:String=FileManager.instance.getZuoQiById2(horseid);//s1_Show);
			
//			if(mc["mcZuoQiPreview"]["mcZuoqi"].source != path){
//			mc["mcZuoQiPreview"]["mcZuoqi"].source=path;
//			}
			
			//坐骑形象
			if(skinZuoQi!=null&&skinZuoQi.parent!=null)
			{
				skinZuoQi.unload();
				skinZuoQi.parent.removeChild(skinZuoQi);
				skinZuoQi = null;
			}
			
			if(skinZuoQi==null){
				skinZuoQi=new SkinByWin();
				
				skinZuoQi.mouseChildren = false;
				skinZuoQi.mouseEnabled = false;
				
				skinZuoQi.x=212+190;//212+80;
				skinZuoQi.y=336-100 + 45;
				skinZuoQi.mouseChildren=skinZuoQi.mouseEnabled=false;
			}
			
			//
			var s0:int=0;
			var s1:int=horseid_;
			var s2:int=Data.myKing.s2;
			var s3:int=Data.myKing.s3;
			//				var s3:int= 0;
			
			var path:BeingFilePath=FileManager.instance.getMainByHumanId(s0,s1,s2,s3,Data.myKing.sex);
			
			//2012-10-19 变身情况下，不显示变身
			//2012-12-27 策划搞了很多变身的东西，都是以310开头
			if(s2.toString().indexOf("310")>=0){
				//s2 = s1;
				//s1=0;
				path.setS2(path.s1);
				path.setS1(0);
				
				path.swf_path2 = path.swf_path1;
				path.swf_path1 = "";
				
				path.xml_path2 = path.xml_path1;
				path.xml_path1 = "";
				
			}
			
			
			path.rightHand = FileManager.instance.getRightHand(Data.myKing.metier);
			
			skinZuoQi.setSkin(path,false);	
			
			mc["mcZuoQiPreview"].addChild(skinZuoQi);
			
			mc["mcZuoQiPreview"].visible = true;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}