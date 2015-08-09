package ui.view.view7
{
	import engine.load.GamelibS;
	import engine.utils.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import ui.base.mainStage.UI_index;

	public class UI_BiShaJi_Pet_Map
	{
		
		private static var _list:HashMap;
		
		private static function get list():HashMap
		{
			
			if(null == _list){
				
				_list = new HashMap();
				
			}
			
			return _list;		
			
		}
		
		private static var _unUselist:Array;
		
		private static function get unUseList():Array
		{
			if(null == _unUselist){
				
				_unUselist = new Array();
				
			}
			
			return _unUselist;	
		}
		
		
		
		public static function Show(objid:uint,skillId:int):void
		{
			var petWin:UI_BiShaJi_Pet;
			
			if(0 == unUseList.length)
			{
				//
				var cloneDo:DisplayObject = GamelibS.getswflink("tong_yong", "win_bi_sha_ji_pet");
				cloneDo.name = "win_bi_sha_ji_pet" + (unUseList.length + 1).toString();
				
				var indexId:int = unUseList.length + 1;
				
				//var cloneArr:Array = [cloneSP];
				
				//var s:Sprite = new cloneArr[0].constructor;
				
				petWin = new UI_BiShaJi_Pet(cloneDo,objid,skillId,indexId);
								
				//
				unUseList.push(petWin);
			}
			
			
			if(unUseList.length > 0)
			{
				petWin = unUseList.shift() as UI_BiShaJi_Pet;
				petWin.reset(objid,skillId);
				
				
				//
				if(null != petWin)
				{
					list.put(petWin.mc.name,petWin);
					petWin.open(true);
				}
			}			
		
		}	
		
		public static function Pool(petWin:UI_BiShaJi_Pet):void{
		
			
			list.remove(petWin.mc.name);
			unUseList.push(petWin);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}