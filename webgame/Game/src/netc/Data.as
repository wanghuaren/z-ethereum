package netc
{
	import engine.support.IPacket;
	import engine.support.ISet;
	import engine.utils.HashMap;
	
	import flash.utils.Dictionary;
	
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;

	public class Data
	{
		/**
		 * 保存最新的服务器数据
		 */
		private static var _packZone:HashMap=new HashMap();

		public function Data()
		{
		}

		public static function get packZone():HashMap
		{
			return _packZone;
		}

		/**
		 * 数据集数组,
		 * 每个数据集依服务器数据(收，发)得出 逻辑集
		 */
		private static var _listSetIndex:int=0;
		private static var _listSet:Vector.<ISet>=new Vector.<ISet>();

		/**
		 * length为0时初始化数组
		 */
		private static function chklistSet():void
		{
			if (0 == _listSetIndex)
			{
				listSet;
			}
		}

		private static function get listSet():Vector.<ISet>
		{
			if (0 == _listSet.length)
			{
				//主角
				_myKingSet=new MyCharacterSet(packZone);
				_listSet.push(_myKingSet);
				_myKingIndex=_listSet.length - 1;


				//
				_npcSet=new NpcSet(packZone);
				_listSet.push(_npcSet);
				_npcIndex=_listSet.length - 1;

				//
				_skillShortSet=new SkillShortSet(packZone);
				_listSet.push(_skillShortSet);
				_skillShortIndex=_listSet.length - 1;

				//背包，仓库，装备 
				_beibaoSet=new BeiBaoSet(packZone);
				_listSet.push(_beibaoSet);
				_beibaoIndex=_listSet.length - 1;

				//
				_haoYouSet=new HaoYouSet(packZone);
				_listSet.push(_haoYouSet);
				_haoYouIndex=_listSet.length - 1;
				//角色【炼骨，坐骑，丹药】
				_jiaoSeSet=new JiaoSeSet(packZone);
				_listSet.push(_jiaoSeSet);
				_jiaoSeIndex=_listSet.length - 1;
				//活动
				_huoDongSet=new HuoDongSet(packZone);
				_listSet.push(_huoDongSet);
				_huoDongIndex=_listSet.length - 1;
				//时间
				_dateSet=new DateSet(packZone);
				_listSet.push(_dateSet);
				_dateIndex=_listSet.length - 1;
				//空闲
				_idleTimeSet=new IdleTimeSet(packZone);
				_listSet.push(_idleTimeSet);
				_idleTimeIndex=_listSet.length - 1;
				//经验获得的又一途径
				_monsterExpSet=new MonsterExpSet(packZone);
				_listSet.push(_monsterExpSet);
				_monsterExpIndex=_listSet.length - 1;
				//魔天万界
				_moTianSet=new MoTianSet(packZone);
				_listSet.push(_moTianSet);
				_moTianIndex=_listSet.length - 1;
				//家族
				_jiaZuSet=new JiaZuSet(packZone);
				_listSet.push(_jiaZuSet);
				_jiaZuIndex=_listSet.length - 1;
				//
				_paiHangSet=new PaiHangSet(packZone);
				_listSet.push(_paiHangSet);
				_paiHangIndex=_listSet.length - 1;
				//
//				_huoBanSet=new HuoBanSet(packZone);
//				_listSet.push(_huoBanSet);
//				_huoBanIndex=_listSet.length - 1;
				//
				_skillSet = new SkillSet(packZone)
				_listSet.push(_skillSet)
				_skillSetIndex = _listSet.length - 1
				//
//				_cangJingGeSet = new CangJingGeSet(packZone);
//				_listSet.push(_cangJingGeSet);
//				_cangJingGeSetIndex = _listSet.length - 1;
				//
				_zuoQiSet = new ZuoQiSet(packZone);
				_listSet.push(_zuoQiSet);
				_zuoQiSetIndex = _listSet.length - 1;
				//
				_fuBenSet = new FuBenSet(packZone);
				_listSet.push(_fuBenSet);
				_fuBenSetIndex = _listSet.length - 1;
				//
				_bangPaiSet = new BangPaiSet(packZone);
				_listSet.push(_bangPaiSet);
				_bangPaiSetIndex = _listSet.length - 1;

				//总结个数
				_listSetIndex=_listSet.length;
			}

			return _listSet;
		}
		
		private static var _skillSetIndex:int;
		private static var _skillSet:SkillSet;
		public static function get skill():SkillSet
		{
			chklistSet();
			return _skillSet;
		}

		/**
		 * 排行
		 */
		private static var _paiHangIndex:int;
		private static var _paiHangSet:PaiHangSet;

		public static function get paiHang():PaiHangSet
		{
			//listSet;
			chklistSet();
			return _paiHangSet;
		}
		/**
		 * 伙伴
		 */
//		private static var _huoBanIndex:int;
//		private static var _huoBanSet:HuoBanSet;
//
//		public static function get huoBan():HuoBanSet
//		{
//			//listSet;
//			chklistSet();
//			return _huoBanSet;
//		}
		/**
		 * 获取背包数据集，
		 * 如没有请在listSet里用push方法 加入
		 */
		private static var _beibaoIndex:int;
		private static var _beibaoSet:BeiBaoSet;

		public static function get beiBao():BeiBaoSet
		{
			//listSet;
			chklistSet();
			return _beibaoSet;
			//return listSet[_beibaoIndex] as BeiBaoSet;
		}


		private static var _npcIndex:int;
		private static var _npcSet:NpcSet;

		public static function get npc():NpcSet
		{
			//listSet;
			chklistSet();
			return _npcSet;
			//return listSet[_npcIndex] as NpcSet;
		}

		private static var _skillShortIndex:int;
		private static var _skillShortSet:SkillShortSet;

		public static function get skillShort():SkillShortSet
		{
			//listSet;
			chklistSet();
			return _skillShortSet;
			//return listSet[_skillShortIndex] as SkillShortSet;
		}

		/**
		 * 获取主角信息，
		 * 如没有请在listSet里用push方法 加入
		 */
		private static var _myKingIndex:int;
		private static var _myKingSet:MyCharacterSet;

		public static function get myKing():MyCharacterSet
		{
			//listSet;
			chklistSet();
			return _myKingSet;
			//return listSet[_myKingIndex] as MyCharacterSet;
		}

		/**
		 *	好友信息
		 */
		private static var _haoYouIndex:int;
		private static var _haoYouSet:HaoYouSet;

		public static function get haoYou():HaoYouSet
		{
			//listSet;
			chklistSet();
			return _haoYouSet;
			//return listSet[_haoYouIndex] as HaoYouSet;
		}
		/**
		 *	角色信息
		 */
		private static var _jiaoSeIndex:int;
		private static var _jiaoSeSet:JiaoSeSet;

		public static function get jiaoSe():JiaoSeSet
		{
			//listSet;
			chklistSet();
			return _jiaoSeSet;

			//return listSet[_jiaoSeIndex] as JiaoSeSet;
		}

		/**
		 *	活动信息
		 */
		private static var _huoDongIndex:int;
		private static var _huoDongSet:HuoDongSet;

		public static function get huoDong():HuoDongSet
		{
			//listSet;
			chklistSet();
			return _huoDongSet;

			//return listSet[_huoDongIndex] as HuoDongSet;
		}

		/**
		 * 时间信息
		 */
		private static var _dateIndex:int;
		private static var _dateSet:DateSet;

		public static function get date():DateSet
		{
			//listSet;
			chklistSet();
			//==========whr==========
			return _dateSet;

			//return listSet[_dateIndex] as DateSet;
		}

		/**
		 * 空闲信息
		 */
		private static var _idleTimeIndex:int;
		private static var _idleTimeSet:IdleTimeSet;

		public static function get idleTime():IdleTimeSet
		{
			//listSet;
			chklistSet();
			return _idleTimeSet;

			//return listSet[_idleTimeIndex] as IdleTimeSet;
		}

		/**
		 * 获得的经验又一途径
		 */
		private static var _monsterExpIndex:int;
		private static var _monsterExpSet:MonsterExpSet;

		public static function get monsterExp():MonsterExpSet
		{
			//listSet;
			chklistSet();
			return _monsterExpSet;

			//return listSet[_monsterExpIndex] as MonsterExpSet;
		}

		/**
		 * 魔天万界
		 */
		private static var _moTianIndex:int;
		private static var _moTianSet:MoTianSet;

		public static function get moTian():MoTianSet
		{
			//listSet;
			chklistSet();
			return _moTianSet;

			//return listSet[_moTianIndex] as MoTianSet;
		}

		/**
		 * 家族
		 */
		private static var _jiaZuIndex:int;
		private static var _jiaZuSet:JiaZuSet;

		public static function get jiaZu():JiaZuSet
		{
			//listSet;
			chklistSet();
			return _jiaZuSet;
			//return listSet[_jiaZuIndex] as JiaZuSet;
		}

		
		
		private static var _zuoQiSetIndex:int;
		private static var _zuoQiSet:ZuoQiSet;
		public static function get zuoQi():ZuoQiSet
		{
			chklistSet();
			return _zuoQiSet;
		}
		
		private static var _fuBenSetIndex:int;
		private static var _fuBenSet:FuBenSet;
		public static function get fuBen():FuBenSet
		{
			chklistSet();
			return _fuBenSet;
		}
		
		private static var _bangPaiSetIndex:int;
		private static var _bangPaiSet:BangPaiSet;
		public static function get bangPai():BangPaiSet
		{
			chklistSet();
			return _bangPaiSet;
		}

		/**
		 * 同步各个数据集的数据更新
		 */
//		public static function sync(p:PacketSCPlayerData2):void
		public static function sync(p:IPacket):void
		{
			var i:int=0;
			var len:int=listSet.length;

			for (i=0; i < len; i++)
			{
				listSet[i].sync(p);
			}

		}

	}
}
