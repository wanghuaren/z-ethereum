package scene.action.hangup
{
	import flash.display.Sprite;
	
	/**
	 * 游戏辅助功能 测试类 (老版本的挂机功能的改版)
	 * @author steven guo
	 * 
	 */	
	public class GamePlugInsTest extends Sprite
	{
		private var m_target:GamePlugIns = null;
		
		public function GamePlugInsTest()
		{
			//TODO: implement function
			super();
			
			m_target = new GamePlugIns();
			
			m_target.autoIdxHP = 1;
			m_target.autoIdxMP = 1;
			m_target.autoPerHP = 50;
			m_target.autoPerMP = 50;
			m_target.autoTimeHP = 500;
			m_target.autoTimeMP = 500;
			m_target.isAttackBoss = false;
			m_target.isAttackEnemy = false;
			m_target.isAutoHP = true;
			m_target.isAutoMP = true;
			m_target.isAutoSkill = true;
			m_target.isPickUpEquip = true;
			m_target.isPickUpMaterial = true;
			m_target.isPickUpMedicine = true;
			m_target.isPickUpOthers = true;
			m_target.isProtect = true;
			m_target.minLevelPickUpEquip = 40;
			m_target.pickUpOthersLevel = 1;
			m_target.protectPer = 50;
			m_target.protectPropIdx = 1;
			m_target.scope = 2;
			
			m_target.requestPacketCSSetAutoConfig();
		}
		
		
	}
	
	
}






