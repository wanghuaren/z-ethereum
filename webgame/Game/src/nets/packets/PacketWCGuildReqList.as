package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildRequire2
    /** 
    *公会申请列表
    */
    public class PacketWCGuildReqList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39213;
        /** 
        *公会申请列表
        */
        public var arrItemReqlist:Vector.<StructGuildRequire2> = new Vector.<StructGuildRequire2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemReqlist.length);
            for each (var Reqlistitem:Object in arrItemReqlist)
            {
                var objReqlist:ISerializable = Reqlistitem as ISerializable;
                if (null!=objReqlist)
                {
                    objReqlist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemReqlist= new  Vector.<StructGuildRequire2>();
            var ReqlistLength:int = ar.readInt();
            for (var iReqlist:int=0;iReqlist<ReqlistLength; ++iReqlist)
            {
                var objGuildRequire:StructGuildRequire2 = new StructGuildRequire2();
                objGuildRequire.Deserialize(ar);
                arrItemReqlist.push(objGuildRequire);
            }
        }
    }
}
