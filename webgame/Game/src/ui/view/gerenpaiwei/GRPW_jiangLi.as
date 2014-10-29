package ui.view.gerenpaiwei
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	import common.utils.component.ToolTip;
	
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructIntParamList2;
	
	import nets.packets.PacketCSCallBack;
	import nets.packets.PacketCSPlayerLeaveInstance;
	import nets.packets.PacketSCCallBack;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view1.fuhuo.FuHuo_GRPW;
	
	import world.WorldEvent;
	
	public class GRPW_jiangLi extends UIWindow
	{
		private static var m_instance:GRPW_jiangLi;
		private static var sipl:Vector.<StructIntParamList2>;
		private static var callbacktype:int;
		private var daoJiShi:int;
		
		
		public function GRPW_jiangLi(value:Vector.<StructIntParamList2>,_callbacktype:int)
		{
			sipl = value;
			callbacktype = _callbacktype;
			
			this.canDrag = false;
			super(getLink(WindowName.win_pai_wei_sai_jiang_li));
		}
		public static function getInstance(value:Vector.<StructIntParamList2>,_callbacktype:int):GRPW_jiangLi
		{
			if (null == m_instance)
			{
				m_instance=new GRPW_jiangLi(value,_callbacktype);
			}
			else
			{
				sipl = value;
			}
			return m_instance;
		}
		override protected function init():void 
		{
			super.init();
			
			//
			
			//
//			mc['fbjl'].visible = false;
//			mc["fbjl"]['txt_daoJiShi'].mouseEnabled = false;
			reset();
			//
			mc['txt_daoJiShi'].mouseEnabled = false;
			//
			uiRegister(PacketSCCallBack.id, SCCallBack);
			//
			showValue();
			
			//
			daoJiShi = 10;
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
			
		}
		private function SCCallBack(p:IPacket):void
		{
			var value:PacketSCCallBack=p as PacketSCCallBack;
			if (value == null)
			{
				alert.ShowMsg("value", 2);
				return;
			}
			
			//这里是2
			if (value.callbacktype ==2)
			{
				var s:Vector.<StructIntParamList2>=value.arrItemintparam;
				
				var pos:int=1;
				
				var len:uint=s.length;
				
				var tool_id_list:Array = [];
				var tool_id_num_list:Array = [];
				
				var loop_i:int= 0;
				
				for(loop_i=0;loop_i<len;)
				{
					if (s[loop_i] == null)
					{
						alert.ShowMsg("s[" + loop_i.toString() + "]:null", 2);
						return;
					}
					
					if (s[loop_i].intparam != 19790115)
					{
						//var color:int=XmlRes.GetEquipColor(sipl[i].intparam);
						//if (color > 0)
						//	color--;
						var tool:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(s[loop_i].intparam) as Pub_ToolsResModel;
						if(tool==null){
							//测试要求屏蔽
							alert.ShowMsg("物品不存在:" + s[loop_i].intparam.toString(),2);
							//mc["bx"+box].gotoAndStop(1);
							return;
						}
						
						if(pos <= 3)
						{
							//sprite["title" + pos].htmlText="<font color='#" + ResCtrl.instance().arrColor[color] + "'>" + tool.tool_name + "</font>";
							
							var color:int = tool.tool_color;
							
							if (color > 0)color--;
							
							tool_id_list.push(s[loop_i].intparam);
							tool_id_num_list.push(s[loop_i+1].intparam);		
							
							showPackageContainer = mc;
							showPackage(tool_id_list,tool_id_num_list);
						}
						
						pos++;
						
						loop_i+=2;
					}
					else
					{
						loop_i+=1;
						break;
					}
				}
			}
		}
		public var showPackageContainer:DisplayObjectContainer;
		public function showPackage(tool_id_list:Array,tool_id_num_list:Array):void
		{
			
			//
			var arr:Array = [];
			
			//
			var itemList:Vector.<StructBagCell2> = new Vector.<StructBagCell2>();
			
			var len:int = tool_id_list.length;		
			for(var h:int=0;h<len;h++)
			{
				var bag:StructBagCell2 = new StructBagCell2();
				bag.itemid = tool_id_list[h];
				bag.num = tool_id_num_list[h];
				//bag.pos = i+1;
				bag.pos = 0;
				bag.huodong_pos = h+1;
				
				//
				Data.beiBao.fillCahceData(bag);
				
				//
				itemList.push(bag);
			}
			
			//-----------------------------
			
			len =  itemList.length;	
			for(var j:int=0;j<len;j++)
			{			
				arr.push(itemList[j]);
			}
			
			//arr.sortOn("pos");
			arr.sortOn("huodong_pos");
			arr.forEach(callback);
			ToolTip.instance().resetOver();
			
		}
		//列表中条目处理方法
		private function callback(itemData:StructBagCell2,index:int,arr:Array):void {
			//var pos:int=itemData.pos;
			var pos:int= itemData.huodong_pos;
			
			var sprite:*=showPackageContainer.getChildByName("pic"+pos);
			
			if(sprite==null)return;
			sprite.mouseChildren=false;
			sprite.visible = true;
			sprite.data=itemData;
			
			ItemManager.instance().setEquipFace(sprite);
			
//			sprite["uil"].source=itemData.icon;
			ImageUtils.replaceImage(sprite,sprite["uil"],itemData.icon);
			sprite["r_num"].text=itemData.sort==13?"":itemData.num;
			CtrlFactory.getUIShow().addTip(sprite);
			//new MainDrag(sprite,null);
		}
		private function showValue() : void {
			
			
			if(sipl[3].intparam==2){
				mc["title"].gotoAndStop(1);
				//mc["title2"].gotoAndStop(1);
			}else{
				mc["title"].gotoAndStop(2);
				//mc["title2"].gotoAndStop(2);
			}
			mc["tf_0"].htmlText = sipl[6].intparam.toString();
			mc["tf_1"].htmlText = sipl[4].intparam.toString();
			mc["tf_2"].htmlText = sipl[5].intparam.toString();
			//
			var vo:PacketCSCallBack = new PacketCSCallBack();
			vo.callbacktype = 2;
			uiSend(vo);
		}
		public function daoJiShiHandler(e:WorldEvent):void
		{
			daoJiShi--;
			
			if(daoJiShi >= 0)
			{
				mc['txt_daoJiShi'].text = daoJiShi.toString();
			}
			//40秒时自动开宝箱
			if(40 == daoJiShi)
			{
//				mcHandler({name:"bx1"});
			}else if(0 == daoJiShi)//0秒自动离开
			{				
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
				mcHandler({name:"likai"});
			}
			
		}
		private function reset():void
		{
			this.mc["tf_0"].text = "0";
			this.mc["tf_1"].text = "0";
			this.mc["tf_2"].text = "0";
			var mcItem:MovieClip;
			for (var i:int = 1;i<4;i++){
				mcItem = this.mc["pic"+i];
				mcItem.visible = false;
				CtrlFactory.getUIShow().removeTip(mcItem);
				mcItem.data = null;
			}
		}
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			var target_name:String = target.name;
			
			switch(target_name)
			{
				case "likai":
					var vo2:PacketCSCallBack = new PacketCSCallBack();
					vo2.callbacktype = 2;
					uiSend(vo2);
					//}
					
					var vo3:PacketCSPlayerLeaveInstance = new PacketCSPlayerLeaveInstance();
					vo3.flag = 1;
					uiSend(vo3);
					this.winClose();
					break;
				default:
					break;
			}
			
		}
		public static function grpw_showJiangli(_sipl:Vector.<StructIntParamList2>,_callbacktype:int):void{
			GRPW_jiangLi.getInstance(_sipl,_callbacktype).open();
			if(FuHuo_GRPW.instance().isOpen){
				FuHuo_GRPW.instance().winClose()
			}
		}
		// 窗口关闭事件
		override protected function windowClose():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
			super.windowClose();
		}
		
	}
}