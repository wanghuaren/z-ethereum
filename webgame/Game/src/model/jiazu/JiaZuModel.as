package model.jiazu
{
	import common.managers.Lang;
	
	import engine.support.IPacket;
	
	import flash.events.EventDispatcher;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.PacketSCActiveGuildSkill2;
	import netc.packets2.PacketSCEntryGuildHome2;
	import netc.packets2.PacketSCEntryGuildMelee2;
	import netc.packets2.PacketSCGetGuildBossTime2;
	import netc.packets2.PacketSCGuildSkillData2;
	import netc.packets2.PacketSCSetGuildBossTime2;
	import netc.packets2.PacketSCStudyGuildSkill2;
	import netc.packets2.PacketWCGuildAccess2;
	import netc.packets2.PacketWCGuildChangeJob2;
	import netc.packets2.PacketWCGuildDel2;
	import netc.packets2.PacketWCGuildDelMember2;
	import netc.packets2.PacketWCGuildGiveMoney2;
	import netc.packets2.PacketWCGuildInfo2;
	import netc.packets2.PacketWCGuildLevelUp2;
	import netc.packets2.PacketWCGuildList2;
	import netc.packets2.PacketWCGuildLog2;
	import netc.packets2.PacketWCGuildPrize2;
	import netc.packets2.PacketWCGuildQuit2;
	import netc.packets2.PacketWCGuildRefuse2;
	import netc.packets2.PacketWCGuildReq2;
	import netc.packets2.PacketWCGuildReqList2;
	import netc.packets2.PacketWCGuildSetText2;
	import netc.packets2.PacketWCGuildTreeDrop2;
	import netc.packets2.PacketWCGuildTreeInfo2;
	import netc.packets2.PacketWCGuildTreeOp2;
	
	import nets.packets.PacketCSActiveGuildSkill;
	import nets.packets.PacketCSEntryGuildHome;
	import nets.packets.PacketCSGetGuildBossTime;
	import nets.packets.PacketCSGuildAccess;
	import nets.packets.PacketCSGuildAutoAccess;
	import nets.packets.PacketCSGuildChangeJob;
	import nets.packets.PacketCSGuildCreate;
	import nets.packets.PacketCSGuildDel;
	import nets.packets.PacketCSGuildDelMember;
	import nets.packets.PacketCSGuildGiveMoney;
	import nets.packets.PacketCSGuildInfo;
	import nets.packets.PacketCSGuildList;
	import nets.packets.PacketCSGuildLog;
	import nets.packets.PacketCSGuildPrize;
	import nets.packets.PacketCSGuildQuit;
	import nets.packets.PacketCSGuildRefuse;
	import nets.packets.PacketCSGuildReq;
	import nets.packets.PacketCSGuildReqList;
	import nets.packets.PacketCSGuildSetText;
	import nets.packets.PacketCSGuildSkillData;
	import nets.packets.PacketCSGuildTreeDrop;
	import nets.packets.PacketCSGuildTreeInfo;
	import nets.packets.PacketCSGuildTreeOp;
	import nets.packets.PacketCSSetGuildBossTime;
	import nets.packets.PacketCSStudyGuildSkill;
	import nets.packets.PacketSCActiveGuildSkill;
	import nets.packets.PacketSCEntryGuildHome;
	import nets.packets.PacketSCEntryGuildMelee;
	import nets.packets.PacketSCGetGuildBossTime;
	import nets.packets.PacketSCGuildCreate;
	import nets.packets.PacketSCGuildSkillData;
	import nets.packets.PacketSCSetGuildBossTime;
	import nets.packets.PacketSCStudyGuildSkill;
	import nets.packets.PacketWCGuildAccess;
	import nets.packets.PacketWCGuildChangeJob;
	import nets.packets.PacketWCGuildDel;
	import nets.packets.PacketWCGuildDelMember;
	import nets.packets.PacketWCGuildGiveMoney;
	import nets.packets.PacketWCGuildInfo;
	import nets.packets.PacketWCGuildList;
	import nets.packets.PacketWCGuildLog;
	import nets.packets.PacketWCGuildPrize;
	import nets.packets.PacketWCGuildQuit;
	import nets.packets.PacketWCGuildRefuse;
	import nets.packets.PacketWCGuildReq;
	import nets.packets.PacketWCGuildReqList;
	import nets.packets.PacketWCGuildSetText;
	import nets.packets.PacketWCGuildTreeDrop;
	import nets.packets.PacketWCGuildTreeInfo;
	import nets.packets.PacketWCGuildTreeOp;

	public class JiaZuModel extends EventDispatcher
	{
		//public static var AUTO_ACCESS:String="auto join family";
		private static var m_instance:JiaZuModel;

		public static function getInstance():JiaZuModel
		{
			if (null == m_instance)
			{
				m_instance=new JiaZuModel();
			}

			return m_instance;
		}

		public function JiaZuModel()
		{
			//初始化监听服务端消息
			DataKey.instance.register(PacketSCGuildCreate.id, _responeGuildCreate);
			DataKey.instance.register(PacketWCGuildList.id, _responeGuildList);
			DataKey.instance.register(PacketWCGuildReq.id, _responeGuildReq);
			DataKey.instance.register(PacketWCGuildInfo.id, _responseGuildInfo);
			DataKey.instance.register(PacketWCGuildGiveMoney.id, _responseGuildGiveMoney);

			DataKey.instance.register(PacketSCEntryGuildHome.id, _responseEntryGuildHome);


			//家族动态
			DataKey.instance.register(PacketWCGuildLog.id, _responseGuildLog);

			//成员离开
			DataKey.instance.register(PacketWCGuildDelMember.id, _responseGuildDelMember);

			//公会解散
			DataKey.instance.register(PacketWCGuildDel.id, _responseGuildDel);


			//同意某人加入公会
			DataKey.instance.register(PacketWCGuildAccess.id, _responseGuildAccess);

			//拒绝某人加入公会
			DataKey.instance.register(PacketWCGuildRefuse.id, _responseGuildRefuse);

			//设置神兽大作战时间


			//DataKey.instance.register(PacketWCSetGuildBossTime.id,_responseSetGuildBossTime);

			//家族待审核列表

			DataKey.instance.register(PacketWCGuildReqList.id, _responseGuildReqList);

			//查询bossTime时间
			DataKey.instance.register(PacketSCGetGuildBossTime.id, _responseGetGuildBossTime);

			//修改bossTime时间
			DataKey.instance.register(PacketSCSetGuildBossTime.id, _responseSetGuildBossTime);


			DataKey.instance.register(PacketSCGuildSkillData.id, _responseGuildSkillData);


			DataKey.instance.register(PacketSCStudyGuildSkill.id, _responseStudyGuildSkill);

			DataKey.instance.register(PacketWCGuildTreeInfo.id, _responseGuildTreeInfo);

			DataKey.instance.register(PacketWCGuildTreeOp.id, _responseGuildTreeOp);

			DataKey.instance.register(PacketWCGuildTreeDrop.id, _responseGuildTreeDrop);


			DataKey.instance.register(PacketSCActiveGuildSkill.id, _responseActiveGuildSkill);

			DataKey.instance.register(PacketSCEntryGuildHome.id, _responseEntryGuildHome);

			DataKey.instance.register(PacketWCGuildSetText.id, _responseGuildSetText);

			DataKey.instance.register(PacketSCEntryGuildMelee.id, _responseGuildMelee);

			DataKey.instance.register(PacketWCGuildQuit.id, _responseGuildQuit);

			DataKey.instance.register(PacketWCGuildChangeJob.id, _responseWCGuildChangeJob);
			
			//家族礼包
			DataKey.instance.register(PacketWCGuildPrize.id,_responseWCGuildPrize);
			
			

			DataKey.instance.register(PacketCSGuildAutoAccess.id, _responseGuildAutoAccess);
		}

		//---whr------------
		public function requestAutoAccess(value:int):void
		{
			var _packetCSGuildAutoAccess:PacketCSGuildAutoAccess=new PacketCSGuildAutoAccess()
			_packetCSGuildAutoAccess.autoAcess=value;
			DataKey.instance.send(_packetCSGuildAutoAccess);
		}

		private function _responseEntryGuildHome(p:PacketSCEntryGuildHome2):void
		{
			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}


		}

		private function _responseActiveGuildSkill(p:PacketSCActiveGuildSkill2):void
		{
			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_SKILL_LVL_UPD_EVENT;
			//协议包有变化   注释一行
//			_e.msg={key: p.skillInstance};

			dispatchEvent(_e);

		}


		private function _responseStudyGuildSkill(p:PacketSCStudyGuildSkill2):void
		{
			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}


			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_SKILL_LVL_UPD_EVENT;
			//_e.msg={key: p.skillInstanceId};
			dispatchEvent(_e);

		}


		private function _responseGuildSkillData(p:PacketSCGuildSkillData2):void
		{
			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_SKILL_DATA_UPD_EVENT;
			dispatchEvent(_e);

		}

		private function _responseGetGuildBossTime(p:PacketSCGetGuildBossTime2):void
		{
			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_BOSS_TIME_EVENT;
			_e.msg=p.time;
			dispatchEvent(_e);

		}

		private function _responseSetGuildBossTime(p:PacketSCSetGuildBossTime2):void
		{
			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}
		}

		private function _responseGuildReqList(p:PacketWCGuildReqList2):void
		{
			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_REQ_LIST_EVENT;
			dispatchEvent(_e);

		}

		//private function _responseSetGuildBossTime(p:PacketWCSetGuildBossTime):void
		//{



		//}

		private function _responseGuildRefuse(p:PacketWCGuildRefuse2):void
		{
			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_REFUSE_EVENT;
			dispatchEvent(_e);
		}

		private function _responseGuildAccess(p:PacketWCGuildAccess2):void
		{
			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_ACCESS_EVENT;
			dispatchEvent(_e);

		}

		
		private function _responseGuildLvlUp(p:PacketWCGuildLevelUp2):void
		{
			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_LVL_UPD_EVENT;
			dispatchEvent(_e);
		}

		private function _responseGuildQuit(p:PacketWCGuildQuit2):void
		{
			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_DEL_EVENT;
			dispatchEvent(_e);

		}

		private function _responseGuildDel(p:PacketWCGuildDel2):void
		{
			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_DEL_EVENT;
			dispatchEvent(_e);
		}

		private function _responseGuildDelMember(p:PacketWCGuildDelMember2):void
		{
			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_MEMBER_DEL_EVENT;
			dispatchEvent(_e);

		}

		private function _responseGuildLog(p:PacketWCGuildLog2):void
		{

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_LOG_UPD_EVENT;
			dispatchEvent(_e);


		}

		private function _responeGuildCreate(p:PacketSCGuildCreate):void
		{

			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_CREATE_SUCCESS_EVENT;
			dispatchEvent(_e);

		}

		/**
		 * 请求创建家族
		 */
		public function requestGuildCreate(guildname:String):void
		{
			var _p:PacketCSGuildCreate=new PacketCSGuildCreate();
			_p.guildname=guildname;
			DataKey.instance.send(_p);
		}


		/**
		 * 返回家族列表信息
		 * @param p
		 *
		 */
		private function _responeGuildList(p:PacketWCGuildList2):void
		{

			Data.jiaZu.GuildListData=p.arrItemguildlist;

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_LIST_UPD_EVENT;
			dispatchEvent(_e);
		}


		/**
		 * 请求家族列表信息 ,或者查看家族排行榜 
		 * @param type  1:家族申请界面2.家族排行榜
		 * 
		 */		
		public function requestGuildList(type:int):void
		{
			var _p:PacketCSGuildList=new PacketCSGuildList();
			_p.type = type;
			DataKey.instance.send(_p);
		}

		private function _responeGuildReq(p:PacketWCGuildReq2):void
		{

			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_REQ_SUCCESS_EVENT;
			dispatchEvent(_e);
		}

		/**
		 * 申请加入家族
		 * @param gid
		 *
		 */
		public function requestGuildReq(gid:int):void
		{
			var _p:PacketCSGuildReq=new PacketCSGuildReq();
			_p.guildid=gid;
			DataKey.instance.send(_p);
		}


		private function _responseGuildInfo(p:PacketWCGuildInfo2):void
		{
			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_INFO_EVENT;
			_e.msg=p;
			dispatchEvent(_e);
		}


		/**
		 * 通过 guild ID 查询某个家族的信息
		 * @param gid
		 *
		 */
		public function requestGuildInfo(gid:int):void
		{
			var _p:PacketCSGuildInfo=new PacketCSGuildInfo();
			_p.guildid=gid;
			DataKey.instance.send(_p);
		}

		public function requestGuildBossTime():void
		{
			var _p:PacketCSGetGuildBossTime=new PacketCSGetGuildBossTime();
			DataKey.instance.send(_p);

		}



		/**
		 * 通过 guild ID 查询家族动态
		 */
		public function requestGuildLog(gid:int):void
		{
			var _p:PacketCSGuildLog=new PacketCSGuildLog();
			_p.guildid=gid;
			DataKey.instance.send(_p);

		}

		public function requestGuildSkillData():void
		{
			var _p:PacketCSGuildSkillData=new PacketCSGuildSkillData();

			//服务器说不需要传guild id
			DataKey.instance.send(_p);

		}


		/**
		 * 同意某人加入公会
		 */
		public function requestGuildAccess(gid:int, pid:int):void
		{
			var _p:PacketCSGuildAccess=new PacketCSGuildAccess();
			_p.guildid=gid;
			_p.playerid=pid;
			DataKey.instance.send(_p);

		}

		/**
		 * 自由加入公会
		 */
		public function requestGuildAutoAccess(isAutoAcess:Boolean):void
		{
			var _p:PacketCSGuildAutoAccess=new PacketCSGuildAutoAccess();
			_p.autoAcess=true == isAutoAcess?1:0;
			DataKey.instance.send(_p);

		}

		/**
		 * 拒绝某人加入公会
		 */
		public function requestGuildRefuse(gid:int, pid:int):void
		{
			var _p:PacketCSGuildRefuse=new PacketCSGuildRefuse();
			_p.guildid=gid;
			_p.playerid=pid;
			DataKey.instance.send(_p);

		}

		/**
		 * 设置神兽大作战时间
		 */
		public function requestSetGuildBossTime(time:int):void
		{

			var _p:PacketCSSetGuildBossTime=new PacketCSSetGuildBossTime();
			_p.time=time;

			DataKey.instance.send(_p);

		}

		public function requestGuildReqList(gid:int):void
		{
			var _p:PacketCSGuildReqList=new PacketCSGuildReqList();
			_p.guildid=gid;

			DataKey.instance.send(_p);
		}


		/**
		 * 1.退出的协议是CSGuildQuit
			2.踢人的协议是CSGuildDelMember
			3.解散的协议是CSGuildDel
		 */
		public function requestGuildDelMember(playerid:int, gid:int):void
		{
			var _p:PacketCSGuildDelMember=new PacketCSGuildDelMember();
			_p.playerid=playerid;
			_p.guildid=gid;

			DataKey.instance.send(_p);
		}

		//
		public function requestGuildQuit(gid:int):void
		{
			var _p:PacketCSGuildQuit=new PacketCSGuildQuit();
			//_p.playerid = playerid;
			_p.guildid=gid;

			DataKey.instance.send(_p);
		}

		public function requestGuildDel(gid:int):void
		{
			var _p:PacketCSGuildDel=new PacketCSGuildDel();
			_p.guildid=gid;

			DataKey.instance.send(_p);
		}


		//CSStudyGuildSkill
		public function requestStudyGuildSkill(pos:int):void
		{
			var _p:PacketCSStudyGuildSkill=new PacketCSStudyGuildSkill();
			//_p.pos=pos;

			DataKey.instance.send(_p);
		}

		//CSActiveGuildSkill
		public function requestActiveGuildSkill(pos:int):void
		{
			var _p:PacketCSActiveGuildSkill=new PacketCSActiveGuildSkill();
			//因为协议包改变   所以本函数注释了一行  加上我 二行
			//			_p.pos=pos;

			DataKey.instance.send(_p);
		}

		//CSEntryGuildHome
		/**
		 * 请求进入家园
		 * 进入类型,0为进入家园,1为进入神树,2为进入我爱我家
		 */
		public function requestEntryGuildHome(flag:int):void
		{
			var _p:PacketCSEntryGuildHome=new PacketCSEntryGuildHome();
			_p.flag=flag;
			DataKey.instance.send(_p);
		}


		private function _responseGuildSetText(p:PacketWCGuildSetText2):void
		{
			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_SET_TEXT_SUCCESS_EVENT;
			_e.msg=p;
			dispatchEvent(_e);

		}

		private function _responseGuildMelee(p:PacketSCEntryGuildMelee2):void
		{
			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}
		}

		/**
		 * 向服务器保存家族公告信息
		 * @param txtGongGao
		 * @param txtJieShao
		 *
		 */
		public function requestGuildSetText(txtGongGao:String, txtJieShao:String):void
		{
			var _p:PacketCSGuildSetText=new PacketCSGuildSetText();
			_p.guildid=Data.myKing.Guild.GuildId;
			_p.bull=txtGongGao;
			_p.desc=txtJieShao;
			DataKey.instance.send(_p);
		}




		private function _responseGuildGiveMoney(p:PacketWCGuildGiveMoney2):void
		{
			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_GIVE_MONEY_SUCCESS_EVENT;
			_e.msg=p;
			dispatchEvent(_e);
		}


		public function requestGuildGiveMoney(guildid:int, money:int):void
		{
			if (guildid <= 0 || money <= 0)
			{
				return;
			}

			var _p:PacketCSGuildGiveMoney=new PacketCSGuildGiveMoney();
			//_p.guildid=guildid;
			//_p.money=money;
			DataKey.instance.send(_p);
		}






		private function _responseGuildTreeInfo(p:IPacket):void
		{
			var _p:PacketWCGuildTreeInfo2=p as PacketWCGuildTreeInfo2;

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_TREE_INFO_UPD_EVENT;
			_e.msg=_p;
			dispatchEvent(_e);
		}


		/**
		 * 获得家族树的信息
		 * @param guildid
		 *
		 */
		public function requestGuildTreeInfo(guildid:int):void
		{
			var _p:PacketCSGuildTreeInfo=new PacketCSGuildTreeInfo();
			_p.guildid=guildid;
			DataKey.instance.send(_p);
		}


		private function _responseGuildTreeOp(p:IPacket):void
		{
			var _p:PacketWCGuildTreeOp2=p as PacketWCGuildTreeOp2;

			if (0 != _p.tag)
			{
				Lang.showResult(p);
				return;
			}

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_TREE_OP_SUCCESS_EVENT;
			_e.msg=_p;
			dispatchEvent(_e);
		}

		/**
		 * 家族树操作
		 * @param guildid     家族ID
		 * @param treeop      操作0:浇水1:施肥2:除虫
		 *
		 */
		public function requestCSGuildTreeOp(guildid:int, treeop:int):void
		{
			var _p:PacketCSGuildTreeOp=new PacketCSGuildTreeOp();
			_p.guildid=guildid;
			_p.treeop=treeop;
			DataKey.instance.send(_p);
		}

		private function _responseGuildTreeDrop(p:IPacket):void
		{
			var _p:PacketWCGuildTreeDrop2= p as PacketWCGuildTreeDrop2;

			if (0 != _p.tag)
			{
				Lang.showResult(p);
				return;
			}

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_TREE_DROP_SUCCESS_EVENT;
			_e.msg=_p;
			dispatchEvent(_e);
		}

		/**
		 * 家族树掉落请求
		 * @param guildid
		 *
		 */
		public function requestCSGuildTreeDrop(guildid:int):void
		{
			var _p:PacketCSGuildTreeDrop=new PacketCSGuildTreeDrop();
			_p.guildid=guildid;

			DataKey.instance.send(_p);
		}


		/**
		 * 家族职位变更 ,
		 * @param playerid
		 * @param job        新职位2:成员3:副会长4:会长
		 *
		 */
		public function requestCSGuildChangeJob(playerid:int, job:int):void
		{
			var _p:PacketCSGuildChangeJob=new PacketCSGuildChangeJob();
			_p.playerid=playerid;
			_p.job=job;
			DataKey.instance.send(_p);
		}
		
		public function requestCSGuildPrize(jzLvl:int):void
		{
			var _p:PacketCSGuildPrize = new PacketCSGuildPrize();
			_p.prize = jzLvl;
			DataKey.instance.send(_p);
		
		}
		
		private function _responseWCGuildPrize(p:PacketWCGuildPrize2):void
		{
			if (0 != p.tag)
			{
				Lang.showResult(p);
				//return;
			}
		
			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_PRIZE;
			dispatchEvent(_e);
			
		}
		
		private function _responseGuildAutoAccess(p:PacketCSGuildAutoAccess):void
		{
			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_AUTO_ACCESS_EVENT;
			dispatchEvent(_e);
		
		}

		private function _responseWCGuildChangeJob(p:PacketWCGuildChangeJob2):void
		{

			if (0 != p.tag)
			{
				Lang.showResult(p);
				return;
			}

			var _e:JiaZuEvent=new JiaZuEvent(JiaZuEvent.JZ_EVENT);
			_e.sort=JiaZuEvent.JZ_GUILD_CHANGE_JOB_EVENT;
			dispatchEvent(_e);

		}


	}


}



