/**
 * Copyright the company of XiHe, all rights reserved.
 */
package ui.view.jingjie
{
	import common.config.Att;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_BournResModel;
	import common.config.xmlres.server.Pub_Bourn_StarResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	
	import display.components.CheckBoxStyle1;
	
	import engine.load.GamelibS;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import model.jingjie.JingjieController;
	import model.jingjie.JingjieModel;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import ui.base.npc.NpcShop;
	import ui.frame.ImageUtils;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.view.liandanlu.LianDanLuWin;
	
	import world.FileManager;
	
	/**
	 * 境界升级UI窗口
	 * @author liuaobo
	 * @create date 2013-5-15
	 */
	public class JingJieLevelUpWin extends UIWindow
	{
		private static var _instance:JingJieLevelUpWin = null;
		// 境界丹药兑换商店编号
		private static const JING_JI_DAN_YAO_SHOP_ID:int = 70200001;
		
		private var dataList:Array = null;
		private var index:int = -1;
		/**
		 * 由境界强化等级上限-》境界球强化等级上限 
		 */
		private var indexChanged:Boolean = false;
		private var focusIndex:int = 0;
		private var jingjieStarList:Array = null;
		//星星强化等级上限
		private var starLimit:int = 0;
		private var ballEnabledArr:Array = [];
		private var ballStarLimitArr:Array = [];
		
		
		public function JingJieLevelUpWin()
		{
			super(getLink("win_jing_jie_ti_sheng"));
		}
		
		public static function getInstance():JingJieLevelUpWin{
			UIMovieClip.currentObjName = null;
			if (_instance==null){
				_instance = new JingJieLevelUpWin();
			}
			return _instance;
		}
		
		override protected function init():void{
			mc["mc_zlzpd"].visible = false;
			var tempMC:MovieClip;
			var size:int = JingjieModel.LIMIT;
			var i:int = 0;
			while (i<size){
				tempMC = this.mc["_b"+(i+1)];
				tempMC.mouseChildren = false;
				tempMC["mcSelector"].visible = false;
				i++;
			}
		}
		
		override public function open(must:Boolean=false, type:Boolean=true):void{
			super.open(must,type);
		}
		
		override public function mcHandler(target:Object):void{
			var name:String=target.name;
			if (name.indexOf("_b")!=-1 && name.length==3){
				var tempFocusIndex:int = int(name.charAt(name.length-1))-1;//点击的节点位置
				if (this.ballEnabledArr[tempFocusIndex]){
					if (tempFocusIndex!=focusIndex) this.indexChanged = true;
					focusIndex = tempFocusIndex;
					this.updateBallAttr();
					this.updateJingJieStar();
				}
				return;
			}
			switch (name){
				case "btnAuto":
					this.levelUp();
					break;
				case "cbShopBuy":
					var cbShopBuy:CheckBoxStyle1 = this.mc["cbShopBuy"];
					cbShopBuy.selected = !cbShopBuy.selected;
					break;
				case "btn_zlzpd":   // 如何获得丹药的按钮
					mc["mc_zlzpd"].visible=!mc["mc_zlzpd"].visible;
					break;
				case "btn_zlzpd_close":
					mc["mc_zlzpd"].visible= false;
					break;
				case "btn_buy_from_shop":
					NpcShop.instance().setshopId(JING_JI_DAN_YAO_SHOP_ID);
					break;
				case "btn_go_lian_dan":
					LianDanLuWin.getInstance().setType(3);
					break;
				case "btn_buy_and_eat":
					//直接购买丹药
					break;
				default:
					break;
			}
		}
		
		/**
		 * UI控件重新定位 
		 */
		private function reposition():void{
			if (mc!=null && mc.parent!=null&&mc.stage!=null){
				var p:Point = new Point();
				p.x = ((mc.stage.stageWidth - mc.width)>>1)-15;
				p.y = (mc.stage.stageHeight - mc.height)>>1;
				
				p = mc.parent.globalToLocal(p);
				mc.x = p.x;
				mc.y = p.y;
			}
		}
		
		/**
		 * 客户端窗口大小发生变化后重新定位 
		 * @param e
		 * 
		 */
		private function onResizeHandler(e:Event):void{
			this.reposition();
		}
		
		override public function winClose():void{
			super.winClose();
			if (stage){
				stage.removeEventListener(Event.RESIZE,onResizeHandler);
			}
		}
		
		/**
		 * 更新数据
		 * @param value index 
		 * 
		 */
		public function update(value:int=-1):void{
			var needUpdateTips:Boolean= false;
			if (value==-1){
				//只更新当前数据
			}else{
				if (this.index!=value) {
					needUpdateTips = true;
				}
				
				this.index = value;
			}
			
			dataList = JingjieModel.getInstance().getJingJieArea(index);
			this.updateBallState();
			this.updateJingJieStar();
			this.updateJingJieAttr(needUpdateTips);
		}
		
		private function clearJingJieStar():void{
			if (jingjieStarList){
				for each (var ms:MovieClip in jingjieStarList){
					if (ms.parent){
						ms.parent.removeChild(ms);
					}
				}
				jingjieStarList = null;
			}
		}
		
		/**
		 * 更新境界强化等级对应的星星数量 
		 * 
		 */
		public function updateJingJieStar():void{
			if (indexChanged){
				
				this.clearJingJieStar();
			}
			var starIndex:int = 0;
			var mcStar:MovieClip = null;
			if (jingjieStarList==null){
				jingjieStarList = [];
				//最大星星数量
				starLimit = XmlManager.localres.Bourn_StarXml.getResPath(this.index*JingjieModel.LIMIT+focusIndex+1).max_level;
				this.ballStarLimitArr[focusIndex] = starLimit;
//				starLimit = JingjieModel.getInstance().jingJieStarLevelLimit;
				var tempPos:int = index*JingjieModel.LIMIT+focusIndex+1;
				var tempLevel:int = JingjieModel.getInstance().getJingJieBall(index,focusIndex);
				if (tempLevel==0) tempLevel = 1;
				var tempB:Pub_BournResModel = XmlManager.localres.getPubBournXml.getBournByPosAndLevel(tempPos,tempLevel);
				starLimit = tempB.maxlevel;
				var clazz:Class = GamelibS.getswflinkClass("game_index","JingJieStar");
				
				
				var totalWidth:int;
				var starX:int;
				var starY:int = 346;
				while (starIndex<starLimit){
					mcStar = new clazz();
					if (starIndex==0){
						totalWidth = mcStar.width * starLimit;
						starX = (this.width - totalWidth)>>1;
					}
					mcStar.x = starX+mcStar.width*starIndex;
					mcStar.y = starY;
					jingjieStarList[starIndex] = mcStar;
					mcStar.mouseChildren = mcStar.mouseEnabled = false;
					this.addChild(mcStar);
					starIndex++;
				}
			}
			starIndex = 0;
			//当前强化的星级
			var starLevel:int = JingjieModel.getInstance().getJingJieBall(index,focusIndex);
			while (starIndex<starLevel){
				mcStar = this.jingjieStarList[starIndex];
				mcStar.gotoAndStop(2);
				starIndex++;
			}
			this.addChildAt(mc,0);
		}
		
		/**
		 * 更新境界球开启提示 
		 * 
		 */
		private function updateBallTips():void{
			var b_star:Pub_Bourn_StarResModel;
			var i:int = 0;
			var size:int = JingjieModel.LIMIT;
			while (i<size){
				var pos:int = this.index*JingjieModel.LIMIT+i+1;
				b_star = XmlManager.localres.Bourn_StarXml.getResPath(pos);
				var ballName:String = b_star.star_name;
				this.mc["tb"+(i+1)].htmlText = ballName;
				
				if (this.ballEnabledArr[i]){
					this.mc["_b"+(i+1)]["tipParam"] = [b_star.open_tips];
					Lang.addTip(this.mc["_b"+(i+1)],"pub_param");//开启提示
				}else{
					this.mc["_b"+(i+1)]["tipParam"] = [b_star.close_tips];
					Lang.addTip(this.mc["_b"+(i+1)],"pub_param");//未开启提示
				}
				i++;
			}
			pos = this.index*JingjieModel.LIMIT+focusIndex+1;
			b_star = XmlManager.localres.Bourn_StarXml.getResPath(pos);
			this.mc["txt_cailiao1_desc"].htmlText = b_star.item_effect_desc;
			this.mc["txt_cailiao_level1"].htmlText = b_star.item_desc;
//			if (b_star.other_desc.length>0){
//				this.mc["txtExtraAttr"].htmlText = b_star.other_desc;
//			}
		}
		
		/**
		 * 更新境界七阶球状态 
		 * 
		 */
		private function updateBallState():void{
			//更新ball
			var tempFocusIndex:int = 0;
			var index1:int = 0;
			var size:int = JingjieModel.LIMIT;
			var tempMC:MovieClip;
			var findIt:Boolean = false;
			var b:Pub_BournResModel = null;
			var b_pos:int = 0;
			var b_enabled:Boolean = false;
			var level:int;
			while (index1<size){
				
				tempMC = this.mc["_b"+(index1+1)];
				tempMC["mcSelector"].visible = false;
				b_pos = index*size+index1+1;
				b = XmlManager.localres.getPubBournXml.getBournByPosAndLevel(b_pos);
				
				level = this.dataList[index1];
				if (index1>0){
					var line:MovieClip = this.mc["mc_line"+index1];
					if (b.openConditions.length==0){
						b_enabled = true;
					}else{
						b_enabled = JingjieModel.getInstance().checkJingJieAreaEnabled(b.openConditions);
					}
					
					if (level>0){
						tempMC.gotoAndStop(2);
						line.gotoAndStop(2);//更新line
					}else{
						//
						if (findIt==false){
							findIt = true;
							if (b_enabled){
								tempFocusIndex = index1;
							}else{
								tempFocusIndex = index1-1;
							}
//							tempFocusIndex = index1-1;	
						}
						tempMC.gotoAndStop(1);
						line.gotoAndStop(1);//更新line
					}
				}else {
					if (level==0){
						b_enabled = true;
						tempMC.gotoAndStop(1);
						findIt = true;
					}else{
						b_enabled = true;
						tempMC.gotoAndStop(2);
					}
				}
				this.ballEnabledArr[index1] = b_enabled;
				
				index1++;
			}
			if (level>0){//如果最后一个点的强化等级也大于0，则保持当前焦点
				if (index1-1!=focusIndex){
					this.indexChanged = true;
				}
				focusIndex = index1-1;
			}else{
				if (tempFocusIndex!=focusIndex){
					this.indexChanged = true;
				}
				focusIndex = tempFocusIndex;	
			}
//			if (tempFocusIndex!=focusIndex){
//				focusIndex = tempFocusIndex;
//				if (this.dataList[focusIndex]>=JingjieModel.getInstance().jingJieStarLevelLimit){
//				}
//			}
			
			//todo 更新text
			
			this.updateBallAttr();
		}
		
		private var pillId:int;
		
		/**
		 * 更新境界七阶球对应的属性 
		 * 
		 */
		private function updateBallAttr():void{
			//
			var tempMC:MovieClip;
			var size:int = JingjieModel.LIMIT;
			var i:int = 0;
			while (i<size){
				tempMC = this.mc["_b"+(i+1)];
				tempMC.mouseChildren = false;
				if (focusIndex==i){
					tempMC["mcSelector"].visible = true;
				}else{
					tempMC["mcSelector"].visible = false;	
				}
				i++;
			}
			var globalPos:int = index*JingjieModel.LIMIT+focusIndex+1;
			//对应强化等级
			var starLevel:int = JingjieModel.getInstance().getJingJieBall(index,focusIndex);
			this.mc["txtCurrBallLevel"].text = JingjieModel.JING_JIE_NAMES[index]+"界"+(focusIndex+1)+"阶"+starLevel+"星";
			var b:Pub_BournResModel = null;
			if (starLevel==this.ballStarLimitArr[focusIndex]){
				this.mc["btnAuto"].visible = false;
			}else{
				b = XmlManager.localres.getPubBournXml.getBournByPosAndLevel(globalPos,starLevel+1);
				this.mc["btnAuto"].visible = JingjieModel.getInstance().checkJingJieAreaEnabled(b.openConditions);
			}
			
			b = XmlManager.localres.getPubBournXml.getBournByPosAndLevel(globalPos);
			var item1Config:String = b.levelupNeed.split(";")[0];
			var item1Arr:Array = item1Config.split(",");
			var _pillID:int = int(item1Arr[0]);
			this.pillId = _pillID;
			var _cell:StructBagCell2 = Data.beiBao.getJingJieItemByMinLevel(_pillID);
			var ingot:int;
//			//获取当前境界下对应位置对应等级的配置信息
//			b = XmlManager.localres.getPubBournXml.getBournByPosAndLevel(globalPos,starLevel);
//			//当前境界星之前的所有境界星的属性值
//			var preValue:int = this.getPreJingJieBallValues();
//			
//			
//			if (focusIndex==0 && b==null){
//				this.mc["txtBaseAttr"].visible = false;
//			}else{
//				this.mc["txtBaseAttr"].visible = true;
//				if (b!=null){
//					this.mc["txtBaseAttr"].text = Att.getAttNameDesc(b.func1,b.value1);	
//				}
//			}
			//通过 _pillID 在表中找到对应的 元宝
			var _ToolsResModel:Pub_ToolsResModel = XmlManager.localres.getToolsXml.getResPath(_pillID);
			if(null == _cell)
			{
				//处理没有药的时候
//				//通过 _pillID 在表中找到对应的 元宝
//				var _ToolsResModel:Pub_ToolsResModel = XmlManager.localres.getToolsXml.getResPath(_pillID);
				
				if(null != _ToolsResModel)
				{
					ingot = _ToolsResModel.tool_coin3;//元宝数
					this.mc["txtShopBuy"].text = Lang.replaceParam(Lang.getLabel("20304_JingJie_ShopBuy"),[ingot]);
					this.mc["txt_cailiao_name1"].text = _ToolsResModel.tool_name;
//					this.mc["cailiao1"]["uil"].source = FileManager.instance.getIconSById(_ToolsResModel.tool_icon);
					ImageUtils.replaceImage(mc["cailiao1"],mc["cailiao1"]["uil"],FileManager.instance.getIconSById(_ToolsResModel.tool_icon));
					this.mc["cailiao1"]["mc_color"].gotoAndStop(_ToolsResModel.tool_color);
					this.mc["cailiao1"]["txt_num"].htmlText = "<font color='#fff5d2'>"+0/1+"</font>";
//					this.mc["txt_cailiao1_desc"].htmlText = _ToolsResModel.tool_desc;
//					this.mc["txt_cailiao_level1"].text = _ToolsResModel.tool_name;
				}
			}
			else
			{
				if(null != _ToolsResModel)
				{
					ingot = _ToolsResModel.tool_coin3;//元宝数
					this.mc["txtShopBuy"].text = Lang.replaceParam(Lang.getLabel("20304_JingJie_ShopBuy"),[ingot]);
				}
				this.mc["txt_cailiao_name1"].text = _cell.itemname;
//				this.mc["cailiao1"]["uil"].source = _cell.icon;
				ImageUtils.replaceImage(mc["cailiao1"],mc["cailiao1"]["uil"],_cell.icon);
				this.mc["cailiao1"]["mc_color"].gotoAndStop(_cell.toolColor);
				this.mc["cailiao1"]["txt_num"].htmlText = "<font color='#00FF00'>"+_cell.num+"/1"+"</font>";
//				this.mc["txt_cailiao1_desc"].htmlText = _cell.desc;
//				this.mc["txt_cailiao_level1"].text = _cell.itemname;
//				JingjieController.getInstance().chiDanYao(_cell);
			}
			
		}
		
		/**
		 * 获取当前境界球之前的所有境界球的警戒值 
		 * @return 
		 * 
		 */
		public function getPreJingJieBallValues():int{
			var jjm:JingjieModel = JingjieModel.getInstance();
			var starLevel:int = 0;
			var ballIndex:int = 0;
			var len:int = focusIndex;
			var b:Pub_BournResModel;
			var value:int = 0;
			while (ballIndex<len){
				starLevel = jjm.getJingJieBall(index,ballIndex);
				b = XmlManager.localres.getPubBournXml.getBournByPosAndLevel(index*JingjieModel.LIMIT+ballIndex+1,starLevel);
				if (b!=null)
					value += b.value1;
				ballIndex++;
			}
			return value;
		}
		
		/**
		 * 更新当前境界对应的属性 
		 * 
		 */
		private function updateJingJieAttr(needUpdateTips:Boolean):void{
			this.mc["txtBaseAttr"].htmlText = JingjieModel.getInstance().getJingJieBaseAttr(index);
			var b_Pos:int = index*JingjieModel.LIMIT+focusIndex+1;
			var b_star:Pub_Bourn_StarResModel = XmlManager.localres.Bourn_StarXml.getResPath(b_Pos);
			if (needUpdateTips){//当前境界改变，或者境界点提升
				this.indexChanged = false;
				this.mc["txtExtraAttr"].htmlText = b_star.other_desc;
				this.mc["txtBaseAttrLabel"].text = Lang.replaceParam(Lang.getLabel("20301_JingJie_BaseAttr"),[JingjieModel.JING_JIE_NAMES[index]]);
				this.updateBallTips();
			}else if (this.indexChanged){
				this.indexChanged = false;
				this.updateBallTips();
			}
			var b_starLv:int = JingjieModel.getInstance().getJingJieBall(index,focusIndex);
			if (b_star.other_desc.length>0 && b_starLv>=b_star.other_open_level){
				this.mc["txtExtraAttr"].htmlText = b_star.other_desc;
			}
		}
		
		private function levelUp():void{
			var _cell:StructBagCell2 = Data.beiBao.getJingJieItemByMinLevel(this.pillId);
			var cbShopBuy:CheckBoxStyle1 = this.mc["cbShopBuy"];
			var currPos:int = this.index*JingjieModel.LIMIT+focusIndex+1;
			if (cbShopBuy.selected==false){
				if (_cell==null){
					_cell = Data.beiBao.getJingJieItemCanUse(this.pillId);
					if (_cell==null){
						Lang.showMsg(Lang.getClientMsg("20074_meterial_not_enough"));
//						JingjieController.getInstance().requestCSEatPill(this.pillId,currPos,false);
						return;
					}
					var _pillConfig:Pub_ToolsResModel = XmlManager.localres.getToolsXml.getResPath(this.pillId);
					//是否消耗XX品丹药提升境界
					alert.setModal(true);
					alert.ShowMsg(Lang.getLabel("20308_JingJie_EatPill"),
						4,null,callbackBuyAndEatPill,_pillConfig);
				}else{
					JingjieController.getInstance().requestCSEatPill(this.pillId,currPos,false);
				}
			}else{
				JingjieController.getInstance().requestCSEatPill(this.pillId,currPos,true);
			}
		}
		
		private function callbackBuyAndEatPill(_pillConfig:Pub_ToolsResModel):void
		{
			JingjieController.getInstance().requestCSBuyPill(_pillConfig.tool_id,1,JingjieModel.getInstance().getIndex());
		}
	}
}