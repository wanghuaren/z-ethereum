package ui.view.marry
{
	import common.managers.Lang;
	
	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	
	import nets.packets.PacketCSUseFirework;
	import nets.packets.PacketSCUseFirework;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	

	/**
	 * 点烟花窗口  hpt
	 */
	public class LightenFireworksWin extends UIWindow
	{
		private static var _instance:LightenFireworksWin = null;
		private var sort:int=1;
		private var _content:String="";
		private var _desc:String="";
		private var _prompt:String = "<br><font color='#999999'>(点击可进行编辑，未编辑按默认祝词发送)</font>";
		private var _hasEdit:Boolean = false;
		
		public static function getInstance():LightenFireworksWin{
			if (_instance == null){
				_instance = new LightenFireworksWin();
			}
			return _instance;
		}
		
		public function LightenFireworksWin()
		{
			super(getLink(WindowName.win_jie_hun_ti_shi));
		}
		
		override protected function init():void{
			super.init();
			TextField(this.mc["tDesc"]).maxChars = 20;
			this.mc["yanhua_name"].htmlText = this._content;
			this.mc["tDesc"].htmlText = this._desc+this._prompt;
			this.mc["tDesc"].addEventListener(FocusEvent.FOCUS_IN,onFocusIn);
			uiRegister(PacketSCUseFirework.id,onUseFirework);//使用焰火返回
			_hasEdit = false;
		}
		
		private function onFocusIn(e:FocusEvent):void{
			this.mc["tDesc"].removeEventListener(FocusEvent.FOCUS_IN,onFocusIn);
			this.mc["tDesc"].text = this._desc;
			_hasEdit = true;
			if (this.mc.stage!=null){
				this.mc.stage.focus = TextField(this.mc["tDesc"]);
			}
		}
		
		public function confirm(itemName:String,index:int):void{
			sort = index;
			//烟花id列表
			this._content = Lang.replaceParam(Lang.getLabel("900015_marry_alert4"),[itemName]);
			this._desc = Lang.getLabelArr("900015_marry_alert4_desc")[index];
			this.open(true);
		}
		
		override public function mcHandler(target:Object):void{
			super.mcHandler(target);
			var target_name:String = target.name;
			switch (target_name){
				case "fire_btn":
					this.fire();
					this.winClose();
					break;
				case "cancel":
					this.winClose();
					break;
			}
		}
		
		/**
		 * 点烟花
		 */
		private function fire():void{
			var p:PacketCSUseFirework = new PacketCSUseFirework();
			p.sort = this.sort;
			p.msg = this._hasEdit?this.mc["tDesc"].text:this._desc;
			uiSend(p);
		}
		
		/**
		 *使用焰火返回 
		 * @param p
		 * 
		 */
		private function onUseFirework(p:PacketSCUseFirework):void{
			Lang.showResult(p);
		}
			
	}
}