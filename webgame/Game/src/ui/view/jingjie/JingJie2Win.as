/**
 * Copyright the company of XiHe, all rights reserved.
 */
package ui.view.jingjie
{
	import com.greensock.TweenLite;

	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Bourn_StarResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;

	import display.components.CheckBoxStyle1;

	import engine.load.GamelibS;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;

	import model.jingjie.JingjieController;
	import model.jingjie.JingjieModel;

	import netc.Data;
	import netc.packets2.StructBagCell2;

	import scene.action.BodyAction;

	import ui.frame.UIWindow;
	import ui.base.npc.NpcShop;

	/**
	 * @author liuaobo
	 * @create date 2013-8-13
	 */
	public class JingJie2Win extends UIWindow
	{
		private static var _instance:JingJie2Win=null;
		/**
		 * 区域对应索引编号，方便获取对应的境界数据
		 */
		private static const AREAS:Object={mc_qingLong: 0, mc_baiHu: 1, mc_zhuQue: 2, mc_xuanWu: 3};
		// 境界丹药兑换商店编号
		private static const JING_JI_DAN_YAO_SHOP_ID:int=70200001;
		public static var IsLevelUp:Boolean=false;
		private var dataList:Array=null;
		private var index:int=-1;
		/**
		 * 由境界强化等级上限-》境界球强化等级上限
		 */
		private var indexChanged:Boolean=false;
		private var focusIndex:int=0;
		private var jingjieStarList:Array=null;
		//星星强化等级上限
		private var starLimit:int=0;
		private var ballEnabledArr:Array=[];
		private var ballStarLimitArr:Array=[];

		public function JingJie2Win()
		{
			super(getLink("win_jing_jie"));
		}

		public static function getInstance():JingJie2Win
		{
			if (_instance == null)
			{
				_instance=new JingJie2Win();
			}
			return _instance;
		}

		/**
		 * UI唯一标识
		 * @return id
		 *
		 */
		override public function getID():int
		{
			return 1006;
		}

		/**
		 * 初始化UI控件
		 *
		 */
		override protected function init():void
		{
			//禁用容器子控件鼠标响应事件
//			this.mc["mc_qingLong"].mouseChildren = false;
//			this.mc["mc_baiHu"].mouseChildren = false;
//			this.mc["mc_xuanWu"].mouseChildren = false;
//			this.mc["mc_zhuQue"].mouseChildren = false;
			this.mc["mcTip"].visible=true;
			//每次开启窗口的时候强制设置默认的当前玩家
			JingjieModel.getInstance().setIndex(0);
			//新手引导  UI 
			MovieClip(this.mc["mcJJSelecter"]).mouseEnabled=MovieClip(this.mc["mcJJSelecter"]).mouseChildren=false;
		}

		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			if (JingjieModel.getInstance().hasOwnProperty(name + "Enabled"))
			{
				var canOpen:Boolean=JingjieModel.getInstance()[name + "Enabled"];
				var areaIndex:int=AREAS[name];
				if (canOpen)
				{
					MovieClip(this.mc["back"]).gotoAndStop(areaIndex + 1);
					MovieClip(this.mc["mcJJSelecter"]).gotoAndStop(areaIndex + 1);
				}
				return;
			}
			if (name.indexOf("_b") != -1 && name.length == 3)
			{
				var tempFocusIndex:int=int(name.charAt(name.length - 1)) - 1; //点击的节点位置
				if (this.ballEnabledArr[tempFocusIndex])
				{
					if (tempFocusIndex != focusIndex)
						this.indexChanged=true;
					focusIndex=tempFocusIndex;
					mc["mcTip"].visible=true;
					this.updateJingJieStar();
				}
				return;
			}
			switch (name)
			{
				case "btnAuto":
					this.levelUp();
					break;
				case "cbShopBuy":
					var cbShopBuy:CheckBoxStyle1=this.mc["mcTip"]["cbShopBuy"];
					cbShopBuy.selected=!cbShopBuy.selected;
					break;
				case "btn_zlzpd": // 如何获得丹药的按钮
//					mc["mc_zlzpd"].visible=!mc["mc_zlzpd"].visible;
//					LianDanLuWin.getInstance().setType(3);
					break;
				case "btn_zlzpd_close":
					mc["mc_zlzpd"].visible=false;
					break;
				case "btn_buy_from_shop":
					NpcShop.instance().setshopId(JING_JI_DAN_YAO_SHOP_ID);
					break;
				case "btn_buy_and_eat":
					//直接购买丹药
					break;
				case "btnClose1":
					mc["mcTip"].visible=false;
					break;
				case "btnClose2":
					mc["mcTotalAttrPane"].visible=false;
					break;
				case "mcTotalAttr":
					mc["mcTotalAttrPane"].visible=true;
					break;
				default:
					break;
			}
		}

		/**
		 * UI控件重新定位
		 */
		private function reposition():void
		{
			if (mc != null && mc.parent != null && mc.stage != null)
			{
				var p:Point=new Point();
				p.x=((mc.stage.stageWidth - width) >> 1);
				p.y=(mc.stage.stageHeight - width) >> 1;
				p=mc.parent.globalToLocal(p);
				mc.x=p.x;
				mc.y=p.y;
			}
		}

		/**
		 * 客户端窗口大小发生变化后重新定位
		 * @param e
		 *
		 */
		private function onResizeHandler(e:Event):void
		{
			this.reposition();
		}

		override public function winClose():void
		{
			super.winClose();
//			if (stage){
//				stage.removeEventListener(Event.RESIZE,onResizeHandler);
//			}
		}

		private function updateJingJieAreaBgState():void
		{
			(this.mc["mc_qingLong"] as MovieClip).gotoAndStop(2);
			var targetFrame:int=1;
			targetFrame=JingjieModel.getInstance().mc_baiHuEnabled ? 2 : 1;
			(this.mc["mc_baiHu"] as MovieClip).gotoAndStop(targetFrame);
			targetFrame=JingjieModel.getInstance().mc_zhuQueEnabled ? 2 : 1;
			(this.mc["mc_zhuQue"] as MovieClip).gotoAndStop(targetFrame);
			targetFrame=JingjieModel.getInstance().mc_xuanWuEnabled ? 2 : 1;
			(this.mc["mc_xuanWu"] as MovieClip).gotoAndStop(targetFrame);
		}

		private function updateJingJieBallState():void
		{
			var instance:JingjieModel=JingjieModel.getInstance();
			var index:int=0;
//			var areas:Array = [area_qingLong,area_baiHu,area_zhuQue,area_xuanWu];
			var mcs:Array=["mc_qingLong", "mc_baiHu", "mc_zhuQue", "mc_xuanWu"];
//			var a:JingJieArea = null;
			while (index < 4)
			{
//				a = (areas[index] as JingJieArea);
//				a.open(instance.getJingJieArea(index));
				this.mc[mcs[index]]["tipParam"]=[JingjieModel.getInstance()[mcs[index] + "Tip"]];
				Lang.addTip(this.mc[mcs[index]], "pub_param", 150);
				index++;
			}
		}

		/**
		 * 更新境界满星状态
		 */
		private function checkJingJieFull():void
		{
			var f0:Boolean=JingjieModel.getInstance().isLevelUpFull(0, starLimit);
			var f1:Boolean=JingjieModel.getInstance().isLevelUpFull(1, starLimit);
			var f2:Boolean=JingjieModel.getInstance().isLevelUpFull(2, starLimit);
			var f3:Boolean=JingjieModel.getInstance().isLevelUpFull(3, starLimit);
			if (f0)
				(this.mc["mc_qingLong"] as MovieClip).gotoAndStop(3);
			if (f1)
				(this.mc["mc_baiHu"] as MovieClip).gotoAndStop(3);
			if (f2)
				(this.mc["mc_zhuQue"] as MovieClip).gotoAndStop(3);
			if (f3)
				(this.mc["mc_xuanWu"] as MovieClip).gotoAndStop(3);
		}

		private function clearJingJieStar():void
		{
			if (jingjieStarList)
			{
				for each (var ms:MovieClip in jingjieStarList)
				{
					if (ms.parent)
					{
						ms.parent.removeChild(ms);
					}
				}
				jingjieStarList=null;
			}
		}

		/**
		 * 更新境界强化等级对应的星星数量
		 *
		 */
		public function updateJingJieStar():void
		{
			if (indexChanged)
			{
				this.clearJingJieStar();
			}
			var starIndex:int=0;
			var mcStar:MovieClip=null;
			if (jingjieStarList == null)
			{
				jingjieStarList=[];
				//最大星星数量
				starLimit=1; //XmlManager.localres.Bourn_StarXml.getResPath(this.index*JingjieModel.LIMIT+focusIndex+1).max_level;
				this.ballStarLimitArr[focusIndex]=starLimit;
				//				starLimit = JingjieModel.getInstance().jingJieStarLevelLimit;
				var tempPos:int=index * JingjieModel.LIMIT + focusIndex + 1;
				var tempLevel:int=JingjieModel.getInstance().getJingJieBall(index, focusIndex);
				if (tempLevel == 0)
					tempLevel=1;
//				var tempB:Pub_BournResModel = XmlManager.localres.getPubBournXml.getBournByPosAndLevel(tempPos,tempLevel);
//				starLimit = tempB.maxlevel;
				var clazz:Class=GamelibS.getswflinkClass("game_index", "JingJieStar");
				var totalWidth:int;
				var starX:int;
				var starY:int=326;
//				starX = 12;
				while (starIndex < starLimit)
				{
					mcStar=new clazz();
					if (starIndex == 0)
					{
						totalWidth=mcStar.width * starLimit;
						starX=(this.mc["mcTip"].width - totalWidth) >> 1;
					}
					//newcodes
//					starX = 12;
					starY=52 - 20;
					mcStar.x=starX + mcStar.width * starIndex;
					mcStar.y=starY;
					jingjieStarList[starIndex]=mcStar;
					mcStar.mouseChildren=mcStar.mouseEnabled=false;
					this.mc["mcTip"].addChild(mcStar);
					starIndex++;
				}
			}
			starIndex=0;
			//当前强化的星级
			var starLevel:int=JingjieModel.getInstance().getJingJieBall(index, focusIndex);
			while (starIndex < starLevel)
			{
				mcStar=this.jingjieStarList[starIndex];
				mcStar.gotoAndStop(2);
				starIndex++;
			}
//			this.addChildAt(mc,0);
		}

		/**
		 * 更新境界球开启提示
		 *
		 */
		private function updateBallTips():void
		{
			var b_star:Pub_Bourn_StarResModel;
			var i:int=0;
			var size:int=JingjieModel.LIMIT;
			while (i < size)
			{
				var pos:int=this.index * JingjieModel.LIMIT + i + 1;
				b_star=XmlManager.localres.Bourn_StarXml.getResPath(pos) as Pub_Bourn_StarResModel;
				var ballName:String=b_star.star_name;
				//newcodes need changed
//				this.mc["back"]["tb"+(i+1)].htmlText = ballName;
				if (this.ballEnabledArr[i])
				{
					//this.mc["back"]["_b"+(i+1)]["tipParam"] = [b_star.open_tips];
					Lang.addTip(this.mc["back"]["_b" + (i + 1)], "pub_param"); //开启提示
				}
				else
				{
					//this.mc["back"]["_b"+(i+1)]["tipParam"] = [b_star.close_tips];
					Lang.addTip(this.mc["back"]["_b" + (i + 1)], "pub_param"); //未开启提示
				}
				i++;
			}
			pos=this.index * JingjieModel.LIMIT + focusIndex + 1;
			b_star=XmlManager.localres.Bourn_StarXml.getResPath(pos) as Pub_Bourn_StarResModel;
			//this.mc["mcTip"]["txt_cailiao1_desc"].text = b_star.item_effect_desc;
//			this.mc["mcTip"]["txt_cailiao_level1"].text = b_star.item_desc;
			//			if (b_star.other_desc.length>0){
			//				this.mc["txtExtraAttr"].htmlText = b_star.other_desc;
			//			}
		}
		private var pillId:int;

		private function moveTipTo(mcBall:MovieClip):void
		{
			var p:Point=new Point();
			p.x=mcBall.x;
			p.y=mcBall.y;
			p=mcBall.parent.localToGlobal(p);
			p=mc.globalToLocal(p);
			p.x+=100;
			p.y-=10
			var onComplete:Function=function():void
			{
				TweenLite.killTweensOf(mc["mcTip"], true);
			};
			TweenLite.to(this.mc["mcTip"], 0.5, {x: p.x, y: p.y, onComplete: onComplete});
		}

		private function levelUp():void
		{
			var _cell:StructBagCell2=Data.beiBao.getJingJieItemByMinLevel(this.pillId);
			var cbShopBuy:CheckBoxStyle1=this.mc["mcTip"]["cbShopBuy"];
			var currPos:int=this.index * JingjieModel.LIMIT + focusIndex + 1;
			if (cbShopBuy.selected == false || cbShopBuy.visible == false)
			{
				if (_cell == null)
				{
					_cell=Data.beiBao.getJingJieItemCanUse(this.pillId);
					if (_cell == null)
					{
						Lang.showMsg(Lang.getClientMsg("20074_meterial_not_enough"));
						//						JingjieController.getInstance().requestCSEatPill(this.pillId,currPos,false);
						return;
					}
					var _pillConfig:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(_cell.itemid) as Pub_ToolsResModel;
					//是否消耗XX品丹药提升境界
					alert.setModal(true);
					alert.ShowMsg(Lang.getLabel("20308_JingJie_EatPill"), 4, null, callbackBuyAndEatPill, _pillConfig);
				}
				else
				{
					JingjieController.getInstance().requestCSEatPill(this.pillId, currPos, false);
				}
			}
			else
			{
				JingjieController.getInstance().requestCSEatPill(this.pillId, currPos, true);
			}
		}

		private function callbackBuyAndEatPill(_pillConfig:Pub_ToolsResModel):void
		{
			var currPos:int=this.index * JingjieModel.LIMIT + focusIndex + 1;
			JingjieController.getInstance().requestCSEatPill(_pillConfig.tool_id, currPos, false);
		}

		public function levelupBallByPos(pos:int):void
		{
			var index:int=(pos - 1) / JingjieModel.LIMIT;
			//设置对应境界里每一个境界球的强化星级
			var i:int=0;
			if (pos % JingjieModel.LIMIT == 0)
			{
				i=JingjieModel.LIMIT;
			}
			else
			{
				i=pos % JingjieModel.LIMIT;
			}
			var tempMC:MovieClip=this.mc["back"]["_b" + i];
			if (IsLevelUp)
			{
				IsLevelUp=false;
				tempMC["mcLevelUpEffect"].gotoAndPlay(2);
				var currFrame:int=MovieClip(tempMC["mcBall"]).currentFrame;
				var starLevel:int=JingjieModel.getInstance().jingJieOrigList[pos];
				if (starLevel == 1 || starLevel == 7 || starLevel == 10)
				{
					BodyAction.EarthShake();
				}
				if (starLevel == 10 && i == JingjieModel.LIMIT)
				{
					if (this.index < 3)
					{
						var btns:Array=["mc_qingLong", "mc_baiHu", "mc_zhuQue", "mc_xuanWu"];
						setTimeout(this.mcHandler, 500, {name: btns[index + 1]});
					}
				}
			}
		}

		override public function get width():Number
		{
			return 856;
		}

		override public function get height():Number
		{
			return 540;
		}
	}
}
