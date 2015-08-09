package ui.base.huodong
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Action_DescResModel;
	import common.config.xmlres.server.Pub_InstanceResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructDiGongBossState2;
	import netc.packets2.StructLimitInfo2;
	
	import nets.packets.PacketCSActWeekOnline;
	import nets.packets.PacketCSEntryBossAction;
	import nets.packets.PacketCSGetDiGongBossState;
	import nets.packets.PacketCSOpenActTimeWaring;
	import nets.packets.PacketCSSInstanceStart;
	import nets.packets.PacketSCGetDiGongBossState;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIMovieClip;
	import ui.view.view1.fuben.FuBenDuiWu;
	import ui.view.view2.NewMap.DiGongMap;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.view.view2.motianwanjie.MoTianWanJie;
	
	import world.FileManager;

	public class DiGongBoss extends UIMovieClip
	{
		private static const BOSS_ID_START:int=30330310;
		public static const BOSS_LIST:Object={
		b0: BOSS_ID_START,
		 b1: BOSS_ID_START + 1,
		  b2: BOSS_ID_START + 2, 
		  b3: BOSS_ID_START + 3, 
		  b4: BOSS_ID_START + 4, 
		  b5: BOSS_ID_START + 5
		  };
		private var mc:Sprite;
		private var mc_content:Sprite;
		private var _bossRefreshTimeList:Array=null;

		public function DiGongBoss()
		{
			super();
			//地宫boss
		}
		private var showSort:int=0;

		public function setUi(ui:Sprite, _mc_content:Sprite, m_sort:int=0):void
		{
			showSort=m_sort;
			mc=ui;
			mc_content=_mc_content
			if (mc != null)
			{
				this.getBossState();
			}
			//
//			var vo:PacketCSActWeekOnline = new PacketCSActWeekOnline();
//			DataKey.instance.send(vo);
		}
		private static var _instance:DiGongBoss;

		public static function getInstance():DiGongBoss
		{
			if (_instance == null)
				_instance=new DiGongBoss();
			return _instance;
		}

		public function get is_m_ui_null():Boolean
		{
			if (null == mc)
			{
				return true;
			}

			return false;
		}

		public function mcHandler(target:Object):void
		{

			if (null == target)
			{
				return;
			}

			var name:String=target.name;
			if (name.indexOf("dbtn") >= 0)
			{
				int(name.replace("dbtn", ""));
				return;
			}
			if (name.indexOf("") >= 0)
			{
				return;
			}
//			switch(name) {
//				case "cbtn2":
//					//					QianDaoPage_2.getInstance().setUi(mc);
//					break;
//				case "cbtn3":
//					break;
//			}
		}
		private var listStatsBoss:Vector.<StructDiGongBossState2>;

		public function onGetBossStateBack(p:PacketSCGetDiGongBossState):void
		{
			if (this.mc == null)
				return;
			if ((this.mc as MovieClip).currentFrame == 1||(this.mc as MovieClip).currentFrame == 2)
				return;
			listStatsBoss=p.arrItemboss_list;
			m_bossArr.forEach(bossItemHuoDongStates)
		}

		/**
		 *此函数只设置状态
		 * @param itemData
		 * @param index
		 * @param arr
		 *
		 */
		private function bossItemHuoDongStates(itemData:Object, index:int, arr:Vector.<Object>):void
		{
			var sprite:*=ItemManager.instance().getHuoDongTaskAndDiGongBossItem(itemData["action_id"]);
			var resModel:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(itemData["action_id"]) as Pub_Action_DescResModel;
			var bossStates:StructDiGongBossState2;
			var time_cp:int=0;
			for (var i:int=0; i < listStatsBoss.length; i++)
			{
				bossStates=listStatsBoss[i] as StructDiGongBossState2;//服务端发的状态
				if (bossStates.bossid == resModel.action_para1)
				{ //action_para1为活动表中的boss  id
					time_cp=bossStates.state; //1:刷出 2:被击杀
					break;
				}
			}
			sprite["kai_qi1"].visible=false; //未
			sprite["kai_qi2"].visible=false; //参加活动
			sprite["kai_qi3"].visible=false; //已刷新
			sprite["kai_qi4"].visible=false; //多少级可参加
			StringUtils.setEnable(sprite);
			if (1 == time_cp)
			{
				sprite["kai_qi3"].visible=true; //已刷新
				sprite["kai_qi2"].visible=true; //前往击杀
				sprite["txt_killer"].htmlText="";
			}
			else if (2 == time_cp)
			{
				sprite["kai_qi4"].visible=true; //已击杀
				sprite["txt_killer"].htmlText=bossStates.killer_name;
			}

			else
			{
				sprite["txt_killer"].htmlText="";
				sprite["kai_qi1"].visible=true; //为刷新
				StringUtils.setUnEnable(sprite, true);
			}
		}

		public function viewSort(a:Object, b:Object):int
		{
			var a_view_sort_id:int=parseInt(a.view_sort_id);
			var b_view_sort_id:int=parseInt(b.view_sort_id);

			//if(a.view_sort_id > b.view_sort_id)
			if (a_view_sort_id > b_view_sort_id)
			{
				return 1;
			}

			//if(a.view_sort_id < b.view_sort_id)
			if (a_view_sort_id < b_view_sort_id)
			{
				return -1;
			}
			//原样排序
			return 0;
		}
		/**
		 * 获取boss状态列表
		 *
		 */
		private function getBossState():void
		{
			//			showDayRenWu();
			mc["sp"].visible=false;
			mc["sp2"].visible=true;
			//清除列表	
			HuoDong.instance().clearMcContent();
			showBossList();
			var p:PacketCSGetDiGongBossState=new PacketCSGetDiGongBossState();
			DataKey.instance.send(p);
		}
		private var  m_bossArr:Vector.<Object>;
		private function showBossList():void 
		{
			var bossArr:Vector.<Object>;
			if (showSort == 0)
			{
				bossArr=Data.huoDong.bossHuoDong();
			}
			else
			{
				bossArr=Data.huoDong.bossHuoDong(showSort);
			}
			var len:int=bossArr.length;
			bossArr.sort(viewSort);
			bossArr.forEach(callbackBossItemHuoDong)
			CtrlFactory.getUIShow().showList2(mc_content, 1, 417, 25);
			m_bossArr=bossArr;
			//陈营过滤
			//需求补充：
			//在活动表中增加“需求阵营”字段action_camp。
			//填0为无阵营需求，填其他为对应阵营玩家才能看到
			mc["sp2"].source=mc_content;
			mc["sp2"].position=0;
			mc["sp2"].x=50;
			mc["sp2"].y=112;
			//mc_content.x=10;
			mc_content.x=0;
			var item1:DisplayObject=mc_content.getChildByName("item1");

			if (null == item1)
			{
				return;
			}

			HuoDong.instance().itemSelected(item1);
			HuoDong.instance().itemSelectedOther(item1);

		}
		//		callbackByDuoRenHuoDong
		private var bossItemSpritArr:Array=[];

		private function callbackBossItemHuoDong(itemData:Object, index:int, arr:Vector.<Object>):void
		{
			var sprite:*=ItemManager.instance().getHuoDongTaskAndDiGongBossItem(itemData["action_id"]);
			super.itemEvent(sprite, itemData, true);
			if (sprite.hasOwnProperty("back"))
			{
				sprite["back"].mouseEnabled=false;
				sprite["back"].visible=index%2==0;
			}
			

			sprite["txt_killer"].mouseEnabled=false;
			sprite['txt_limit'].mouseEnabled=false;
			sprite['txt_Condition'].mouseEnabled=false;
			sprite["kai_qi3"].mouseEnabled=false;
			sprite["kai_qi4"].mouseEnabled=false;
			sprite["kai_qi1"].mouseEnabled=false;
			sprite["uil"].mouseEnabled=sprite["uil"].mouseChildren=false;
			sprite["bg"].mouseEnabled=false;
			sprite["name"]="item" + (index + 1);


			var resModel:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(itemData["action_id"]) as Pub_Action_DescResModel;
			if (showSort == 0 || resModel.sort == showSort)
			{
				sprite["data"]=resModel;

				if (sprite.hasOwnProperty("bg"))
				{
					sprite["bg"].mouseEnabled=false;
				}

				//			sprite["txt_action_name"].text=itemData["action_name"];
				//			sprite["txt_action_name"].mouseEnabled=false;
				sprite["txt_Level"].htmlText=resModel.action_minlevel;
				sprite["txt_Condition"].text=resModel.action_prize; //刷新地图
				sprite["txt_limit"].text=resModel.action_date; //刷新间隔

//				sprite["uil"].source=FileManager.instance.getActionDescIconById(resModel.res_id);
				ImageUtils.replaceImage(sprite,sprite['uil'],FileManager.instance.getActionDescIconById(resModel.res_id));
				sprite["uil"].mouseEnabled=false;

				sprite["kai_qi1"].visible=false; //未
				sprite["kai_qi2"].visible=false; //参加活动
				sprite["kai_qi3"].visible=false; //已刷新
				sprite["kai_qi4"].visible=false; //多少级可参加
				StringUtils.setEnable(sprite);
//			sprite['txt_Condition'].htmlText=itemData["action_prize"];;
				bossItemSpritArr.push(sprite);

				sprite.removeEventListener(MouseEvent.MOUSE_OVER, HuoDong.instance().itemOverListenerTuiJian);
				sprite.removeEventListener(MouseEvent.MOUSE_OUT, HuoDong.instance().itemOutListenerTuiJian);
				sprite.removeEventListener(MouseEvent.CLICK, itemClickByBossHuoDong2);
				sprite["kai_qi2"].removeEventListener(MouseEvent.CLICK, itemClickByBossHuoDong2);
				sprite["kai_qi2"].addEventListener(MouseEvent.CLICK, itemClickByBossHuoDong2);
				mc_content.addChild(sprite);
			}
		}

		public function itemClickByBossHuoDong2(e:MouseEvent):void
		{
			
			var sprite:*=e.target.parent;

			var action_jointype:String=sprite["data"]["action_jointype"];

			if ("0" == action_jointype)
			{
				//nothing
				//该活动到时间会自动参加，保持在线即可
				Lang.showMsg({type: 4, msg: Lang.getLabel("20048_HuoDongJoin")});

			}
			else if ("1" == action_jointype)
			{
				//寻路
				if (sprite["data"]["sort"] == 3||sprite["data"]["sort"] == 7)
				{
					GameAutoPath.seek(sprite["data"]["action_para2"]);
				}
				else
				{
					GameAutoPath.seek(sprite["data"]["action_para1"]);
				}
			}
			else if ("2" == action_jointype)
			{
				//副本id
				var instance_id:int=sprite["data"]["action_para1"]
				FuBenDuiWu.groupid=instance_id;

				//instancesort:int;//副本类型(1单人，2多人)
				var instance_model:Pub_InstanceResModel=XmlManager.localres.getInstanceXml.getResPath(instance_id) as Pub_InstanceResModel;

				if (0 == instance_model.instancesort || 1 == instance_model.instancesort)
				{
					//单人副本快速进入
					var client1:PacketCSSInstanceStart=new PacketCSSInstanceStart();
					client1.map_id=instance_id;
					DataKey.instance.send(client1);

				}
				else
				{
					FuBenDuiWu.instance.open(true);
				}


			}
			else if ("3" == action_jointype)
			{
				MoTianWanJie.instance().open();

			}
			else if ("4" == action_jointype)
			{
				var cs:PacketCSOpenActTimeWaring=new PacketCSOpenActTimeWaring();
				cs.act_id=parseInt(sprite["data"]["action_id"]);
				cs.seek_id=parseInt(sprite["data"]["action_para1"]);
				cs.token=0;
				DataKey.instance.send(cs);

			}
			else if ("5" == action_jointype)
			{
				var cs5:PacketCSEntryBossAction=new PacketCSEntryBossAction();
				cs5.action_id=parseInt(sprite["data"]["action_para1"]);

				DataKey.instance.send(cs5);

			}
			else if ("6" == action_jointype)
			{
				//				ZhenYing.instance().requestCamp();

			}
			else if ("14" == action_jointype)
			{

				DiGongMap.instance().open(true);

			}


		}
		////////////////////////////////////////地宫boss/////////////////////////////////////

	}
}
