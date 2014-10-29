package ui.view.view7
{
	import common.config.PubData;
	import common.managers.Lang;
	
	import ui.frame.UIMovieClip;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import netc.Data;
	
	import scene.action.*;

	import scene.bin.GameSceneMain;
	import scene.body.Body;
	import scene.body.KingBody;
	import scene.event.HumanEvent;
	import scene.event.KingActionEnum;
	import scene.king.FightSource;
	import scene.king.IGameKing;
	import scene.king.SkinParam;
	import scene.kingname.KingNameParam;
	import scene.load.ShowLoadMap;
	import scene.manager.SceneManager;
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	import scene.winWeather.WinWeaterEffectByCloud;
	import scene.winWeather.WinWeaterEffectByFlyHuman;
	
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	
	
	public class UI_BiShaJi_Pet extends UIWindow
	{
		
		private var _objid:uint;
		
		private var _skillId:int;
		
		private var _indexId:int;
		
		public function reset(objid_:uint,skillId_:int):void
		{
			_objid = objid_;
			
			_skillId = skillId_;
		}
		
		public function UI_BiShaJi_Pet(DO:DisplayObject,objid_:uint,skillId_:int,indexId_:int)
		{
			
			//UIMovieClip.currentObjName=null;
			
			_objid = objid_;
			
			_skillId = skillId_;
			
			_indexId = indexId_;
			
			super(DO, null, 1, false);
			
			this.mouseEnabled = this.mouseChildren = false;
			
		}
		
		public function get objid():uint
		{
			return _objid;
		}

		override protected function init():void
		{	
			setPosNow();
			
			MovieClip(mc).gotoAndPlay(2);
			mc["mc"].gotoAndStop(Prof);
			
			setTimeout(end,3000);
			
			
		}
		
		public function get Prof():int
		{
			//test
			//return 3;
			
			//404111(初级)、404112(高级)、404131(初级)、404132(高级)、
			//404121(初级)、404122(高级)、404141(初级)、404142(高级)、
			//404151(初级)、404152(高级)
			
			var profList:Array = Lang.getLabelArr("skill_bishaji_pet");
			
			var jLen:int = profList.length;			
			for(var j:int=0;j<jLen;j++)
			{
				if(this._skillId.toString() == profList[j])
				{
					return j+1;
				}
			
			}

			return 1;
		}
		
		public function isGaoJi():Boolean
		{
			//404111(初级)、404112(高级)、404131(初级)、
			//404132(高级)、404121(初级)、404122(高级)、
			//404141(初级)、404142(高级)、404151(初级)、
			//404152(高级)
			
			var gaojiList:Array = Lang.getLabelArr("skill_bishaji_pet_isGaoJi");
					
			if(1 == gaojiList[Prof-1])
			{
				return true;
			}
			
			return false;
		}
				
		public function setPosNow():void
		{
			
			//层级
			var win_UI_index:int=PubData.AlertUI.getChildIndex(UI_Mrb.instance);
			
						
			PubData.AlertUI.addChildAt(this, win_UI_index + 1);
			
			//
			var enemyKing:IGameKing = SceneManager.instance.GetKing_Core(objid);
			
			if(null == enemyKing)
			{
				this.end();
				return;
			}
			
			var enemyGP:Point=new Point(enemyKing.x, enemyKing.y);
			enemyGP=enemyKing.globalToLocal(enemyGP);
			var enemyLP:Point=new Point(enemyKing.x - enemyGP.x, enemyKing.y - enemyGP.y);
			//
			//setPos
			this.x=enemyLP.x;
			this.y=enemyLP.y - Action.instance.fight.GetRoleHeight(enemyKing) + KingNameParam.MenuHeadPoint.y;
			
			
			
			//光环
			
			
			Action.instance.biShaJi.Update(objid,true,isGaoJi());
			
		}
		
		public function end():void
		{	
			
			UI_BiShaJi_Pet_Map.Pool(this);
			
			this.winClose();
		}
		
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		
		
		
	}
}