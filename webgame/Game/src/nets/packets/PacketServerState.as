package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructServer_Detail2
    /** 
    *服务器监视数据
    */
    public class PacketServerState implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1101;
        /** 
        *服务器状态
        */
        public var live:int;
        /** 
        *Player数量
        */
        public var players:int;
        /** 
        *异常数量
        */
        public var exception:int;
        /** 
        *自动重启
        */
        public var automodel:int;
        /** 
        *地图分线策略
        */
        public var mappolicy:int;
        /** 
        *服务器组详细信息
        */
        public var arrItemgroup:Vector.<StructServer_Detail2> = new Vector.<StructServer_Detail2>();
        /** 
        *必需的服务器
        */
        public var arrItemneedservers:Vector.<int> = new Vector.<int>();
        /** 
        *机器人数量
        */
        public var robot:int;
        /** 
        *开区时间
        */
        public var startDate:int;
        /** 
        *运行天数
        */
        public var runDays:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(live);
            ar.writeInt(players);
            ar.writeInt(exception);
            ar.writeInt(automodel);
            ar.writeInt(mappolicy);
            ar.writeInt(arrItemgroup.length);
            for each (var groupitem:Object in arrItemgroup)
            {
                var objgroup:ISerializable = groupitem as ISerializable;
                if (null!=objgroup)
                {
                    objgroup.Serialize(ar);
                }
            }
            ar.writeInt(arrItemneedservers.length);
            for each (var needserversitem:int in arrItemneedservers)
            {
                ar.writeInt(needserversitem);
            }
            ar.writeInt(robot);
            ar.writeInt(startDate);
            ar.writeInt(runDays);
        }
        public function Deserialize(ar:ByteArray):void
        {
            live = ar.readInt();
            players = ar.readInt();
            exception = ar.readInt();
            automodel = ar.readInt();
            mappolicy = ar.readInt();
            arrItemgroup= new  Vector.<StructServer_Detail2>();
            var groupLength:int = ar.readInt();
            for (var igroup:int=0;igroup<groupLength; ++igroup)
            {
                var objServer_Detail:StructServer_Detail2 = new StructServer_Detail2();
                objServer_Detail.Deserialize(ar);
                arrItemgroup.push(objServer_Detail);
            }
            arrItemneedservers= new  Vector.<int>();
            var needserversLength:int = ar.readInt();
            for (var ineedservers:int=0;ineedservers<needserversLength; ++ineedservers)
            {
                arrItemneedservers.push(ar.readInt());
            }
            robot = ar.readInt();
            startDate = ar.readInt();
            runDays = ar.readInt();
        }
    }
}
