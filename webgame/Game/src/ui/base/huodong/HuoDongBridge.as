package ui.base.huodong
{
	import flash.display.Sprite;
	
	import ui.view.view2.mrfl_qiandao.QianDao;

	public class HuoDongBridge
	{
		
		//充值福利页签
		private static var m_RewardOfAddMoney_:RewardOfAddMoney;
		
		//运用活动页签
		private static var m_OperatingActivity_:OperatingActivity;
		
		
				
		
		
		public static function m_RewardOfAddMoney(mc_:Sprite = null):RewardOfAddMoney
		{
			if (null == m_RewardOfAddMoney_)
			{
				m_RewardOfAddMoney_=RewardOfAddMoney.getInstance();				
			}
			
			if(null != mc_ && m_RewardOfAddMoney_.is_m_ui_null)
			{
				m_RewardOfAddMoney_.setUI(mc_);
			}
			
			if(m_RewardOfAddMoney_.is_m_ui_null)
			{
				throw new Error("first run you must set mc_ param !");
			}
			
			return m_RewardOfAddMoney_;
		
		}
		
		public static function m_OperatingActivity(mc_:Sprite = null):OperatingActivity
		{
		
			if (null == m_OperatingActivity_)
			{
				m_OperatingActivity_=OperatingActivity.getInstance();
				
			}			
			
			if(null != mc_ && m_OperatingActivity_.is_m_ui_null)
			{
				m_OperatingActivity_.setUI(mc_);
			}
			
			if(m_OperatingActivity_.is_m_ui_null)
			{
				throw new Error("first run you must set mc_ param !");
			}
			
			return m_OperatingActivity_;
		
		}
		
		
		
		
		
		
	}
}