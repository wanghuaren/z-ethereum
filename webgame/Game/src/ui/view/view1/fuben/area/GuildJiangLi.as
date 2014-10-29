package ui.view.view1.fuben.area
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	import common.utils.component.ToolTip;
	import common.utils.res.ResCtrl;
	
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.packets2.PacketSCCallBack2;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructCharParamList2;
	import netc.packets2.StructIntParamList2;
	
	import nets.packets.PacketCSCallBack;
	import nets.packets.PacketCSPlayerLeaveInstance;
	import nets.packets.PacketSCCallBack;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	
	import world.WorldEvent;
	
	public class GuildJiangLi  extends UIWindow
	{
		
		private static var sipl:Vector.<StructIntParamList2>;
		private static var callbacktype:int;
		private var daoJiShi:int;
		
		public function GuildJiangLi(value:Vector.<StructIntParamList2>,_callbacktype:int)
		{
			sipl=value;
			callbacktype = _callbacktype;
			super(getLink("win_ping_fen"));
		}
		
		private static var _instance:GuildJiangLi=null;
		
		public static function instance(value:Vector.<StructIntParamList2>,_callbacktype:int):GuildJiangLi
		{
			if (null == _instance)
			{
				_instance=new GuildJiangLi(value,_callbacktype);
			}
			else
			{
				sipl=value;
			}
			return _instance;
		}
		
		public static function hasAndGetInstance():Array
		{
			if(null != _instance)
			{
				return [true,_instance];
			}
			
			return [false,null];
		}
		
		// 面板初始化
		override protected function init():void
		{
			super.init();
			
			(mc as MovieClip).gotoAndStop(1);
						
			//
			reset();
			
			//
			mc['fbjl'].visible = false;
			mc["fbjl"]['txt_daoJiShi'].mouseEnabled = false;
			
			//
			showValue();
			
			//
			uiRegister(PacketSCCallBack.id, SCCallBack);
			
			//
			daoJiShi = 60;
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
			
		}
		
		public function daoJiShiHandler(e:WorldEvent):void
		{
			daoJiShi--;
			
			if(daoJiShi == 59)
			{
				mc['fbjl'].scaleX = mc['fbjl'].scaleY = 1.0;
				
				mc['fbjl'].x = 538 + 240;
				
				mc['fbjl'].y += 60;
				
				mc['fbjl'].visible = true;
				
				mc['fbjl'].alpha = 0.0;
				
				TweenLite.to(mc['fbjl'],1.2,{
				
				alpha:1.0,
				x:658
				});
			}
			
			if(daoJiShi >= 0)
			{
				mc["fbjl"]['txt_daoJiShi'].text = daoJiShi.toString();
			}
			
			//40秒时自动开宝箱
			//if(40 == daoJiShi && 1 == mc["bx1"].currentFrame)
			//{
			//	mcHandler(mc["bx1"]);
			//}
			
			//0秒自动离开
			if(0 == daoJiShi)
			{				
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
				
				mcHandler({name:"likai"});
				
			}
			
		}
		
		private function showValue():void
		{
			
			//胜利 或 失败
			if(sipl[3].intparam==2){
				mc["fbjl"]["title"].gotoAndStop(1);
				//mc["title2"].gotoAndStop(1);
			}else{
				mc["fbjl"]["title"].gotoAndStop(2);
				//mc["title2"].gotoAndStop(2);
			}
			
			//
			var i:int;
			var star:int;
			//评分是第2个
			//star = int(sipl[0].intparam/20);
			star = int(sipl[2].intparam/20);
			if(star==0)star=1;
			if(star>6)star=6;
			
			mc["fbjl"]["zonghe"].gotoAndStop(star);
			//mc["zonghe2"].gotoAndStop(star);
//			1-3星成功通关
//			4星完美通关
//			5星超神通关
//			失败  挑战失败
			
			if(star >=1 && star <=3 && sipl[3].intparam == 2)
			{
				mc['mc_tong_guan']['mc_tong_guan_star'].gotoAndStop(1);
			
			}else if(star == 4 && sipl[3].intparam == 2)
			{
				mc['mc_tong_guan']['mc_tong_guan_star'].gotoAndStop(2);
					
			}else if(star >=5 && star <=6 && sipl[3].intparam == 2)
			{
				mc['mc_tong_guan']['mc_tong_guan_star'].gotoAndStop(3);
			
			}else if(0 == star || sipl[3].intparam != 2)
			{
				mc['mc_tong_guan']['mc_tong_guan_star'].gotoAndStop(4);
			}
			
						
			//获得金币，获得贡献，评分，成功失败(1失败，2成功)
			//0         1            2     3  
			//(mc["txtExpName"] as TextField).htmlText  = "<b>资 金：</b>";
			//(mc["txtCoinName"] as TextField).htmlText = "<b>贡 献：</b>";
			(mc["txtExpName"] as TextField).htmlText  = "<b>" + Lang.getLabel("500103_ThreeBoxJiangLi") +"</b>";
			(mc["txtCoinName"] as TextField).htmlText = "<b>" + Lang.getLabel("500104_ThreeBoxJiangLi") +"</b>";
			
			//coin
			//mc["txtCoin"].text = sipl[0].intparam.toString();
			//mc["txtExp"].text = sipl[0].intparam.toString();	
			mc["txtExp"].text = sipl[0].intparam.toString();		
			
			//mc["txtRenown"].text =  sipl[1].intparam.toString();
			mc["txtCoin"].text = sipl[1].intparam.toString();
			
			//if(18 == callbacktype)
			//{
				mc["txtRenownName"].visible = false;
				mc["txtRenown"].text = "";
			//}
			
			mc["fbjl"]["likai"].visible = true;
			//
			var vo:PacketCSCallBack = new PacketCSCallBack();
			vo.callbacktype = 2;
			uiSend(vo);
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
			if (value.callbacktype == 2)
			{
				var s:Vector.<StructIntParamList2>=value.arrItemintparam;
				
				//
				//mc["bx1"].gotoAndStop(2);	
				
				mc["fbjl"]["jiangli1"].visible=true;
				mc["fbjl"]["jiangli1"].gotoAndStop(1);
				//mc["jiangli1"]["beijing"].gotoAndStop(1);
				
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
		
							
							mc["fbjl"]["jiangli1"]["title" + pos].htmlText="<font color='#" + ResCtrl.instance().arrColor[color] + "'>" + tool.tool_name + "</font>";
							
							//sprite["num" + pos].text=sipl[i + 1].intparam + "";
							
							tool_id_list.push(s[loop_i].intparam);
							tool_id_num_list.push(s[loop_i+1].intparam);		
							
							showPackageContainer = mc["fbjl"]["jiangli1"];
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

				//
				DuiYou(loop_i,len,s);
			}
		}
		
		public function DuiYou(loop_i:int,len:int,s:Vector.<StructIntParamList2>):void
		{			
			
			var tool_id_list:Array = [];
			var tool_id_num_list:Array = [];
			
			var jiangli_x:int = 2;
			
			var pos:int=1;
			
			for(loop_i;loop_i<len;)
			{
				
				if (null == s[loop_i])
				{
					alert.ShowMsg("s[" + loop_i.toString() + "]:null", 2);
					return;
				}
				
				if (s[loop_i].intparam != 19790115)
				{					
									
					var tool:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(s[loop_i].intparam) as Pub_ToolsResModel;
					
					if(tool==null)
					{
						//测试要求屏蔽
						alert.ShowMsg("物品不存在:" + s[loop_i].intparam.toString(),2);
						return;
					}
									
					if(pos <= 3)
					{
						var color:int = tool.tool_color;
						
		
						tool_id_list.push(s[loop_i].intparam);
						tool_id_num_list.push(s[loop_i+1].intparam);						

						mc["fbjl"]["jiangli" + jiangli_x.toString()]["title" + pos].htmlText="<font color='#" + ResCtrl.instance().arrColor[color] + "'>" + tool.tool_name + "</font>";
						
						//
						//mc["wenHao" + jiangli_x.toString()].visible = false;
						mc["fbjl"]["jiangli" + jiangli_x.toString()].visible = true;
						
						showPackageContainer = mc["jiangli" + jiangli_x.toString()];
						showPackage(tool_id_list,tool_id_num_list);
						//
					}
					
					pos++;
					loop_i+=2;
				}
				else
				{					
					
					//
					//mc["wenHao" + jiangli_x.toString()].visible = false;
					mc["fbjl"]["jiangli" + jiangli_x.toString()].visible = true;
					
					showPackageContainer = mc["fbjl"]["jiangli" + jiangli_x.toString()];
					showPackage(tool_id_list,tool_id_num_list);
					//
					
										
					jiangli_x++;
					
					pos = 1;
										
					loop_i+=1;
					
					//
					tool_id_list = [];
					tool_id_num_list = [];
					
					if(loop_i >= len)
					{
						break;
					}
					
					if(jiangli_x >= 5)
					{
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
			sprite.data=itemData;
			
			ItemManager.instance().setEquipFace(sprite);
			
//			sprite["uil"].source=itemData.iconBig;
			ImageUtils.replaceImage(sprite,sprite["uil"],itemData.iconBig);
			sprite["r_num"].text=itemData.sort==13?"":itemData.num;
			CtrlFactory.getUIShow().addTip(sprite);
			//new MainDrag(sprite,null);
		}
		
		private function reset():void
		{
			//mc["bx1"].gotoAndStop(1);	
			
			mc['fbjl'].visible = false;
			var k:int;
			var m:int;
			
			//
			mc['mc_tong_guan']['mc_tong_guan_star'].gotoAndStop(1);
			mc['mc_tong_guan']["title1"].text = "";
			mc['mc_tong_guan']["title2"].text = "";
			mc['mc_tong_guan']["title3"].text = "";
			for(k=1;k<=1;k++)
			{
				mc["fbjl"]["jiangli" + k.toString()].visible = false;
				
				//clear				
				//mc["jiangli" + k.toString()]["title1"].text = "";
				//mc["jiangli" + k.toString()]["title2"].text = "";
				//mc["jiangli" + k.toString()]["title3"].text = "";
				
			}
			
			for(m=2;m<=5;m++)
			{
				//mc["wenHao" + m.toString()].visible = true;
				mc["fbjl"]["jiangli" + m.toString()].visible = false;
				
				//mc["jiangli" + m.toString()]["title1"].text = "";
				//mc["jiangli" + m.toString()]["title2"].text = "";
				//mc["jiangli" + m.toString()]["title3"].text = "";
				
			}
			
			var _loc1:*;
			var _loc2:*;
			var _loc3:*;
			var _loc4:*;
			var len:int = 3;
			
			for(k=1;k<=1;k++)
			{
				var dc:DisplayObjectContainer = mc["fbjl"]["jiangli" + k.toString()];
				
				_loc1=dc.getChildByName("pic1");
				_loc1["uil"].unload();
				_loc1["r_num"].text="";
				_loc1.mouseChildren=false;
				_loc1.data=null;
				ItemManager.instance().setEquipFace(_loc1,false);
				
				_loc2=dc.getChildByName("pic2");
				_loc2["uil"].unload();
				_loc2["r_num"].text="";
				_loc2.mouseChildren=false;
				_loc2.data=null;
				ItemManager.instance().setEquipFace(_loc2,false);
				
				_loc3=dc.getChildByName("pic3");
				_loc3["uil"].unload();
				_loc3["r_num"].text="";
				_loc3.mouseChildren=false;
				_loc3.data=null;
				ItemManager.instance().setEquipFace(_loc3,false);
								
			}
			
			//-------------------------------------------------------------
			var dc:DisplayObjectContainer = mc['mc_tong_guan'];
			
			_loc1=dc.getChildByName("pic1");
			_loc1["uil"].unload();
			_loc1["r_num"].text="";
			_loc1.mouseChildren=false;
			_loc1.data=null;
			ItemManager.instance().setEquipFace(_loc1,false);
			
			_loc2=dc.getChildByName("pic2");
			_loc2["uil"].unload();
			_loc2["r_num"].text="";
			_loc2.mouseChildren=false;
			_loc2.data=null;
			ItemManager.instance().setEquipFace(_loc2,false);
			
			_loc3=dc.getChildByName("pic3");
			_loc3["uil"].unload();
			_loc3["r_num"].text="";
			_loc3.mouseChildren=false;
			_loc3.data=null;
			ItemManager.instance().setEquipFace(_loc3,false);
			
			//-------------------------------------------------------------
			for(m=2;k<=5;k++)
			{
				var dc:DisplayObjectContainer = mc["fbjl"]["jiangli" + m.toString()];
				
				_loc1=dc.getChildByName("pic1");
				_loc1["uil"].unload();
				_loc1["r_num"].text="";
				_loc1.mouseChildren=false;
				_loc1.data=null;
				ItemManager.instance().setEquipFace(_loc1,false);
				
				_loc2=dc.getChildByName("pic2");
				_loc2["uil"].unload();
				_loc2["r_num"].text="";
				_loc2.mouseChildren=false;
				_loc2.data=null;
				ItemManager.instance().setEquipFace(_loc2,false);
				
				_loc3=dc.getChildByName("pic3");
				_loc3["uil"].unload();
				_loc3["r_num"].text="";
				_loc3.mouseChildren=false;
				_loc3.data=null;
				ItemManager.instance().setEquipFace(_loc3,false);
				
				
			}
		}
		
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{			
			super.mcHandler(target);
			
			if (target.name == "bx" || target.name == "bx1")
			{
				//if(2 == mc["bx1"].currentFrame)
				//{
				//	return;
				//}
				
				var vo:PacketCSCallBack=new PacketCSCallBack();
				vo.callbacktype=2;//这个地方得是2
				uiSend(vo);
				return;
			}
			
			switch (target.name)
			{
				case "likai":
					
					//if(1 == mc["bx1"].currentFrame)
					//{
						var vo2:PacketCSCallBack=new PacketCSCallBack();
						vo2.callbacktype=2;//这个地方得是2
						uiSend(vo2);
					//}
					
					
					var vo3:PacketCSPlayerLeaveInstance=new PacketCSPlayerLeaveInstance();
					vo3.flag = 1;
					uiSend(vo3);
					this.winClose();
					
					break;
			}
		}
		
		public static function showJiangLi(_sipl:Vector.<StructIntParamList2>,_callbacktype:int):void
		{
			GuildJiangLi.instance(_sipl,_callbacktype).open();
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			
			
			mc['fbjl'].visible = false;
			
			mc['fbjl'].scaleX = mc['fbjl'].scaleY = 0.25;
			
			mc['fbjl'].x = 538;
			
			mc['fbjl'].y = 126;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
			
			
			super.windowClose();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}