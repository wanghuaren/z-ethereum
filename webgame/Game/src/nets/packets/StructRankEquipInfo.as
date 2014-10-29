package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSCEquipTip2
    /** 
    *排名数据
    */
    public class StructRankEquipInfo implements ISerializable
    {
        /** 
        *位置
        */
        public var pos:int;
        /** 
        *装备
        */
        public var equip:StructSCEquipTip2 = new StructSCEquipTip2();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(pos);
            equip.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
            equip.Deserialize(ar);
        }
    }
}
