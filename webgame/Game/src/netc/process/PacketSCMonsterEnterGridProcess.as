/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 *
 */
package netc.process
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;

	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;

	import flash.utils.getQualifiedClassName;

	import netc.packets2.PacketSCMonsterEnterGrid2;

	import world.FileManager;
	import world.model.file.BeingFilePath;

	public class PacketSCMonsterEnterGridProcess extends PacketBaseProcess
	{
		public function PacketSCMonsterEnterGridProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCMonsterEnterGrid2=pack as PacketSCMonsterEnterGrid2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			//step2
			//"monster/m0001"
			var outlookFile:BeingFilePath;
			var res_id:int;
			//查表无法查到，水贼头目 临时代替
			var DEF_RES_ID:int=30300021;
			if (2 == p.monsterinfo.isnpc)
			{
			
			
			
			
				res_id = DEF_RES_ID;
				
				outlookFile = FileManager.instance.getMainByMonsterId(res_id);
			
			}else if (4 == p.monsterinfo.isnpc || 6 == p.monsterinfo.isnpc)
			{
				var resSkill:Pub_Skill_SpecialResModel=XmlManager.localres.SkillSpecialXml.getResPath(p.monsterinfo.templateid) as Pub_Skill_SpecialResModel;
				res_id=null == resSkill ? DEF_RES_ID : resSkill.out_look;
				if (6 == p.monsterinfo.isnpc)//火墙
				{
					p.monsterinfo.direct = 0;
					outlookFile = FileManager.instance.getSkillFileByResId(401206);
				}
				else
				{
					outlookFile = FileManager.instance.getMainByMonsterId(res_id);
				}
			}
			else
			{
				var resDefault:Pub_NpcResModel=XmlManager.localres.getNpcXml.getResPath(p.monsterinfo.templateid) as Pub_NpcResModel;
				res_id=null == resDefault ? DEF_RES_ID : resDefault.res_id;
				var show_name:int=null == resDefault ? 0 : resDefault.show_name;
				p.monsterinfo.qiangZhi_show_name=1 == show_name ? true : false;
				//------------------------------ begin -----------------------------------------------
				var res_id1_:String=null == resDefault ? "40302M" : resDefault.res_id1;
				var res_id2_:String=null == resDefault ? "40303M" : resDefault.res_id2;
				var res_id3_:String=null == resDefault ? "31000010" : resDefault.res_id3;
				//test
				//res_id = 1;
				//res_id1_ = "10102M";
				//res_id2_ = "10103M";
				if (1 != res_id)
				{
					outlookFile=FileManager.instance.getMainByNpcId(res_id);
				}
				else
				{
					var res_id1:int=parseInt(res_id1_.replace("M", "").replace("W", ""));
					var res_id2:int=parseInt(res_id2_.replace("M", "").replace("W", ""));
					var res_id3:int=parseInt(res_id3_.replace("M", "").replace("W", ""));
					var sexPath:String=res_id1_.replace(res_id1.toString(), "");
					//1 - 身体 2-武器					
					outlookFile=FileManager.instance.getMainByMonsterId__(res_id3, 0, res_id1, res_id2, sexPath);
				}
					//------------------------------- end ---------------------------------------------
			}
			p.monsterinfo.filePath=outlookFile;
			//step3
			return p;
		}
	}
}
