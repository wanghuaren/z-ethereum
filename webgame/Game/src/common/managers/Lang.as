package common.managers
{
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.XmlConfig;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_VariableResModel;
	import common.utils.ControlTip;
	import common.utils.GamePrint;
	import common.utils.GamePrintByShiHuang;
	import common.utils.res.ResCtrl;
	
	import engine.event.DispatchEvent;
	import engine.utils.HashMap;
	
	import flash.display.DisplayObject;
	import flash.utils.getTimer;
	
	import netc.Data;
	import netc.packets2.StructVariant2;
	
	import nets.packets.StructVariant;
	
	import ui.base.mainStage.UI_index;
	import ui.base.vip.NoMoney;
	import ui.base.vip.NoWuHun;
	import ui.base.vip.NoYueLi;
	import ui.frame.UIActMap;
	import ui.frame.WindowName;
	import ui.view.UIMessage;
	import ui.view.newFunction.FunJudge;
	import ui.view.view1.desctip.GameTip;
	import ui.view.view4.yunying.ZhiZunVIPMain;
	import ui.view.view6.GameAlert;

	/**
	 * 游戏中语言文字控制【多国语言】
	 * @Author : andy
	 * @Date :   2011-10-28
	 */
	public final class Lang
	{
		/**
		 *	是否显示开关
		 *  2013-11-06
		 */
		private static const IS_SHOW:Boolean=true;
		private static const WARING_MSG:String="性能测试屏蔽";
		private static const IS_START_INIT:Boolean=true;
		/**
		 * tips映射表
		 */
		private static var mapTip:HashMap=new HashMap();
		private static var mapLabel:HashMap=new HashMap();
		private static var mapLabelArr:HashMap=new HashMap();
		private static var mapClientMsg:HashMap=new HashMap();
		public static var mapServerMsg:HashMap=new HashMap();
		private static var msg_:String="";
		private static var timer_:int;

		/**
		 *  添加元件悬浮提示
		 *  请将key写到Lang.xml <tips>
		 *  @param dp  悬浮元件
		 *  @param key
		 *  注：如果悬浮文字中带参数，请这样设置参数：
		 *  dp.tipParam=[param1,param2..]
		 */
		public static function addTip(dp:DisplayObject, key:Object="", txtWidth:int=100):void
		{
			ControlTip.getInstance().addTip(dp, key as String, txtWidth);
		}

		/**
		 *  移除元件悬浮提示
		 *  @param dp  悬浮元件
		 */
		public static function removeTip(dp:DisplayObject):void
		{
			ControlTip.getInstance().removeTip(dp);
		}

		/**
		 * 获取tips标签下的内容
		 * @param key
		 * @param param
		 * @return
		 *
		 */
		public static function getTip(key:String="", param:Array=null):String
		{
			var tip:String="";
			if (mapTip.containsKey(key))
			{
				tip=mapTip.get(key);
			}
			else
			{
				try
				{
					tip=String(XmlConfig.LANGXML.tips.t.(@k == key));

					mapTip.put(key, tip);
				}
				catch (e:Error)
				{
					showMsg({type: 1, msg: "cleint tips not find:" + key});
				}
			}
			return replaceParam(tip, param);
		}

		/**
		 *	文本信息
		 *  请将key写到Lang.xml <lbls>
		 *  @param key
		 *  @param param 文本中参数数组
		 */
		public static function getLabel(key:String="", param:Array=null):String
		{
			if (IS_SHOW == false)
			{
				return WARING_MSG;
			}
			var word:String=null;
			if (mapLabel.containsKey(key))
			{
				word=mapLabel.get(key);
			}
			else
			{
//				try
//				{
				word=String(XmlConfig.LANGXML.lbls.t.(@k == key));
				if (GameIni.pf() == GameIni.PF_3366)
				{
					word=word.replace(/\$2000/g, "蓝钻");
				}
				else
				{
					word=word.replace(/\$2000/g, "黄钻");
				}
				mapLabel.put(key, word);
//				}
//				catch (e:Error)
//				{
//					showMsg({type: 1, msg: "cleint lbls not find:" + key});
//				}
			}
			return replaceParam(word, param);
		}

		/**
		 *	文本信息【数组】
		 *  请将key写到Lang.xml <lbls>
		 *  @param key
		 */
		public static function getLabelArr(key:String=""):Array
		{
			var arr:Array;
			if (mapLabelArr.containsKey(key))
			{
				arr=mapLabelArr.get(key);
			}
			else
			{
				try
				{
					arr=[];
					var xml:XML=XML(XmlConfig.LANGXML.lbls.arr.(@k == key));
					var item:XML=null;
					for each (item in xml.child("t"))
					{
						arr[int(item.@k)]=String(item);
					}
					mapLabelArr.put(key, arr);
				}
				catch (e:Error)
				{
					showMsg({type: 1, msg: "cleint lbls not find:" + key});
				}
			}
			return arr;
		}

		/**
		 *	获得客户端操作信息
		 *  请将key写到Lang.xml <msgs>
		 *  @param key
		 * 	@param 参数数组
		 */
		public static function getClientMsg(key:String="", param:Array=null):Object
		{
			var obj:Object=null;
			try
			{
				if (mapClientMsg.containsKey(key))
				{
					obj=mapClientMsg.get(key);
				}
				else
				{
					//var item:XML=XML(XmlConfig.LANGXML.msgs.t.(@k==key));

					var list:XMLList=XmlConfig.LANGXML.msgs.t;
					var item:XML=XML(list.(@k == key));

					obj={type: int(item.@p), msg: String(item)};
					mapClientMsg.put(key, obj);
				}
			}
			catch (e:Error)
			{
				obj={type: 1, msg: "cleint msg not find:" + key};
			}
			if (obj == null)
				return new Object();
			var str:String=obj.msg;
			str=replaceParam(str, param);
			return {type: obj.type, msg: str};
		}

		/**
		 *	获得服务端操作信息
		 *  @param key
		 */
		public static function getServerMsg(key:int=0, tempParam:Vector.<StructVariant2>=null, msg:String=null):Object
		{
			var obj:Object=null;
			try
			{
				if (mapServerMsg.containsKey(key))
				{
					obj=mapServerMsg.get(key);
				}
				else
				{
					var item:XML=XML(XmlConfig.MSGXML..e.(@i == key));

					obj={type: int(item.@p), msg: String(item.@m), t: int(item.@t), l: int(item.@l), s: int(item.@s), ui: int(item.@ui)};
					mapServerMsg.put(key, obj);
				}
				var str:String="";
				if (msg == null || msg == "")
				{
					var param:Array;
					if (tempParam != null)
					{
						param=[];
						for each (var sv:StructVariant in tempParam)
						{
							param.push(sv.val);
						}
					}
					str=obj.msg;
					str=replaceParam(str, param);
				}
				else
				{
					str=msg;
				}
			}
			catch (e:Error)
			{
				obj={type: 1, msg: "server msg not find:" + key, s: 0};
			}
			if (obj == null)
				new Object();
			return {type: obj.type, msg: str, t: obj.t, l: obj.l, s: obj.s, ui: obj.ui};
		}

		/**
		 *	显示信息
		 *  @param obj obj.type
		 *   1,	   //右下角
			 2,	   //中间系统公告(个人)
			 3,    //中间系统公告[跑马灯]
			 4,    //中间  个人系统提示
			 5,    //左下角 系统
			 6 =  2+5
			 7 =  3+5
			 8 =  1+4
			 * 9 =  动画提醒
		 */
		public static function showMsg(obj:Object):void
		{
			if (obj == null)
				return;
			
			//test
			//GamePrintByShiHuang.Print(obj.msg);
			//UIMessage.CMessage19(obj.msg);
			//UIMessage.CMessage20(obj.msg);
			
			switch (obj.type)
			{
				case 1:
					//右下[重新启用][废弃]
					GamePrint.Print(obj.msg);
					break;
				
				case 2:
					//中间  中间系统公告(个人)
					UIMessage.CMessage1(obj.msg);
					break;
				case 3:
					//中间   中间系统公告
					UIMessage.CMessage2(obj.msg);
					break;
				case 4:
					//中间  上下滚动【个人】
					if ((msg_ != obj.msg) || ((getTimer() - timer_) > 2000))
					{
						UIMessage.CMessage3(obj.msg);
						timer_=getTimer();
						msg_=obj.msg;
					}
					break;
				case 5:
					PubData.chat.SCSayXiTong({userid: 0, username: getLabel("20066_UIAction"), content: obj.msg, arrItemequipattrs: obj.arrItemequipattrs});
					break;
				case 6:
					UIMessage.CMessage1(obj.msg);
					PubData.chat.SCSayXiTong({userid: 0, username: getLabel("20066_UIAction"), content: obj.msg, arrItemequipattrs: obj.arrItemequipattrs});
					break;
				case 7:
					UIMessage.CMessage2(obj.msg);
					PubData.chat.SCSayXiTong({userid: 0, username: getLabel("20066_UIAction"), content: obj.msg, arrItemequipattrs: obj.arrItemequipattrs});
					break;
				case 8:
					GamePrint.Print(obj.msg);
					if ((msg_ != obj.msg) || ((getTimer() - timer_) > 1000))
					{
						UIMessage.CMessage3(obj.msg);
						timer_=getTimer();
						msg_=obj.msg;
					}
					break;
				case 9:
					UIMessage.CMessage4(obj.msg);
					break;
				case 10:
					//中间  上下滚动【个人】
					if ((msg_ != obj.msg) || ((getTimer() - timer_) > 1000))
					{
						UIMessage.CMessage3(obj.msg);
						timer_=getTimer();
						msg_=obj.msg;
					}
					PubData.chat.SCSayXiTong({userid: 0, username: getLabel("20066_UIAction"), content: obj.msg, arrItemequipattrs: obj.arrItemequipattrs});
					break;
				case 11:
					PubData.chat.SCSayJiaZu({userid: 0, username: "", content: obj.msg, arrItemequipattrs: obj.arrItemequipattrs});
					break;
				case 12:
					UIMessage.CMessage1(obj.msg);
					PubData.chat.SCSayJiaZu({userid: 0, username: "", content: obj.msg, arrItemequipattrs: obj.arrItemequipattrs});
					break;
				case 13:
					UIMessage.CMessage2(obj.msg);
					PubData.chat.SCSayJiaZu({userid: 0, username: "", content: obj.msg, arrItemequipattrs: obj.arrItemequipattrs});
					break;
				case 14:
					PubData.chat.SCSayZuDui({userid: 0, username: "", content: obj.msg, arrItemequipattrs: obj.arrItemequipattrs});
					break;
				
				case 18:
					GamePrintByShiHuang.Print(obj.msg);
					break;
				
				case 19:
					//中间   黄字
					UIMessage.CMessage19(obj.msg);
					break;
				
				case 20:
					//中间   紫字
					UIMessage.CMessage20(obj.msg);
					break;
				
			}
		}

		/**
		 * 处理服务端信息
		 *
		 */
		public static function showResult(p:Object):Boolean
		{
			if (!p.hasOwnProperty("tag"))
			{
				return false;
			}
			if (p.tag == 0)
			{
				if (p.hasOwnProperty("msg") && p.msg != null && p.msg != "")
				{
					showMsg({type: 4, msg: p.msg});
				}
				return true;
			}
			else
			{
				var param:Vector.<StructVariant2>=null;
				if (p.hasOwnProperty("arrItemparams"))
				{
					param=p.arrItemparams;
				}
				var msg:String=null;
				if (p.hasOwnProperty("msg") && p.msg != null && p.msg != "")
				{
					msg=p.msg;
				}
				var serverMsg:Object=Lang.getServerMsg(p.tag, param, msg);
				if (p.hasOwnProperty("arrItemequipattrs"))
					serverMsg["arrItemequipattrs"]=p["arrItemequipattrs"];

				switch (serverMsg.t)
				{
					case 2:
						//公用接口【元宝不足】
						UI_index.UIAct.dispatchEvent(new DispatchEvent(UIActMap.EVENT_PLEASE_PAY));
						return false;
						break;
					case 3:
						//公用接口【包裹空间不足】
						UI_index.UIAct.dispatchEvent(new DispatchEvent(UIActMap.EVENT_PLEASE_BAG_UP));
						return false;
						break;
					case 4:
						//公用接口【消息提醒-邮件】
						GameTip.addTipButton(null, 1, serverMsg.msg);
						return false;
						break;
					case 5:
						//公用接口【消息提醒-感叹号】
						GameTip.addTipButton(null, 4, serverMsg.msg);
						return false;
						break;
					case 6:
						//公用接口【消息提醒-感叹号】 打开指定面板
						var arr:Object=serverMsg["arrItemequipattrs"];
						GameTip.addTipButton(null, 6, "", {type: serverMsg.ui, param: (arr != null && arr.length > 0) ? arr[0] : null});
						return false;
						break;
					case 7:
						//公用接口【银两不足】
						if (FunJudge.judgeByName(WindowName.win_dui_huan, false))
						{
							NoMoney.getInstance().setType(1);
							return false;
						}
						break;
					case 8:
						//公用接口【消息提醒-分享】 
						GameTip.addTipButton(UIMessage.fenXiang, 7, serverMsg.msg, p.tag);
						return false;
						break;
					case 9:
						//公用接口【阅历不足】
						if (FunJudge.judgeByName(WindowName.win_dui_huan_yueli, false))
						{
							NoYueLi.getInstance().open();
							return false;
						}
						break;
					case 10:
						//公用接口【武魂不足】
						NoWuHun.getInstance().open();
						return false;
					case 11:
						//公用接口【确定提示】
						new GameAlert().ShowMsg(serverMsg.msg,2,null);
						return false;	
						break;
					case 12:
						//公用接口【成为VIP提示】
						new GameAlert().ShowMsg(serverMsg.msg,2,"成为VIP",toVip);
						return false;	
						break;
					case 13:
						//公用接口【消息提醒-奖】 打开指定面板
						GameTip.addTipButton(null, 2, serverMsg.msg, {type: serverMsg.ui});
						return false;
						break;
					default:
						break;
				}
				//级别不足  
				//2012-07-06 msg.xml 1.l<0代表为小于这个等级显示 2.l>0代表为大于这个等级显示
				if (serverMsg.l < 0 && Data.myKing.level >= Math.abs(serverMsg.l))
				{
					return false;
				}
				if (serverMsg.l > 0 && Data.myKing.level < serverMsg.l)
				{
					return false;
				}
				//阵营 2012-06-19   家族 2012-09-09 没有家族不显示
				if (serverMsg.s == 0 || serverMsg.s == 1 || serverMsg.s == 2 || (serverMsg.s == 4 && Data.myKing.campid == 3) || (serverMsg.s == 3 && Data.myKing.campid == 2) || (serverMsg.s == 5 && Data.myKing.Guild.GuildId > 0)|| serverMsg.s == 7 )
				{

				}
				else
				{
					return false;
				}

				if (serverMsg.s == 6 && Data.myKing.campid == 0)
				{
					return false;
				}
				showMsg(serverMsg);
				return false;
			}
		}
		/**
		 *  弹出成为vip提示【如：没有小飞鞋】
		 *  2014-09-28 
		 * 
		 */		
		private static function toVip(obj:Object=null):void{
			ZhiZunVIPMain.getInstance().setType(1);
		}
		/**
		 *	玩家游戏金钱变化
		 */
		public static function showCoinChange(e:DispatchEvent):void
		{
			var arr:Array=e.getInfo;
			if (arr.length > 0)
			{
				for each (var item:Object in arr)
				{
					if (item.hasOwnProperty("type") == false)
						continue;
					var type:String=item.type;
					var count:int=int(item.count);
					if (count == 0)
						continue;
					var status:String=count > 0 ? getLabel("pub_huo_de") : getLabel("pub_shi_qu");

					var name:String="";
					switch (type)
					{
						case "coin1":
						case "coin5":
							name=getLabel("pub_yin_liang")
							break;
						case "coin2":
							name=getLabel("pub_li_jin")
							break;
						case "coin3":
							name=getLabel("pub_yuan_bao")
							break;
						case "coin4":
							break;
						case "suipian1":
							name=getLabel("pub_suipian1");
							break;
						case "suipian2":
							name=getLabel("pub_suipian2");
							break;
						case "suipian3":
							name=getLabel("pub_suipian3");
							break;
						case "suipian4":
							name=getLabel("pub_suipian4");
							break;
						case "suipian5":
							name=getLabel("pub_suipian5");
							break;
						case "suipian6":
							name=getLabel("pub_suipian6");
							break;
						case "soarexp":
							name=getLabel("pub_soarexp");
							break;
						default:
							break;
					}
					showMsg({type: 1, msg: status + Math.abs(count) + name});
					PubData.chat.SCSayMyself({userid: 0, username: "", content: status + Math.abs(count) + name});
				}
			}
		}

		/**
		 *	玩家游戏经验变化【只显示增加的】
		 */
		public static function showExpAddChange(e:DispatchEvent):void
		{
			showMsg({type: 1, msg: getLabel("pub_huo_de") + e.getInfo + getLabel("pub_jing_yan")});
			if (PubData.chat != null)
				PubData.chat.SCSayMyself({userid: 0, username: "", content: getLabel("pub_huo_de") + e.getInfo + getLabel("pub_jing_yan")});
		}

		/**
		 *	玩家游戏经验变化【补充协议】
		 *
		 * 杀怪获得xx经验，额外获得连斩奖励xx经验。
		 */
		public static function showExpAddChangeByMonExp(e:DispatchEvent):void
		{

			var expList:Array=e.getInfo as Array;

			if (0 == expList[0])
			{
				showMsg({type: 1, msg: getLabel("pub_huo_de") + expList[1] + getLabel("pub_jing_yan")});

			}
			else
			{
				//策划要求分二句打印
				showMsg({type: 1, msg: getLabel("pub_killMon_huo_de") + expList[1] + getLabel("pub_jing_yan")});

				showMsg({type: 1, msg: getLabel("pub_lianZhan_huo_de") + expList[0] + getLabel("pub_jing_yan")});
			}
		}

		/**
		 *	玩家包裹道具变化【只显示增加的】
		 */
		public static function showBagAddChange(e:DispatchEvent):void
		{
			if (e.getInfo.addCount > 0)
			{
				showMsg({type: 1, msg: getLabel("pub_huo_de") + e.getInfo.addCount + getLabel("pub_ge") + "<font color='#" + ResCtrl.instance().arrColor[e.getInfo.toolColor] + "'>" + e.getInfo.itemname + "</font>"});
				PubData.chat.SCSayMyself({userid: 0, username: "", content: getLabel("pub_huo_de") + e.getInfo.addCount + getLabel("pub_ge") + "<font color='#" + ResCtrl.instance().arrColor[e.getInfo.toolColor ] + "'>" + e.getInfo.itemname + "</font>"});
			}
		}

		/**
		 *	声望(阅历)变化【只显示增加的】
		 */
		public static function showRenownAddChange(e:DispatchEvent):void
		{
			if (e == null)
				return;
			showMsg({type: 1, msg: getLabel("pub_huo_de") + e.getInfo + getLabel("pub_sheng_wang")});
			PubData.chat.SCSayMyself({userid: 0, username: "", content: getLabel("pub_huo_de") + e.getInfo + getLabel("pub_sheng_wang")});
		}
		

		/**
		 *	替换文字中带参数
		 *  @param word  文字
		 * 	@param param 参数数组
		 */
		public static function replaceParam(word:String="", param:Array=null):String
		{
			if (param == null)
				return word;
			var len:int=param.length;

			//服务端消息参数标记 %d,%s先替换成客户端参数标记 #param 
			while (word.indexOf("%d") >= 0)
			{
				word=word.replace("%d", "#param");
			}
			while (word.indexOf("%s") >= 0)
			{
				word=word.replace("%s", "#param");
			}
			for (var i:uint=0; i < len; i++)
			{
				word=word.replace("#param", param[i]);
			}
			return word;
		}


		/**
		 *	通配符
		 */
		public static function $word(v:String):String
		{
			if (v == null)
				return "";

			while (v.indexOf("$") >= 0)
			{
				//通配符编号
				var $no:String=v.substr(v.indexOf("$"), 5);
				//通配符配置数据
				var $var:Pub_VariableResModel=XmlManager.localres.getVarXml.getResPath($no) as Pub_VariableResModel;
				if ($var != null)
				{
					var replace:String="";
					switch ($var.sort)
					{
						case 1:
							//根据性别选择
							replace=Data.myKing.sex == 1 ? $var.para1 : $var.para2;
							break;
						case 2:
							//直接换成名字
							replace=Data.myKing.name;
							break;
						default:
							break;
					}
					if (replace != null)
						v=v.replace($no, replace);
				}
				else
				{
					v=v.replace($no, "");
				}
			}
			return v;
		}

		/**
		 *	过滤中间漂浮的文字 {}
		 *  2012-08-13 andy
		 */
		public static function filterMsg(msg:String=""):String
		{
			if (msg == null)
				return "";
			var currStr:String=null;
			var i:int=msg.length - 1;
			var lastPos:int;
			while (i >= 0)
			{
				currStr=msg.substr(i, 1);
				if (currStr == "}")
				{
					lastPos=i;

				}
				else if (currStr == "{")
				{
					//2012-08-11 andy 文字可以点击
					var p:String=msg.substring(i + 1, lastPos);
					var arr:Array=p.split("@");
					if (arr.length >= 3)
						msg=msg.substring(0, i) + "<font color='#" + arr[2] + "'>" + arr[1] + "</font>" + msg.substring(lastPos + 1, msg.length);
				}
				i--;
			}
			return msg;
		}

		/**
		 *	进入游戏初始化
		 *  由于数据庞大，可能会卡一下
		 *  2013-11-06
		 */
		public static function startInit():void
		{
			if (IS_START_INIT == false)
				return;
			try
			{
				var xml:XML=null;
				var item:XML=null;
				var word:String="";
				//tip
				xml=XML(XmlConfig.LANGXML.tips);
				for each (item in xml.child("t"))
				{
					mapTip.put(String(item.@k), String(item));
				}
				//msg
				xml=XML(XmlConfig.LANGXML.msgs);
				for each (item in xml.child("t"))
				{
					mapClientMsg.put(String(item.@k), {type: int(item.@p), msg: String(item)});
				}

				//lbl
				xml=XML(XmlConfig.LANGXML.lbls);
				for each (item in xml.child("t"))
				{
					word=String(item);
					if (GameIni.pf() == GameIni.PF_3366)
					{
						word=word.replace(/\$2000/g, "蓝钻");
					}
					else
					{
						word=word.replace(/\$2000/g, "黄钻");
					}
					mapLabel.put(String(item.@k), word);
				}
				//lbl arr
				var arrXml:XML=null;
				var arr:Array=[];
				for each (arrXml in xml.child("arr"))
				{
					arr=[];
					for each (item in arrXml.child("t"))
					{
						arr[int(item.@k)]=String(item);
					}
					mapLabelArr.put(String(arrXml.@k), arr);
				}
			}
			catch (e:Error)
			{
				showMsg({type: 1, msg: "lang.xml init warning!please check"});
			}
		}
	}
}
