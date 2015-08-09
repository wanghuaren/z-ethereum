/**
 * Copyright the company of XiHe, all rights reserved.
 */
package ui.view.fubenui
{
	import common.managers.Lang;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSCallBack;
	
	import ui.frame.UIWindow;
	import ui.view.view6.GameAlert;
	
	/**
	 * @author liuaobo
	 * @create date 2013-7-26
	 */
	public class TianMenZhenControlBar extends UIWindow
	{
		private static var _instance:TianMenZhenControlBar = null;
		private var _hasInited:Boolean = false;
		private var _callbackTypeStart:int = 100011011;
		private var _resources:Array = null;
		private var _resCount:int;
		private var _speed:int;
		
		public function TianMenZhenControlBar()
		{
			blmBtn = 0;
			type = 0;
			super(getLink("win_tian_men_zhen","fu_ben_ui"));
		}
		
		public static function getInstance():TianMenZhenControlBar{
			if (_instance==null){
				_instance = new TianMenZhenControlBar();
			}
			return _instance;
		}
		
		public static function hasInstance():Boolean
		{
			if (null == _instance)
			{
				return false;
			}
			return true;
		}
		
		override protected function init():void{
			super.init();
			//2013-11-25 策划屏蔽超必杀
			mc["btn6"].visible=false;
			if (_hasInited==false){
				_hasInited = true;
				var tempRes:Array = Lang.getLabelArr("20500_TianMenZhen_Resource");
				this._resources = [];
				for (var i:int = 0;i<8;i++){
					if (i<7){
						this._resources.push(int(tempRes[i]));
					}
					Lang.addTip(mc["btn"+i],"tianMenZhen_btn"+i,120);
				}
			}
			update(_resCount,_speed);
			reposition();
		}
		
		override public function mcHandler(target:Object):void{
			super.mcHandler(target);
			var target_name:String = target.name;
			if (target_name.indexOf("btn")==0){
				var ctrlType:int = int(target_name.replace("btn",""));
				var p:PacketCSCallBack = null;
				if (ctrlType==7){//拆除
					new GameAlert().ShowMsg(Lang.getLabel("20500_TianMenZhen_Remove"),4,null,function ():void{
						//TODO 操作协议
						p = new PacketCSCallBack();
						p.callbacktype = _callbackTypeStart+ctrlType;
						DataKey.instance.send(p);
					});
				}else{
					//TODO 操作协议
					p = new PacketCSCallBack();
					p.callbacktype = _callbackTypeStart+ctrlType;
					DataKey.instance.send(p);
				}
			}
		}
		
		/**
		 * 资源更新 
		 * @param resCount 资源数量
		 * @param speed 增长速度
		 * 
		 */
		public function update(resCount:int,speed:int):void{
			this._resCount = resCount;
			this._speed = speed;
			if (mc==null||mc.stage==null){
				this.open(true,false);
				return;
			}
			mc["tRes"].text = Lang.replaceParam(Lang.getLabel("20500_TianMenZhen_CurrentRes"),[_resCount]);
			mc["tSpeed"].text = _speed.toString();
			var mcItem:MovieClip;
			var targetFrame:int = 1;
			for (var i:int = 0;i<6;i++){
				mcItem = mc["btn"+i];
				if (resCount>= this._resources[i]){
					targetFrame = 2;
				}else{
					targetFrame = 1;
				}
				mcItem.gotoAndStop(targetFrame);
			}
		}
		
		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标
		private function reposition():void
		{
			
			if(null == m_gPoint)
			{
				m_gPoint = new Point();
				
			}
			
			if(null == m_lPoint)
			{
				m_lPoint = new Point();
			}
			
			if(null != mc && null != mc.parent && null != mc.stage)
			{
				m_gPoint.x = (mc.stage.stageWidth - mc.width ) >> 1 ;
				m_gPoint.y = mc.stage.stageHeight - 220;
				
				m_lPoint = mc.parent.globalToLocal(m_gPoint);
				
				mc.x = m_lPoint.x;
				mc.y = m_lPoint.y;
			}
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		override public function getID():int
		{
			return 0;
		}
	}
}