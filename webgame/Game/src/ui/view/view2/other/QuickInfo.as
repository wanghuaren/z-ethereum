package ui.view.view2.other
{
	import com.greensock.TweenLite;
	
	import common.config.PubData;
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	import common.utils.res.ResCtrl;
	
	import engine.event.DispatchEvent;
	import engine.load.Gamelib;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import netc.Data;
	import netc.dataset.BeiBaoSet;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.StructBagCell2;
	
	import ui.base.mainStage.UI_index;
	import ui.view.newFunction.FunJudge;
	
	import world.WorldEvent;

	/**
	 *	即时消息【吃药，炼骨，伙伴，战魂】
	 *  @andy 2012-07-05
	 */
	public class QuickInfo
	{
		public static const LIAN_GU:int=1;
		public static const HUO_BAN:int=2;
		public static const CHI_YAO:int=3;
		public static const ZHAN_HUN:int=4;
		public static const CHONG_ZHU:int=5;
		public static const DOUBLE_EXP:int=7;
		public static const DOUBLE_EXP_ZERO:int=8;
		public static const XINGHUN_FUXING:int=9;
		/**特权推荐 */
		public static const TE_QUAN_TUI_JIAN:int=11;
		private var target:DisplayObject;
		private var tip:MovieClip;
		//描述文字
		private var arrWord:Array;
		//间隔时间
		private var timeCnt:int=0;
		//炼骨是否启动5分钟定时
		private var lianGuStart:Boolean=true;
		private var lianGuCnt:int=0;
		//特权推荐
		private var teQuanStart:Boolean=true;
		private var teQuanCnt:int=0;
		//吃药是否启动5分钟定时
		private var chiYaoStart:Boolean=false;
		private var chiYaoCnt:int=0;
		//伙伴招募 声望
		private var petId:int=0;
		//战魂 每次登陆只显示一次
		private var zhanHunStart:Boolean=false;
		//2012-09-01 每次登陆15分钟没有免费重铸
		private var chongZhuStart:Boolean=true;
		private var chongZhuCnt:int=0;
		private static var _instance:QuickInfo;

		public static function getInstance():QuickInfo
		{
			if (_instance == null)
				_instance=new QuickInfo();
			return _instance;
		}

		public function QuickInfo()
		{
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, coolTime);
			Data.myKing.addEventListener(MyCharacterSet.RENOWN_ADD, renownAdd);
		}

		/**
		 * 场景宽高改变，重新设置显示位置
		 * @param offSetX
		 * @param offSetY
		 */
		public function resize(offSetX:int=0, offSetY:int=0):void
		{
			if (null == tip)
			{
				return;
			}
			if (null == target)
			{
				return;
			}
			var localPoint:Point=new Point(target.x, target.y);
			var globalPoint:Point=target.parent.localToGlobal(localPoint);
			tip.x=globalPoint.x + offSetX;
			tip.y=globalPoint.y + offSetY;
			switch (tip.currentFrame)
			{
				case 1:
					tip.y=globalPoint.y + target.height;
					break;
				case 2:
					tip.y=globalPoint.y + target.height;
					break;
				case 3:
					break;
				case 4:
					break;
				default:
					break;
			}
		}

		/**
		 *	设置显示内容
		 */
		public function setType(type:int=1, param:Object=null):void
		{
			if (tip == null)
			{
				tip=Gamelib.getInstance().getswflink("game_index", "pop_quick_info") as MovieClip;
				if (tip == null)
					return;
				else
				{
					arrWord=Lang.getLabelArr("arrQuickInfo");
				}
			}
			target=null;
			switch (type)
			{
				case LIAN_GU: //神兵决/ 炼骨
					if (lianGuStart == true)
						return;
					target=UI_index.indexMC_mrb["mc_index_menu"]["btnLianGu"];
					if (target != null)
						setPostion(type, 4, null, target.width / 2);
					break;
				case HUO_BAN:
					target=UI_index.indexMC_mrb["btnZhaoMu"];
					if (target != null)
						setPostion(type, 4, param as Array, target.width / 2);
					break;
				case CHI_YAO:
					target=UI_index.indexMC_mrb["btnBeiBao"];
					if (chiYaoStart == true)
						return;
					chiYaoStart=true;
					setPostion(type, 3, param as Array);
					break;
				case ZHAN_HUN:
					target=UI_index.indexMC_character["jueshaji"];
					zhanHunStart=true;
					setPostion(type, 3);
					break;
				case CHONG_ZHU:
					target=UI_index.indexMC_mrb["btnLianDanLu"];
					setPostion(type, 3, param as Array);
					break;
				case DOUBLE_EXP:
					target=UI_index.indexMC_mrt["missionMain"]["shuangbei"];
					setPostion(type, 3, param as Array);
					break;
				case DOUBLE_EXP_ZERO:
					target=UI_index.indexMC_mrt["missionMain"]["shuangbei"];
					setPostion(type, 3, param as Array);
					break;
				default:
					break;
			}
		}

		/**
		 *	即时提示显示5秒
		 */
		private function showQuickTip():void
		{
			tip.alpha=0;
			TweenLite.to(tip, 8, {alpha: 1, delay: .2, onComplete: hiheQuickTip});
		}

		private function hiheQuickTip():void
		{
			TweenLite.to(tip, 1, {alpha: 0, delay: .6});
		}

		/**
		 *  设置方向，文字
		 *	方向 1.左下 2.右下 3.左上 4.右上
		 */
		private function setPostion(type:int, v:int=1, param:Array=null, offSetX:int=0, offSetY:int=0):void
		{
			if (target != null && target.visible && arrWord != null)
			{
				tip.gotoAndStop(v);
				if (arrWord.length > type)
				{
					tip["txt_ti_shi"].text=arrWord[type];
				}
				if (param != null)
					tip["txt_ti_shi"].text=Lang.replaceParam(arrWord[type], param);
				resize(offSetX, offSetY);
				PubData.mainUI.Layer5.addChild(tip);
				showQuickTip();
			}
		}

		/**
		 *	时间控制
		 */
		private function coolTime(we:WorldEvent):void
		{
			timeCnt++;
			if (timeCnt == 10)
			{
				//登录10秒检测
				Data.beiBao.dispatchEvent(new DispatchEvent(BeiBaoSet.BAG_UPDATE));
			}
			//吃药 可以炼骨时如果玩家5分钟之内不点击，则提示
			if (chiYaoStart)
			{
				chiYaoCnt++;
				if (chiYaoCnt >= 300)
				{
					retsetStartChiYao5();
				}
			}
			//重铸 每次登陆如果玩家15分钟之内不点击，则提示
			if (chongZhuStart)
			{
				chongZhuCnt++;
				if (chongZhuCnt >= 900)
				{
					showChongZhu();
				}
			}
			if (teQuanStart)
			{
				teQuanCnt++;
				if (teQuanCnt >= 60)
				{
//					showTeQuanTuiJian();
				}
			}
		}
		/************特殊应用************/
		private var _isRunnedDoubleExpZero:Boolean=false;

		public function runDoubleExpZero():void
		{
			if (_isRunnedDoubleExpZero)
			{
				return;
			}
			_isRunnedDoubleExpZero=true;
			setType(DOUBLE_EXP_ZERO);
		}

		/**
		 * 2012-11-12 andy 增加两个副本显示双倍经验
		 * 神兵峰     20100088
		 * 守护玄黄剑 20200005
		 */
//		private var fuBen:String="20100088,20200005";
		/**
		 *	只提示一次
		 */
//		private var mapFuBen:HashMap=new HashMap();
//		public function checkDoubleDoubleExp():void
//		{
//			var cur_map_id:int = SceneManager.instance.currentMapId;
//			
//			if(mapFuBen.containsKey(cur_map_id)){
//				return;
//			}
//			mapFuBen.put(cur_map_id,"ok");
//			
//			var map_list:Array = DiGongMap.MAP_LIST;
//			
//			var len:int = map_list.length;
//			
//			
//			
//		
//		}
		/**
		 *	招募伙伴【声望达到且没有招募过】
		 *
		 */
		public function renownAdd(e:DispatchEvent=null):void
		{
			if (Data.myKing.level < 30)
				return;
//			var pet:Pub_PetResModel=Data.huoBan.getRepMinPet();
//			if(pet!=null&&pet.pet_id!=petId){
//				petId=pet.pet_id;
//				setType(HUO_BAN,[pet.pet_name]);
//			}
		}

		/**
		 *	无药可吃【暂时】
		 */
		public function notYao():void
		{
			if (Data.myKing.level < 20)
				return;
			var bag:StructBagCell2=null;
			bag=Data.beiBao.getHPItemByMaxLevel();
			if (bag == null)
			{
				setType(CHI_YAO, [Lang.getLabel("10080_quickinfo")]);
				return;
			}
			bag=Data.beiBao.getMPItemByMaxLevel();
			if (bag == null)
			{
				setType(CHI_YAO, [Lang.getLabel("10081_quickinfo")]);
				return;
			}
			bag=Data.beiBao.getPetHpItemByMaxLevel();
			if (bag == null)
			{
				setType(CHI_YAO, [Lang.getLabel("10082_quickinfo")]);
				return;
			}
		}

		/**
		 *	吃药提示检测启动 5分钟时间到了可以提示，
		 *
		 */
		public function retsetStartChiYao5():void
		{
			this.chiYaoCnt=0;
			this.chiYaoStart=false;
		}

		/**
		 *	战魂
		 */
		public function showZhanHun():void
		{
			if (zhanHunStart == false)
			{
				setType(ZHAN_HUN);
			}
		}

		/**
		 *	vip特权推荐
		 */
		public function showTeQuanTuiJian():void
		{
			teQuanCnt=0;
			teQuanStart=false;
			setType(TE_QUAN_TUI_JIAN);
		}

		/**
		 *	重铸
		 *  2012-09-01
		 */
		public function showChongZhu():void
		{
			chongZhuStart=false;
			chongZhuCnt=0;
			if (FunJudge.judgeByName(FunJudge.JIANDING, false) == false)
				return;
			var freeTimes:int=ResCtrl.instance().getFreeTimes();
			if (freeTimes > 0)
				setType(CHONG_ZHU, [freeTimes]);
		}
	}
}
