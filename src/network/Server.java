package network;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelOption;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioServerSocketChannel;

import java.util.logging.Logger;

import database.DataBase;
import database.GameData;
import game.*;

public class Server {
	
	private int port;
	private final Logger logger = Logger.getLogger(Server.class.getName());
	
    public static final void main(String[] args) throws Exception {
        new Server(Integer.parseInt(args[0])).run();
    }
	
	public Server(int port) {
		this.port = port;
		Runtime.getRuntime().addShutdownHook(new Thread() {
			public void run() {
				logger.info("Server Shutdown.");
			}
		});
	}
	
	public void run() throws Exception {
		EventLoopGroup bossGroup = new NioEventLoopGroup();
		EventLoopGroup workerGroup = new NioEventLoopGroup();
		
        try {
            ServerBootstrap bootStrap = new ServerBootstrap()
            	.group(bossGroup, workerGroup)
            	.channel(NioServerSocketChannel.class)
            	.childHandler(new Initializer())
            	.option(ChannelOption.SO_BACKLOG, 128)
            	.childOption(ChannelOption.SO_KEEPALIVE, true);
            
            logger.info("서버를 시작합니다. (" + port + ")");
            ChannelFuture f = bootStrap.bind(port).sync();
            DataBase.connect("jdbc:mysql://localhost:3306/danbi", "root", "projectDanbi");
			GameData.loadSettings();
            Map.loadMap(2);

			while (Handler.isRunning) {
				Thread.sleep(100);
				for (Map map : Map.getAll().values()) {
					map.update();
				}
			}
            
            f.channel().closeFuture().sync();
        } finally {
            workerGroup.shutdownGracefully();
            bossGroup.shutdownGracefully();

            bossGroup.terminationFuture().sync();
            workerGroup.terminationFuture().sync();
        }
	}
	
}
