package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSHJoinInfo2
    /** 
    *请求个人赛参赛列表返回
    */
    public class PacketSCGetSHJoinList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53010;
        /** 
        *总人数
        */
        public var total_num:int;
        /** 
        *参赛列表
        */
        public var arrItemjoinlist:Vector.<StructSHJoinInfo2> = new Vector.<StructSHJoinInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(total_num);
            ar.writeInt(arrItemjoinlist.length);
            for each (var joinlistitem:Object in arrItemjoinlist)
            {
                var objjoinlist:ISerializable = joinlistitem as ISerializable;
                if (null!=objjoinlist)
                {
                    objjoinlist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            total_num = ar.readInt();
            arrItemjoinlist= new  Vector.<StructSHJoinInfo2>();
            var joinlistLength:int = ar.readInt();
            for (var ijoinlist:int=0;ijoinlist<joinlistLength; ++ijoinlist)
            {
                var objSHJoinInfo:StructSHJoinInfo2 = new StructSHJoinInfo2();
                objSHJoinInfo.Deserialize(ar);
                arrItemjoinlist.push(objSHJoinInfo);
            }
        }
    }
}
