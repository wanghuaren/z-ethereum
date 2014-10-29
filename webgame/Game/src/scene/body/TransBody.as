package scene.body
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.def.DepthDef;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.model.lib.Lib;

	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Map_SeekResModel;

	import flash.utils.setTimeout;

	import netc.Data;
	import netc.DataKey;
	import netc.packets2.PacketSCMapSeek2;
	import netc.packets2.StructMapSeek2;

	import nets.packets.PacketSCMapSeek;

	import scene.king.IGameKing;
	import scene.manager.SceneManager;

	import world.WorldFactory;
	import world.model.file.BeingFilePath;
	import world.type.BeingType;
	import world.type.ItemType;
	import world.type.WorldType;

	public class TransBody
	{
		public function TransBody()
		{
			DataKey.instance.register(PacketSCMapSeek.id, CTransGetList);

		}
		private var transData:Vector.<StructMapSeek2>;

		public function CTransGetList(p:PacketSCMapSeek2):void
		{
			transData=p.arrItemlist;
//			var i:int;
//			var len:int=p.arrItemlist.length;
//
//			for (i=0; i < len; i++)
//			{
//				GetTrans(p.arrItemlist[i]);
//
//			} //end for
		}

		public function canAddTrans(px:int, py:int):void
		{
			if(transData==null) return;
			for (var i:int=0; i < transData.length; i++)
			{
				if (Math.abs(transData[i].map_x - px) < 10 && Math.abs(transData[i].map_y - py) < 10)
				{
					GetTrans(transData[i]);
					transData.splice(i,1);
				}
			}
		}

		public function GetTrans(data:StructMapSeek2):void
		{
			var isNew:Boolean=false;
			var GameTrans:IGameKing=SceneManager.instance.GetKing_Core(data.seek_id);
			//职业和性别同怪物
			var metier:int=0;
			var sex:int=0;
			if (null == GameTrans)
			{
				isNew=true;
			}
			if (isNew)
			{
				GameTrans=WorldFactory.createBeing(BeingType.TRANS);
				GameTrans.name=WorldType.WORLD + data.seek_id.toString();
				GameTrans.name2=BeingType.TRANS + data.seek_id.toString();
				GameTrans.setKingData(data.seek_id, data.seek_id, data.seek_name, sex, metier, 1, 1, 1, Data.myKing.campid, -1, data.map_x, data.map_y + 2, -1, "", -1, -1);
				SceneManager.instance.AddKing_Core(GameTrans);
				GameTrans.setSelectable=true;
				GameTrans.setCamp=Data.myKing.campid;
//项目转换				var m:Pub_Map_SeekResModel = Lib.getObj(LibDef.PUB_MAP_SEEK, data.seek_id.toString());
				var m:Pub_Map_SeekResModel=XmlManager.localres.getPubMapSeekXml.getResPath(data.seek_id) as Pub_Map_SeekResModel;
				if (m != null)
				{
					var swf_path2:String=GameData.GAMESERVERS + "Effect/Sys_" + m.res_id.toString() + ".swf";
					var xml_path2:String=GameData.GAMESERVERS + "Effect/Sys_" + m.res_id.toString() + "xml.xml";
				}
				//先用小孩代替
				var pList:Array=["", "", swf_path2, ""];
				var xList:Array=["", "", xml_path2, ""];
				//
				var bfp:BeingFilePath=null;
				if (m != null)
				{
					bfp=new BeingFilePath(0, 0, m.res_id, 0, pList, xList);
				}
				GameTrans.depthPri=DepthDef.BOTTOM;
				GameTrans.checkMouseEnable();
				setTimeout(function():void
				{
					if (bfp != null)
					{
						GameTrans.setKingSkin(bfp);
					}
					GameTrans.checkMouseEnable();
				}, 500);
			}
			else
			{
				GameTrans.setKingData(data.seek_id, data.seek_id, data.seek_name, sex, metier, 1, 1, 1, Data.myKing.campid, -1, data.map_x, data.map_y, -1, "", -1, -1);
				GameTrans.checkMouseEnable();
			}
		}
	}
}
