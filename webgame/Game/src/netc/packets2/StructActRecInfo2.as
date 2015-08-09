package netc.packets2
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_AchievementResModel;
	
	import nets.packets.StructActRecInfo;

	public class StructActRecInfo2 extends StructActRecInfo
	{
		public function get sort():int{
			var itemData:Pub_AchievementResModel=XmlManager.localres.AchievementXml.getResPath(this.arid) as Pub_AchievementResModel;
			if(itemData!=null){
				return itemData.sort;
			}
			return 0;
		}
	}
}