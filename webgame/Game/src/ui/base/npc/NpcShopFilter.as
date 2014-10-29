package ui.base.npc
{
	import common.managers.Lang;
	
	import display.components.CmbArrange;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;

	/**
	 *	npc商店 【数据过滤】
	 *  andy 2013-08-23 
	 */
	public class NpcShopFilter extends EventDispatcher
	{
		private var mc:MovieClip=null;
		//装备兑换 选中职业 2013-08-22
		public var equip_metier:int=0;
		//装备兑换 选中等级 2013-08-22
		public var equip_level:int=0;
		public var arrType:Array=[[],[1,2,3,4,5,6,7],[8,9,10,11,12]];
		//等级按钮【根据界面调整】
		private var arrEquipLevel:Array=[20,40,60,70,80,90,100];
		
		
		private var i:int=0;
		private var child:DisplayObject=null;
		private static var _instance:NpcShopFilter;
		public static function instance():NpcShopFilter{
			if(_instance==null){
				_instance=new NpcShopFilter();
			}
			
			return _instance;
		}
		public function NpcShopFilter()
		{

		}
		public function setMc(m:MovieClip):void{
			mc=m;
		}
		
		public function reset():void {
			equip_metier=0;
			equip_level=0;
		}

		public function mcHandler(target:Object):void {
			var name:String=target.name;
			

//			switch(name) {
//				case "":
//					break;
//
//				
//			}
		}

		
		

		/**************内部方法***********/
		/**
		 * 过滤数据
		 * 2013-08-23
		 */
		public function filter(arrRet:Array,shopId:int,type:int):Array{
			if(shopId==NpcShop.DUI_HUAN_SHOP_ID&&type==1){
				//兑换商店
				var arrTemp:Array=[];
				
				for each(var bag:StructBagCell2 in arrRet){
					if((equip_metier==0||bag.metier==equip_metier||bag.metier==0)&&
						(equip_level==0||bag.level==equip_level)
					){
						arrTemp.push(bag);
					}
				}
				arrRet=arrTemp;
			}else{
			
			}
			return arrRet;
		}

		
		public var arrLevel:Array=[20,40,60,70,80,90,100];
		//装备卷轴
		public var arrJuanZhou:Array=[11800380,11800381,11800382,11800383,11800384,11800385,11800386];
		//饰品卷轴
		public var arrJuanZhou2:Array=[11800631,11800632,11800633,11800634,11800635,11800636,11800637];

		public function setCmbLevel(cmb:CmbArrange,callBack:Function):void{
			var arrCmb:Array=new Array();
			var len:int=arrLevel.length;
			for(i=0;i<len;i++){
				arrCmb.push({label:arrLevel[i]+Lang.getLabel("pub_ji"),data:arrLevel[i]});
			}
			
			cmb.rowCount=5;
			cmb.overHeight=5;
			cmb.addItems=arrCmb;
			cmb.addEventListener(DispatchEvent.EVENT_COMB_CLICK,callBack);
		}
		/**
		 *	当前等级对应的区间【默认选择等级】 
		 */
		public function getDefautLevelIndex():int{
			var index:int=0;
			var lv:int = Data.myKing.level;
			var len:int=arrLevel.length-1;
			
			if(lv>=20&&lv<40){
				index=0;
			}else if(lv>=40&&lv<60){
				index=1;
			}else if(lv>=60&&lv<70){
				index=2;
			}else if(lv>=70&&lv<80){
				index=3;
			}else if(lv>=80&&lv<90){
				index=4;
			}else if(lv>=90&&lv<100){
				index=5;
			}else if(lv>=100){
				index=6;
			}else{
				index=0;
			}
			return index;
		}
		/**
		 *	 得到选中等级的index
		 */
		public function getLevelIndex():int{
			var index:int=arrLevel.indexOf(equip_level);
			
			return index;
		}
		
	}
}