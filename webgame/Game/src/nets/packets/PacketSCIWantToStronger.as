package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *我要变强
    */
    public class PacketSCIWantToStronger implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24505;
        /** 
        *评分
        */
        public var arrItemgrades:Vector.<int> = new Vector.<int>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemgrades.length);
            for each (var gradesitem:int in arrItemgrades)
            {
                ar.writeInt(gradesitem);
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemgrades= new  Vector.<int>();
            var gradesLength:int = ar.readInt();
            for (var igrades:int=0;igrades<gradesLength; ++igrades)
            {
                arrItemgrades.push(ar.readInt());
            }
        }
    }
}
