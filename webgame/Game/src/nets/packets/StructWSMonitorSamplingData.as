package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructServerState2
    /** 
    *WorldServer采样数据
    */
    public class StructWSMonitorSamplingData implements ISerializable
    {
        /** 
        *在线玩家数量
        */
        public var PlayerCnt:int;
        /** 
        *地图分线策略
        */
        public var MapPolicy:int;
        /** 
        *GameServer状态
        */
        public var arrItemGameServerState:Vector.<StructServerState2> = new Vector.<StructServerState2>();
        /** 
        *必需的GameServer
        */
        public var arrItemNeedsGameServer:Vector.<int> = new Vector.<int>();
        /** 
        *robot
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

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(PlayerCnt);
            ar.writeInt(MapPolicy);
            ar.writeInt(arrItemGameServerState.length);
            for each (var GameServerStateitem:Object in arrItemGameServerState)
            {
                var objGameServerState:ISerializable = GameServerStateitem as ISerializable;
                if (null!=objGameServerState)
                {
                    objGameServerState.Serialize(ar);
                }
            }
            ar.writeInt(arrItemNeedsGameServer.length);
            for each (var NeedsGameServeritem:int in arrItemNeedsGameServer)
            {
                ar.writeInt(NeedsGameServeritem);
            }
            ar.writeInt(robot);
            ar.writeInt(startDate);
            ar.writeInt(runDays);
        }
        public function Deserialize(ar:ByteArray):void
        {
            PlayerCnt = ar.readInt();
            MapPolicy = ar.readInt();
            arrItemGameServerState= new  Vector.<StructServerState2>();
            var GameServerStateLength:int = ar.readInt();
            for (var iGameServerState:int=0;iGameServerState<GameServerStateLength; ++iGameServerState)
            {
                var objServerState:StructServerState2 = new StructServerState2();
                objServerState.Deserialize(ar);
                arrItemGameServerState.push(objServerState);
            }
            arrItemNeedsGameServer= new  Vector.<int>();
            var NeedsGameServerLength:int = ar.readInt();
            for (var iNeedsGameServer:int=0;iNeedsGameServer<NeedsGameServerLength; ++iNeedsGameServer)
            {
                arrItemNeedsGameServer.push(ar.readInt());
            }
            robot = ar.readInt();
            startDate = ar.readInt();
            runDays = ar.readInt();
        }
    }
}
