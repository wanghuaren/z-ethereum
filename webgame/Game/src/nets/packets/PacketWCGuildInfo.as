package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildInfo2
    import netc.packets2.StructGuildRequire2
    import netc.packets2.StructGuildSkillList2
    import netc.packets2.StructGuildItemList2
    /** 
    *获得家族信息
    */
    public class PacketWCGuildInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39231;
        /** 
        *家族信息
        */
        public var guildinfo:StructGuildInfo2 = new StructGuildInfo2();
        /** 
        *成员列表
        */
        public var arrItemmemberlist:Vector.<StructGuildRequire2> = new Vector.<StructGuildRequire2>();
        /** 
        *技能列表
        */
        public var skilllist:StructGuildSkillList2 = new StructGuildSkillList2();
        /** 
        *珍宝列表
        */
        public var itemlist:StructGuildItemList2 = new StructGuildItemList2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            guildinfo.Serialize(ar);
            ar.writeInt(arrItemmemberlist.length);
            for each (var memberlistitem:Object in arrItemmemberlist)
            {
                var objmemberlist:ISerializable = memberlistitem as ISerializable;
                if (null!=objmemberlist)
                {
                    objmemberlist.Serialize(ar);
                }
            }
            skilllist.Serialize(ar);
            itemlist.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            guildinfo.Deserialize(ar);
            arrItemmemberlist= new  Vector.<StructGuildRequire2>();
            var memberlistLength:int = ar.readInt();
            for (var imemberlist:int=0;imemberlist<memberlistLength; ++imemberlist)
            {
                var objGuildRequire:StructGuildRequire2 = new StructGuildRequire2();
                objGuildRequire.Deserialize(ar);
                arrItemmemberlist.push(objGuildRequire);
            }
            skilllist.Deserialize(ar);
            itemlist.Deserialize(ar);
        }
    }
}
