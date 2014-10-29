package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructCooldown2
    /** 
    *返回冷却数据
    */
    public class PacketSCCooldownList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14021;
        /** 
        *冷却时间列表
        */
        public var arrItemlist:Vector.<StructCooldown2> = new Vector.<StructCooldown2>();
        /** 
        *技能公共冷却时间
        */
        public var skillcooldown:int;
        /** 
        *物品公共冷却时间
        */
        public var itemcooldown:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemlist.length);
            for each (var listitem:Object in arrItemlist)
            {
                var objlist:ISerializable = listitem as ISerializable;
                if (null!=objlist)
                {
                    objlist.Serialize(ar);
                }
            }
            ar.writeInt(skillcooldown);
            ar.writeInt(itemcooldown);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemlist= new  Vector.<StructCooldown2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objCooldown:StructCooldown2 = new StructCooldown2();
                objCooldown.Deserialize(ar);
                arrItemlist.push(objCooldown);
            }
            skillcooldown = ar.readInt();
            itemcooldown = ar.readInt();
        }
    }
}
