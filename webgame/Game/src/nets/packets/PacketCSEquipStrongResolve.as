package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *装备分解
    */
    public class PacketCSEquipStrongResolve implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15053;
        /** 
        *装备位置信息
        */
        public var arrItemequips:Vector.<int> = new Vector.<int>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemequips.length);
            for each (var equipsitem:int in arrItemequips)
            {
                ar.writeInt(equipsitem);
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemequips= new  Vector.<int>();
            var equipsLength:int = ar.readInt();
            for (var iequips:int=0;iequips<equipsLength; ++iequips)
            {
                arrItemequips.push(ar.readInt());
            }
        }
    }
}
