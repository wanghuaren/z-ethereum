package ui.view.marry
{
	
	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.lib.TablesLib;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_Marriage_BeatitudeResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSBlessMarry;
	import nets.packets.PacketSCBlessMarry;
	
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	
	/**
	 * 为新人祝福界面  hpt
	 */
	public class BlessingWin extends UIWindow
	{
		private static var _instance:BlessingWin = null;
		
		public static function getInstance():BlessingWin{
			if (_instance == null){
				_instance = new BlessingWin();
			}
			return _instance;
		}
		private var _selectedIndex:int = -1;
		private var _hasInit:Boolean = false;
		private var _name1:String=null;
		private var _name2:String=null;
		private var _content:String="";
		private var _prompt:String = "<br><font color='#999999'>(点击可进行编辑，未编辑按默认祝词发送)</font>";
		private var _hasEdit:Boolean = false;
		private var _sendMsgLock:Boolean = false;
		
		public function BlessingWin()
		{
			super(getLink(WindowName.win_jie_hun_zhu_fu_li_bao));
		}
		
		override protected function init():void{
			super.init();
			if (this._hasInit==false){
				this._hasInit = true;
				TextField(this.mc["tContent"]).maxChars =15;
				//祝福礼包
				this.initGifts();
			}
//			this.mc["tContent"].addEventListener(FocusEvent.FOCUS_IN,onFocusIn);
			this.uiRegister(PacketSCBlessMarry.id,onBlessMarry);
			this.selectedIndex = 2;
		}
		
		private function onFocusIn(e:FocusEvent):void{
			this.mc["tContent"].removeEventListener(FocusEvent.FOCUS_IN,onFocusIn);
			this.mc["tContent"].htmlText = this._content;
			this._hasEdit = true;
			if (this.mc.stage!=null){
				this.mc.stage.focus = TextField(this.mc["tContent"]);
			}
		}
		
		private function onBlessMarry(p:PacketSCBlessMarry):void{
			_sendMsgLock = false;
			if (Lang.showResult(p)){
				this.winClose();
			}
		}
		
		public function show(name1:String,name2:String):void{
			this._name1 = name1;
			this._name2 = name2;
		}
		
		private function initGifts():void{
			var mcItem:MovieClip;
			var mb:TablesLib = XmlManager.localres.marriageBeatitudeXml;
			var m:Pub_Marriage_BeatitudeResModel;
			var itemId:int;
			var bag:StructBagCell2;
			for (var i:int = 1;i<4;i++){
				mcItem = this.mc["zhufu_tiem"+i];
				mcItem.mouseChildren = false;
				m = mb.getResPath(i) as Pub_Marriage_BeatitudeResModel;
				var da:Vector.<Pub_DropResModel> = GameData.getDropXml().getResPath2(m.drop_id) as Vector.<Pub_DropResModel>;
				itemId = da[0].drop_item_id;
				bag = new StructBagCell2();
				bag.itemid = itemId;
				bag.num = 1;
				Data.beiBao.fillCahceData(bag);
				mcItem.data = bag;
//				mcItem["uil"].source = bag.icon;
				ImageUtils.replaceImage(mcItem,mcItem["uil"],bag.icon);
				CtrlFactory.getUIShow().addTip(mcItem);
				if (m.need_coin1!=0){
					this.mc["tzhu_fu_"+i].text = m.need_coin1+Lang.getLabel("pub_yin_liang");
				}else if (m.need_coin3!=0){
					this.mc["tzhu_fu_"+i].text = m.need_coin3+Lang.getLabel("pub_yuan_bao");
				}
			}
		}
		
		override public function mcHandler(target:Object):void{
			super.mcHandler(target);
			var target_name:String = target.name;
			switch (target_name){
				case "zhufu_tiem1":
					this.selectedIndex = 1;
					break;
				case "zhufu_tiem2":
					this.selectedIndex = 2;
					break;
				case "zhufu_tiem3":
					this.selectedIndex = 3;
					break;
				case "zhufu_btn":
					this.bless();
					break;
			}
		}
		
		private function bless():void{
			if (_sendMsgLock) return;
			var p:PacketCSBlessMarry = new PacketCSBlessMarry();
			var msg:String = this._hasEdit?this.mc["tContent"].text:this._content;
			p.msg = "<b><font color='#01ff0d'>"+Data.myKing.name+"</font></b>祝<b><font color='#01ff0d'>"+this._name1+"</font></b>、<b><font color='#01ff0d'>"+this._name2+"</font></b>夫妇，"+msg;
			p.sort = selectedIndex;
			uiSend(p);
			_sendMsgLock = true;
		}
		
		public function get selectedIndex():int{
			return this._selectedIndex;
		}
		
		public function set selectedIndex(value:int):void{
			if (value!=this._selectedIndex){
				_hasEdit = false;
				if (this.mc["tContent"].hasEventListener(FocusEvent.FOCUS_IN)==false){
					this.mc["tContent"].addEventListener(FocusEvent.FOCUS_IN,onFocusIn);
				}
				this._selectedIndex = value;
				var m:Pub_Marriage_BeatitudeResModel = XmlManager.localres.marriageBeatitudeXml.getResPath(value) as Pub_Marriage_BeatitudeResModel;
				_content = m.beatitude_desc;
				this.mc["tContent"].htmlText = _content+this._prompt;
				var mcItem:MovieClip = null;
				for (var i:int = 1;i<4;i++){
					mcItem = this.mc["zhufu_tiem"+i];
					if (i == value){
						MovieClip(mcItem["mcSelect"]).gotoAndStop(2);
					}else{
						MovieClip(mcItem["mcSelect"]).gotoAndStop(1);
					}
				}
			}
		}
	}
}