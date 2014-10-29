package common.config.xmlres
{
	import common.config.XmlConfig;
	import common.config.xmlres.lib.TablesLib;
	import common.config.xmlres.server.*;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * @Author : wanghuaren
	 * @Data : 2014/08/11
	 */
	public class LocalResXml
	{

		public function LocalResXml()
		{
		}

		public function getTableData(value:String):TablesLib
		{
			TablesLib.instance.initXML(value);
			return TablesLib.instance;
		}
		private var _limitTimesXml:TablesLib;

		public function get getPubLimitTimesXml():TablesLib
		{
			return getTableData(XmlConfig.PUBLIMITTIMESXML);
		}

		/**
		 * 复活面板上的随机话语
		 *
		 */
		public function get HintXml():TablesLib
		{
			return getTableData(XmlConfig.HINTXML);
		}

		public function get PubNpcXml():TablesLib
		{
			return getTableData(XmlConfig.PUBNPCXML);
		}

		public function get PubModelXml():TablesLib
		{
			return getTableData(XmlConfig.PubModelXML);
		}

		/**
		 * 静态资源文本数据，使用时才初始化
		 */
		public function get CampXml():TablesLib
		{
			return getTableData(XmlConfig.CAMPXML);
		}

		/**
		 * 游戏全局配置信息
		 * @return
		 *
		 */
		public function get ConfigXml():TablesLib
		{
			return getTableData(XmlConfig.CONFIGXML);
		}

		/**
		 * 静态资源文本数据，使用时才初始化
		 */
		public function get SkillXml():TablesLib
		{
			return getTableData(XmlConfig.SKILLXML);
		}

		public function get marriagePackXml():TablesLib
		{
			return getTableData(XmlConfig.PubMarriagePackXML);
		}

		public function get marriageBeatitudeXml():TablesLib
		{
			return getTableData(XmlConfig.PubMarriageBeatitudeXML);
		}

		public function get SkillTreeXml():TablesLib
		{
			return getTableData(XmlConfig.PUBSKILLTREEXML);
		}

		public function get SkillTreeConfigXml():TablesLib
		{
			return getTableData(XmlConfig.PUBSKILLTREECONFIGXML);
		}

		/**
		 * 天赋技能学习条件
		 */
		public function get TalentStudyXml():TablesLib
		{
			return getTableData(XmlConfig.PUBTALENTSTUDYXML);
		}

		/**
		 * skill表,effect4为0时查这张表
		 */
		public function get SkillSpecialXml():TablesLib
		{
			return getTableData(XmlConfig.SKILLSPECIALXML);
		}

		/**
		 * vip表
		 */
		public function get VipXml():TablesLib
		{
			return getTableData(XmlConfig.VIPXML);
		}

		/**
		 * 每日活动，任务
		 */
		public function get ActionDescXml():TablesLib
		{
			return getTableData(XmlConfig.ACTIONDESCXML);
		}

		/**
		 * 成就，每日推荐
		 */
		public function get AchievementXml():TablesLib
		{
			return getTableData(XmlConfig.ACHIEVEMENTXML);
		}

		public function get ActionNewXml():TablesLib
		{
			return getTableData(XmlConfig.ACTION_NEW);
		}

		/**
		 * 角色升级属性
		 */
		public function get RolePropertyXml():TablesLib
		{
			return getTableData(XmlConfig.ROLEPROPERTYXML);
		}

		/**
		 * npc喊话表
		 */
		public function get NpcShoutXml():TablesLib
		{
			return getTableData(XmlConfig.NPCSHOUTXML);
		}

		/**
		 * 魔天万界
		 */
		public function get MoTianXml():TablesLib
		{
			return getTableData(XmlConfig.DEMONWORLDXML);
		}

		/**
		 * 魔天万界地图
		 */
		public function get MoTianMapXml():TablesLib
		{
			return getTableData(XmlConfig.DEMONMAPXML);
		}

		/**
		 * 家族
		 */
		public function get FamilyXml():TablesLib
		{
			return getTableData(XmlConfig.FAMILYXML);
		}

		/**
		 * 家族技能
		 */
		public function get FamilySkillXml():TablesLib
		{
			return getTableData(XmlConfig.FamilySkillXML);
		}

		/**
		 * 【排行榜奖励展示】界面
		 *
		 * <1>BOSS战
			<2>玄仙论剑每日
			<3>玄仙论剑每周
			<4>家族大乱斗
			<5>金戈铁马
		 */
		public function get TopPrizeXml():TablesLib
		{
			return getTableData(XmlConfig.TopPrizeXML);
		}

		/**
		 * 开服嘉年华
		 */
		public function get JnhXml():TablesLib
		{
			return getTableData(XmlConfig.ActionStartXML);
		}

		/**
		 * 活动面板中的每日 新推荐
		 */
		public function get CommendXml():TablesLib
		{
			return getTableData(XmlConfig.COMMENDXML);
		}

		/**
		 * 怪物喊话内容
		 */
		public function get ShoutXml():TablesLib
		{
			return getTableData(XmlConfig.SHOUTXML);
		}

		/**
		 * 宵小 ，捉贼
		 */
		public function get NpcSeekXml():TablesLib
		{
			return getTableData(XmlConfig.NPCSEEKXML);
		}

		/**
		 * 领取神兽数据
		 */
		public function get NetShopXml():TablesLib
		{
			return getTableData(XmlConfig.NETSHOPXML);
		}

		/**
		 * 服务器版本更新内容
		 */

		public function get UpDateXml():TablesLib
		{
			return getTableData(XmlConfig.UPDATEXML);
		}

		/**
		 * 第一天登陆，第二天登陆，第三天登陆
		 */
		public function get EnterPrizeXml():TablesLib
		{
			return getTableData(XmlConfig.ENTERPRIZEXML);
		}

		/**
		 * 对应chongzhi1
		 */
		public function get ActionPayXml():TablesLib
		{
			return getTableData(XmlConfig.ACTIONPAYXML);
		}

		public function getQQInviteFriend():TablesLib
		{
			return getTableData(XmlConfig.QQINVITEFRIENDXML);
		}

		public function get SitzUpStrongXml():TablesLib
		{
			return getTableData(XmlConfig.SITZUPSTRONGXML);
		}

		public function get getConvoyXml():TablesLib
		{
			return getTableData(XmlConfig.CONVOYXML);
		}

		public function get getREFOUND2Xml():TablesLib
		{
			return getTableData(XmlConfig.REFOUND2XML);
		}

		public function get getNpcTalkXml():TablesLib
		{
			return getTableData(XmlConfig.NpcTalkXML);
		}

		public function get getToolcolorupXml():TablesLib
		{
			return getTableData(XmlConfig.ToolcolorupXML);
		}

		public function get getSuitcomposeXml():TablesLib
		{
			return getTableData(XmlConfig.SuitcomposeXML);
		}

		public function get getPropertytackXml():TablesLib
		{
			return getTableData(XmlConfig.PropertytackXML);
		}

		public function get getUpTargetXml():TablesLib
		{
			return getTableData(XmlConfig.UPTARGETXML);
		}

		public function get getManageActionXml():TablesLib
		{
			return getTableData(XmlConfig.MANAGEACTIONXML);
		}

		public function get getVarXml():TablesLib
		{
			return getTableData(XmlConfig.VARXML);
		}

		public function get getInterfaceClewXml():TablesLib
		{
			return getTableData(XmlConfig.INTERFACECLEWXML);
		}

		public function get getExpBackXml():TablesLib
		{
			return getTableData(XmlConfig.EXPBACKXML);
		}

		public function get getShopMysteriousXml():TablesLib
		{
			return getTableData(XmlConfig.SHOPMYSTERIOUSXML);
		}

		public function get getEquipSoulStrongXml():TablesLib
		{
			return getTableData(XmlConfig.EQUIPSOUlSTRONGXML);
		}

		public function get getDropXml():TablesLib
		{
			return getTableData(XmlConfig.DROPXML);
		}

		public function get getThemeXml():TablesLib
		{
			return getTableData(XmlConfig.THEMEXML);
		}

		public function get getVipXml():TablesLib
		{
			return getTableData(XmlConfig.VIPXML);
		}

		public function get getUnderwriteTypeXml():TablesLib
		{
			return getTableData(XmlConfig.UNDERWRITETYPEXML);
		}

		public function get getHelpDataXml():TablesLib
		{
			return getTableData(XmlConfig.HELPDATAXML);
		}

		public function get getHelpXml():TablesLib
		{
			return getTableData(XmlConfig.HELPXML);
		}

		public function get getInstanceXml():TablesLib
		{
			return getTableData(XmlConfig.INSTANCEXML);
		}

		public function get getSitzUpXml():TablesLib
		{
			return getTableData(XmlConfig.SITZUPXML);
		}

		public function get getPetSkillXml():TablesLib
		{
			return getTableData(XmlConfig.PETSKILLXML);
		}

		public function get getPetXml():TablesLib
		{
			return getTableData(XmlConfig.PETXML);
		}

		public function get getPetAddCommendXml():TablesLib
		{
			return getTableData(XmlConfig.PET_ADD_COMMEND_XML);
		}

		public function get getEquipFenjieXml():TablesLib
		{
			return getTableData(XmlConfig.ZHUANGBEI_XML);
		}

		public function get getPetStrongXml():TablesLib
		{
			return getTableData(XmlConfig.PETSTRONGXML);
		}

		public function get getPetSealXml():TablesLib
		{
			return getTableData(XmlConfig.PET_SEAL_XML);
		}

		public function get getPubShopNormalXml():TablesLib
		{
			return getTableData(XmlConfig.SHOPNORMALXML);
		}

		public function get getPubInheritXml():TablesLib
		{
			return getTableData(XmlConfig.INHERITXML);
		}

		public function get getPubShopPageXml():TablesLib
		{
			return getTableData(XmlConfig.SHOPPAGEXML);
		}

		/**
		 * 静态资源文本数据，使用时才初始化
		 */
		public function get getPubMapSeekXml():TablesLib
		{
			return getTableData(XmlConfig.MAPSEEKXML);
		}

		/**
		 * 静态资源文本数据，使用时才初始化
		 */
		public function get getPubSeekXml():TablesLib
		{
			return getTableData(XmlConfig.SEEKXML);
		}

		/**
		 * 静态资源文本数据，使用时才初始化
		 */
		public function get getToolsXml():TablesLib
		{
			return getTableData(XmlConfig.TOOLXML);
		}

		public function get ToolsXml():TablesLib
		{
			return getToolsXml;
		}

		/**
		 * 静态资源文本数据，使用时才初始化
		 */
		public function get getPubChangeStrongDescXml():TablesLib
		{
			return getTableData(XmlConfig.CHANGE_STRONG_DESC_XML);
		}

		/**
		 * 静态资源文本数据，使用时才初始化
		 */
		public function get getPubStarXml():TablesLib
		{
			return getTableData(XmlConfig.STARXML);
		}

		/**
		 * 静态资源文本数据，使用时才初始化
		 */
		public function get PubStarExchangeXml():TablesLib
		{
			return getTableData(XmlConfig.STAREXCHANGEXML);
		}

		/**
		 * 静态资源文本数据，使用时才初始化
		 */
		public function get getEquipSrongXml():TablesLib
		{
			return getTableData(XmlConfig.EQUIP_STRONGXML);
		}

		/**
		 * 静态资源文本数据，使用时才初始化
		 */
		public function get getEquipSuitXml():TablesLib
		{
			return getTableData(XmlConfig.EQUIP_SUITXML);
		}

		public function get getPubTaskXml():TablesLib
		{
			return getTableData(XmlConfig.TASKXML);
		}

		public function get getPubActionTargetXml():TablesLib
		{
			return getTableData(XmlConfig.Action_TargetXML);
		}

		public function get getPubTaskStepXml():TablesLib
		{
			return getTableData(XmlConfig.TASKSTEPXML);
		}

		public function get getPubHeadIconXml():TablesLib
		{
			return getTableData(XmlConfig.HEADICONXML);
		}

		public function get getPubExpXml():TablesLib
		{
			return getTableData(XmlConfig.EXPXML);
		}

		public function get getBoneBaseXml():TablesLib
		{
			return getTableData(XmlConfig.BONEBASEXML);
		}

		public function get getBoneStarXml():TablesLib
		{
			return getTableData(XmlConfig.BONESTARXML);
		}

		public function get getPayment_DayXml():TablesLib
		{
			return getTableData(XmlConfig.PAYMENT_DAY_XML);
		}

		public function get getBoneXml():TablesLib
		{
			return getTableData(XmlConfig.BONEXML);
		}
		
		public function get getNpcXml():TablesLib
		{
			return getTableData(XmlConfig.PUBNPCXML);
		}
		public function get getSkillDataXml():TablesLib
		{
			return getTableData(XmlConfig.SKILLDATAXML);
		}
		public function get getSkillXml():TablesLib
		{
			return getTableData(XmlConfig.SKILLXML);
		}

		public function get getBookXml():TablesLib
		{
			return getTableData(XmlConfig.BOOKXML);
		}

		public function get getBookXml2():TablesLib
		{
			return getTableData(XmlConfig.BOOKXML);
		}

		public function get getPubKingnameXml():TablesLib
		{
			return getTableData(XmlConfig.KINGNAMEXML);
		}

		public function get getPubSkillBuffXml():TablesLib
		{
			return getTableData(XmlConfig.SKILLBUFFXML);
		}

		public function get getPubSkillXml():TablesLib
		{
			return getTableData(XmlConfig.SKILLXML);
		}

		public function get SkillDataXml():TablesLib
		{
			return getTableData(XmlConfig.SKILLDATAXML);
		}

		public function get getPubRefoundXml():TablesLib
		{
			return getTableData(XmlConfig.REFOUNDXML);
		}

		public function get getPubMapXml():TablesLib
		{
			return getTableData(XmlConfig.MAPXML);
		}

		public function get getPubTaskPrizeXml():TablesLib
		{
			return getTableData(XmlConfig.TASK_PRIZEXML);
		}

		public function get getPubModelXml():TablesLib
		{
			return getTableData(XmlConfig.MODELXML);
		}

		public function get getPubMapZonesXml():TablesLib
		{
			return getTableData(XmlConfig.MAPZONESXML);
		}

		public function get getPubComposeXml():TablesLib
		{
			return getTableData(XmlConfig.COMPOSEXML);
		}

		public function get getPubGradeXml():TablesLib
		{
			return getTableData(XmlConfig.GRADEXML);
		}

		public function get getPubBournXml():TablesLib
		{
			return getTableData(XmlConfig.BOURNXML);
		}

		public function get getToolAttrXml():TablesLib
		{
			return getTableData(XmlConfig.TOOLATTRXML);
		}

		public function get getColorStrongXml():TablesLib
		{
			return getTableData(XmlConfig.COLORSTRONGXML);
		}

		public function get getEquipSoulXml():TablesLib
		{
			return getTableData(XmlConfig.EQUIPSOUlXML);
		}

		//2013-05-13 宝石合成
		public function get getGemComposelXml():TablesLib
		{
			return getTableData(XmlConfig.GEMCOMPOSEXML);
		}

		public function get EsotericaXml():TablesLib
		{
			return getTableData(XmlConfig.PUBESOTERICAXML);
		}

		public function get EsotericaListXml():TablesLib
		{
			return getTableData(XmlConfig.PUBESOTERICALISTXMLXML);
		}

		public function get SysEffectXml():TablesLib
		{
			return getTableData(XmlConfig.PUBSYSEFFECTXML);
		}

		public function get Bourn_StarXml():TablesLib
		{
			return getTableData(XmlConfig.PubBournStarXML);
		}

		public function get SitzupSkillXml():TablesLib
		{
			return getTableData(XmlConfig.PUBSITZUPSKILLXML);
		}

		public function get SitzUpUpXml():TablesLib
		{
			return getTableData(XmlConfig.PUBSITZUPUPXML);
		}

		public function get SitzupShowXml():TablesLib
		{
			return getTableData(XmlConfig.PUBSITZUPSHOWXML);
		}

		public function get SitzupNameXml():TablesLib
		{
			return getTableData(XmlConfig.PUBSITZUPNAMEXML);
		}

		public function get FamilyItemShopXml():TablesLib
		{
			return getTableData(XmlConfig.PUBFAMILYITEMSHOPXML);
		}

		public function get FamilySkillTreeConfigXml():TablesLib
		{
			return getTableData(XmlConfig.PUBFAMILYSKILLTREECONFIGXML);
		}

		public function get FamilySkillTreeXml():TablesLib
		{
			return getTableData(XmlConfig.PUBFAMILYSKILLTREEXML);
		}

		public function get FamilyBossXml():TablesLib
		{
			return getTableData(XmlConfig.PUBFAMILYBOSSXML);
		}

		public function get FamilyItemXml():TablesLib
		{
			return getTableData(XmlConfig.PUBFAMILYITEMXML);
		}

		public function get FamilySkillLearnXml():TablesLib
		{
			return getTableData(XmlConfig.PUBFAMILYSKILLLEARNXML);
		}

		public function get FamilyLeaguerLvXml():TablesLib
		{
			return getTableData(XmlConfig.PUBFAMILYLEAGUERLVXML);
		}

		public function get FlyMaskPathXml():TablesLib
		{
			return getTableData(XmlConfig.PUBFLYMASKPATHXML);
		}

		public function get playDemesneXml():TablesLib
		{
			return getTableData(XmlConfig.PUBPLAYDEMESNEXML);
		}

		public function get limitTimesXml():TablesLib
		{
			return getTableData(XmlConfig.LIMITTIMESXML);
		}

		public function get soundXml():TablesLib
		{
			return getTableData(XmlConfig.PUBSOUNDXML);
		}

		public function get titleXml():TablesLib
		{
			return getTableData(XmlConfig.TITLEXML);
		}

		public function get identifyXml():TablesLib
		{
			return getTableData(XmlConfig.IDENTIFYXML);
		}

		public function get EffectSoundXml():TablesLib
		{
			return getTableData(XmlConfig.PUBEFFECTSOUNDXML);
		}

		/**
		 * QQ黄钻礼包配置文件
		 */
		public function get QQYellowXml():TablesLib
		{
			return getTableData(XmlConfig.QQYellowXML);
		}

		public function get QQShareXml():TablesLib
		{
			return getTableData(XmlConfig.PUBQQSHARERESMODELXML);
		}

		/**
		 * 珍宝阁配置文件
		 */
		public function get shopIbXml():TablesLib
		{
			return getTableData(XmlConfig.PUBSHOPIBXML);
		}

		/**
		 * 珍宝阁分页配置文件
		 */
		public function get ibShopPageXml():TablesLib
		{
			return getTableData(XmlConfig.PUBIBSHOPPAGEXML);
		}

		/**
		 * 银两兑换 配置文件
		 */
		public function get changeXml():TablesLib
		{
			return getTableData(XmlConfig.PUBCHANGEXML);
		}

		public function get ActionForeXml():TablesLib
		{
			return getTableData(XmlConfig.PUBACTIONFOREXML);
		}

		public function get equipHeirXml():TablesLib
		{
			return getTableData(XmlConfig.PUBEQUIPHEIRXML);
		}

		/**
		 * 包裹格子开启
		 */
		public function get packopenXml():TablesLib
		{
			return getTableData(XmlConfig.PUBPACKOPENXML);
		}

		public function get soarXml():TablesLib
		{
			return getTableData(XmlConfig.SOARXML);
		}

		/**
		 * vip特权推荐
		 */
		public function get vipPromptXml():TablesLib
		{
			return getTableData(XmlConfig.PUBVIPPROMPTXML);
		}

		/**
		 * 锻造强化，清除，转移
		 */
		public function get equipStrongCostXml():TablesLib
		{
			return getTableData(XmlConfig.PUBEQUPSTRONGCONSTXML);
		}

		/**
		 * 皇榜军阶兑换
		 * 2013-12-30
		 */
		public function get exploitXml():TablesLib
		{
			return getTableData(XmlConfig.PUBEXPLOITXML);
		}

		/**
		 * 充值奖励 huodong_zhenghe
		 */
		public function get PaymentStartXml():TablesLib
		{
			return getTableData(XmlConfig.PUBPAYMENTSTARTXML);
		}

		/**
		 * 剑灵
		 */
		public function get BladeXml():TablesLib
		{
			return getTableData(XmlConfig.PUBBLADEXML);
		}

		/**
		 * 始皇魔窟
		 */
		public function get ExpActionPrizeXml():TablesLib
		{
			return getTableData(XmlConfig.PUBEXPACTIONPRIZEXML);
		}

		/**
		 * 天书
		 */
		public function get TianShuXml():TablesLib
		{
			return getTableData(XmlConfig.PUBTIANSHUXML);
		}

		/**
		 * 宝石
		 */
		public function get pubGemXml():TablesLib
		{
			return getTableData(XmlConfig.PUBGEMXML);
		}
		
		private var _pubWingXml:TablesLib;
		/**
		 *翅膀 
		 * @return 
		 * 
		 */
		public function get getWingXml():TablesLib
		{
			return getTableData(XmlConfig.WINGXML);
		}
		/**
		 *神兵
		 * @return 
		 * 
		 */
		public function get getGodXml():TablesLib
		{
			return getTableData(XmlConfig.GODXML);
		}
		/**
		 *投资
		 * @return 
		 * 
		 */
		public function get pubInvestXml():TablesLib
		{
			return getTableData(XmlConfig.PUBINVESTXML);
		}
		/**
		 *投资
		 * @return 
		 * 
		 */
		public function get pubInvestRepayXml():TablesLib
		{
			return getTableData(XmlConfig.PUBINVESTREPAYXML);
		}
	}
}
