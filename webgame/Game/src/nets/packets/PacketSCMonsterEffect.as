package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *BOSS特效
    */
    public class PacketSCMonsterEffect implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14041;
        /** 
        *模版id
        */
        public var infoid:int;
        /** 
        *1文字特效,2动画特效
        */
        public var flag:int;
        /** 
        *坐标x
        */
        public var posx:int;
        /** 
        *坐标y
        */
        public var posy:int;
        /** 
        *对象id
        */
        public var objid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(infoid);
            ar.writeInt(flag);
            ar.writeInt(posx);
            ar.writeInt(posy);
            ar.writeInt(objid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            infoid = ar.readInt();
            flag = ar.readInt();
            posx = ar.readInt();
            posy = ar.readInt();
            objid = ar.readInt();
        }
    }
}
