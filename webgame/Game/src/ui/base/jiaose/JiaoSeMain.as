package ui.base.jiaose
{

	import common.managers.Lang;
	
	import scene.manager.SceneManager;
	
	import ui.frame.UIPanel;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.jingjie.JingJiePanel;
	import ui.view.newFunction.FunJudge;
	import ui.view.view4.shenbing.Shenbing;
	import ui.view.view4.soar.SoarPanel;

	/**
	 *	角色主窗体
	 *  andy 2013-12-17
	 */
	public class JiaoSeMain extends UIWindow
	{

		//curMc
		private var panel:UIPanel;
		//刷新面板
		private var panelReload:Function;
		//由于菜单切换太快，导致帧上元件为空，特此控制两次点击时间
		private var delayTime:int=1;
		//
		private var date:Date=null;
		//
		private var childIndex:int=0;

		private static var _instance:JiaoSeMain;


		public static function getInstance():JiaoSeMain
		{
			if (_instance == null)
			{
				_instance=new JiaoSeMain();
			}
			return _instance;
		}

		public function JiaoSeMain()
		{
			this.doubleClickEnabled=true;
			super(this.getLink(WindowName.win_jue_se_main));
		}

		override public function get width():Number
		{
			return 580;
		}

		override public function get height():Number
		{
			return 515;
		}
		private var callBackFunc:Function=null;

		public function setType(v:int, must:Boolean=false, f:Function=null, childMenu:int=0):void
		{
			type=v;
			callBackFunc=f;
			childIndex=childMenu;
			super.open(must);
		}

		override protected function openFunction():void
		{
			init();
		}

		override protected function init():void
		{	
			super.init();
			super.blmBtn=5;
			if(20220031==SceneManager.instance.currentMapId){
				this.x=70;
			}
			if (date == null)
				date=new Date();
			if (type == 0)
				type=1;
			mc["m_role"].mouseEnabled=mc["m_role"].mouseChildren=false;
			mc["m_role"].visible=false;

//			Lang.addTip(mc["cbtn1"], "jiaose_1", 60);
//			Lang.addTip(mc["cbtn2"], "jiaose_2", 60);
//			Lang.addTip(mc["cbtn3"], "jiaose_3", 60);
//			Lang.addTip(mc["cbtn4"], "jiaose_4", 60);
//			Lang.addTip(mc["cbtn5"], "jiaose_5", 60);
			mc["mc_tip"].visible=false;
			mcHandler({name: "cbtn" + type});

		}

		override protected function mcDoubleClickHandler(target:Object):void
		{
			if (panel != null)
			{
				panel.mcDoubleClickHandler(target);
			}
		}

		override public function mcHandler(target:Object):void
		{
			if (date.time - delayTime < 200)
			{
				return;
			}
			else
				delayTime=date.time;

			var name:String=target.name;
			//panel事件
			if (name.indexOf("cbtn") == -1)
			{
				if (panel != null)
					panel.mcHandler(target);
				return;
			}

			if (name == "cbtn2" && FunJudge.judgeByName(WindowName.win_shen_bing, true) == false)
			{
				//坐骑30级开放  ////改为神兵 2014年8月12日 19:32:40   25级开放
				super.mcHandler({name: "cbtn" + type});
				return;
			}
//			else if (name == "cbtn3" && FunJudge.judgeByName(WindowName.win_tian_shu, true) == false)
//			{
//				//天书70级开放
//			
////				super.mcHandler({name: "cbtn" + type});
//				return;
//			}
			else if (name == "cbtn4" && FunJudge.judgeByName(WindowName.win_du_jie, true) == false)
			{
				//渡劫80级开放  2014年8月11日 15:07:00改成转生功能 hpt
				super.mcHandler({name: "cbtn" + type});
				return;
			}
			else if (name == "cbtn5" && FunJudge.judgeByName(WindowName.win_xing_jie, true) == false)
			{
				//星界80级开放
//				super.mcHandler({name: "cbtn" + type});
				return;
			}
			else
			{

			}
			super.mcHandler(target);
			if (panel != null && panel.parent != null)
				panel.parent.removeChild(panel);

			type=int(name.replace("cbtn", ""));
			mc["m_role"].visible=type == 1 ? true : false;
			switch (name)
			{
				case "cbtn1":
					//角色
					panelReload=JiaoSe.getInstance;
					break;
				case "cbtn2":
					
					//坐骑
					//panelReload=ZuoQiMain.getInstance;
					//神兵
					//panelReload=Shenbing.getInstance;
					break;
				case "cbtn4":
					//渡劫 转生
					panelReload=SoarPanel.getInstance;
					break;
				case "cbtn5":
					//星界 龙脉
					panelReload=JingJiePanel.instance;
					break;
				default:
					break;
			}
			panel=panelReload();
			if (this.mc["mc_content"].numChildren == 0 || panel.mc == null)
			{
				panelReload(true);
			}
			panel.x=0;
			panel.y=0;
			panel.type=childIndex;
			panel.init();
			this.mc["mc_content"].addChild(panel);
		}



		override protected function windowClose():void
		{
			super.windowClose();
			if (panel != null)
				panel.windowClose();

		}

		override public function getID():int
		{
			return 1000;
		}

		public function getPanel():UIPanel
		{
			return panel;
		}
	}
}
