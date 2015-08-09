package ui.view.view2.other{
	import common.config.xmlres.XmlRes;
	
	import common.utils.clock.GameClock;
	
	import ui.view.view6.GameAlertNotTiShi;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import ui.frame.UIMovieClip;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.*;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import common.config.GameIni;
	
	import engine.load.GamelibS;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructItemAttr2;
	
	import common.utils.CtrlFactory;
	
	import ui.frame.UIActMap;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	import ui.view.view1.newFunction.FunJudge;
	import ui.base.beibao.BeiBao;
	import ui.view.view2.help.Help;
	import ui.base.npc.NpcShop;
	
	import common.managers.Lang;
	import world.WorldEvent;


	/**
	 * 界面显示属性上下漂浮
	 * @author andy
	 * @date   2012-08-30
	 */
	public final class ShowAtt {
		//属性集合
		private var vecAtt:Vector.<StructItemAttr2>;
		//漂浮容器
		private var mc_content:Sprite;
		//文本
		private var arrTxt:Vector.<Sprite>;
		//文本初始数量 暂定漂浮一次10个
		private const TXT_COUNT:int=10;
		//
		private var index:int=0;
		//
		private var startX:int=0;
		//
		private var startY:int=0;
		//
		private var flowHeiht:int=0;
		
		private static var _instance:ShowAtt;
		public static function getInstance():ShowAtt{
			if(_instance==null)
				_instance=new ShowAtt();
			return _instance;
		}
		public function ShowAtt() {
			init();
		}

		/**
		 *	属性飘字
		 *  @param data     属性
		 *  @param mc       出现的面板
		 *  @param startX   起始X坐标
		 *  @param startY   起始Y坐标
		 *  @param ht       漂浮高度【往上飘填写负数】
		 */
		public function show(data:Vector.<StructItemAttr2>,mc:Sprite,startX:int,startY:int,ht:int):void{
			if(data==null||data.length==0)return;
			if(mc==null)return;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK__SECOND200,coolTime);
			vecAtt=data;
			index=0;
			while(mc_content.numChildren>0)mc_content.removeChildAt(0);
			mc_content.x=startX;
			mc_content.y=startY;
			flowHeiht=ht;
			mc.addChild(mc_content);
			
			GameClock.instance.addEventListener(WorldEvent.CLOCK__SECOND200,coolTime);
		}
		/**
		 *	逐个显示 
		 */
		private function coolTime(we:WorldEvent):void{
			if(index==vecAtt.length){
				GameClock.instance.removeEventListener(WorldEvent.CLOCK__SECOND200,coolTime);
				index=0;
				return;
				
			}
			while(arrTxt[index].numChildren>0) arrTxt[index].removeChildAt(0);
			//属性名字
			var sprite:Sprite=getAttNameMc(vecAtt[index].attrIndex);
			arrTxt[index].addChild(sprite);
			//加号
			sprite=getAddMc(vecAtt[index].attrIndex);
			sprite.x=arrTxt[index].width;
			arrTxt[index].addChild(sprite);
			//数字
			sprite=getNumberMc(vecAtt[index].attrIndex,vecAtt[index].attrValue);
			sprite.x=arrTxt[index].width;
			arrTxt[index].addChild(sprite);
			
			mc_content.addChild(arrTxt[index]);
			//如果已经在移动，先删除
			TweenLite.killTweensOf(arrTxt[index]);
			arrTxt[index].x=0;
			arrTxt[index].y=0;
			arrTxt[index].alpha=1;
			TweenLite.to(arrTxt[index],2,{alpha:0,y:flowHeiht});
			index++;
		}
		
		/**
		 *	得到属性 
		 */
		private function getAttNameMc(itemIndex:int):Sprite{
			var ret:Sprite;
			switch(itemIndex){
				case 1:
					ret=GamelibS.getswflink("game_index","lvlup_life_nc") as Sprite;
					break;
				case 5:
					ret=GamelibS.getswflink("game_index","lvlup_attack_nc") as Sprite;
					break;
				case 6:
					ret=GamelibS.getswflink("game_index","lvlup_defend_nc") as Sprite;
					break;
				case 7:
					ret=GamelibS.getswflink("game_index","lvlup_mingzhong_nc") as Sprite;
					break;
				case 8:
					ret=GamelibS.getswflink("game_index","lvlup_attack_miss_nc") as Sprite;
					break;
				case 9:
					ret=GamelibS.getswflink("game_index","lvlup_baoji_nc") as Sprite;
					break;
				case 10:
					ret=GamelibS.getswflink("game_index","lvlup_renxing_nc") as Sprite;
					break;
				case 51:
					ret=GamelibS.getswflink("game_index","lvlup_pojia_nc") as Sprite;
					break;
				case 100:
					ret=GamelibS.getswflink("game_index","lian_gu_zi") as Sprite;
					break;
				default :
					ret=new Sprite();
					break;
			}
			if(ret==null)ret=new Sprite();
			return ret;
		}
		/**
		 *	得到属性 
		 */
		private function getAddMc(itemIndex:int):Sprite{
			var ret:Sprite;
			if(itemIndex==100)
				ret=GamelibS.getswflink("game_index","lian_gu_na") as Sprite;
			else
				ret=GamelibS.getswflink("game_index","lvlup_life_na") as Sprite;
			return ret;
		}
		/**
		 *	得到数字 
		 */
		private function getNumberMc(itemIndex:int,itemValue:int):Sprite{
			var ret:Sprite=new Sprite();
			var numStr:String=itemValue.toString();
			var child:Sprite;
			for(var i:int=0;i<numStr.length;i++){
				if(itemIndex==100)
					child=GamelibS.getswflink("game_index","lian_gu_n"+numStr.charAt(i)) as Sprite;
				else
					child=GamelibS.getswflink("game_index","lvlup_life_n"+numStr.charAt(i)) as Sprite;
				child.x=i*11;
				ret.addChild(child);
			}
			return ret;
		}
		
		/**
		 *	得到战力值 
		 */
		public function getZhanLi(itemValue:int):StructItemAttr2{
			var item:StructItemAttr2=new StructItemAttr2();
			//战力值 自定义的编号
			item.attrIndex=100;
			item.attrValue=itemValue;
			return item;
		}
		private function init():void{
			mc_content=new Sprite();
			arrTxt=new Vector.<Sprite>;
			var txt:Sprite;
			for(var i:int=0;i<TXT_COUNT;i++){
				txt=new Sprite();
	
				arrTxt.push(txt);
			}
			
		}
		
	}
}




