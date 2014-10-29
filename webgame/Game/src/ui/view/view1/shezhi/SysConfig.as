package ui.view.view1.shezhi
{
	import com.bellaxu.def.NeverNoticeDef;
	import com.bellaxu.display.Alert;
	import com.bellaxu.mgr.MusicMgr;

	import common.managers.Lang;
	import common.utils.AsToJs;
	import common.utils.bit.BitUtil;
	import common.utils.clock.GameClock;

	import netc.DataKey;

	import nets.packets.PacketCSSystemSetting;

	import scene.action.Action;

	import ui.base.mainStage.UI_index;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view3.drop.ResDrop;

	import world.WorldEvent;

	/**
	 * 系统设置
	 * @author sh
	 * @date   2011-12-26
	 */
	public final class SysConfig extends UIWindow
	{
		//设置信息用数组保存
		public static var arrConfig:Array=[];
		//音乐
		public static var sound1:int=1;
		//音效
		public static var sound2:int=1;
		//音乐拖动条
		private var back_scroll:MusicScroll;
		//音效拖动条
		private var game_scroll:MusicScroll;

		public static var arrSetting:Array=[];
		public static var setting:int;

		/**
		 * 音乐声音大小
		 */
		private static var arrSoundValue:Array;
		//单例
		public static var _instance:SysConfig;

		public static function getInstance():SysConfig
		{
			if (_instance == null)
				_instance=new SysConfig();
			return _instance;
		}

		public function SysConfig()
		{
			super(getLink(WindowName.win_xi_tong));
		}

		override protected function init():void
		{
			super.init();
			arrSoundValue=Lang.getLabelArr("arrSoundValue");
			back_scroll=new MusicScroll(mc["mc_sound1"]);
			game_scroll=new MusicScroll(mc["mc_sound2"]);


			GameClock.instance.addEventListener(WorldEvent.CLOCK_HALF_OF_SECOND, timerHandler);
		}

		private function timerHandler(e:WorldEvent):void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_HALF_OF_SECOND, timerHandler);
			showSelected();
		}

		//0 始终显示玩家信息   1始终显示怪物信息   2隐藏其他玩家及伙伴   3始终显示掉落物品名称   4全屏游戏   5消费提醒   
		//6自动同意组队   7自动同意交友   8音乐   9音效  
		//12帮派仓库销毁提示
		public static function getSettingValue(pos:int):Boolean
		{
			return arrConfig[pos] == 0 ? false : true;
		}




		/**
		 *	获得系统配置数据
		 */
		public function SCSystemSetting(setting_:int, first:Boolean=false):void
		{
			setting=setting_;
			for (var n:int=1; n < 17; n++)
			{
				if (n - 1 == 4)
				{ //初始化始终全屏显示---WHR
					arrConfig[n - 1]=1;
				}
				else
				{
					arrConfig[n - 1]=BitUtil.getOneToOne(setting_, n, n);
				}

			}
			arrSetting=arrConfig.slice(0);
			sound1=BitUtil.getOneToOne(int(setting_), 17, 24);
			sound2=BitUtil.getOneToOne(int(setting_), 25, 32);

			if (sound1 < 1 || sound1 > 100)
				sound1=100;
			if (sound2 < 1 || sound2 > 100)
				sound2=100;
			update(first);
		}

		/**
		 *	主界面右上角关闭音乐
		 */
		public static function tellClose(result:Boolean):void
		{
			arrConfig[8]=result ? 0 : 1;
			arrConfig[9]=result ? 0 : 1;
			saveConfig();
		}

		/**
		 *	主界面全屏
		 */
		public static function tellClose2(result:Boolean):void
		{
			arrConfig[4]=result ? 1 : 0;
			saveConfig();
		}

		/**
		 *	显示隐藏玩家
		 */
		public static function tellClose3(result:Boolean):void
		{
			arrConfig[2]=result ? 1 : 0;
			saveConfig();
		}

