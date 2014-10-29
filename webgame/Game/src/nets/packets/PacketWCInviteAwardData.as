package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructAwardLog2
    /** 
    *获取邀请抽奖数据
    */
    public class PacketWCInviteAwardData implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 37016;
        /** 
        *获奖日志
        */
        public var arrItemloglist:Vector.<StructAwardLog2> = new Vector.<StructAwardLog2>();
        /** 
        *掉落编号
        */
        public var dropid:int;
        /** 
        *当前奖励
        */
        public var itemid:int;
        /** 
        *当前奖励数量
        */
        public var itemnum:int;
        /** 
        *是否抽取过奖励没有,0没有，1抽取过
        */
        public var isdraw:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemloglist.length);
            for each (var loglistitem:Object in arrItemloglist)
            {
                var objloglist:ISerializable = loglistitem as ISerializable;
                if (null!=objloglist)
                {
                    objloglist.Serialize(ar);
                }
            }
            ar.writeInt(dropid);
            ar.writeInt(itemid);
            ar.writeInt(itemnum);
            ar.writeInt(isdraw);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemloglist= new  Vector.<StructAwardLog2>();
            var loglistLength:int = ar.readInt();
            for (var iloglist:int=0;iloglist<loglistLength; ++iloglist)
            {
                var objAwardLog:StructAwardLog2 = new StructAwardLog2();
                objAwardLog.Deserialize(ar);
                arrItemloglist.push(objAwardLog);
            }
            dropid = ar.readInt();
            itemid = ar.readInt();
            itemnum = ar.readInt();
            isdraw = ar.readInt();
        }
    }
}
