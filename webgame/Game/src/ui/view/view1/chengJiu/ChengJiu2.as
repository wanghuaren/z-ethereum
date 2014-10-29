package ui.view.view1.chengJiu
{
	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_AchievementResModel;
	import common.managers.Lang;
	import common.utils.component.ButtonGroup;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import netc.packets2.StructActRecList2;
	
	import nets.packets.PacketSCArChange;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.base.mainStage.UI_index;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.view.view7.UI_Exclamation;
	
	import world.FileManager;

	/**
	 *@author suhang
	 *@version 2011-10
	 * 成就面板
	 */
	public class ChengJiu2 extends UIWindow
	{
		//左边一列的按钮组
		private var bg:ButtonGroup;
		//总点数
		public static var point:int;
		//玩家的成就数据
		private static var _arList:Vector.<Vector.<StructActRecList2>>;

		public static function get arList():Vector.<Vector.<StructActRecList2>>
		{
			if (null == _arList)
			{
				_arList=new Vector.<Vector.<StructActRecList2>>();
			}

			if (_arList.length == 0)
			{
				_arList.push(new Vector.<StructActRecList2>, new Vector.<StructActRecList2>, new Vector.<StructActRecList2>, new Vector.<StructActRecList2>, new Vector.<StructActRecList2>, new Vector.<StructActRecList2>);
			}

			return _arList;
		}

		public static function get arListName():Array
		{
			return [Lang.getLabelArr("arrChengjiu2")[1], Lang.getLabelArr("arrChengjiu2")[2], Lang.getLabelArr("arrChengjiu2")[3], Lang.getLabelArr("arrChengjiu2")[4], Lang.getLabelArr("arrChengjiu2")[5]];
			//return ["玄仙宝典", "炼器大师", "绝世高手", "富可敌国", "江湖义气"];

		}

		private var sprite:Sprite=new Sprite;

		private static var arChangePanel:MovieClip;

		//成就基本数据
		private static var playVec:Vector.<Pub_AchievementResModel>=new Vector.<Pub_AchievementResModel>;

		public static function countUndone(selectSortIndex:int=-1):Array
		{
			var undoneList:Array=[];
			var k:int;
			var j:int;
			var arListLen:int=arList.length;

			//强设为5，最后一个不计入
			arListLen=5;

			for (k=0; k < arListLen; k++)
			{
				//---------------------------------------------------------------
				for (j=0; j < arList[k].length; j++)
				{
					if (selectSortIndex == j || selectSortIndex == -1)
					{
						if (!arList[k][j].ar_completeByChengJiu)
						{
							//doned++;
							undoneList.push(arList[k][j].arid);
						}
					}

				}
					//---------------------------------------------------------------	

			}

			//无进度时，随机抽取成就显示
			arListLen=arList.length;

			//强设为5，最后一个不计入
			arListLen=5;

			for (k=0; k < arListLen; k++)
			{
				//---------------------------------------------------------------
				for (j=0; j < arList[k].length; j++)
				{
					if (selectSortIndex == j || selectSortIndex == -1)
					{
						//if(!arList[k][j].ar_completeByChengJiu)
						//{
						//doned++;
						undoneList.push(arList[k][j].arid);
							//}							
					}

				}
					//---------------------------------------------------------------	

			}

			return undoneList;

		}

		public static function countComplete(selectSortIndex:int=-1):int
		{
			var total:int=0;
			var doned:int=0;


			var arListLen:int=arList.length;

			//强设为5，最后一个不计入
			arListLen=5;

			for (var k:int=0; k < arListLen; k++)
			{

				//---------------------------------------------------------------
				if (selectSortIndex == k || selectSortIndex == -1)
				{
					//total += arList[k].length;
					var parmVec:Vector.<Pub_AchievementResModel>=XmlManager.localres.AchievementXml.getResPath_BySort(k + 2) as Vector.<Pub_AchievementResModel>;
					total+=parmVec.length;

					for (var j:int=0; j < arList[k].length; j++)
					{

						if (arList[k][j].ar_completeByChengJiu)
						{
							doned++;
						}


					}

				}
					//---------------------------------------------------------------	

			}

			var per:Number=Math.round(doned / total * 100);

			if (per < 1 && per > 0)
			{
				per=1;
			}

			if (per > 100)
			{
				per=100;
			}

			return per;
		}

		public static function isComplete(ar_id:int):Boolean
		{

			var arListLen:int=arList.length;

			//不需强设为5
			for (var k:int=0; k < arListLen; k++)
			{
				//
				for (var j:int=0; j < arList[k].length; j++)
				{

					if (arList[k][j].arid == ar_id && arList[k][j].ar_completeByChengJiu)
					{
						return true;
					}
				}
			}

			return false;
		}

		public function ChengJiu2()
		{
			super(getLink("win_chengjiu"));
		}

		private static var _instance:ChengJiu2=null;

		public static function get instance():ChengJiu2
		{
			if (null == _instance)
			{
				_instance=new ChengJiu2();
			}
			return _instance;
		}

		override protected function init():void
		{

			bg=new ButtonGroup([mc["groupBtn1"], mc["groupBtn2"], mc["groupBtn3"], mc["groupBtn4"], mc["groupBtn5"], mc["groupBtn6"]], 6);
			sysAddEvent(bg, DispatchEvent.EVENT_DOWN_HANDER, downHander);

			//
			//uiRegister(PacketSCArList.id, roleArList);

			//
			mc["point"].text=point + "";

			this.y=(GameIni.MAP_SIZE_H - 420) / 2;

			//
			getArList();

		}

		//获取成就数据
		private function getArList():void
		{
			//setTimeout(function():void{
			if (!isOpen)
				return;

			if (bg.selectedIndex == 5)
			{
				mc["countMC"].visible=true;
				mc["list"].visible=false;

				showCount();

			}
			else
			{
				showList();
			}
			//},100);
		}

		//已完成每日必做列表返回
		private function roleArList(p:IPacket):void
		{
		/*var value:PacketSCArList=p as PacketSCArList;
		if ((bg.selectedIndex + 2) != value.sort)
			return;
		arList[value.sort - 2]=value.arrItemactlist;
		if (value.ar_point != -1)
		{
			point=value.ar_point;
			mc["point"].text=point + "";
		}
		showList();*/
		}



		private function showCount():void
		{

			var totalPer:int=countComplete()
			mc["countMC"]["itemTotal"]["txtDTPercent"].text=totalPer.toString() + "%";

			mc["countMC"]["itemTotal"]["jinduTotalBar"].gotoAndStop(totalPer + 1);

			var k:int;
			for (k=1; k < 6; k++)
			{
				mc["countMC"]["item" + k.toString()]["txtChengJiuName"].text=arListName[k - 1];

				var per:int=countComplete(k - 1);

				mc["countMC"]["item" + k.toString()]["txtDTPercent"].text=per.toString() + "%";

				mc["countMC"]["item" + k.toString()]["jinduBar"].gotoAndStop(per + 1);
			}


			//搜出未完成的，然后随机选4个
			//itemUndone1

			for (k=1; k < 5; k++)
			{
				mc["countMC"]["itemUndone" + k.toString()].visible=false;
				mc["countMC"]["itemUndone" + k.toString()]["pic"].unload();
			}

			var undoneList:Array=countUndone();

			for (k=1; k < 5; k++)
			{
				if (undoneList.length > 0)
				{
					var r_index:Number=Math.random() * undoneList.length;
					var r_i:int=Math.floor(r_index);
					var ar_id:int=undoneList.splice(r_i, 1);

					mc["countMC"]["itemUndone" + k.toString()].visible=true;

					var m:Pub_AchievementResModel=XmlManager.localres.AchievementXml.getResPath(ar_id) as Pub_AchievementResModel;
					if (m != null)
					{
//						mc["countMC"]["itemUndone" + k.toString()]["pic"].source=FileManager.instance.getChengJiuIconById(m.achievement_icon);
						ImageUtils.replaceImage(mc["countMC"]["itemUndone" + k.toString()],mc["countMC"]["itemUndone" + k.toString()]["pic"],FileManager.instance.getChengJiuIconById(m.achievement_icon));
						mc["countMC"]["itemUndone" + k.toString()]["txtPic"].text=m.ar_desc;

						//增加Tip
						Lang.addTip(mc["countMC"]["itemUndone" + k.toString()], "pub_param", 130);
						mc["countMC"]["itemUndone" + k.toString()].tipParam=[getUndoneTip(m)]; //this._getJingJieTip(i)
					}
				}

			}


		}

		public function getUndoneTip(m:Pub_AchievementResModel):String
		{
			/*成就名称：万夫之勇
			成就奖励：50点声望、20点成就
			获得途径：每日活动中BOSS伤害排名
			位于前5名2次。 */

			return "成就名称：" + m.ar_desc + "\n" + "成就奖励：" + m.reward + "\n" + "获得途径：" + m.target_desc;


		}


		private function showList():void
		{
			mc["countMC"].visible=false;
			mc["list"].visible=true;

			while (sprite.numChildren > 0)
			{
				sprite.removeChildAt(0);
			}

			mc["point"].text=point.toString();

			var parmVec:Vector.<Pub_AchievementResModel>=XmlManager.localres.AchievementXml.getResPath_BySort(bg.selectedIndex + 2) as Vector.<Pub_AchievementResModel>;

			i=0;

			parmVec.forEach(callback);

			mc["list"].source=sprite;
			mc["list"].position=0;
		}

		private function callback(parm:Pub_AchievementResModel, index:int, arr:Vector.<Pub_AchievementResModel>):void
		{
			if (parm.is_load == 0)
				return;

			var itemDO:DisplayObject=ItemManager.instance().getChengJiuItem(parm.ar_id);
			var count:int=0;
			for each (var sarl:StructActRecList2 in arList[bg.selectedIndex])
			{
				if (sarl.arid == parm.ar_id)
				{
					count=sarl.count;
					break;
				}
			}
//			var limit:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(parm.limit_id);
			if (count >= parm.max_count)
			{
				(itemDO as MovieClip).gotoAndStop(2);
				count=parm.max_count;
			}
			if (parm.is_load_plan == 0)
			{
				itemDO["jindu"].visible=false;
				itemDO["bili"].text="";
			}
			else
			{
				itemDO["jindu"]["zhezhao"].scaleX=count / parm.max_count;
				itemDO["bili"].text=count + "/" + parm.max_count;
			}
			itemDO["mingcheng"].text=parm.ar_desc;
			itemDO["jiangli"].htmlText=Lang.getLabel("20070_chengjiu") + parm.reward;
			itemDO["miaoshu"].htmlText=parm.target_desc;
			itemDO["point"].text=parm.achievement_value;
//			itemDO["uil"].source=FileManager.instance.getChengJiuIconById(parm.achievement_icon);
			ImageUtils.replaceImage(itemDO as DisplayObjectContainer,itemDO["uil"],FileManager.instance.getChengJiuIconById(parm.achievement_icon));
			itemDO.y=i * itemDO.height;
			sprite.addChild(itemDO);
			i++
		}

//		public static function arUpdate(p:IPacket):void
//		{
//			var value:PacketSCArList=p as PacketSCArList;
//
//		}

		private function downHander(e:DispatchEvent):void
		{
			switch (e.getInfo.name)
			{
				case "groupBtn1":

					break;
				case "groupBtn2":

					break;
				case "groupBtn3":

					break;
				case "groupBtn4":

					break;
				case "groupBtn5":

					break;
			}
			while (sprite.numChildren > 0)
			{
				sprite.removeChildAt(0);
			}
			getArList();
		}

		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "":

					break;
			}
		}

		//主界面新获得成就提示框
		//成就变化
