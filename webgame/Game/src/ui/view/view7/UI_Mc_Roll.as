package ui.view.view7
{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	import common.utils.res.ResCtrl;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.frame.ItemManager;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	
	import world.WorldEvent;
	
	public class UI_Mc_Roll extends UIWindow
	{
		
		private static var _dropRollList:Array = [];
		
		
		public static function save(value:Object):void
		{
			value.daoJiShi = 30;
			_dropRollList.push(value);
			
			//
			//instance.refresh();
		}
		
		/**
		 * 
		 * 
		 */ 
		private static var _instance:UI_Mc_Roll;
		
		

		public static function get instance():UI_Mc_Roll
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_Mc_Roll):void
		{
			_instance = value;
		}
		
		public function UI_Mc_Roll(DO:DisplayObject)
		{
			UIMovieClip.currentObjName=null;
			
			//DO.x = 0;
			//DO.y = 0;
			
			super(DO, null, 1, false);
		}
		
		
		override protected function init():void
		{		
			//
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
			DataKey.instance.register(PacketSCDropRollRep.id,SCDropRollRep);
			//this.x = 340;
			//this.y = 25;
		}
		
		private function SCDropRollRep(p:PacketSCDropRollRep2):void
		{
						if(p.hasOwnProperty('tag'))
			{
				if(super.showResult(p)){
					
					
					
				}else{
					
				}
				
			}
			
		}
		
		
		private var hasEffect:Boolean = false;
		public function daoJiShiHandler(e:WorldEvent):void
		{
			var len:int = _dropRollList.length;
			
			
			hasEffect = false;
			
			
			var j:int;
			var daoJiShi_:int;
			//upd
			for(j=1;j<=len;j++)
			{
				daoJiShi_ = _dropRollList[j-1].daoJiShi - 1;
				
				if(daoJiShi_ < 0){
					
					daoJiShi_ = 0;
				}
				
				//close 
				_dropRollList[j-1].daoJiShi = daoJiShi_;	
				
				
			}
			
			
			
			//del
			for(j=1;j<=_dropRollList.length;j++)
			{
				
				daoJiShi_ = _dropRollList[j-1].daoJiShi;
				
				if(daoJiShi_ <= 0){
					
					_dropRollList.splice(j-1,1);
					
					j=1;
					continue;
				}
			
			}
			
			
			
			
			
			
			if(!hasEffect){
				refresh();
			}
			
			
		}
		
		public var MAX_ROLL_NUM:int = 5;
		public function refresh():void
		{
			//mc_roll1 - 5

			//reset
			var j:int;
			for(j=1;j<=MAX_ROLL_NUM;j++)
			{
				
				mc['mc_roll' + j.toString()].visible = false;
				
				
			}
			
			//
			var len:int = _dropRollList.length;
			
			for(j=1;j<=len;j++)
			{
				if(j <= MAX_ROLL_NUM){
				mc['mc_roll' + j.toString()].visible = true;
				mc['mc_roll' + j.toString()].data = _dropRollList[j-1];
				fillData(mc['mc_roll' + j.toString()],_dropRollList[j-1]);
				}
			
			}
			
		}
		
		public function fillData(roll:MovieClip,drop:Object):void
		{
			var item:Pub_ToolsResModel=null;
			child=roll['pic1'];				
			
			item=XmlManager.localres.getToolsXml.getResPath(drop['itemtype']) as Pub_ToolsResModel;
			
			if(item!=null){
				
				
				
				var bag:StructBagCell2=new StructBagCell2();
				bag.itemid=item.tool_id;
				Data.beiBao.fillCahceData(bag);
				//bag.num=arr[i-1].drop_num;
				
				//
				roll['txt_tool_name'].htmlText = ResCtrl.instance().getFontByColor(item.tool_name,bag.toolColor);
				
				ItemManager.instance().setToolTipByData(child,bag,1);
				
				//
				child.visible = true;
				
			}
		
			//
			roll['txt_daoJiShi'].text = drop.daoJiShi + Lang.getLabel("pub_miao");
		
		}
		
		override public function mcHandler(target:Object):void
		{
			//
			var target_name:String = target.name;
			
			var t_data:Object;
			
			var j:int;
			
			if(null != target.parent)
			{
				t_data = target.parent.data;
			}
			
			
			switch (target_name)
			{	
				
				case "btnShuiJi":
										
					var cs:PacketCSDropRollRep = new PacketCSDropRollRep();
					cs.flag = 1;
					cs.objid = t_data.objid;
					uiSend(cs);
					
					for(j=1;j<=_dropRollList.length;j++)
					{
						
						if(_dropRollList[j-1].objid == t_data.objid &&
						   _dropRollList[j-1].itemtype == t_data.itemtype){
							
							_dropRollList.splice(j-1,1);
							
							break;
						}						
					}
					
					
					//
					if(!hasEffect){
						refresh();
					}
					
					break;
				
				
				case "btnCancel":
					var cs2:PacketCSDropRollRep = new PacketCSDropRollRep();
					cs2.flag = 0;
					cs2.objid = t_data.objid;
					uiSend(cs2);
					
					for(j=1;j<=_dropRollList.length;j++)
					{
						
						if(_dropRollList[j-1].objid == t_data.objid &&
							_dropRollList[j-1].itemtype == t_data.itemtype){
							
							_dropRollList.splice(j-1,1);
							
							break;
						}						
					}
					
					
					//
					if(!hasEffect){
						refresh();
					}
					
					
					break;
			
				default:"";
			}
			
			//
			UI_index.instance.mcHandler(target);
			
		}
		
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		
		
		
		
		
		
		
		
		
		
	}
}