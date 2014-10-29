package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *资源进入视野
    */
    public class PacketSCResEnterGrid implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1011;
        /** 
        *资源id
        */
        public var objid:int;
        /** 
        *坐标x
        */
        public var posx:int;
        /** 
        *坐标y
        */
        public var posy:int;
        /** 
        *方向
        */
        public var direct:int;
        /** 
        *指定资源的modeid
        */
        public var modeid:int;
        /** 
        *指定资源的名称
        */
        public var res_name:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
            ar.writeInt(posx);
            ar.writeInt(posy);
            ar.writeInt(direct);
            ar.writeInt(modeid);
            PacketFactory.Instance.WriteString(ar, res_name, 64);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            posx = ar.readInt();
            posy = ar.readInt();
            direct = ar.readInt();
            modeid = ar.readInt();
            var res_nameLength:int = ar.readInt();
            res_name = ar.readMultiByte(res_nameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
