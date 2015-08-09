package ui.view.view1.fuben.area
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import common.config.GameIni;
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

	public class ShengLiJiangLi extends UIWindow
	{
		private static var sipl:Vector.<StructIntParamList2>;
		private static var callbacktype:int;
		private var daoJiShi:int;

		public function ShengLiJiangLi(value:Vector.<StructIntParamList2>, _callbacktype:int)
		{
			sipl=value;
			callbacktype=_callbacktype;
			this.canDrag=false;
			super(getLink("win_ping_fen1"));
		}
		private static var _instance:ShengLiJiangLi=null;

		public static function instance(value:Vector.<StructIntParamList2>, _callbacktype:int):ShengLiJiangLi
		{
			if (null == _instance)
			{
				_instance=new ShengLiJiangLi(value, _callbacktype);
			}
			else
			{
				sipl=value;
			}
			return _instance;
		}

		public static function hasAndGetInstance():Array
		{
			if (null != _instance)
			{
				return [true, _instance];
			}
			return [false, null];
		}

		// 面板初始化
		override protected function init():void
		{
			super.init();
			(mc as MovieClip).gotoAndStop(1);
			mc.visible=false;
			//
			reset();
			//
			mc['fbjl'].visible=false;
			mc["fbjl"]['txt_daoJiShi'].mouseEnabled=false;
			//
			uiRegister(PacketSCCallBack.id, SCCallBack);
			//
			showValue();
			//
			daoJiShi=10;
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, daoJiShiHandler);
		}

		public function hide_mc_tong_guan():void
		{
			mc['mc_tong_guan'].visible=false;
		}

		public function daoJiShiHandler(e:WorldEvent):void
		{
			daoJiShi--;
			if (daoJiShi == 5)
			{
				TweenLite.to(mc['mc_tong_guan'], 1.0, {alpha: 0.0, onComplete: hide_mc_tong_guan});
				//
				mc['fbjl'].scaleX=mc['fbjl'].scaleY=1.0;
				//
				mc['fbjl'].x=GameIni.MAP_SIZE_W / 2 + 220 * 2;
				//终点
				var mc_fbjl_x:int=GameIni.MAP_SIZE_W / 2 + 220;
				//
				mc['fbjl'].y=200;
				mc['fbjl'].visible=true;
				//mc['fbjl'].alpha = 0.0;
				TweenLite.to(mc['fbjl'], 1.0, {
					//alpha:1.0//,
						x: mc_fbjl_x});
			}
			if (daoJiShi == 9)
			{
				mc['mc_tong_guan'].alpha=0.0;
				mc['mc_tong_guan'].visible=true;
				TweenLite.to(mc['mc_tong_guan'], 1.0, {alpha: 1.0 //,
					});
			}
			if (daoJiShi >= 0)
			{
				mc["fbjl"]['txt_daoJiShi'].text=daoJiShi.toString();
			}
			//40秒时自动开宝箱
			//if(40 == daoJiShi && 1 == mc["bx1"].currentFrame)
			//{
			//	mcHandler(mc["bx1"]);
			//}
			//0秒自动离开
			if (0 == daoJiShi)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, daoJiShiHandler);
				mcHandler({name: "likai"});
			}
		}

		private function showValue():void
		{
			if (sipl[3].intparam == 2)
			{
				mc["fbjl"]["title"].gotoAndStop(1);
					//mc["title2"].gotoAndStop(1);
			}
			else
			{
				mc["fbjl"]["title"].gotoAndStop(2);
					//mc["title2"].gotoAndStop(2);
			}
			var i:int;
			var star:int;
			star=int(sipl[0].intparam / 20);
			if (star == 0)
				star=1;
			if (star > 6)
				star=6;
			/*for(i=1;i<=len;i++){
			mc["gj"]["gj"+i].gotoAndStop(2);
			}*/
			star=int(sipl[1].intparam / 20);
			if (star == 0)
				star=1;
			if (star > 6)
				star=6;
			/*for(i=1;i<len;i++){
			mc["fy"]["fy"+i].gotoAndStop(2);
			}*/
			star=int(sipl[2].intparam / 20);
			if (star == 0)
				star=1;
			if (star > 6)
				star=6;
			mc["fbjl"]["zonghe"].gotoAndStop(star);
			//mc["zonghe2"].gotoAndStop(star);
			//			1-3星成功通关
			//			4星完美通关
			//			5星超神通关
			//			失败  挑战失败
			if (star >= 1 && star <= 3 && sipl[3].intparam == 2)
			{
				mc['mc_tong_guan']['mc_tong_guan_star'].gotoAndStop(1);
			}
			else if (star == 4 && sipl[3].intparam == 2)
			{
				mc['mc_tong_guan']['mc_tong_guan_star'].gotoAndStop(2);
			}
			else if (star >= 5 && star <= 6 && sipl[3].intparam == 2)
			{
				mc['mc_tong_guan']['mc_tong_guan_star'].gotoAndStop(3);
			}
			else if (0 == star || sipl[3].intparam != 2)
			{
				mc['mc_tong_guan']['mc_tong_guan_star'].gotoAndStop(4);
			}
			//			
			//			(mc["fbjl"]["txtExpName"] as TextField).htmlText  = "<b>经 验：</b>";
			//			(mc["fbjl"]["txtCoinName"] as TextField).htmlText  = "<b>银 两：</b>";
			//			(mc["fbjl"]["txtRenownName"] as TextField).htmlText = "<b>声 望：</b>";
			(mc["fbjl"]["txtExpName"] as TextField).htmlText="<b>" + Lang.getLabel("500100_ThreeBoxJiangLi") + "</b>";
			(mc["fbjl"]["txtCoinName"] as TextField).htmlText="<b>" + Lang.getLabel("500101_ThreeBoxJiangLi") + "</b>";
			(mc["fbjl"]["txtRenownName"] as TextField).htmlText="<b>" + Lang.getLabel("500102_ThreeBoxJiangLi") + "</b>";
			//
			mc["fbjl"]["txtExp"].text=sipl[4].intparam.toString();
			mc["fbjl"]["txtCoin"].text=sipl[5].intparam.toString();
			if (4 == callbacktype)
			{
				mc["fbjl"]["txtRenownName"].visible=true;
				mc["fbjl"]["txtRenown"].visible=true;
				mc["fbjl"]["txtRenown"].text=sipl[1].intparam.toString();
			}
			else
			{
				mc["fbjl"]["txtRenownName"].visible=false;
				mc["fbjl"]["txtRenown"].visible=false;
				mc["fbjl"]["txtRenown"].text="";
			}
			mc["fbjl"]["likai"].visible=true;
			//
			var vo:PacketCSCallBack=new PacketCSCallBack();
			vo.callbacktype=2;
			uiSend(vo);
		}
		//
		public var duiYouI:int=0;

		private function SCCallBack(p:IPacket):void
		{
			var value:PacketSCCallBack=p as PacketSCCallBack;
			if (value == null)
			{
				alert.ShowMsg("value", 2);
				return;
			}
			if (value.callbacktype == 2222)
			{
				//if(value.arrItemcharparam[0].charparam != "")
				//{
				duiYouI++;
				this.DuiYou(value.arrItemintparam, value.arrItemcharparam);
					//return;
					//}
			}
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
				var tool_id_list:Array=[];
				var tool_id_num_list:Array=[];
				var loop_i:int=0;
				for (loop_i=0; loop_i < len; )
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
						var tool:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(s[loop_i].intparam);
						if (tool == null)
						{
							//测试要求屏蔽
							alert.ShowMsg("物品不存在:" + s[loop_i].intparam.toString(), 2);
							//mc["bx"+box].gotoAndStop(1);
							return;
						}
						if (pos <= 3)
						{
							//sprite["title" + pos].htmlText="<font color='#" + ResCtrl.instance().arrColor[color] + "'>" + tool.tool_name + "</font>";
							var color:int=tool.tool_color;
							if (null != mc["fbjl"]["jiangli1"]["title" + pos])
							{
								mc["fbjl"]["jiangli1"]["title" + pos].htmlText="<font color='#" + ResCtrl.instance().arrColor[color] + "'>" + tool.tool_name + "</font>";
							}
							if (null != mc["mc_tong_guan"]["title" + pos])
							{
								mc["mc_tong_guan"]["title" + pos].htmlText="<font color='#" + ResCtrl.instance().arrColor[color] + "'>" + tool.tool_name + "</font>";
							}
							//sprite["num" + pos].text=sipl[i + 1].intparam + "";
							tool_id_list.push(s[loop_i].intparam);
							tool_id_num_list.push(s[loop_i + 1].intparam);
							showPackageContainer=mc["fbjl"]["jiangli1"];
							showPackage(tool_id_list, tool_id_num_list);
							showPackageContainer=mc["mc_tong_guan"];
							showPackage(tool_id_list, tool_id_num_list);
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
			}
		}

		public function DuiYou(s:Vector.<StructIntParamList2>, s2:Vector.<StructCharParamList2>):void
		{
			var loop_i:int=0;
			var len:int=s.length;
			var tool_id_list:Array=[];
			var tool_id_num_list:Array=[];
			var jiangli_x:int=this.duiYouI + 1;
			var pos:int=1;
			//队友名称
			mc["fbjl"]["jiangli" + jiangli_x.toString()]["title1"].htmlText=s2[0].charparam;
			//
			for (loop_i; loop_i < len; )
			{
				if (null == s[loop_i])
				{
					alert.ShowMsg("s[" + loop_i.toString() + "]:null", 2);
					return;
				}
				//				if (s[loop_i].intparam != 19790115)
				//				{					
				var tool:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(s[loop_i].intparam);
				if (tool == null)
				{
					//测试要求屏蔽
					alert.ShowMsg("物品不存在:" + s[loop_i].intparam.toString(), 2);
					return;
				}
				if (pos <= 3)
				{
					var color:int=tool.tool_color;
					if (color > 0)
						color--;
					tool_id_list.push(s[loop_i].intparam);
					tool_id_num_list.push(s[loop_i + 1].intparam);
					//mc["fbjl"]["jiangli" + jiangli_x.toString()]["title" + pos].htmlText="<font color='#" + ResCtrl.instance().arrColor[color] + "'>" + tool.tool_name + "</font>";
					//
					//mc["wenHao" + jiangli_x.toString()].visible = false;
					mc["fbjl"]["jiangli" + jiangli_x.toString()].visible=true;
					showPackageContainer=mc["fbjl"]["jiangli" + jiangli_x.toString()];
					showPackage(tool_id_list, tool_id_num_list);
						//
				}
				pos++;
				loop_i+=2;
					//				}
					//				else
					//				{					
					//					
					//					//
					//					//mc["wenHao" + jiangli_x.toString()].visible = false;
					//					mc["fbjl"]["jiangli" + jiangli_x.toString()].visible = true;
					//					
					//					showPackageContainer = mc["fbjl"]["jiangli" + jiangli_x.toString()];
					//					showPackage(tool_id_list,tool_id_num_list);
					//					//
					//					
					//										
					//					jiangli_x++;
					//					
					//					pos = 1;
					//										
					//					loop_i+=1;
					//					
					//					//
					//					tool_id_list = [];
					//					tool_id_num_list = [];
					//					
					//					if(loop_i >= len)
					//					{
					//						break;
					//					}
					//					
					//					if(jiangli_x >= 5)
					//					{
					//						break;
					//					}
					//				}
			}
		}
		public var showPackageContainer:DisplayObjectContainer;

		public function showPackage(tool_id_list:Array, tool_id_num_list:Array):void
		{
			//
			var arr:Array=[];
			//
			var itemList:Vector.<StructBagCell2>=new Vector.<StructBagCell2>();
			var len:int=tool_id_list.length;
			for (var h:int=0; h < len; h++)
			{
				var bag:StructBagCell2=new StructBagCell2();
				bag.itemid=tool_id_list[h];
				bag.num=tool_id_num_list[h];
				//bag.pos = i+1;
				bag.pos=0;
				bag.huodong_pos=h + 1;
				//
				Data.beiBao.fillCahceData(bag);
				//
				itemList.push(bag);
			}
			//-----------------------------
			len=itemList.length;
			for (var j:int=0; j < len; j++)
			{
				arr.push(itemList[j]);
			}
			//arr.sortOn("pos");
			arr.sortOn("huodong_pos");
			arr.forEach(callback);
			ToolTip.instance().resetOver();
		}

		//列表中条目处理方法
		private function callback(itemData:StructBagCell2, index:int, arr:Array):void
		{
			//var pos:int=itemData.pos;
			var pos:int=itemData.huodong_pos;
			var sprite:*=showPackageContainer.getChildByName("pic" + pos);
			if (sprite == null)
				return;
			sprite.mouseChildren=false;
			sprite.data=itemData;
			ItemManager.instance().setEquipFace(sprite);
//			sprite["uil"].source=itemData.iconBig;
			ImageUtils.replaceImage(sprite,sprite["uil"],itemData.iconBig);
			sprite["r_num"].text=itemData.sort == 13 ? "" : itemData.num;
			CtrlFactory.getUIShow().addTip(sprite);
			//new MainDrag(sprite,null);
		}

		private function reset():void
		{
			//mc["bx1"].gotoAndStop(1);	
			mc['mc_tong_guan'].alpha=0.0;
			mc['fbjl'].visible=false;
			mc.visible=true;
			duiYouI=0;
			var k:int;
			var m:int;
			//
			mc['mc_tong_guan']['mc_tong_guan_star'].gotoAndStop(1);
			mc['mc_tong_guan']["title1"].text="";
			mc['mc_tong_guan']["title2"].text="";
			mc['mc_tong_guan']["title3"].text="";
			for (k=1; k <= 1; k++)
			{
				mc["fbjl"]["jiangli" + k.toString()].visible=false;
					//clear				
					//mc["jiangli" + k.toString()]["title1"].text = "";
					//mc["jiangli" + k.toString()]["title2"].text = "";
					//mc["jiangli" + k.toString()]["title3"].text = "";
			}
			for (m=2; m <= 5; m++)
			{
				//mc["wenHao" + m.toString()].visible = true;
				mc["fbjl"]["jiangli" + m.toString()].visible=false;
					//mc["jiangli" + m.toString()]["title1"].text = "";
					//mc["jiangli" + m.toString()]["title2"].text = "";
					//mc["jiangli" + m.toString()]["title3"].text = "";
			}
			var _loc1:*;
			var _loc2:*;
			var _loc3:*;
			var _loc4:*;
			var len:int=3;
			for (k=1; k <= 1; k++)
			{
				var dc:DisplayObjectContainer=mc["fbjl"]["jiangli" + k.toString()];
				_loc1=dc.getChildByName("pic1");
				_loc1["uil"].unload();
				_loc1["r_num"].text="";
				_loc1.mouseChildren=false;
				_loc1.data=null;
				ItemManager.instance().setEquipFace(_loc1, false);
				_loc2=dc.getChildByName("pic2");
				_loc2["uil"].unload();
				_loc2["r_num"].text="";
				_loc2.mouseChildren=false;
				_loc2.data=null;
				ItemManager.instance().setEquipFace(_loc2, false);
				_loc3=dc.getChildByName("pic3");
				_loc3["uil"].unload();
				_loc3["r_num"].text="";
				_loc3.mouseChildren=false;
				_loc3.data=null;
				ItemManager.instance().setEquipFace(_loc3, false);
			}
			//-------------------------------------------------------------
			var dc:DisplayObjectContainer=mc['mc_tong_guan'];
			_loc1=dc.getChildByName("pic1");
			_loc1["uil"].unload();
			_loc1["r_num"].text="";
			_loc1.mouseChildren=false;
			_loc1.data=null;
			ItemManager.instance().setEquipFace(_loc1, false);
			_loc2=dc.getChildByName("pic2");
			_loc2["uil"].unload();
			_loc2["r_num"].text="";
			_loc2.mouseChildren=false;
			_loc2.data=null;
			ItemManager.instance().setEquipFace(_loc2, false);
			_loc3=dc.getChildByName("pic3");
			_loc3["uil"].unload();
			_loc3["r_num"].text="";
			_loc3.mouseChildren=false;
			_loc3.data=null;
			ItemManager.instance().setEquipFace(_loc3, false);
			//-------------------------------------------------------------
			for (m=2; k <= 5; k++)
			{
				var dc:DisplayObjectContainer=mc["fbjl"]["jiangli" + m.toString()];
				_loc1=dc.getChildByName("pic1");
				_loc1["uil"].unload();
				_loc1["r_num"].text="";
				_loc1.mouseChildren=false;
				_loc1.data=null;
				ItemManager.instance().setEquipFace(_loc1, false);
				_loc2=dc.getChildByName("pic2");
				_loc2["uil"].unload();
				_loc2["r_num"].text="";
				_loc2.mouseChildren=false;
				_loc2.data=null;
				ItemManager.instance().setEquipFace(_loc2, false);
				_loc3=dc.getChildByName("pic3");
				_loc3["uil"].unload();
				_loc3["r_num"].text="";
				_loc3.mouseChildren=false;
				_loc3.data=null;
				ItemManager.instance().setEquipFace(_loc3, false);
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
				vo.callbacktype=2;
				uiSend(vo);
			}
			switch (target.name)
			{
				case "likai":
					//if(1 == mc["bx1"].currentFrame)
					//{
					var vo2:PacketCSCallBack=new PacketCSCallBack();
					vo2.callbacktype=2;
					uiSend(vo2);
					//}
					var vo3:PacketCSPlayerLeaveInstance=new PacketCSPlayerLeaveInstance();
					vo3.flag=1;
					uiSend(vo3);
					this.winClose();
					break;
			}
		}

		public static function showJiangLi(_sipl:Vector.<StructIntParamList2>, _callbacktype:int):void
		{
			//			if(DataCenter.myKing.hp==0){
			//				sipl = _sipl;
			//				setTimeout(function():void{
			//					showJiangLi(_sipl);
			//				},1000);
			//			}else{
			//				FuBenJiangLi.instance(_sipl);	
			//			}
			ShengLiJiangLi.instance(_sipl, _callbacktype).open();
		}

		override public function closeByESC():Boolean
		{
			return false;
		}

		// 窗口关闭事件
		override protected function windowClose():void
		{
			mc['fbjl'].visible=false;
			mc['fbjl'].scaleX=mc['fbjl'].scaleY=0.25;
			mc['fbjl'].x=538;
			mc['fbjl'].y=126;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, daoJiShiHandler);
			super.windowClose();
		}
	}
}