//		public static function SCArChange(p:IPacket):void
//		{
//			var value:PacketSCArChange=p as PacketSCArChange;
//			var hasValue:Boolean=false;
//			var hasValueIndex:int=0;
//
//			var len:int=arList.length;

			//此处更新数据，不用强设为5

//			for (var i:int=0; i < len; i++)
//			{
//				if (arList[i] != null)
//				{
//					for (var j:int=0; j < arList[i].length; j++)
//					{
//						if (arList[i][j].arid == value.ar_id)
//						{
//							arList[i][j].count=value.cur_num;
//							arList[i][j].change_type=value.change_type;
//							hasValue=true;
//							hasValueIndex=i;
//							break;
//						}
//					}
//				}
//			}

			//
//			if (7 == value.sort)
//			{
//				hasValueIndex=5;
//			}
//
//			if (9 == value.sort)
//			{
//				hasValueIndex=7;
//			}
//
//			if (10 == value.sort)
//			{
//				hasValueIndex=8;
//			}


//			var parm:Pub_AchievementResModel=XmlManager.localres.AchievementXml.getResPath(value.ar_id) as Pub_AchievementResModel;

		
		

//				playArCompelete();
//			}
//		}

		//完成新成就
//		private static function playArCompelete():void
//		{
//			if (arChangePanel == null)
//			{
//				arChangePanel=GamelibS.getswflink("game_index", "chengjiu_tishi") as MovieClip;
//			}
//			if (arChangePanel != null && arChangePanel.parent == null && playVec.length > 0)
//			{
//				var parm:Pub_AchievementResModel=playVec.shift();
//
//				if (parm.is_load_plan == 0)
//				{
//					arChangePanel["jindu"].visible=false;
//					arChangePanel["bili"].text="";
//				}
//				else
//				{
//					arChangePanel["jindu"].visible=true;
//					arChangePanel["jindu"]["zhezhao"].scaleX=1;
//					arChangePanel["bili"].text=parm.max_count + "/" + parm.max_count;
//				}
//				arChangePanel.x=(GameIni.MAP_SIZE_W - 575) / 2;
//				arChangePanel.y=GameIni.MAP_SIZE_H - 240;
//				arChangePanel["mingcheng"].text=parm.ar_desc;
//				arChangePanel["jiangli"].htmlText=Lang.getLabel("20070_chengjiu") + parm.reward;
//				arChangePanel["miaoshu"].htmlText=parm.target_desc;
//				arChangePanel["point"].text=parm.achievement_value;
//				arChangePanel["icon"].source=FileManager.instance.getChengJiuIconById(parm.achievement_icon);
//
//				//UI_index.indexMC.addChild(arChangePanel);
//				UI_Exclamation.instance.mc.addChild(arChangePanel);
//
//				arChangePanel.gotoAndPlay(1);
//				arChangePanel.addFrameScript(arChangePanel.endframe, deleteWin);
//
//				arChangePanel.mouseEnabled=true;
//				arChangePanel.mouseChildren=false;
//				arChangePanel.arType=parm.sort;
//				arChangePanel.addEventListener(MouseEvent.CLICK, clickAr);
//
//				GameMusic.playWave(WaveURL.ui_get_cheng_jiu);
//			}
//		}
//
//		private static function clickAr(e:MouseEvent):void
//		{
//			try
//			{
//				ChengJiu2.instance.open(true);
//				ChengJiu2.instance.bg.outDownHander(ChengJiu2.instance.mc["groupBtn" + (int(arChangePanel.arType) - 1)], false);
//			}
//			catch (e:Error)
//			{
//			}
//		}
//
//		private static function deleteWin():void
//		{
//			if (arChangePanel.parent != null)
//			{
//				TweenLite.to(arChangePanel, 2, {alpha: 0, delay: 3, onComplete: onComplete});
//			}
//		}
//
//		private static function onComplete():void
//		{
//			TweenLite.killTweensOf(arChangePanel, true);
//			arChangePanel.alpha=1;
//			arChangePanel.removeEventListener(MouseEvent.CLICK, clickAr);
//			if (arChangePanel.parent != null)
//				arChangePanel.parent.removeChild(arChangePanel);
//			playArCompelete();
//		}

		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();
		}

		override public function getID():int
		{
			return 1008;
		}

	}
}
