package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildSkillInfo2
    /** 
    *工会技能研发信息
    */
    public class StructGuildSkillList implements ISerializable
    {
        /** 
        *技能列表
        */
        public var arrItemlist:Vector.<StructGuildSkillInfo2> = new Vector.<StructGuildSkillInfo2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemlist.length);
            for each (var listitem:Object in arrItemlist)
            {
                var objlist:ISerializable = listitem as ISerializable;
                if (null!=objlist)
                {
                    objlist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemlist= new  Vector.<StructGuildSkillInfo2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objGuildSkillInfo:StructGuildSkillInfo2 = new StructGuildSkillInfo2();
                objGuildSkillInfo.Deserialize(ar);
                arrItemlist.push(objGuildSkillInfo);
            }
        }
    }
}
