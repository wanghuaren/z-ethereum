package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructInvest2
    /** 
    *投资计划信息返回
    */
    public class PacketSCGetInvestInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54603;
        /** 
        *活动开始天数
        */
        public var actopen_day:int;
        /** 
        *投资领取状态
        */
        public var arrItemstatus:Vector.<StructInvest2> = new Vector.<StructInvest2>();
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(actopen_day);
            ar.writeInt(arrItemstatus.length);
            for each (var statusitem:Object in arrItemstatus)
            {
                var objstatus:ISerializable = statusitem as ISerializable;
                if (null!=objstatus)
                {
                    objstatus.Serialize(ar);
                }
            }
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            actopen_day = ar.readInt();
            arrItemstatus= new  Vector.<StructInvest2>();
            var statusLength:int = ar.readInt();
            for (var istatus:int=0;istatus<statusLength; ++istatus)
            {
                var objInvest:StructInvest2 = new StructInvest2();
                objInvest.Deserialize(ar);
                arrItemstatus.push(objInvest);
            }
            tag = ar.readInt();
        }
    }
}
