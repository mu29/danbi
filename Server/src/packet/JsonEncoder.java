package packet;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.CorruptedFrameException;
import io.netty.handler.codec.MessageToMessageEncoder;
import io.netty.util.CharsetUtil;

import java.io.IOException;
import java.util.List;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@SuppressWarnings("unchecked")
public class JsonEncoder extends MessageToMessageEncoder {

	@Override
	protected void encode(ChannelHandlerContext ctx, Object msg, List out) throws Exception {
        String json = serialize(msg);
        byte[] data = json.getBytes(CharsetUtil.UTF_8);
        int dataLength = data.length;

        ByteBuf buf = Unpooled.buffer();
        //buf.writeInt(dataLength);
        buf.writeBytes(data);
        out.add(buf);
	}
    
    private String serialize(Object msg) throws CorruptedFrameException {
        ObjectMapper mapper = new ObjectMapper();
        Throwable t;
        try {
            return mapper.writeValueAsString(msg);
        } catch (JsonGenerationException e) {
                t = e;
        } catch (JsonMappingException e) {
                t = e;
        } catch (IOException e) {
                t = e;
        }

        throw new CorruptedFrameException("Error while serializing message: " + t.getMessage());
    }
    
}
