package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *视野内物体瞬间移动
    */
    public class PacketSCObjTeleport implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 11005;
        /** 
        *物体id
        */
        public var objid:int;
        /** 
        *X坐标
        */
        public var posx:int;
        /** 
        *y坐标
        */
        public var posy:int;
        /** 
        *技能
        */
        public var skillid:int;
        /** 
        *寻路
        */
        public var seekid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
            ar.writeInt(posx);
            ar.writeInt(posy);
            ar.writeInt(skillid);
            ar.writeInt(seekid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            posx = ar.readInt();
            posy = ar.readInt();
            skillid = ar.readInt();
            seekid = ar.readInt();
        }
    }
}
