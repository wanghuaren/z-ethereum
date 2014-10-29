package ui.view.view1.xiaoGongNeng
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	
	import flash.display.MovieClip;
	import flash.profiler.showRedrawRegions;
	import flash.text.TextField;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSGetOnlineTime;
	import nets.packets.PacketSCGetOnlineTime;
	import nets.packets.PacketSCOnlinePrize;
	
	import ui.base.mainStage.UI_index;
	import ui.view.view2.other.ControlButton;
	import ui.view.view6.GameAlert;
	
	import world.WorldEvent;

	//在线礼包
	public class ZaiXianLiBao
	{
		public function get mcParent():MovieClip
		{
			if (null == ControlButton.getInstance().btnGroup)
			{
				return null;
			}

			return ControlButton.getInstance().btnGroup["arrZaiXian"];
		}

		public function get mc():MovieClip
		{
			if (null == ControlButton.getInstance().btnGroup)
			{
				return null;
			}

			return ControlButton.getInstance().btnGroup["arrZaiXian"];
		}

		private function get label():TextField
		{
			if (null == ControlButton.getInstance().btnGroup)
			{
				return null;
			}

			return ControlButton.getInstance().btnGroup["arrZaiXian"]["zaixianTime"];
		}

		private var time:int;
		private var yuanbao:int=5;

		/**
		 * 第几次获得
		 * 如大于5，需减5
		 *
		 * 1 - 5获得完后，第二天开始每天6,7,8
		 *
		 * 现改成1-7
		 */
		public var times:int;

		public function times_logic():int
		{
			if (times <= 7)
			{
				return times;
			}

			return times - 7;
		}


		public var nextTime:int;
		private var nextYuanbao:int;

		public var dropId:int;
		public var nextDropId:int;

		/*吕文帅 15:30:41
		PacketSCGetOnlineTime
		这个就是在线奖励*/
		public function ZaiXianLiBao()
		{
			//获取在线时间
			DataKey.instance.register(PacketSCGetOnlineTime.id, SCGetOnlineTime);

			//在线奖励
			DataKey.instance.register(PacketSCOnlinePrize.id, SCOnlinePrize);

			//			var vo:PacketCSGetOnlineTime = new PacketCSGetOnlineTime();
			//			DataKey.instance.send(vo);
		}

		private function SCGetOnlineTime(p:PacketSCGetOnlineTime):void
		{

			//yuanbao = p.rmb;
			dropId=p.rmb;

			var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(p.rmb) as Vector.<Pub_DropResModel>;

			if (arr.length > 0)
			{
				yuanbao=arr[0].drop_num;
			}
			else
			{
				yuanbao=0;
			}

			times=p.current;
			nextTime=p.nexttime;

			//nextYuanbao = p.nextrmb;			
			nextDropId=p.nextrmb;

			var arr2:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(p.nextrmb) as Vector.<Pub_DropResModel>;

			if (arr2.length > 0)
			{
				nextYuanbao=arr2[0].drop_num;
			}
			else
			{
				nextYuanbao=0;
			}
			var chazhiTime:int=p.time - p.nexttime;
			if (p.time == -1)
			{

				ControlButton.getInstance().setVisible("arrZaiXian", false);
				ControlButton.getInstance().check();

				if (null != label)
				{
					label.text="";
				}



					//				ControlButton.getInstance().check();

			}
			else if (p.time >= p.nexttime)
			{ //在线时间大于可领取时间 

				ControlButton.getInstance().setVisible("arrZaiXian", true, true);
				ControlButton.getInstance().check();
				//mc.gotoAndStop(2);
				if (null != mc)
				{
					mc["arrZaiXian1"].visible=false;
					mc["arrZaiXian2"].visible=true;

					mc.tabChildren=false;
					mc.tabEnabled=false;
				}
				//
				if (null != label)
				{
					label.text=Lang.getLabel("pub_lin_qu_jiang_li");
				}
				if (times <= 7)
				{
					//zaixianlibao对应arrZaiXian1
					//newcodes
					if (null != mc)
					{
						mc.tipParam=[yuanbao + ""];
						Lang.addTip(mc, "zaixianlibao");
						mc.tipParam=[yuanbao + ""];
						Lang.addTip(mc, "zaixianlibao");
					}
				}
				else
				{
					//ui_index_ZaiXian1对应arrZaiXian1
					//newcodes
					if (null != mc)
					{
						Lang.addTip(mc, "ui_index_ZaiXian1", 120);
						Lang.addTip(mc["arrZaiXian1"], "ui_index_ZaiXian1", 120);
					}
				}
				//添加可领取特效
				if(ControlButton.getInstance().btnGroup)
				{
					ControlButton.getInstance().btnGroup["arrZaiXian"]["guangxiao"].gotoAndPlay(1);
					ControlButton.getInstance().btnGroup["arrZaiXian"]["guangxiao"].visible=true;
				}
			}
			else if (p.time < p.nexttime)
			{ //在线时间不够，显示倒计时

				time=p.nexttime - p.time;
				ControlButton.getInstance().setVisible("arrZaiXian", true, false);
				ControlButton.getInstance().check();

				//mc.gotoAndStop(1);
				if (null != mc)
				{
					mc["arrZaiXian1"].visible=true;
					mc["arrZaiXian2"].visible=false;

					mc.tabChildren=false;
					mc.tabEnabled=false;
				}

				if (times <= 7)
				{
					//zaixianlibao对应arrZaiXian1
					//newcodes
					if (null != mc)
					{
						mc.tipParam=[yuanbao + ""];
						Lang.addTip(mc, "zaixianlibao");
						mc.tipParam=[yuanbao + ""];
						Lang.addTip(mc, "zaixianlibao");
					}
				}
				else
				{
					//ui_index_ZaiXian1对应arrZaiXian1
					//newcodes
					if (null != mc)
					{
						Lang.addTip(mc, "ui_index_ZaiXian1", 120);
						Lang.addTip(mc["arrZaiXian1"], "ui_index_ZaiXian1", 120);
					}
				}
				GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, messageTimer);
				//取消可领取特效
				if(ControlButton.getInstance().btnGroup)
				{
					ControlButton.getInstance().btnGroup["arrZaiXian"]["guangxiao"].stop();
					ControlButton.getInstance().btnGroup["arrZaiXian"]["guangxiao"].visible=false;
				}
			}
		}

		private function SCOnlinePrize(p:PacketSCOnlinePrize):void
		{
			var vo:PacketCSGetOnlineTime=new PacketCSGetOnlineTime();
			DataKey.instance.send(vo);
			if (Lang.showResult(p))
			{
				if (this.times <= 7)
				{
					if (this.times != 7)
					{
						(new GameAlert).ShowMsg(Lang.getLabel("20079_ZaiXianLiBao", [times + "", yuanbao + ""]), 2) //+"\n\n"+Lang.getLabel("20082_ZaiXianLiBao",[int(nextTime/60)+"",nextYuanbao]),2);	
					}
					else
					{
						(new GameAlert).ShowMsg(Lang.getLabel("20079_ZaiXianLiBao", [times + "", yuanbao + ""]) + "\n" + Lang.getLabel("20083_ZaiXianLiBao"), 2);
					}
				}
				if (this.times > 7)
				{
					if (nextTime != 0)
					{
						ZaiXianLiBao678.getInstance().winClose();

					}
					else
					{
						ZaiXianLiBao678.getInstance().winClose();
							//此提示现在不要
						/*(new GameAlert).ShowMsg(Lang.getLabel("20079_ZaiXianLiBao",[
						this.times_logic() +"",yuanbao+""])+"\n"+Lang.getLabel("20083_ZaiXianLiBao"),2);	*/
					}
				}



			}
		}

		private function messageTimer(e:WorldEvent):void
		{
			time--;
			if (time > 0)
			{
				if (null != label)
				{
					label.text=CtrlFactory.getUICtrl().formatTime(time); //getTime(time);
				}
			}
			else
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, messageTimer);
				//mc.gotoAndStop(2);
				if (null != mc)
				{
					mc["arrZaiXian1"].visible=false;
					mc["arrZaiXian2"].visible=true;

					mc.tabChildren=false;
					mc.tabEnabled=false;
				}

				if (null != label)
				{
					ControlButton.getInstance().setVisible("arrZaiXian", true, true);
					ControlButton.getInstance().check();
					label.text=Lang.getLabel("pub_lin_qu_jiang_li");
					ControlButton.getInstance().btnGroup["arrZaiXian"]["guangxiao"].gotoAndPlay(1);
					ControlButton.getInstance().btnGroup["arrZaiXian"]["guangxiao"].visible=true;
				}


			}
		}

		private function getTime(second:int):String
		{
			var value:String="";
			var shi:int=int(second / 3600);
			var fen:int=int((second % 3600) / 60);
			var miao:int=int((second % 3600) % 60);
			if (shi > 0)
			{
				value=shi + Lang.getLabel("pub_shi") + fen + Lang.getLabel("pub_fen");
			}
			else if (fen)
			{
				value=fen + Lang.getLabel("pub_fen") + miao + Lang.getLabel("pub_miao");
			}
			else
			{
				value=miao + Lang.getLabel("pub_miao");
			}
			return value;
		}
	}
}
