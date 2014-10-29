package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *仇敌数据
    */
    public class StructEnemyItem implements ISerializable
    {
        /** 
        *角色id
        */
        public var userid:int;
        /** 
        *角色名称
        */
        public var king_name:String = new String();
        /** 
        *地图编号
        */
        public var map_id:int;
        /** 
        *杀死时间
        */
        public var killtime:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(userid);
            PacketFactory.Instance.WriteString(ar, king_name, 50);
            ar.writeInt(map_id);
            ar.writeInt(killtime);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            var king_nameLength:int = ar.readInt();
            king_name = ar.readMultiByte(king_nameLength,PacketFactory.Instance.GetCharSet());
            map_id = ar.readInt();
            killtime = ar.readInt();
        }
    }
}
