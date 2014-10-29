package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructEnemyItem2
    /** 
    *增加一个仇人
    */
    public class PacketSCEnemyAdd implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 3023;
        /** 
        *仇敌数组
        */
        public var EnemyItem:StructEnemyItem2 = new StructEnemyItem2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            EnemyItem.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            EnemyItem.Deserialize(ar);
        }
    }
}
