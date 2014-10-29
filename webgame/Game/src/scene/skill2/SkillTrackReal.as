package scene.skill2
{
	import com.bellaxu.data.GameData;
	
	import flash.utils.Dictionary;
	
	import netc.packets2.PacketSCObjDetail2;
	
	import nets.packets.PacketSCObjBuffList;
	
	import scene.body.KingBody;
	import scene.king.IGameKing;
	import scene.manager.SceneManager;

	/**
	 *@author WangHuaRen
	 *@playerversion 2013-6-7_下午8:31:15
	 **/
	public class SkillTrackReal
	{
		private static var _instance:SkillTrackReal;

		public static function get instance():SkillTrackReal
		{
			if (_instance == null)
			{
				_instance=new SkillTrackReal();
			}
			return _instance;
		}

		public function SkillTrackReal()
		{
		}
		/**
		 * 攻击 并且成功的对象
		 * */
		public var dicAttackSucessObj:Dictionary=new Dictionary();
		/**
		 * 地图上怪物受攻击后的信息
		 * */
		public var _dicMapObj:Dictionary=new Dictionary();

		public function get dicMapObj():Dictionary
		{
			return _dicMapObj;
		}

		public function set dicMapObj(value:Dictionary):void
		{
			_dicMapObj=value;
		}
//		private var m_p2:PacketSCObjDetail2;//缓存一个攻击的怪
		/**
		 * 取得受攻击怪物信息后  对其操作
		 * */
		public function mapObjStatus(pObjid:int):void
		{
			var m_p:PacketSCObjDetail2=dicMapObj[pObjid];
			if (m_p == null)
			{
				return;
			}
			var k:IGameKing=SceneManager.instance.GetKing_Core(m_p.objid);

			if (null == k)
			{
				return;
			}

			if (-1 != m_p.movspeed)
				k.setSpeed=m_p.movspeed;

			if (-1 != m_p.maxhp)
				k.setMaxHp=m_p.maxhp;
			if (-1 != m_p.hp)
				k.setHp=m_p.hp;
			if (-1 != m_p.maxmp)
				k.setMaxMp=m_p.maxmp;

			if (-1 != m_p.mp)
				k.setMp=m_p.mp;

			//处理  buff 特效,已经处理过buff特效，此处不再处理  ??????????? 在哪里处理了?
//			if (-1 != m_p.buffeffect)
//				k.setBuff=m_p.buffeffect;
			

			delete dicAttackSucessObj[m_p.objid];
			delete dicMapObj[m_p.objid];
		}
		public var dicMapObjWillDispppear:Dictionary=new Dictionary();

		public function mapObjLeave(pObjid:int):void
		{
			var value:KingBody=dicMapObjWillDispppear[pObjid];
			if (value != null)
			{
				value.disppearObj(pObjid);
			}
			delete dicMapObjWillDispppear[pObjid];
			delete dicAttackSucessObj[pObjid];
			delete dicMapObj[pObjid];
			evetyItem();
		}

		/**
		 * 遍历需要消失的项   让马上要消失的消失
		 * */
		public function evetyItem():void
		{
			var value:KingBody;
			for (var m_objid:String in dicMapObjWillDispppear)
			{
				if (dicAttackSucessObj[m_objid] == undefined)
				{
					value=dicMapObjWillDispppear[m_objid];
					if (value != null)
					{
						value.disppearObj(int(m_objid));
					}
					delete dicMapObjWillDispppear[m_objid];
					delete dicAttackSucessObj[m_objid];
					delete dicMapObj[m_objid];
				}
			}
		}
		//攻击延迟死亡
		public function update():void
		{
			for each(var p:PacketSCObjDetail2 in _dicMapObj)
			{
				this.mapObjStatus(p.objid);
			}
		}
	}
}
