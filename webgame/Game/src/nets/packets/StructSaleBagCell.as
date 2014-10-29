package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructBagCell2
    /** 
    *摆摊物品格数据
    */
    public class StructSaleBagCell implements ISerializable
    {
        /** 
        *物品信息
        */
        public var bagcell:StructBagCell2 = new StructBagCell2();
        /** 
        *售价
        */
        public var price:int;

        public function Serialize(ar:ByteArray):void
        {
            bagcell.Serialize(ar);
            ar.writeInt(price);
        }
        public function Deserialize(ar:ByteArray):void
        {
            bagcell.Deserialize(ar);
            price = ar.readInt();
        }
    }
}
