package com.bellaxu.display
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.data.PubData;
	import com.bellaxu.def.AlertDef;
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.def.NeverNoticeDef;
	import com.bellaxu.def.ResPathDef;
	import com.bellaxu.mgr.TimerMgr;
	import com.bellaxu.res.ResTool;
	import com.bellaxu.util.StageUtil;
	
	import common.utils.CtrlFactory;
	import common.utils.bit.BitUtil;
	
	import engine.utils.HashMap;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.utils.Dictionary;
	
	import ui.base.renwu.Renwu;
	import ui.view.view4.yunying.ZhiZunVIPMain;

	/**
	 * Alert单例来实现
	 * @author BellaXu
	 */
	public class Alert
	{
		private static const alertDic:Dictionary = new Dictionary(); //保存舞台上的Alert
		private static var index:int = 0; //用于起名，防止名字冲突，名字用来再textLink的地方判断类型
		private static var map:HashMap = new HashMap(); //类型－状态
		private static var config:int = 0; //服务器同步的状态
		
		/**
		 * 显示弹出框
		 * type见AlertDef
		 * subType只对AlertDef.CONFIRM_CANCEL_NEVERNOTICE起作用，是不再提示的类别，见NeverNoticeDef
		 */
		public static function show(type:String, subType:int = 0, htmlTxt:String = null, time:int = 0, onConfirm:Function = null, onCancel:Function = null, onSelect:Function = null, 
									layer:DisplayObjectContainer = null, confirmParams:Array = null, cancelParams:Array = null, confirmLabel:String = null, cancelLabel:String = null):void
		{
			//优先处理不再提示
			if(type == AlertDef.CONFIRM_CANCEL_NEVERNOTICE && map.get(subType) == 1)
			{
				if(onConfirm != null)
					onConfirm.apply(null, confirmParams);
				return;
			}
			var parent:DisplayObjectContainer = layer ? layer : LayerDef.alertLayer;
			var spr:Sprite = ResTool.getMc(ResPathDef.GAME_CORE, type);
			spr.name = type + (++index);
			spr.x = StageUtil.stageWidth - spr.width >> 1;
			spr.y = StageUtil.stageHeight - spr.height >> 1;
			addModal(spr); //添加底层
			parent.addChild(spr);
			alertDic[spr] = spr;
			if(spr["txt_msg"])
			{
				if(htmlTxt)
					spr["txt_msg"].htmlText = htmlTxt;
				spr["txt_msg"].addEventListener(TextEvent.LINK, onTextLink);
			}
			var confirmFunc:Function = function(e:MouseEvent):void{
				if(TimerMgr.getInstance().hasTimer(timeFunc))
					TimerMgr.getInstance().remove(timeFunc);
				if(spr.parent)
					spr.parent.removeChild(spr);
				spr["btnSubmit"].removeEventListener(MouseEvent.CLICK, confirmFunc);
				if(spr["txt_msg"])
					spr["txt_msg"].removeEventListener(TextEvent.LINK, onTextLink);
				if(spr["check"] && selectFunc != null)
					spr["check"].removeEventListener(MouseEvent.CLICK, selectFunc);
				if(spr["checkTxt"])
					spr["checkTxt"].removeEventListener(MouseEvent.CLICK, selectFunc);
				if(onConfirm != null)
					onConfirm.apply(null, confirmParams);
				delete alertDic[spr];
			};
			var cancelFunc:Function = function(e:MouseEvent):void{
				if(spr.parent)
					spr.parent.removeChild(spr);
				spr["btnclose"].removeEventListener(MouseEvent.CLICK, cancelFunc);
				if(spr["txt_msg"])
					spr["txt_msg"].removeEventListener(TextEvent.LINK, onTextLink);
				if(spr["check"] && selectFunc != null)
				{
					if(spr["check"].selected)
					{
						map.put(subType, 1);
						config = changeMapToInt(map);
						PubData.save(2, config);
						
						if(onSelect != null)
							onSelect();
					}
					spr["check"].removeEventListener(MouseEvent.CLICK, selectFunc);
				}
				if(spr["checkTxt"])
					spr["checkTxt"].removeEventListener(MouseEvent.CLICK, selectFunc);
				if(onCancel != null)
					onCancel.apply(null, cancelParams);
				delete alertDic[spr];
			};
			var selectFunc:Function = function(e:MouseEvent):void{
				if(spr["check"])
				{
					spr["check"].selected = !spr["check"].selected;
					
					map.put(subType, spr["check"].selected ? 1 : 0);
					config = changeMapToInt(map);
					PubData.save(2, config);
				}
				if(onSelect != null)
					onSelect();
			};
			var timeFunc:Function = function():void{
				if(--time > -1)
					spr["btnSubmit"].text = spr["btnSubmit"].label + "(" + CtrlFactory.getUICtrl().formatTime2(time) + ")";
				else
					TimerMgr.getInstance().remove(timeFunc);
			};
			if(spr["btnSubmit"])
			{
				if(time > 0)
				{
					spr["btnSubmit"].text = spr["btnSubmit"].label + "(" + CtrlFactory.getUICtrl().formatTime2(time) + ")";
					TimerMgr.getInstance().add(1000, timeFunc);
				}
				if(confirmLabel)
					spr["btnSubmit"].text = confirmLabel;
				spr["btnSubmit"].addEventListener(MouseEvent.CLICK, confirmFunc);
			}
			if(spr["btnclose"])
			{
				if(cancelLabel)
					spr["btnclose"].text = cancelLabel;
				spr["btnclose"].addEventListener(MouseEvent.CLICK, cancelFunc);
			}
			if(spr["check"])
				spr["check"].addEventListener(MouseEvent.CLICK, selectFunc);
			if(spr["checkTxt"])
				spr["checkTxt"].addEventListener(MouseEvent.CLICK, selectFunc);
		}
		
		private static function addModal(spr:Sprite):void
		{
			var modal:Sprite = new Sprite();
			var startX:int = spr.width - StageUtil.stageWidth >> 1;
			var startY:int = spr.height - StageUtil.stageHeight >> 1;
			modal.graphics.beginFill(0x000000, 0.1);
			modal.graphics.drawRect(startX, startY, StageUtil.stageWidth, StageUtil.stageHeight);
			modal.graphics.endFill();
			spr.addChildAt(modal, 0);
		}
		
		private static function onTextLink(e:TextEvent):void
		{
			if (int(e.text) == NeverNoticeDef.CHUANSONG)
				ZhiZunVIPMain.getInstance().open();
			else if(e.target.parent.name.indexOf(AlertDef.CONFIRM_CANCEL_NEVERNOTICE) < 0)
				Renwu.textLinkListener_(e);
		}
		
		public static function clearConfig():void
		{
			map = new HashMap();
			config = 0;
			PubData.save(2, config);
		}
		
		//从服务器读取的配置信息，保存到客户端
		public static function set serverConfig(pare:int):void
		{
			config = pare;
			map = changeIntToMap(config);
		}
		
		public static function getStateByType(type:int):int
		{
			return map.get(type);
		}
		
		public static function setStateByType(type:int, value:int):void
		{
			map.put(type, value);
		}
		
		private static function changeMapToInt(map:HashMap):int
		{
			var _config:int = 0;
			_config = BitUtil.setIntToInt(map.get(NeverNoticeDef.RMBSHOP), _config, NeverNoticeDef.RMBSHOP, NeverNoticeDef.RMBSHOP);
			_config = BitUtil.setIntToInt(map.get(NeverNoticeDef.BONE), _config, NeverNoticeDef.BONE, NeverNoticeDef.BONE);
			_config = BitUtil.setIntToInt(map.get(NeverNoticeDef.GUAJI), _config, NeverNoticeDef.GUAJI, NeverNoticeDef.GUAJI);
			_config = BitUtil.setIntToInt(map.get(NeverNoticeDef.JINGJIE), _config, NeverNoticeDef.JINGJIE, NeverNoticeDef.JINGJIE);
			_config = BitUtil.setIntToInt(map.get(NeverNoticeDef.GUWU), _config, NeverNoticeDef.GUWU, NeverNoticeDef.GUWU);
			_config = BitUtil.setIntToInt(map.get(NeverNoticeDef.MOTIAN), _config, NeverNoticeDef.MOTIAN, NeverNoticeDef.MOTIAN);
			_config = BitUtil.setIntToInt(map.get(NeverNoticeDef.CHONGZHU), _config, NeverNoticeDef.CHONGZHU, NeverNoticeDef.CHONGZHU);
			_config = BitUtil.setIntToInt(map.get(NeverNoticeDef.CHUANSONG), _config, NeverNoticeDef.CHUANSONG, NeverNoticeDef.CHUANSONG);
//			_config = BitUtil.setIntToInt(map.get(NeverNoticeDef.BOOTH_AD), _config, NeverNoticeDef.BOOTH_AD, NeverNoticeDef.BOOTH_AD);
//			_config = BitUtil.setIntToInt(map.get(NeverNoticeDef.BANGPAI), _config, NeverNoticeDef.BANGPAI, NeverNoticeDef.BANGPAI);
//			_config = BitUtil.setIntToInt(map.get(NeverNoticeDef.FENJIE_ZHUANGBEI), _config, NeverNoticeDef.FENJIE_ZHUANGBEI, NeverNoticeDef.FENJIE_ZHUANGBEI);
			return _config;
		}
		
		private static function changeIntToMap(i:int):HashMap
		{
			var _map:HashMap = new HashMap();
			_map.put(NeverNoticeDef.RMBSHOP, BitUtil.getOneToOne(i, NeverNoticeDef.RMBSHOP, NeverNoticeDef.RMBSHOP));
			_map.put(NeverNoticeDef.BONE, BitUtil.getOneToOne(i, NeverNoticeDef.BONE, NeverNoticeDef.BONE));
			_map.put(NeverNoticeDef.GUAJI, BitUtil.getOneToOne(i, NeverNoticeDef.GUAJI, NeverNoticeDef.GUAJI));
			_map.put(NeverNoticeDef.JINGJIE, BitUtil.getOneToOne(i, NeverNoticeDef.JINGJIE, NeverNoticeDef.JINGJIE));
			_map.put(NeverNoticeDef.GUWU, BitUtil.getOneToOne(i, NeverNoticeDef.GUWU, NeverNoticeDef.GUWU));
			_map.put(NeverNoticeDef.MOTIAN, BitUtil.getOneToOne(i, NeverNoticeDef.MOTIAN, NeverNoticeDef.MOTIAN));
			_map.put(NeverNoticeDef.CHONGZHU, BitUtil.getOneToOne(i, NeverNoticeDef.CHONGZHU, NeverNoticeDef.CHONGZHU));
			_map.put(NeverNoticeDef.CHUANSONG, BitUtil.getOneToOne(i, NeverNoticeDef.CHUANSONG, NeverNoticeDef.CHUANSONG));
//			_map.put(NeverNoticeDef.BOOTH_AD, BitUtil.getOneToOne(i, NeverNoticeDef.BOOTH_AD, NeverNoticeDef.BOOTH_AD));
//			_map.put(NeverNoticeDef.BANGPAI, BitUtil.getOneToOne(i, NeverNoticeDef.BANGPAI, NeverNoticeDef.BANGPAI));
//			_map.put(NeverNoticeDef.FENJIE_ZHUANGBEI, BitUtil.getOneToOne(i, NeverNoticeDef.FENJIE_ZHUANGBEI, NeverNoticeDef.FENJIE_ZHUANGBEI));
			return _map;
		}
		
		public static function resizeAll():void
		{
			var modal:Sprite;
			var startX:int = 0;
			var startY:int = 0;
			var rw:int = 0;
			var rh:int = 0;
			for each(var spr:Sprite in alertDic)
			{
				rw = spr.getChildAt(1).width;
				rh = spr.getChildAt(1).height;
				
				modal = spr.getChildAt(0) as Sprite;
				modal.graphics.clear();
				startX = rw - StageUtil.stageWidth >> 1;
				startY = rh - StageUtil.stageHeight >> 1;
				modal.graphics.beginFill(0x000000, 0.2);
				modal.graphics.drawRect(startX, startY, StageUtil.stageWidth, StageUtil.stageHeight);
				modal.graphics.endFill();
				
				spr.x = StageUtil.stageWidth - rw >> 1;
				spr.y = StageUtil.stageHeight - rh >> 1;
			}
		}
	}
}