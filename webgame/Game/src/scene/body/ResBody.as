package scene.body
{
	import com.bellaxu.debug.Debug;
	import com.bellaxu.def.DepthDef;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ModelResModel;
	
	import engine.event.DispatchEvent;
	
	import flash.display.Sprite;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.PacketSCResEnterGrid2;
	import netc.packets2.PacketSCResNameUpdate2;
	import netc.packets2.StructTaskList2;
	
	import nets.packets.PacketSCResChangeOutlook;
	import nets.packets.PacketSCResEnterGrid;
	import nets.packets.PacketSCResNameUpdate;
	
	import scene.event.KingActionEnum;
	import scene.human.GameRes;
	import scene.king.IGameKing;
	import scene.king.ResInfo;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect11;
	import scene.skill2.SkillEffectManager;
	import scene.utils.MapCl;
	
	import ui.base.renwu.MissionMain;
	import ui.base.renwu.renwuEvent;
	
	import world.FileManager;
	import world.IWorld;
	import world.WorldFactory;
	import world.model.file.BeingFilePath;
	import world.type.ItemType;
	import world.type.WorldType;

	public class ResBody
	{
		/**
		 * 资源临时列表，主要为性能和做任务考虑
		 */
		private var _resList:Vector.<ResInfo>;

		public function ResBody()
		{
			//资源进入视野
			DataKey.instance.register(PacketSCResEnterGrid.id, SCResEnterGrid);
			//资源形象改变
			DataKey.instance.register(PacketSCResChangeOutlook.id, SCResChangeOutlook);
			//资源名称改变			
			DataKey.instance.register(PacketSCResNameUpdate.id, CResDetail);

			//任务改变
			renwuEvent.instance.addEventListener(renwuEvent.USERTASKCHANGE, taskChange);
		}

		public function get resList():Vector.<ResInfo>
		{
			if (null == _resList)
			{
				_resList=new Vector.<ResInfo>();
			}

			return _resList;
		}

		private function CResDetail(p:PacketSCResNameUpdate2):void
		{
			var w:IWorld=SceneManager.instance.GetObj_Core(p.resid);

			if (null == w)
			{
				return;
			}

			var res:GameRes=w as GameRes;

			if (null != res)
			{
				res.setKingName=p.newname;

			}
		}

		private function SCResEnterGrid(p:PacketSCResEnterGrid2):void
		{
			var isNew:Boolean=false;

			var res:GameRes=SceneManager.instance.GetKing_Core(p.objid) as GameRes;

			//职业和性别同怪物
			var metier:int=0;
			var sex:int=0;

	//项目转换		var pmrm:Pub_ModelResModel = Lib.getObj(LibDef.PUB_MODEL, p.modeid.toString());
var pmrm:Pub_ModelResModel=XmlManager.localres.PubModelXml.getResPath(p.modeid) as Pub_ModelResModel;
			if (null == res)
			{
				isNew=true;
			}

			if (isNew && pmrm != null)
			{

				res=WorldFactory.createBeing(ItemType.PICK) as GameRes;

				//data
				res.name=WorldType.WORLD + p.objid;
				res.name2=ItemType.PICK + p.objid;

				//pmrm.model_name, 
				var res_name:String = "";
				if("" == p.res_name)
				{
					res_name = pmrm.model_name;
				}else
				{
					res_name= p.res_name;
				}
				
				res.setKingData(p.objid, p.objid, res_name, sex, metier, 1, 1, 1, Data.myKing.campid, -1, p.posx, p.posy, -1, "", -1, -1);

				//
				SceneManager.instance.AddKing_Core(res);
				
				if (1 == pmrm.floor)
				{
					//上层
					res.depthPri=DepthDef.TOP;
					
				}
				else if (2 == pmrm.floor)
				{
					//中层
					res.depthPri=DepthDef.NORMAL;
					
				}
				else
				{
					//下层
					res.depthPri=DepthDef.BOTTOM;
				}
				

				//
				res.setSelectable=true;
				res.distance=pmrm.oper_distance;
				res.cursor=pmrm.cursor_id;
				res.needtime=pmrm.oper_time;
				res.dbID=pmrm.model_id;
				res.intonate_desc=pmrm.intonate_desc;

				//res.setKingName=p.res_name;
				res.setSex=sex;
				res.setMetier=metier;
				res.setHp=1;
				res.setCamp=Data.myKing.campid;

				var bfp:BeingFilePath=FileManager.instance.getMainByResId(pmrm.res_id);

				res.roleAngle=p.direct;

				var X:int=MapCl.getFXtoInt(p.direct);

				res.roleFX="F" + X.toString();

				//				
				res.setKingSkin(bfp);

				res.checkMouseEnable();
				
				var info:ResInfo=new ResInfo(p.objid, pmrm.model_id, pmrm.task_id+"", pmrm.task_step);
				resList.push(info);
				//task_id为空，可以直接采集,如天将元宝
				if (pmrm.task_id+"" == "")
				{
					res.getByPick().picking=true;
					res.getSkin().getHeadName().showTxtNameAndBloodBar();
				}
				else
				{
					res.mouseEnabled=res.mouseChildren=false;
					res.getByPick().picking=false;
					res.getSkin().getHeadName().hideTxtNameAndBloodBar();
					setClick(info, res);
				}

			}
			else if (res != null)
			{
				//
				res.setKingData(p.objid, p.objid, p.res_name, sex, metier, 1, 1, 1, Data.myKing.campid, -1, p.posx, p.posy, -1, "", -1, -1);
			
			}

		}

		private function SCResChangeOutlook(p:PacketSCResChangeOutlook):void
		{
			var res:GameRes=SceneManager.instance.GetKing_Core(p.objid) as GameRes;
			if (res != null)
			{
				//var bfp:BeingFilePath = new BeingFilePath();

				var bfp:BeingFilePath=FileManager.instance.getMainByResId(p.outlook);
				res.roleZT=KingActionEnum.DJ;

				res.setKingSkin(bfp);
			}
		}

		/**
		 * 不需要派发事件
		 */
		public function deleteResListByObjid(objid:int):void
		{
			var len:int=this.resList.length;

			for (var i:int=0; i < len; i++)
			{
				if (objid == this.resList[i].objid)
				{
					this.resList.splice(i, 1);

					return;
				}
			}
		}

		private function setClick(res:ResInfo, gr:GameRes=null):void
		{
			if (MissionMain.taskList == null)
				return;

			try
			{
				var taskList_:Vector.<StructTaskList2> = MissionMain.taskList;
				var len:int=taskList_.length;
				
				var arrTask:Array=[];
				for (var i:int=0; i < len; i++)
				{
					//2012-09-06 andy 多个任务对应一个采集资源 taskId由原来的int转成字符串
					arrTask=res.taskid.split(",");
					for each (var taskId:String in arrTask)
					{
						if (int(taskId) == taskList_[i].taskid && taskList_[i].status == 2 && taskList_[i].arrItemstate[res.taskstep - 1].state == 0)
						{
							if (gr == null)
							{
								gr=SceneManager.instance.GetKing_Core(res.objid) as GameRes;
							}
							if (gr != null)
							{
								//gr.mouseEnabled = true;
								gr.mouseEnabled=gr.mouseChildren=true;

								//
								gr.getByPick().picking=true;
								gr.getSkin().getHeadName().showTxtNameAndBloodBar();

								//特效
								var se_caiji:SkillEffect11=new SkillEffect11();
								se_caiji.setData(gr.objid, "caiJi");
								SkillEffectManager.instance.send(se_caiji);

							}
						}
					}
				}
			}
			catch (exc:Error)
			{
				Debug.warn(exc.message);
			}
		}

		private function loseEffect(gr:IGameKing):void
		{
//			var len:int=gr.getSkin().effectUp.numChildren;
			var m_effectUp:Sprite=gr.getSkin().effectUp;

			var se_caiji:SkillEffect11;
//有可能：RangeError: Error 0002006: 提供的索引超出范围   所以要实时取numChildren值
//			for (var i:int=0; i < len; i++)
			for (var i:int=0; i < m_effectUp.numChildren; i++)
			{
				if (gr.getSkin().effectUp.getChildAt(i) as SkillEffect11)
				{
					se_caiji=gr.getSkin().effectUp.getChildAt(i) as SkillEffect11;

					if ("caiJi" == se_caiji.path)
					{
						se_caiji.Four_MoveComplete();
					}
				}
			}
		}

		private function taskChange(e:DispatchEvent):void
		{
			if (_resList == null)
				return;

			var len:int=_resList.length;
			for (var i:int=0; i < len; i++)
			{
				if (_resList[i].taskid != null && _resList[i].taskid != "" && _resList[i].taskid != "0")
				{

					var gr:GameRes=(SceneManager.instance.GetKing_Core(_resList[i].objid) as GameRes);
					if (null == gr)
						continue;
					gr.mouseEnabled=gr.mouseChildren=false;
					//
					gr.getByPick().picking=false;
					gr.getSkin().getHeadName().hideTxtNameAndBloodBar();
					loseEffect(gr);


					setClick(_resList[i]);
				}
			}
		}
	}
}
