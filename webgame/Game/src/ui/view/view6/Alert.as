package ui.view.view6
{
	
	import com.greensock.TweenMax;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.managers.Lang;
	import common.utils.GamePrint;
	
	import engine.load.Gamelib;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ui.frame.UIControl;

	public class Alert extends Sprite
	{
		public var UI:DisplayObject;
		//private var rect:MovieClip;
		
		/**
		 * 
		 */ 
		private var doAct:Function =null;	
		private var param:Object =null;
		
		private  var doAct2:Function =null;
		private  var param2:Object =null;
		
		private var _instance_ind:int;
		
		public function Alert(ind:int)
		{
			_instance_ind = ind;
		}
		
		public function get instance_ind():int
		{
			return _instance_ind;
		}
		
		/**
		 * 
		 */ 
		private static var _instance:Alert;
		public static function get instance():Alert
		{
			if(null == _instance)
			{
				_instance = new Alert(1);
			}
			
			return _instance;
		}
		
		/**
		 * 点确定打开第二个弹窗，适合用instance2
		 */ 
		private static var _instance2:Alert;
		public static function get instance2():Alert
		{
			
			if(null == _instance2)
			{
				_instance2 = new Alert(2);
			}
			
			return _instance2;
		}
		
		/**
		 * 单独打开弹窗，不受其它弹窗影响，适合用instance3
		 */ 
		private static var _instance3:Alert;
		public static function get instance3():Alert
		{
			if(null == _instance3)
			{
				_instance3 = new Alert(3);
			}
			
			return _instance3;
		}
		
		
		public function ShowMsg(msg:Object =null,type:uint =1,sprite:Object =null,doFunction:Function =null,...Param):MovieClip
		{
			
			if(null == PubData.AlertUI2)
			{
				return null;
			}
			
			//type 1
			
			
			if(sprite is Sprite){
				sprite.stopDrag();
			}
			if(type==4||type==3){
				doAct=doFunction;
				param=Param;
			}
			if(type==2){
				doAct2=doFunction;
				param2=Param;
			}
			
			var curShow:Boolean =false;
			switch(type){
				case 1:
					// 普通提示
					GamePrint.Print(msg+"");
					return null;
					break;
				case 2:
					// 确定警告框
					if(PubData.AlertUI2.getChildByName("窗体_警告" + instance_ind.toString())==null)
					{
						
						UI= this.UIMcByType2;
						UI.name="窗体_警告" + instance_ind.toString();
						
					} else
					{
						UI=PubData.AlertUI2.getChildByName("窗体_警告" + instance_ind.toString());
					}
					
					//UI["btnSubmit2"].label=param2==null||param2.length==0?"确认":param2;
					
					UI["btnSubmit2"].label=param2==null||param2.length==0?Lang.getLabel("pub_que_ren"):param2;
					
					
					
					UI["txt_msg"].htmlText=msg+"";
					curShow=true;
					break;
				case 3:
					// 指定MC的警告框
					// if (PubData.AlertUI2.getChildByName("alert")==null||!PubData.AlertUI2.getChildByName("alert").visible) {
					UI=msg as Sprite;
					if(!(sprite is Sprite)){
						for(var elem:String in sprite){
							UI[elem].text=sprite[elem];
						}
					}
					UI.name="alert";
					curShow=true;
					// }
					break;
				case 4:
					// 确定取消框
					if(PubData.AlertUI2.getChildByName("SUBMIT_CANCEL"+ instance_ind.toString())==null)
					{					
						UI= this.UIMcByType4;
						UI.name="SUBMIT_CANCEL"+ instance_ind.toString();
						
					} else
					{
						UI=PubData.AlertUI2.getChildByName("SUBMIT_CANCEL"+ instance_ind.toString());
					}
					
					UI.width = 289;
					UI["txt_msg"].htmlText=msg;
					curShow=true;
					break;
			}
			if(curShow){
				UI.addEventListener(MouseEvent.MOUSE_UP,alertPaneHandler);
				UI.addEventListener(Event.REMOVED_FROM_STAGE,REMOVEDHandler);
				// UI.addEventListener(Event.ADDED_TO_STAGE,alertAddedHandler);
				// PubData.AlertUI2.addChild(UI as DisplayObject);
				// -----------------------------------------------
				if(UI.parent==null||UI.parent.getChildByName("rect")==null){
					//rect=new MovieClip();
					//					rect.graphics.clear();
					//					rect.graphics.beginFill(0x333333);
					//					rect.graphics.drawRoundRect(0,0,GameIni.MAP_SIZE_W,GameIni.MAP_SIZE_H,0,0);
					//					rect.graphics.endFill();
					//					rect.alpha=0.3;
					//					rect.name="rect";
					//					PubData.AlertUI2.addChild(rect);
				} else{
				}
				
				UI.visible=true;
				UI.x=(GameIni.MAP_SIZE_W-UI.width)/2;
				if(type==2){
					UI.y=(GameIni.MAP_SIZE_H-UI.height)/2+50;
				}else{
					UI.y=(GameIni.MAP_SIZE_H-UI.height)/2;
				}
				PubData.AlertUI2.addChild(UI as DisplayObject);
			}
			try{
				return UI as MovieClip;
			} catch(e:Error){
				return null;
			}
			return null;
		
		}
		
		private function alertPaneHandler(e:MouseEvent):void{
			switch(e.target.name){
				case "btnSubmit":
					(doAct is Function)?param.length==0?doAct():doAct(param[0]==null?UI["txt_msg"].text:param[0]):"";
					/*if(rect!=null&&rect.parent!=null){
						rect.parent.removeChild(rect);
					}*/
					// TweenMax.to(UI,UIControl.tweenDelay,{alpha:UIControl.tweenAlpha,x:UI.x+UI.width/2,y:UI.y+UI.height/2,width:UIControl.tweenWidth,height:UIControl.tweenHeight,onComplete:willClose});
					willClose();
					break;
				case "btnclose":
					(doAct is Function)?param.length==2&&param!=null?doAct(param[1]):"":"";
					doAct = null;
					//rect.parent==null?"":rect.parent.removeChild(rect);
					// TweenMax.to(UI,UIControl.tweenDelay,{alpha:UIControl.tweenAlpha,x:UI.x+UI.width/2,y:UI.y+UI.height/2,width:UIControl.tweenWidth,height:UIControl.tweenHeight,onComplete:willClose});
					willClose();
					break;
				case "btnSubmit2":
					(doAct2 is Function)?doAct2(param2):"";
					/*if(rect!=null&&rect.parent!=null){
						rect.parent.removeChild(rect);
					}*/
					willClose(2);
					break;
			}
			
		}
		
		public function willClose(type:int=4):void{
			if(UI==null){
				return;
			}
			//			(doAct is Function)?param.length==2&&param!=null?doAct(param[1]):"":"";
			/*if(rect!=null&&rect.parent!=null){
				rect.parent.removeChild(rect);
			}*/
			//UI.visible=false;
			UI.removeEventListener(MouseEvent.MOUSE_UP,alertPaneHandler);
			UI.removeEventListener(Event.REMOVED_FROM_STAGE,REMOVEDHandler);
			if(null != UI.parent)
			{
				UI.parent.removeChild(UI);
			}
			if(type==2){
				doAct2=null;
				param2=null;
			}else{
				doAct=null;
				param=null;
			}
			
			UI = null;
		}
		
		private var _UIMcByType4:DisplayObject;
		public function get UIMcByType4():DisplayObject
		{
			if(null == _UIMcByType4)
			{
				_UIMcByType4 = lib.getswflink("game_login","pop_que_ren");
			}
			
			return _UIMcByType4;
		}
		
		
		private var _UIMcByType2:DisplayObject;
		public function get UIMcByType2():DisplayObject
		{
			if(null == _UIMcByType2)
			{
				_UIMcByType2 = lib.getswflink("game_login","pop_ti_shi");
				
			}
			
			if(null == _UIMcByType2)
			{
				_UIMcByType2 = lib.getswflink("game_login","pop_ti_shi");
			}
		
			return _UIMcByType2;
		}
		
		private var _lib:Gamelib;
		public function get lib():Gamelib
		{
			if(null == _lib)
			{
				_lib = new Gamelib();
			}
			
			return _lib;
		}
		
		public function REMOVEDHandler(e:Event):void{
			/*while(UI.numChildren){
				UI.removeChildAt(0);
			}*/
			UI.removeEventListener(MouseEvent.MOUSE_UP,alertPaneHandler);
			UI.removeEventListener(Event.REMOVED_FROM_STAGE,REMOVEDHandler);
		}
		
		private function alertAddedHandler(e:Event):void{
			UI.removeEventListener(Event.ADDED_TO_STAGE,alertAddedHandler);
			TweenMax.from(UI,UIControl.tweenDelay,{alpha:UIControl.tweenAlpha,width:UIControl.tweenWidth,height:UIControl.tweenHeight,x:UI.x+UI.width/2,y:UI.y+UI.height});
		}
		
	}
	
}