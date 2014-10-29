package com.bellaxu.mgr
{
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.util.StageUtil;
	
	import common.config.PubData;
	
	import flash.events.MouseEvent;
	
	import netc.Data;
	
	import scene.action.Action;
	import scene.action.FightAction;
	import scene.action.PathAction;
	import scene.action.hangup.GamePlugIns;
	import scene.human.GameLocalHuman;
	import scene.king.King;
	import scene.manager.SceneManager;
	import scene.utils.MapCl;
	
	import world.WorldPoint;

	/**
	 * 层管理
	 * @author BellaXu
	 */
	public class LayerMgr
	{
		public static function init():void
		{
			//初始化地图层
			LayerDef.effectLayer.mouseChildren = LayerDef.effectLayer.mouseEnabled = false;
			LayerDef.mapLayer.addChild(LayerDef.gridLayer);
			LayerDef.mapLayer.addChild(LayerDef.dropLayer);
			LayerDef.mapLayer.addChild(LayerDef.bodyLayer);
			LayerDef.mapLayer.addChild(LayerDef.effectLayer);
			LayerDef.mapLayer.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			LayerDef.gridLayer.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
			//初始化界面层
			LayerDef.weatherLayer.mouseEnabled = LayerDef.weatherLayer.mouseChildren = false;
			LayerDef.tipLayer.mouseEnabled = LayerDef.tipLayer.mouseChildren = false;
			LayerDef.loadLayer.mouseEnabled = LayerDef.loadLayer.mouseChildren = true;
			LayerDef.viewLayer.mouseEnabled = false;
			LayerDef.uiLayer.mouseEnabled = false;
			LayerDef.viewLayer.addChild(LayerDef.weatherLayer);
			LayerDef.viewLayer.addChild(LayerDef.uiLayer);
			LayerDef.viewLayer.addChild(LayerDef.alertLayer);
			LayerDef.viewLayer.addChild(LayerDef.tipLayer);
			LayerDef.viewLayer.addChild(LayerDef.loadLayer);
			LayerDef.viewLayer.addChild(LayerDef.storyLayer);
			
			//按层深度添加，精简至2层
			StageUtil.addChildAt(LayerDef.mapLayer, 0);
			StageUtil.addChildAt(LayerDef.viewLayer, 1);
		}
		
		public static function onMouseDown(e:MouseEvent):void
		{
			StageUtil.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			if(e.target is King&&PubData.canRightKey==false)
				return;
			if (GamePlugIns.getInstance().running)
				return;
			if (Data.myKing.king.isBooth)//摆摊中不能移动
				return;
			if ((Data.myKing.king as King).hasBuff(2))//眩晕
				return;
//			if (Data.myKing.king.getSkin().getHeadName().isAutoPath)
//			{
//				return;
//			}
			if (FightAction.isSkillPlaying())//技能动作播放期间，不能移动
				return;
			if (e.shiftKey)
			{
				Action.instance.fight.basicAttack();
				return;
			}
			
//			var wp:WorldPoint = SceneManager.instance.getIndexUI_GameMap_MouseGridPoint();
//			if (PathAction.moveTo(wp)==false)
//				return;
			Data.myKing.isLeftMouseDown = true;
			(Data.myKing.king as GameLocalHuman).stopAction();
			(Data.myKing.king as GameLocalHuman).moveToMouse(true); //微端为FALSE;
			(Data.myKing.king as GameLocalHuman).btFollowMouse = true;
			(Data.myKing.king as GameLocalHuman).btUseRun = true; //微端使用flase;
			
		}
		
		private static function onMouseUp(e :MouseEvent) :void
		{
			StageUtil.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//			if (e.shiftKey){
////				Action.instance.fight.basicAttack();
//				return;
//			}
			Data.myKing.isLeftMouseDown = false;
			(Data.myKing.king as GameLocalHuman).btFollowMouse = false;
		}
	}
}