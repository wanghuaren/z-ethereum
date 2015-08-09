/**
 * Copyright the company of XiHe, all rights reserved.
 */
package ui.view.jingjie
{
	import common.managers.Lang;
	
	import ui.frame.UIMovieClip;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	import model.jingjie.JingjieModel;
	
	import ui.frame.UIWindow;
	import ui.view.liandanlu.LianDanLuWin;
	
	/**
	 * 境界主窗口
	 * @author liuaobo
	 * @create date 2013-5-15
	 */
	public class JingJieWin extends UIWindow
	{
		private static var _instance:JingJieWin = null;
		
		/********* 境界区域  **********/
		private var area_qingLong:JingJieArea;
		private var area_baiHu:JingJieArea;
		private var area_xuanWu:JingJieArea;
		private var area_zhuQue:JingJieArea;
		
//		/********* 境界区域是否开启 *********/
//		private var area_qingLongEnabled:Boolean = true;//默认开启
//		private var area_baiHuEnabled:Boolean = false;
//		private var area_xuanWuEnabled:Boolean = false;
//		private var area_zhuQueEnabled:Boolean = false;
		
		/**
		 * 区域对应索引编号，方便获取对应的境界数据 
		 */
		private static const AREAS:Object = {mc_qingLong:0,mc_baiHu:1,mc_zhuQue:2,mc_xuanWu:3};
		
		public function JingJieWin()
		{
			super(getLink("win_jing_jie"));//初始化主窗体
		}
		
		public static function getInstance():JingJieWin{
			UIMovieClip.currentObjName = null;
			if (_instance == null){
				_instance = new JingJieWin();
			}
			return _instance;
		}
		
		/**
		 * UI唯一标识 
		 * @return id
		 * 
		 */
		override public function getID():int{
			return 1006;
		}
		
		/**
		 * 初始化UI控件 
		 * 
		 */
		override protected function init():void{
			//初始化境界区域
			this.area_qingLong = new JingJieArea(this.mc["mc_qingLong"]);
			this.area_baiHu = new JingJieArea(this.mc["mc_baiHu"]);
			this.area_xuanWu = new JingJieArea(this.mc["mc_xuanWu"]);
			this.area_zhuQue = new JingJieArea(this.mc["mc_zhuQue"]);
			
			//禁用容器子控件鼠标响应事件
			this.mc["mc_qingLong"].mouseChildren = false;
			this.mc["mc_baiHu"].mouseChildren = false;
			this.mc["mc_xuanWu"].mouseChildren = false;
			this.mc["mc_zhuQue"].mouseChildren = false;
			
			//每次开启窗口的时候强制设置默认的当前玩家
			JingjieModel.getInstance().setIndex(0);
			if(null != stage)
			{
				stage.addEventListener(Event.RESIZE, onResizeHandler);
			}
			//需要归纳到lang.xml
			Lang.addTip(mc["btnLianDanLu"],"20300_JingJie_DanLu",96);
			
			
		}
		
		override public function mcHandler(target:Object):void{
			var name:String=target.name;
			if (name == "btnLianDanLu"){
				
				return;
			}
			if (JingjieModel.getInstance().hasOwnProperty(name+"Enabled")){
				var canOpen:Boolean = JingjieModel.getInstance()[name+"Enabled"];
				var areaIndex:int = AREAS[name];
				if (canOpen){
					JingJieLevelUpWin.getInstance().open();
					JingJieLevelUpWin.getInstance().update(areaIndex);
				}
			}
		}
		
		override public function open(must:Boolean=false, type:Boolean=true):void{
			super.open(must,type);
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
		
		//--------------------------------------
		//----- extra methods
		//--------------------------------------
		
		/**
		 * 更新数据 
		 * 
		 */
		public function update():void{
			//更新境界背景状态
			this.updateJingJieAreaBgState();
			//更新境界点状态
			this.updateJingJieBallState();
		}
		
		private function updateJingJieAreaBgState():void{
			(this.mc["mc_qingLong"]["bg"] as MovieClip).gotoAndStop(2);
			var targetFrame:int = 1;
			targetFrame = JingjieModel.getInstance().mc_baiHuEnabled?2:1;
			(this.mc["mc_baiHu"]["bg"] as MovieClip).gotoAndStop(targetFrame);
			
			targetFrame = JingjieModel.getInstance().mc_zhuQueEnabled?2:1;
			(this.mc["mc_zhuQue"]["bg"] as MovieClip).gotoAndStop(targetFrame);
			
			targetFrame = JingjieModel.getInstance().mc_xuanWuEnabled?2:1;
			(this.mc["mc_xuanWu"]["bg"] as MovieClip).gotoAndStop(targetFrame);
		}
		
		private function updateJingJieBallState():void{
			var instance:JingjieModel = JingjieModel.getInstance();
			var index:int = 0;
			var areas:Array = [area_qingLong,area_baiHu,area_zhuQue,area_xuanWu];
			var mcs:Array = ["mc_qingLong","mc_baiHu","mc_zhuQue","mc_xuanWu"];
			var a:JingJieArea = null;
			while (index<4){
				a = (areas[index] as JingJieArea);
				a.open(instance.getJingJieArea(index));
//				this.mc[mcs[index]]["tipParam"] = [JingjieModel.getInstance().getOpenCondition(index)];
				this.mc[mcs[index]]["tipParam"] = [JingjieModel.getInstance()[mcs[index]+"Tip"]];
				Lang.addTip(this.mc[mcs[index]],"pub_param",150);
				index++;
			}
		}
	}
}