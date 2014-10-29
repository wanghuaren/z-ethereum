package ui.base.jiaose
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SuitcomposeResModel;
	import common.utils.res.ResCtrl;
	
	import flash.display.MovieClip;
	
	import model.jingjie.JingjieModel;
	
	import netc.Data;
	import netc.packets2.PacketWCPlayerLookInfo2;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructCardData2;
	import netc.packets2.StructEvilGrain2;
	import netc.packets2.StructItemAttr2;
	import netc.packets2.StructRankEquipInfo2;
	
	import nets.packets.PacketWCPlayerLookInfo;

	/**
	 *	套装属性控制【角色和查看角色共用】
	 *  2013-10-09 andy 
	 */
	public final class TaoZhuang
	{
		private var mc:MovieClip=null;
		private var data:Object=null;
		private var i:int=0;
		
		private static var _instance:TaoZhuang;
		public static function getInstance():TaoZhuang{
			if(_instance==null){
				_instance=new TaoZhuang();
			}
			return _instance;
		}
		public function TaoZhuang()
		{
		}
		

		
		/**
		 *	悬浮信息【套装】
		 *  2012-08-10
		 */
		public function showFiveTip(v:MovieClip,name:String="",d:Object=null):void
		{
			mc=v;
			if (name.indexOf("btnQiangHua") >= 0)
			{
				if(d is PacketWCPlayerLookInfo2){
					data= (d as PacketWCPlayerLookInfo2).arrEquip;
				}else{
					data=Data.beiBao.getRoleEquipList();
				}
				mc["mc_tip"].gotoAndStop(6);
				showTaoZhuang(getEquipQiangHua());
			}
			else if (name.indexOf("btnChongZhu") >= 0)
			{
				if(d is PacketWCPlayerLookInfo2){
					data= (d as PacketWCPlayerLookInfo2).arrEquip;
				}else{
					data=Data.beiBao.getRoleEquipList();
				}	
				mc["mc_tip"].gotoAndStop(3);
				showTaoZhuang(getEquipOrangeCount());
			}
			else if (name.indexOf("btnMoWen") >= 0)
			{
				if(d is PacketWCPlayerLookInfo2){
					data= (d as PacketWCPlayerLookInfo2).arrEquip;
				}else{
					data=Data.beiBao.getRoleEquipList();
				}
				mc["mc_tip"].gotoAndStop(5);
				showTaoZhuang(getEquipMoWen());
			}
			else if (name.indexOf("btnJingJie") >= 0)
			{
				if(d is PacketWCPlayerLookInfo2){
					data= (d as PacketWCPlayerLookInfo2).arrJingJie;
				}else{
					data=JingjieModel.getInstance().jingJieOrigList;
				}	
				mc["mc_tip"].gotoAndStop(2);
				showTaoZhuang(getXingJieCount());
			}
			else
			{
				
			}
			mc["mc_tip"].x=mc[name].x+35;
			mc["mc_tip"].y=mc[name].y  ;
			mc["mc_tip"].visible=true;
			mc.addChild(mc["mc_tip"]);
		}
		
		
		/**
		 *	身上藏经阁【悬浮】
		 *  @2013-09-03
		 */
		
		private function getCangJingGeCount():Array
		{
			var ret:Array=[];
			//魔纹配置数据
			var arr:Array=XmlManager.localres.getSuitcomposeXml.getResPath2(10);
			//统计魔纹的条数 比较复杂
			var arrCount:Array=[0, 0, 0, 0, 0];
			for each (var card:StructCardData2 in data)
			{
				if (card == null)
					continue;
				//藏经阁等级
				var level:int=card.level;
				//统计 
				for (i=0; i < 5; i++)
				{
					if (level >= arr[i].tool_level)
						arrCount[i]++;
				}
				
			}
			setTaoZhuangColor(ret, arr, arrCount);
			return ret;
		}
		/**
		 *	星界属性有几阶【悬浮】
		 *  @2013-08-30
		 */
		
		private function getXingJieCount():Array
		{
			var ret:Array=[];
			//重铸条数
			var count:int=1;
			
			var arr:Array=XmlManager.localres.getSuitcomposeXml.getResPath2(11);
			var j:int=1;
			//统计重铸的条数 比较复杂
			var arrCount:Array=[0, 0, 0, 0, 0];
			for each(var lvl:int in data){
				if(lvl>0){
					if(j>=1&&j<=7)arrCount[0]+=1;
					else if(j>=8&&j<=14)arrCount[1]+=1;
					else if(j>=15&&j<=21)arrCount[2]+=1;
					else if(j>=22&&j<=28){arrCount[3]+=1;arrCount[4]+=1;}
					else{}
				}
				j++;
			}
			setTaoZhuangColor(ret, arr, arrCount);
			return ret;
		}
		/**
		 *	身上装备橙色属性有几条【悬浮】
		 *  @2012-08-10
		 */
		
		private function getEquipOrangeCount():Array
		{
			var ret:Array=[];
			//重铸条数
			var count:int=0;

			//统计重铸的条数 比较复杂
			var arrCount:Array=[0, 0, 0, 0, 0];
			for each (var equip:StructBagCell2 in data)
			{
				for each (var itemAtt:StructItemAttr2 in equip.arrItemattrs)
				{
					if (itemAtt.attrColor >= 4 && itemAtt.attrValid == 1)
						count++;
				}
			}
			var arr:Array=XmlManager.localres.getSuitcomposeXml.getResPath2(2);
			for (i=0; i < 5; i++)
			{
				arrCount[i]=count
			}
			
			setTaoZhuangColor(ret, arr, arrCount);
			return ret;
		}
		
		/**
		 *	身上装备魔纹【悬浮】
		 *  @2012-08-10
		 */
		
		private function getEquipMoWen():Array
		{
			var ret:Array=[];

			//魔纹配置数据
			var arr:Array=XmlManager.localres.getSuitcomposeXml.getResPath2(1);
			//统计魔纹的条数 比较复杂
			var arrCount:Array=[0, 0, 0, 0, 0];
			for each (var equip:StructBagCell2 in data)
			{
				for each (var itemAtt:StructEvilGrain2 in equip.arrItemevilGrains)
				{
					//魔纹等级
					//					var tool:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(itemAtt.toolId);
					//
					//					var level:int=tool != null ? tool.tool_level : 0;
					var level:int=int(itemAtt.toolId.toString().substr(7,1));
					//统计 
					for (i=0; i < 5; i++)
					{
						if (level >= arr[i].tool_level)
							arrCount[i]++;
					}
				}
			}
			setTaoZhuangColor(ret, arr, arrCount);
			return ret;
		}
		
		/**
		 *	身上星魂【悬浮】
		 *  @2012-08-10
		 */
		
		private function getEquipXingHun():Array
		{
			var ret:Array=[];
	
			//魔纹配置数据
			var arr:Array=XmlManager.localres.getSuitcomposeXml.getResPath2(3);
			//统计魔纹的条数 比较复杂
			var arrCount:Array=[0, 0, 0, 0, 0];
			for each (var equip:StructBagCell2 in data)
			{
				if (equip == null)
					continue;
				//星魂等级
				var level:int=equip.level;
				//星魂品质
				var color:int=equip.toolColor;
				//统计 
				for (i=0; i < 5; i++)
				{
					if (level >= arr[i].tool_level && color >= arr[i].tool_color)
						arrCount[i]++;
				}
				
			}
			setTaoZhuangColor(ret, arr, arrCount);
			return ret;
		}
		
		/**
		 *	身上装备强化【悬浮】
		 *  @2012-12-13
		 */
		private function getEquipQiangHua():Array
		{
			var ret:Array=[];

			//强化配置数据
			var arr:Array=XmlManager.localres.getSuitcomposeXml.getResPath2(4);
			//统计强化的条数 比较复杂
			var arrCount:Array=[0, 0, 0, 0, 0];
			if(data==null)data=Data.beiBao.getRoleEquipList();
			for each (var equip:StructBagCell2 in data)
			{
				//强化等级【只统计连续完美】
				var level:int=equip != null ? equip.equip_strongLevel : 0;
				var levelWanMei:int=0;
				
				//统计 
				for (i=0; i < 5; i++)
				{
					if (levelWanMei >= arr[i].tool_level)
						arrCount[i]++;
				}
			}
			setTaoZhuangColor(ret, arr, arrCount);
			return ret;
		}
		
		
		
		/**
		 *	套装颜色
		 */
		private function setTaoZhuangColor(ret:Array, arr:Array, arrCount:Array):void
		{
			i=0;
			for each (var sc:Pub_SuitcomposeResModel in arr)
			{
				if (arrCount[i] >= sc.tool_num)
				{
					//ret[i]=[sc.tool_num,sc.tool_num,"00FF1E","00FF1E"];
					//2012-12-17 策划说 1－5行，颜色按照装备品质显示
					ret[i]=[sc.tool_num, sc.tool_num, ResCtrl.instance().arrColor[i+1], "00FF1E"];
				}
				else
					ret[i]=[arrCount[i], sc.tool_num, "A6A5A3", "FF9c0F"];
				i++;
			}
		}
		
		/**
		 *	显示套装 数量和颜色
		 */
		private function showTaoZhuang(arr:Array):void
		{
			for (i=0; i < 5; i++)
			{
				mc["mc_tip"]["txt" + (i + 1)].htmlText="<font color='#" + arr[i][3] + "'>(" + arr[i][0] + "/" + arr[i][1] + ")</font>";
				mc["mc_tip"]["txt" + ((i + 1) * 10 + (i + 1))].textColor=int("0x" + arr[i][2]);
			}
		}
		
		
		
		/**
		 *	转化信息 
		 */
		private function changeEquip(vec:Vector.<StructRankEquipInfo2>):Array{
			var arr:Array=[];
			var bag:StructBagCell2=null;
			for each(var item:StructRankEquipInfo2 in vec){
				bag=new StructBagCell2();
				bag.itemid=item.equip.itemid;
				Data.beiBao.fillCahceData(bag);
				
			}
			return arr;
		}
		
		/**
		 *	强化套装特效展示
		 *  2013-10-22 
		 */
		public function getQiangHuaTaoZhuangEffect():int{
			var ret:int=0;
			var arr:Array=getEquipQiangHua();
			for(var k:int=4;k>-1;k--){
				if(arr[k][0]>=arr[k][1]){
					ret=k;
					break;
				}
			}
			return ret;
		}
	}
}