package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructCooldown2
    /** 
    *进入冷却
    */
    public class PacketSCCooldown implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14022;
        /** 
        *冷却对象
        */
        public var cooldown:StructCooldown2 = new StructCooldown2();
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
            cooldown.Serialize(ar);
            ar.writeInt(skillcooldown);
            ar.writeInt(itemcooldown);
        }
        public function Deserialize(ar:ByteArray):void
        {
            cooldown.Deserialize(ar);
            skillcooldown = ar.readInt();
            itemcooldown = ar.readInt();
        }
    }
}
