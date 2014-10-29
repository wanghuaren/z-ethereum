package model.wulinbaodian
{
	public class WuLinBaoDianController
	{
		private static var m_instance:WuLinBaoDianController;
		private var m_baodianView:WuLinBaodianView;
		public function WuLinBaoDianController()
		{
			
//			DataKey.instance.register(PacketSCBourn.id,_responseSCBourn);
//			DataKey.instance.register(PacketSCEatPill.id,_responseSCEatPill);
			init();
		}
		public static function getInstance():WuLinBaoDianController
		{
			if(null == m_instance)
			{
				m_instance = new WuLinBaoDianController();
			}
			
			return m_instance;
		}
		private function init():void
		{
//			WuLinBaodianView.getInstance().openWin();
		}
		public function setModelData():void
		{
			
		}
		
	}
}