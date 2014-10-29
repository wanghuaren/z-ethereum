package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *挂机配置
    */
    public class PacketSCAutoConfig implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 25004;
        /** 
        *7位生命,7位灵力,1位拾取装备 ,1位拾取药品 ,1位拾取材料 ,1位拾取其他 ,1位自动释放技能 ,1位自动原地复活 ,1位5分钟死亡两次，回城复活 ,1位 主动攻击敌对势力玩家,1位 主动攻击精英怪和boss,2位 定点打怪(1小范围)(2中范围)(3大范围)
        */
        public var config:int;
        /** 
        *pet:7位生命,7位灵力,1位自动使用魔魂
        */
        public var config1:int;
        /** 
        *pet:7位生命,7位灵力,1位自动使用魔魂
        */
        public var config2:int;
        /** 
        *剩余在线挂机时间(单位 分钟)
        */
        public var autominute:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(config);
            ar.writeInt(config1);
            ar.writeInt(config2);
            ar.writeInt(autominute);
        }
        public function Deserialize(ar:ByteArray):void
        {
            config = ar.readInt();
            config1 = ar.readInt();
            config2 = ar.readInt();
            autominute = ar.readInt();
        }
    }
}