//		/**
//		 *	声音是否打开 
//		 */
//		public static function isClose():Boolean
//		{
//			var ret:Boolean=false;
//			if(arrConfig!=null&&arrConfig[8]==0&&arrConfig[9]==0)
//				ret=true;
//			return ret;
//		}

		/**
		 * 音乐是否打开
		 */
		public static function isMusicClose():Boolean
		{
			var ret:Boolean=false;
			if (arrConfig != null && arrConfig[8] == 0)
				ret=true;
			return ret;
		}

		/**
		 * 音效是否打开
		 */
		public static function isSoundClose():Boolean
		{
			var ret:Boolean=false;
			if (arrConfig != null && arrConfig[9] == 0)
				ret=true;
			return ret;
		}

		/**
		 *是否自动打开使用物品提示
		 * @return
		 *
		 */
		public static function isUseAuto():Boolean
		{
			var ret:Boolean=false;
			if (arrConfig != null && arrConfig[11] == 1)
				ret=true;
			return ret;
		}

//		//防止玩家点击勾选过快，变成双击事件
//		override protected function mcDoubleClickHandler(target : Object) : void {
//			var name:String=String(target.name);
//			if(name.indexOf("item")>=0){
//				var n:int=int(name.substring(4,name.length));
//				arrSetting[n-1]=(target as CheckBox).selected==false?1:0;
//				return;
//			}
//		}
//		
		public function setMonsterBoolBar(show:Boolean):void
		{
			arrConfig[1]=show ? 1 : 0;
			saveConfig();
		}

		override public function mcHandler(target:Object):void
		{
			var name:String=String(target.name);
			if (name.indexOf("check") >= 0)
			{
				var n:int=int(name.substring(5));
				target.selected=!target.selected;
				arrSetting[n - 1]=target.selected == true ? 1 : 0;

				//重新设置一下关于是否需要消费提示
				if (arrSetting[5] == 1)
					Alert.clearConfig();
				return;
			}
			switch (name)
			{
				case "btn_save":
					saveConfig();
					Lang.showMsg({type: 4, msg: Lang.getLabel("20024_SysConfig")});
					break;
				case "btn_reset":
					reset();
					break;
//				case "cbHightGame":
//					switchGameMode();
//					break;
			}
		}

		//恢复默认
		private function reset():void
		{
			//2012-10-19 andy 始终显示掉落物品名字 默认勾选
			arrSetting=[1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1];
			var item:Object=null;
			for (var i:int=1; i < 32; i++)
			{
				item=mc["check" + i];
				if (item != null)
					item.selected=arrSetting[i - 1] == 1 ? true : false;
			}
			back_scroll.init(arrSoundValue[0]);
			game_scroll.init(arrSoundValue[1]);
			saveConfig();
		}

		//保存配置
		private static function saveConfig():void
		{
			if (_instance != null && _instance.parent != null)
			{
				//2012－07－25 andy 如果没有改变数据，则不变化
				if (arrSetting.length == 0)
					return;
				sound1=_instance.back_scroll.value;
				sound2=_instance.game_scroll.value;
				if (sound1 < 0 || sound1 > 100)
					sound1=100;
				if (sound2 < 0 || sound2 > 100)
					sound2=100;
				if (sound1 == 0)
					sound1=1;
				if (sound2 == 0)
					sound2=1;
				var k:int=0;
				for (k=0; k < 32; k++)
				{
					arrConfig[k]=0;
				}
				var arrSettingLen:int=arrSetting.length;
				for (k=0; k < arrSettingLen; k++)
				{
					if (arrSetting[k] != null)
						arrConfig[k]=arrSetting[k];
				}

				if (arrSetting[10] == 1)
				{
					Alert.setStateByType(NeverNoticeDef.BANGPAI, 0);
				}
				else
				{
					Alert.setStateByType(NeverNoticeDef.BANGPAI, 1);
				}


				var arr:Array=BitUtil.convertToBinaryArr(sound1);
				var arrLen:int=arr.length;
				for (k=0; k < arrLen; k++)
				{
					arrConfig[k + 16]=arr[k];
				}
				arr=BitUtil.convertToBinaryArr(sound2);
				arrLen=arr.length;
				for (k=0; k < arrLen; k++)
				{
					arrConfig[k + 24]=arr[k];
				}
			}
			var vo:PacketCSSystemSetting=new PacketCSSystemSetting();
			vo.setting=twoTOten(arrConfig);
			DataKey.instance.send(vo);
			update();
		}

		override protected function windowClose():void
		{
			super.windowClose();
			this.back_scroll.removeListener();
			this.game_scroll.removeListener();
		}

		/**
		 *	更新
		 */
		public static function update(first:Boolean=false):void
		{
			var volume1:int=sound1;
			volume1=sound1;
			if (arrConfig[8] == 0)
			{
				volume1=0;
			}
			var volume2:int=sound2;
			volume2=sound2;
			if (arrConfig[9] == 0)
			{
				volume2=0;
			}
			MusicMgr.setVolume(1, volume1);
			MusicMgr.setVolume(2, volume2);
			if (AsToJs.callJS("getsizestate") == arrConfig[4])
			{
				AsToJs.callJS("checkSize");
			}

			if (!first)
			{
				if (arrConfig[5] == 1)
				{
				}

				if (arrConfig[8] == 0 && arrConfig[9] == 0)
				{
					MusicMgr.musicOff=true;
				}
				else
				{
					MusicMgr.musicOff=false;
				}

//				if (arrConfig[4] == 0)
//				{
//					if (UI_index.indexMC)
//						UI_index.indexMC_mrt_smallmap["btnFullScreen"].gotoAndStop(2);
//				}
//				else
//				{
//					if (UI_index.indexMC)
//						UI_index.indexMC_mrt_smallmap["btnFullScreen"].gotoAndStop(1);
//				}

				if (arrConfig[2] == 0)
				{
					if (UI_index.indexMC)
					{
						UI_index.indexMC_mrt["smallmap"]["btnHidePlayer"].gotoAndStop(1);

						if (UI_index.indexMC["mc_fu_ben"].currentFrame == 3)
						{
							//"隐藏玩家";
							UI_index.indexMC["mc_fu_ben"]["btnYinCangWanJia"].label=Lang.getLabel("10104_sysconfig");
						}
					}
				}
				else
				{
					if (UI_index.indexMC)
					{
						UI_index.indexMC_mrt["smallmap"]["btnHidePlayer"].gotoAndStop(2);

						if (UI_index.indexMC["mc_fu_ben"].currentFrame == 3)
						{
							//"显示玩家"
							UI_index.indexMC["mc_fu_ben"]["btnYinCangWanJia"].label=Lang.getLabel("10105_sysconfig");
						}
					}
				}

				if (SysConfig.getInstance().isOpen)
					SysConfig.getInstance().showSelected();

				Action.instance.sysConfig.alwaysShowPlayerName(arrConfig[0] == 1 ? true : false);
				Action.instance.sysConfig.alwaysShowMonsterName(arrConfig[1] == 1 ? true : false);
				//Action.instance.sysConfig.alwaysHidePlayerAndPet(arrConfig[2] == 1 ? true : false);

				ResDrop.instance.shiftEvent(arrConfig[3] == 1 ? true : false);
			}

		}

		public function showSelected():void
		{
			var item:Object;

			for (var i:int=1; i < 32; i++)
			{
				item=mc.getChildByName("check" + i);
				if (item != null)
					item.selected=arrConfig[i - 1] == 1 ? true : false;
			}
			back_scroll.init(sound1);
			game_scroll.init(sound2);
		}


		private static function twoTOten(arr:Array):uint
		{
			var res:int=0;
			for (var i:int=0; i < arr.length; i++)
			{
				res+=arr[i] * (Math.pow(2, i));
			}
			return res;
		}

		override public function getID():int
		{
			return 1025;
		}

//		private function switchGameMode():void{
//			this.mc["cbHightGame"].selected = !this.mc["cbHightGame"].selected;
//			if (this.mc["cbHightGame"].selected){
//				this.stage.frameRate = 60;
//			}else{
//				this.stage.frameRate = 30;
//			}
//		}

	}
}
